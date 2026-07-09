import * as fs from 'fs';
import * as path from 'path';
import { substituteQueryParameters } from '../src/query-parameters';

export { stripVolatile } from '../src/meta';
export { formatExplainJson } from '../src/json-explain';

/** Directory holding the ClickHouse reference `.sql` cases and their expected outputs. */
export const CLICKHOUSE_DIR = path.join(__dirname, 'clickhouse-reference');

/**
 * Reads a reference `.sql` case and applies the same query-parameter substitution the
 * reference generator uses, so the SQL the tests parse is byte-identical to the SQL
 * ClickHouse parsed when the expected outputs were captured. See
 * {@link substituteQueryParameters}.
 */
export function readReferenceSql(filePath: string): string {
  return substituteQueryParameters(fs.readFileSync(filePath, 'utf-8'));
}

/**
 * Discovers the reference test cases: every `.sql` file in {@link CLICKHOUSE_DIR}
 * that is not an `.expected.*` output file, sorted for stable ordering.
 */
export function discoverCases(): string[] {
  if (!fs.existsSync(CLICKHOUSE_DIR)) return [];
  return fs
    .readdirSync(CLICKHOUSE_DIR)
    .filter((f) => f.endsWith('.sql') && !f.includes('.expected.'))
    .sort();
}

/**
 * Mutates `actual` in place so the ast suite tolerates ClickHouse's per-engine
 * filtering of a table's `SETTINGS` clause, while still catching real bugs.
 *
 * ClickHouse keeps a version- and engine-specific registry of which settings
 * belong on a table's `Storage` node. Session- or query-level settings that
 * leak into a `CREATE TABLE ... SETTINGS` clause (e.g. `log_queries`,
 * `allow_suspicious_low_cardinality_types`, `use_hive_partitioning`) are
 * dropped from the `Storage > Set` `changes` map in `EXPLAIN AST json = 1`,
 * leaving a bare `{type: 'Settings'}` or a map missing the filtered keys. This
 * parser is not built to know that registry, so it keeps every setting.
 *
 * Rather than replicate the registry, we walk `actual` and `expected` in
 * parallel and, for every `Set` that is a direct child of a `Storage` node,
 * remove from `actual`'s `changes` only the keys that `expected` does not
 * have. This tolerates settings ClickHouse filtered out (extra keys in actual)
 * but still fails the comparison if actual is *missing* a key expected keeps,
 * or carries a different value for a shared key. Top-level `SET` statements
 * produce `Set` nodes too; only those nested directly under `Storage` are
 * touched.
 */
export function pruneFilteredStorageSettings(actual: unknown, expected: unknown): void {
  if (Array.isArray(actual) && Array.isArray(expected)) {
    const len = Math.min(actual.length, expected.length);
    for (let i = 0; i < len; i++) pruneFilteredStorageSettings(actual[i], expected[i]);
    return;
  }
  if (!actual || typeof actual !== 'object' || !expected || typeof expected !== 'object') return;

  const a = actual as Record<string, unknown>;
  const e = expected as Record<string, unknown>;

  // CREATE DATABASE with a SETTINGS clause: ClickHouse filters out settings that
  // don't belong to the database engine's registry (e.g. the query-level
  // `distributed_ddl_task_timeout`), and when nothing remains it drops the whole
  // `Storage` node. This parser keeps the settings so `format()` can re-emit the
  // clause. When `expected` has no `storage` but `actual`'s `storage` carries only
  // a filtered `settings` node, drop it so the comparison matches; a `storage` that
  // also has an engine/order_by (a real structural difference) is left intact.
  if (
    a.storage &&
    typeof a.storage === 'object' &&
    (a.storage as Record<string, unknown>).type === 'Storage' &&
    !('storage' in e)
  ) {
    const aStorage = a.storage as Record<string, unknown>;
    const onlySettings = Object.keys(aStorage).every((k) => k === 'type' || k === 'settings');
    if (onlySettings) delete a.storage;
  }

  if (a.type === 'Storage' && e.type === 'Storage') {
    // Legacy `children`-array Storage shape.
    if (Array.isArray(a.children) && Array.isArray(e.children)) {
      const len = Math.min(a.children.length, e.children.length);
      for (let i = 0; i < len; i++) {
        const ac = a.children[i] as Record<string, unknown> | null;
        const ec = e.children[i] as Record<string, unknown> | null;
        if (ac?.type !== 'Settings' || ec?.type !== 'Settings') continue;
        if (!('changes' in ec)) {
          // ClickHouse filtered every setting out — match its bare `{type: 'Settings'}`.
          delete ac.changes;
        } else if (ac.changes && typeof ac.changes === 'object') {
          const eChanges = (ec.changes ?? {}) as Record<string, unknown>;
          for (const key of Object.keys(ac.changes as Record<string, unknown>)) {
            if (!(key in eChanges)) delete (ac.changes as Record<string, unknown>)[key];
          }
        }
      }
    }
    // Current named-field Storage shape: a `settings` Set node carrying the
    // SETTINGS clause. ClickHouse drops settings that don't belong to the
    // table's engine registry (e.g. session settings that leaked into the
    // clause), sometimes removing the whole `settings` field.
    const aSettings = a.settings as Record<string, unknown> | undefined;
    const eSettings = e.settings as Record<string, unknown> | undefined;
    if (aSettings && typeof aSettings === 'object') {
      if (!eSettings) {
        // ClickHouse filtered every setting out — drop the whole node.
        delete a.settings;
      } else if (aSettings.changes && typeof aSettings.changes === 'object') {
        const eChanges = (eSettings.changes ?? {}) as Record<string, unknown>;
        const aChanges = aSettings.changes as Record<string, unknown>;
        for (const key of Object.keys(aChanges)) {
          if (!(key in eChanges)) delete aChanges[key];
        }
        if (Object.keys(aChanges).length === 0 && !('changes' in eSettings)) {
          delete aSettings.changes;
        }
      }
    }
  }

  for (const key of Object.keys(a)) {
    if (key in e) pruneFilteredStorageSettings(a[key], e[key]);
  }
}

/**
 * Mutates `actual` in place so the ast suite tolerates query-parameter SETs
 * (`SET param_x = ...`) that this library keeps in `Set.changes` but the
 * native AST drops entirely.
 *
 * ClickHouse's `EXPLAIN AST json = 1` emits a bare `{type: 'Settings'}` for any
 * SET statement whose names are all `param_*` (the values become
 * `<Query Parameters>` placeholders elsewhere in the tree). This library
 * keeps the original `param_*` entries in `changes` so the formatter can
 * re-emit the SET statement on round-trip. To compare against the native
 * AST, walk every `Set` node and drop any `param_*` key from `actual.changes`
 * that is not present in `expected.changes`. If the resulting map is empty,
 * remove `changes` entirely so the node matches `{type: 'Settings'}`.
 */
export function pruneLibraryOnlyParamSettings(actual: unknown, expected: unknown): void {
  if (Array.isArray(actual) && Array.isArray(expected)) {
    const len = Math.min(actual.length, expected.length);
    for (let i = 0; i < len; i++) pruneLibraryOnlyParamSettings(actual[i], expected[i]);
    return;
  }
  if (!actual || typeof actual !== 'object' || !expected || typeof expected !== 'object') return;

  const a = actual as Record<string, unknown>;
  const e = expected as Record<string, unknown>;

  if (
    a.type === 'Settings' &&
    e.type === 'Settings' &&
    a.changes &&
    typeof a.changes === 'object' &&
    !Array.isArray(a.changes)
  ) {
    const aChanges = a.changes as Record<string, unknown>;
    const eChanges =
      e.changes && typeof e.changes === 'object' && !Array.isArray(e.changes)
        ? (e.changes as Record<string, unknown>)
        : {};
    for (const key of Object.keys(aChanges)) {
      if (key.startsWith('param_') && !(key in eChanges)) {
        delete aChanges[key];
      }
    }
    if (Object.keys(aChanges).length === 0) {
      delete a.changes;
    }
  }

  for (const key of Object.keys(a)) {
    if (key in e) pruneLibraryOnlyParamSettings(a[key], e[key]);
  }
}
