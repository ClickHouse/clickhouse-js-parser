import { Statement, WithoutLocations } from './ast';
import { LIBRARY_ONLY_FIELDS, METADATA_KEYS } from './meta';

function stripNonReference(value: unknown): unknown {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value;
  }

  if (Array.isArray(value)) {
    return value.map(stripNonReference);
  }

  const obj = value as Record<string, unknown>;
  const nodeType = typeof obj.type === 'string' ? obj.type : undefined;

  const result: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(obj)) {
    if (METADATA_KEYS.has(k)) continue;
    const field = LIBRARY_ONLY_FIELDS[k];
    if (field) {
      const stripHere =
        nodeType === undefined ? field.onUntyped === true : field.types.has(nodeType);
      if (stripHere) continue;
    }
    result[k] = stripNonReference(v);
  }
  return result;
}

/** Supported `EXPLAIN AST json = N` schema versions. Only 2 is implemented. */
export type JsonExplainVersion = 2;

/** One statement's projected AST, wrapped in its schema-version envelope. */
export type JsonExplainEnvelope = {
  version: JsonExplainVersion;
  ast: unknown;
};

/**
 * Projects this library's AST onto the ClickHouse-native view emitted by
 * `EXPLAIN AST json = <version>`: each statement's AST is deep-copied with the
 * library-only fields removed — node metadata ({@link METADATA_KEYS}) on every
 * node, and each {@link LIBRARY_ONLY_FIELDS} entry only on the node types it is
 * declared for — then wrapped in a `{ version, ast }` envelope matching the
 * reference `.expected.ast.json` files. Both key sets live in `./meta`
 * alongside the round-trip `VOLATILE_KEYS` they keep in sync with.
 *
 * `version` must be `2`, the only schema this library emits; any other value
 * throws. The result of `formatExplainJson(parse(sql), 2)` must equal
 * ClickHouse's `EXPLAIN AST json = 2` output for the same statements; the
 * reference ast test relies on this.
 */
export function formatExplainJson(
  statements: WithoutLocations<Statement>[],
  version: JsonExplainVersion,
): JsonExplainEnvelope[] {
  if (version !== 2) {
    throw new Error(
      `formatExplainJson: unsupported version ${version}; only version 2 is supported`,
    );
  }
  return statements.map((statement) => ({ version, ast: stripNonReference(statement) }));
}
