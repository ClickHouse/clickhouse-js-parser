#!/usr/bin/env tsx

/**
 * Filters each .sql file in clickhouse-tests/, keeping only SELECT statements.
 * Non-SELECT statements (CREATE, DROP, INSERT, SET, etc.) are removed.
 * Non-.sql/txt/json files are removed entirely.
 * Empty .sql files (after filtering) are removed.
 */

import { readFileSync, writeFileSync, readdirSync, unlinkSync } from 'fs';
import { join } from 'path';
import { splitStatements } from './split-statements.js';

const dir = new URL('../tests/clickhouse-reference', import.meta.url).pathname;

// Step 1: Remove all non-.sql and non-.txt files
const allFiles = readdirSync(dir);
let otherRemoved = 0;
for (const file of allFiles) {
  if (!file.endsWith('.sql') && !file.endsWith('.txt') && !file.endsWith('.json')) {
    unlinkSync(join(dir, file));
    otherRemoved++;
  }
}

/**
 * Returns a normalized key for deduplication: strips trailing inline comments,
 * collapses whitespace, and lowercases.
 */
function normalizeStatement(statement: string): string {
  // Strip the trailing inline comment (everything after the semicolon on the last line)
  let s = statement.replace(/;[^\n]*$/, '');
  // Remove block comments
  s = s.replace(/\/\*[\s\S]*?\*\//g, '');
  // Remove line comments
  s = s.replace(/--[^\n]*/g, '');
  // Collapse whitespace and lowercase
  return s.replace(/\s+/g, ' ').trim().toLowerCase();
}

/** Returns true if the statement is just SELECT '<string>' with nothing else. */
function isStringOnlySelect(statement: string): boolean {
  return /^select\s+('[^']*'|"[^"]*")$/.test(normalizeStatement(statement));
}

/** Returns true if the statement's trailing inline comment contains "clientError". */
function hasClientError(statement: string): boolean {
  return /;\s*--[^\n]*(clientError)/.test(statement);
}

/** Returns true if the statement uses a disallowed setting. */
function hasDisallowedSetting(statement: string): boolean {
  return (
    /implicit_transaction/.test(statement) || /output_format_tsv_crlf_end_of_line/.test(statement)
  );
}

/** Returns true if the statement uses a disallowed setting. */
function hasKql(statement: string): boolean {
  return /kql\(/.test(statement);
}

/**
 * SQL keywords that may appear at the start of a statement. Anything else at
 * the start indicates a bare expression (only valid with implicit_select=1)
 * or a non-SQL dialect (KQL pipe, PRQL, etc.) — neither of which the parser
 * accepts structurally.
 */
const SQL_LEADING_KEYWORDS = new Set([
  'SELECT',
  'WITH',
  'INSERT',
  'UPDATE',
  'DELETE',
  'CREATE',
  'REPLACE',
  'DROP',
  'TRUNCATE',
  'ALTER',
  'ATTACH',
  'DETACH',
  'SET',
  'USE',
  'SYSTEM',
  'EXPLAIN',
  'OPTIMIZE',
  'DESCRIBE',
  'DESC',
  'SHOW',
  'GRANT',
  'REVOKE',
  'KILL',
  'RENAME',
  'EXCHANGE',
  'CHECK',
  'EXISTS',
  'BACKUP',
  'RESTORE',
  'UNDROP',
  'BEGIN',
  'COMMIT',
  'ROLLBACK',
  'WATCH',
  'UNDO',
  'MOVE',
  'EXECUTE',
  'FROM',
]);

/**
 * Returns true when the statement's first non-comment token is clearly a
 * bare expression (only valid with `implicit_select=1`):
 *   - identifier-or-function that is not a known SQL leading keyword
 *     (e.g. `s;`, `count();`, `upper('x');`)
 *   - leading number literal (`1;`, `1 + 2;`)
 *   - leading `*` (`*;`)
 * Statements that begin with anything else (parens, unicode whitespace, etc.)
 * are left alone — we'd rather under-filter than mis-flag a real query.
 */
function isImplicitSelectExpression(statement: string): boolean {
  // Strip block, --, #/#! and // line comments before inspecting the leading
  // token. (ClickHouse supports `--`, `#`, `#!`, and `//` line comments.)
  let s = statement
    .replace(/\/\*[\s\S]*?\*\//g, '')
    .replace(/\/\/[^\n]*/g, '')
    .replace(/--[^\n]*/g, '')
    .replace(/#[^\n]*/g, '')
    .replace(/^[ \t\r\n]+/, '');
  if (s === '') return false;
  // Identifier-led: bare expression iff identifier is not a SQL leading keyword.
  const idMatch = s.match(/^([A-Za-z_][A-Za-z0-9_]*)/);
  if (idMatch) return !SQL_LEADING_KEYWORDS.has(idMatch[1].toUpperCase());
  // Numeric literal at start (e.g. `1;`, `1 + 2;`).
  if (/^[0-9]/.test(s)) return true;
  // Bare asterisk (`*;`).
  if (/^\*\s*;/.test(s)) return true;
  return false;
}

const blocklist: string[] = [
  // Ridiculous inputs
  '03775_too_large_temporary_files_buffer_size.sql',
  '02686_bson3.sql',
  '01666_blns_long.sql',
  // Expected Parse error
  '02474_fix_function_parser_bug.sql',
  // Experimental window views, may be supported in the future
  '01049_window_view_window_functions.sql',
  // KQL parsing — these files are entirely written in KQL after `set dialect='kusto'`,
  // so almost every statement fails to parse as SQL.
  '02366_kql_datatype.sql',
  '02366_kql_distinct.sql',
  '02366_kql_extend.sql',
  '02366_kql_func_binary.sql',
  '02366_kql_func_datetime.sql',
  '02366_kql_func_dynamic.sql',
  '02366_kql_func_iif.sql',
  '02366_kql_func_ip.sql',
  '02366_kql_func_math.sql',
  '02366_kql_func_scalar.sql',
  '02366_kql_func_string.sql',
  '02366_kql_mvexpand.sql',
  '02366_kql_operator_in_sql.sql',
  '02366_kql_summarize.sql',
  '02366_kql_tabular.sql',
  // Mixed-dialect file (PRQL + KQL). The non-SQL branches are unparseable and
  // the SQL splitter can't separate them cleanly.
  '02985_dialects_with_distributed_tables.sql',
  // INSERT INTO ... FORMAT CSV with a non-comma `format_csv_delimiter` puts
  // raw CSV data containing `;` directly in the SQL stream, which breaks
  // statement splitting.
  '00707_float_csv_delimiter.sql',
  // implicit_select / implicit_table_at_top_level enable bare expressions
  // (`1+2;`, `s;`, `count();`, `*;`) which our parser rejects. The remaining
  // valid SQL in these files isn't worth keeping out of sync with the
  // pre-generated expected outputs.
  '03227_implicit_select.sql',
  '03408_implicit_table.sql',
  // Inconsistencies between versions and explain/json AST
  '03168_inconsistent_ast_formatting.sql',
];

// Step 2: Remove blocklisted files
for (const stem of blocklist) {
  for (const file of readdirSync(dir)) {
    if (file.startsWith(stem)) {
      unlinkSync(join(dir, file));
    }
  }
}

// Step 3: Filter .sql files
const sqlFiles = readdirSync(dir).filter((f) => f.endsWith('.sql') && !f.includes('.expected.'));
let totalRemoved = 0;
let totalDuplicates = 0;
let filesModified = 0;

for (const file of sqlFiles) {
  const filePath = join(dir, file);
  const content = readFileSync(filePath, 'utf8');
  const statements = splitStatements(content);

  const supportedStatements = statements.filter(
    (s) =>
      !isStringOnlySelect(s) &&
      !hasClientError(s) &&
      !hasDisallowedSetting(s) &&
      !hasKql(s) &&
      !isImplicitSelectExpression(s),
  );
  const removed = statements.length - supportedStatements.length;

  // Deduplicate: keep only the first occurrence of each normalized statement
  const seen = new Set<string>();
  const dedupedStatements = supportedStatements.filter((s) => {
    const key = normalizeStatement(s);
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
  const duplicates = supportedStatements.length - dedupedStatements.length;

  if (removed > 0 || duplicates > 0) {
    totalRemoved += removed;
    totalDuplicates += duplicates;
    filesModified++;

    if (dedupedStatements.length === 0) {
      // Step 3: Remove files that are now empty
      unlinkSync(filePath);
    } else {
      const newContent = dedupedStatements.map((s) => s.trim()).join('\n') + '\n';
      writeFileSync(filePath, newContent, 'utf8');
    }
  }
}

// Step 4: Remove orphaned .expected.* files with no corresponding input .sql file
const inputFiles = new Set(
  readdirSync(dir).filter((f) => f.endsWith('.sql') && !f.includes('.expected.')),
);
let orphansRemoved = 0;
for (const file of readdirSync(dir)) {
  if (!file.includes('.expected.')) continue;
  // Derive the input filename: strip everything from ".expected." onward.
  const inputFile = file.slice(0, file.indexOf('.expected.'));
  if (!inputFiles.has(inputFile)) {
    unlinkSync(join(dir, file));
    orphansRemoved++;
  }
}

console.log(`Removed ${otherRemoved} .sh/.j2/.data files.`);
console.log(`Removed ${orphansRemoved} orphaned .expected.* files.`);
console.log(
  `Modified ${filesModified} .sql files, removed ${totalRemoved} non-SELECT statements, ${totalDuplicates} duplicates.`,
);
