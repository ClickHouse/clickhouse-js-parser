#!/usr/bin/env tsx

/**
 * For each .sql file in clickhouse-tests/, generates:
 *   - <file>.expected.ast.json       — EXPLAIN AST json=1 output from clickhouse
 *   - <file>.expected.formatted.sql  — re-formatted SQL from format()
 *   - <file>.expected.explain.txt    — EXPLAIN AST output from a ClickHouse server
 *
 * If the library parser fails, writes "<Parse Error>" to the formatted file.
 * If ClickHouse fails for a statement, writes "<AST Error>" into the JSON array.
 * If ClickHouse fails for a statement, writes "<Parse Error>" to the explain file.
 *
 * When explain outputs need to be (re)generated, this script will start a
 * ClickHouse container via `docker compose up -d`, wait for it to be ready,
 * and stop it again (`docker compose down`) on exit. If a ClickHouse server is
 * already running at CLICKHOUSE_URL, it is reused and left running.
 *
 * Usage:
 *   tsx scripts/generate-expected-outputs.ts [<file>] \
 *     [--regenerate-all-references | --regenerate-changed-references] [--ast | --explain]
 *
 *   <file>                           Optional .sql filename to limit processing to a single input.
 *   --regenerate-all-references      Regenerate the reference output for every input, overwriting
 *                                    any existing .expected.ast.json and .expected.explain.txt
 *                                    files. By default, inputs that already have these files are
 *                                    skipped (since they are references from ClickHouse itself and
 *                                    do not change with library changes).
 *   --regenerate-changed-references  Regenerate the reference output only for input .sql files that
 *                                    have uncommitted changes (staged, working-tree, or untracked)
 *                                    according to `git status`. Useful when adding or editing a
 *                                    handful of test cases.
 *   --ast                            Limit reference (re)generation to the AST output
 *                                    (.expected.ast.json). The explain output is left untouched.
 *   --explain                        Limit reference (re)generation to the explain output
 *                                    (.expected.explain.txt). The AST output is left untouched.
 *
 *   The --ast / --explain target selectors scope which references the scope flags above (and the
 *   default "generate if missing" behavior) apply to. If neither is passed, both targets are
 *   processed. Passing both is equivalent to passing neither.
 */

import { spawnSync, spawn } from 'child_process';
import { readFileSync, writeFileSync, readdirSync, existsSync } from 'fs';
import { join } from 'path';
import { parse, format } from '../src/index.js';
import { substituteQueryParameters } from '../src/query-parameters.js';
import { splitStatements } from './split-statements.js';

const PARSE_ERROR = '<Parse Error>';
const AST_ERROR = '<AST Error>';
const EXPLAIN_ERROR = '<Explain Error>';

const dir = new URL('../tests/clickhouse-reference', import.meta.url).pathname;
const projectRoot = new URL('..', import.meta.url).pathname;

// Path to the local clickhouse binary (project root).
const CLICKHOUSE_LOCAL_AST_PATH = join(projectRoot, 'clickhouse');

// ClickHouse HTTP endpoint (matches the port mapping in docker-compose.yml).
const CLICKHOUSE_URL = 'http://localhost:8125';

// Maximum number of concurrent requests.
const CONCURRENCY = 20;

// How long to wait for the ClickHouse container to start accepting connections.
const CLICKHOUSE_READY_TIMEOUT_MS = 120_000;

// ── Concurrency pool ───────────────────────────────────────────────────────────

class Pool {
  private running = 0;
  private queue: (() => void)[] = [];

  constructor(private limit: number) {}

  run<T>(fn: () => Promise<T>): Promise<T> {
    return new Promise((resolve, reject) => {
      const attempt = () => {
        this.running++;
        fn().then(
          (v) => {
            this.running--;
            this.queue.shift()?.();
            resolve(v);
          },
          (e) => {
            this.running--;
            this.queue.shift()?.();
            reject(e);
          },
        );
      };
      if (this.running < this.limit) {
        attempt();
      } else {
        this.queue.push(attempt);
      }
    });
  }
}

// ── Docker compose lifecycle ──────────────────────────────────────────────────

function runDocker(args: string[]): void {
  const result = spawnSync('docker', args, { stdio: 'inherit', cwd: projectRoot });
  if (result.error) {
    throw new Error(`Failed to run \`docker ${args.join(' ')}\`: ${result.error.message}`);
  }
  if (result.status !== 0) {
    throw new Error(`\`docker ${args.join(' ')}\` exited with status ${result.status}`);
  }
}

async function isClickHouseUp(): Promise<boolean> {
  try {
    const r = await fetch(`${CLICKHOUSE_URL}/ping`, { signal: AbortSignal.timeout(2_000) });
    return r.ok;
  } catch {
    return false;
  }
}

async function waitForClickHouse(timeoutMs: number): Promise<void> {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    if (await isClickHouseUp()) return;
    await new Promise((r) => setTimeout(r, 500));
  }
  throw new Error(`ClickHouse not reachable at ${CLICKHOUSE_URL} after ${timeoutMs}ms`);
}

// ── Git: changed input files ──────────────────────────────────────────────────

const REF_PATH_PREFIX = 'tests/clickhouse-reference/';

/**
 * Returns the set of input `.sql` filenames (basenames, not paths) in the
 * reference directory that have uncommitted changes — staged, working-tree,
 * or untracked. `.expected.*` files and non-`.sql` files are ignored, since
 * we only care about whether the input itself changed.
 */
function getChangedInputFiles(): Set<string> {
  const result = spawnSync('git', ['status', '--porcelain', '--', REF_PATH_PREFIX], {
    cwd: projectRoot,
    encoding: 'utf8',
  });
  if (result.error) {
    throw new Error(`Failed to run \`git status\`: ${result.error.message}`);
  }
  if (result.status !== 0) {
    throw new Error(`\`git status\` exited with status ${result.status}: ${result.stderr}`);
  }

  const changed = new Set<string>();
  for (const line of result.stdout.split('\n')) {
    if (!line) continue;
    // Porcelain format: "XY path" (2 status chars + space). For renames the
    // path is "old -> new"; we want the new path.
    let path = line.slice(3);
    const arrow = path.lastIndexOf(' -> ');
    if (arrow >= 0) path = path.slice(arrow + 4);
    // Git quotes paths containing special characters; strip the surrounding
    // quotes if present. (We don't bother decoding the inner escapes since
    // none of the reference filenames contain special characters.)
    if (path.startsWith('"') && path.endsWith('"')) path = path.slice(1, -1);

    if (!path.startsWith(REF_PATH_PREFIX)) continue;
    const file = path.slice(REF_PATH_PREFIX.length);
    if (!file.endsWith('.sql') || file.includes('.expected.')) continue;
    changed.add(file);
  }
  return changed;
}

// ── Explain via ClickHouse HTTP interface ──────────────────────────────────────

const pool = new Pool(CONCURRENCY);

function runExplain(sql: string): Promise<string> {
  return pool.run(async () => {
    const query = `EXPLAIN AST ${sql.trim()}`;
    try {
      const response = await fetch(
        `${CLICKHOUSE_URL}/?user=default&password=clickhouse&default_format=Raw&union_default_mode=ALL`,
        {
          method: 'POST',
          body: query,
          signal: AbortSignal.timeout(60_000),
        },
      );

      const text = await response.text();
      if (!response.ok) {
        console.log(`  Explain failed with status ${response.status}:`, text, query);
        return EXPLAIN_ERROR;
      }
      return text;
    } catch (e) {
      console.log(`  Explain error:`, e);
      return EXPLAIN_ERROR;
    }
  });
}

// ── AST via clickhouse ──────────────────────────────────────────────

/**
 * Spawns clickhouse and feeds `query` on stdin rather than via
 * `-q`/`--query`. The `--query` argument path rewrites some Unicode punctuation
 * (e.g. the Unicode minus U+2212 becomes `--`, which SQL reads as a line comment),
 * silently corrupting queries; the stdin path preserves the bytes verbatim.
 *
 * Resolves with the raw stdout/stderr and exit code (it never rejects on a
 * non-zero exit; callers decide what to do with `stderr`/`code`).
 */
function spawnClickhouse(
  query: string,
  extraArgs: string[] = [],
): Promise<{ stdout: string; stderr: string; code: number | null }> {
  return new Promise((resolve, reject) => {
    const child = spawn(CLICKHOUSE_LOCAL_AST_PATH, ['local', '--format', 'TSVRaw', ...extraArgs], {
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    const stdoutChunks: Buffer[] = [];
    const stderrChunks: Buffer[] = [];
    child.stdout.on('data', (c) => stdoutChunks.push(c));
    child.stderr.on('data', (c) => stderrChunks.push(c));
    child.on('error', reject);
    child.on('close', (code) => {
      resolve({
        stdout: Buffer.concat(stdoutChunks).toString('utf8'),
        stderr: Buffer.concat(stderrChunks).toString('utf8'),
        code,
      });
    });
    child.stdin.end(query, 'utf8');
  });
}

function runClickhouse(query: string): Promise<string> {
  return spawnClickhouse(query).then(({ stdout, stderr, code }) => {
    if (code === 0) return stdout.trimEnd();
    throw new Error(stderr.trim());
  });
}

function runAst(sql: string): Promise<string> {
  return pool.run(async () => {
    const query = `EXPLAIN AST json = 1 ${sql.trim()}`;
    try {
      return await runClickhouse(query);
    } catch (e) {
      const err = e as { stderr?: string; message?: string };
      console.log(`  AST error:`, err.stderr || err.message || e);
      return AST_ERROR;
    }
  });
}

/**
 * Builds a single multi-query batch that explains every statement. No
 * delimiters are inserted: each `EXPLAIN AST json = 1` emits exactly one
 * top-level JSON object, so the concatenated stdout is split back apart by
 * `splitJsonObjects` on object boundaries.
 */
function buildAstBatchQuery(statements: string[]): string {
  return statements
    .map((s) => `EXPLAIN AST json = 1 ${s.trim().replace(/;+\s*$/, '')};`)
    .join('\n');
}

/**
 * Splits a concatenation of top-level JSON objects into their individual texts
 * by tracking brace depth, ignoring braces inside strings (with escape
 * handling). Returns null on any structural anomaly (a `}` at depth 0, or
 * trailing input that never closes), which signals the caller to fall back.
 */
function splitJsonObjects(stdout: string): string[] | null {
  const objects: string[] = [];
  let depth = 0;
  let start = -1;
  let inString = false;
  let escaped = false;
  for (let i = 0; i < stdout.length; i++) {
    const c = stdout[i];
    if (inString) {
      if (escaped) escaped = false;
      else if (c === '\\') escaped = true;
      else if (c === '"') inString = false;
      continue;
    }
    if (c === '"') {
      inString = true;
    } else if (c === '{') {
      if (depth === 0) start = i;
      depth++;
    } else if (c === '}') {
      if (depth === 0) return null;
      depth--;
      if (depth === 0) {
        objects.push(stdout.slice(start, i + 1));
        start = -1;
      }
    }
  }
  if (depth !== 0 || inString) return null;
  return objects;
}

/**
 * Splits batched stdout into one JSON text per statement. Returns null
 * (signalling the caller to fall back to per-statement runs) when the output
 * cannot be cleanly realigned: an object count that differs from the number of
 * statements, or a chunk that is not valid JSON. A failed statement produces no
 * object (and stderr), so any error makes the object count drop below `n` and
 * triggers the fallback — `clickhouse-local` cannot resync statement boundaries
 * after a syntax error even with `--ignore-error`.
 */
function splitAstBatch(stdout: string, n: number): string[] | null {
  const objects = splitJsonObjects(stdout);
  if (objects === null || objects.length !== n) return null;

  const results: string[] = [];
  for (const object of objects) {
    const trimmed = object.trim();
    try {
      JSON.parse(trimmed);
    } catch {
      return null;
    }
    results.push(trimmed);
  }
  return results;
}

/**
 * Explains all statements of a file in one `--multiquery --ignore-error` batch.
 * Returns an array of raw JSON texts (same shape as `statements.map(runAst)`
 * before parsing), or null when the batch could not be cleanly realigned (the
 * caller then falls back to per-statement runs).
 */
function runAstBatch(statements: string[]): Promise<string[] | null> {
  return pool.run(async () => {
    try {
      const { stdout, stderr, code } = await spawnClickhouse(buildAstBatchQuery(statements), [
        '--multiquery',
        '--ignore-error',
      ]);
      // Any stderr output means at least one statement errored, after which the
      // batch can no longer be trusted to realign — fall back.
      if (code !== 0 || stderr.trim() !== '') return null;
      return splitAstBatch(stdout, statements.length);
    } catch {
      return null;
    }
  });
}

// ── Main ───────────────────────────────────────────────────────────────────────

const KNOWN_FLAGS = new Set([
  '--regenerate-all-references',
  '--regenerate-changed-references',
  '--ast',
  '--explain',
]);

const args = process.argv.slice(2);
const regenerateAllReferences = args.includes('--regenerate-all-references');
const regenerateChangedReferences = args.includes('--regenerate-changed-references');
const filterArg = args.find((a) => !a.startsWith('--'));

// Target selectors. If neither --ast nor --explain is passed (or both are),
// process both targets. Otherwise limit (re)generation to the chosen target.
const onlyAst = args.includes('--ast');
const onlyExplain = args.includes('--explain');
const targetAst = onlyAst || !onlyExplain;
const targetExplain = onlyExplain || !onlyAst;

const unknownFlags = args.filter((a) => a.startsWith('--') && !KNOWN_FLAGS.has(a));
if (unknownFlags.length > 0) {
  console.error(`Unknown flag(s): ${unknownFlags.join(', ')}`);
  process.exit(1);
}

if (regenerateAllReferences && regenerateChangedReferences) {
  console.error(
    `--regenerate-all-references and --regenerate-changed-references are mutually exclusive.`,
  );
  process.exit(1);
}

// Compute the set of input files with uncommitted changes once up front.
// Empty if --regenerate-changed-references was not passed.
const changedInputs = regenerateChangedReferences ? getChangedInputFiles() : new Set<string>();
if (regenerateChangedReferences) {
  console.log(
    `--regenerate-changed-references: ${changedInputs.size} input file(s) changed per \`git status\`.`,
  );
}

/** True when the AST file for this input should be (re)generated. */
function shouldRegenerateAst(file: string, astPath: string): boolean {
  if (!targetAst) return false;
  if (regenerateAllReferences) return true;
  if (regenerateChangedReferences && changedInputs.has(file)) return true;
  return !existsSync(astPath);
}

/** True when the explain file for this input should be (re)generated. */
function shouldRegenerateExplain(file: string, explainPath: string): boolean {
  if (!targetExplain) return false;
  if (regenerateAllReferences) return true;
  if (regenerateChangedReferences && changedInputs.has(file)) return true;
  return !existsSync(explainPath);
}

const sqlFiles = readdirSync(dir)
  .filter((f) => f.endsWith('.sql') && !f.includes('.expected.'))
  .filter((f) => !filterArg || f === filterArg || f === `${filterArg}.sql`)
  .sort();

let processed = 0;
let parseErrors = 0;
let astErrors = 0;
let astsWritten = 0;
let explainErrors = 0;
let explainsWritten = 0;

async function processFile(file: string): Promise<void> {
  const filePath = join(dir, file);
  // Substitute query parameters (`{name:Type}`) with placeholder literals so the
  // statements parse in ClickHouse and this library alike. The reference tests apply
  // the same transform, so all outputs are derived from byte-identical SQL.
  const content = substituteQueryParameters(readFileSync(filePath, 'utf8'));
  const statements = splitStatements(content)
    .map((s) => s.trim())
    .filter(Boolean);

  // ── AST via clickhouse ─────────────────────────────────────────────
  // By default, skip if the AST file already exists. Pass --regenerate-all-references
  // to overwrite every existing AST file, or --regenerate-changed-references to
  // overwrite only those whose input has uncommitted git changes.

  const astPath = `${filePath}.expected.ast.json`;
  if (shouldRegenerateAst(file, astPath)) {
    // Fast path: explain every statement in one batch. Falls back to one run
    // per statement when the batch can't be cleanly realigned (e.g. the file
    // contains a statement that fails to parse).
    const astParts =
      (await runAstBatch(statements)) ?? (await Promise.all(statements.map(runAst)));

    let hadAstError = false;
    const astItems = astParts.map((out) => {
      if (out === AST_ERROR) {
        hadAstError = true;
        return '<AST Error>';
      }
      try {
        return JSON.parse(out);
      } catch {
        hadAstError = true;
        return '<AST Error>';
      }
    });

    if (hadAstError) astErrors++;

    writeFileSync(astPath, JSON.stringify(astItems, null, 2) + '\n', 'utf8');
    astsWritten++;
  }

  // ── Formatted SQL ────────────────────────────────────────────────────────────

  let formattedOutput: string;
  try {
    const ast = parse(content);
    try {
      formattedOutput = format(ast);
    } catch (e) {
      formattedOutput = JSON.stringify(e);
      parseErrors++;
    }
  } catch (e) {
    formattedOutput = PARSE_ERROR;
    parseErrors++;
  }

  writeFileSync(`${filePath}.expected.formatted.sql`, formattedOutput, 'utf8');

  // ── Explain AST via ClickHouse HTTP interface ─────────────────────────────────
  // By default, skip if the explain file already exists. Pass
  // --regenerate-all-references to overwrite every existing explain file, or
  // --regenerate-changed-references to overwrite only those whose input has
  // uncommitted git changes.

  const explainPath = `${filePath}.expected.explain.txt`;
  if (shouldRegenerateExplain(file, explainPath)) {
    const explainParts = await Promise.all(statements.map(runExplain));

    let hadExplainError = false;
    const trimmedExplainParts = explainParts.map((out) => {
      if (out === PARSE_ERROR) {
        hadExplainError = true;
        return PARSE_ERROR;
      }
      return out.trimEnd();
    });

    if (hadExplainError) explainErrors++;

    const explainOutput =
      trimmedExplainParts.join('\n\n') + (trimmedExplainParts.length > 0 ? '\n' : '');
    writeFileSync(explainPath, explainOutput, 'utf8');
    explainsWritten++;
  }

  processed++;
  if (processed % 50 === 0) {
    console.log(`  ${processed}/${sqlFiles.length} files processed...`);
  }
}

void (async () => {
  const needsClickhouseLocalAst = sqlFiles.some((f) =>
    shouldRegenerateAst(f, `${join(dir, f)}.expected.ast.json`),
  );

  if (needsClickhouseLocalAst && !existsSync(CLICKHOUSE_LOCAL_AST_PATH)) {
    console.error(`clickhouse binary not found at ${CLICKHOUSE_LOCAL_AST_PATH}`);
    process.exit(1);
  }

  // Decide whether we need ClickHouse at all. If every input already has an
  // explain file and nothing forces a regeneration, we can skip docker entirely.
  const needsClickHouse = sqlFiles.some((f) =>
    shouldRegenerateExplain(f, `${join(dir, f)}.expected.explain.txt`),
  );

  let weStartedDocker = false;
  const stopDocker = (): void => {
    if (!weStartedDocker) return;
    weStartedDocker = false;
    console.log('Stopping ClickHouse via `docker compose down`...');
    try {
      runDocker(['compose', 'down']);
    } catch (e) {
      console.error(`  Failed to stop ClickHouse:`, e);
    }
  };

  if (needsClickHouse) {
    if (await isClickHouseUp()) {
      console.log(`Reusing existing ClickHouse server at ${CLICKHOUSE_URL}.`);
    } else {
      console.log('Starting ClickHouse via `docker compose up -d`...');
      runDocker(['compose', 'up', '-d']);
      weStartedDocker = true;

      const onSignal = (signal: NodeJS.Signals, exitCode: number) => {
        console.log(`\nCaught ${signal}, stopping ClickHouse...`);
        stopDocker();
        process.exit(exitCode);
      };
      process.once('SIGINT', () => onSignal('SIGINT', 130));
      process.once('SIGTERM', () => onSignal('SIGTERM', 143));

      console.log(`Waiting for ClickHouse to be ready at ${CLICKHOUSE_URL}...`);
      await waitForClickHouse(CLICKHOUSE_READY_TIMEOUT_MS);
      console.log('ClickHouse is ready.');
    }
  }

  try {
    await Promise.all(sqlFiles.map(processFile));
  } finally {
    stopDocker();
  }

  console.log(`Done. Processed ${processed} files.`);
  console.log(`  AST files written: ${astsWritten}`);
  console.log(`  Explain files written: ${explainsWritten}`);
  console.log(`  Parse errors: ${parseErrors}`);
  console.log(`  AST errors: ${astErrors}`);
  console.log(`  Explain errors: ${explainErrors}`);
})();
