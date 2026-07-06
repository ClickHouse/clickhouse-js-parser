/**
 * Helpers for stripping library-side metadata from AST nodes.
 *
 * The AST has two views:
 *  - The ClickHouse-native view: the fields that `EXPLAIN AST json = 1` emits.
 *    The reference ast test compares this view (via {@link stripAstMeta})
 *    against the expected JSON byte-for-byte.
 *  - The library view: everything the native JSON loses but that format()
 *    and formatExplain() need — names/flags dropped by the native
 *    serialization (stored in underscore-prefixed fields), comments,
 *    locations, and parent references.
 */

/**
 * True for keys that hold library-only data the ClickHouse-native JSON does
 * not contain (e.g. `_name`, `_settings`, `_nonfinite`).
 */
export function isLibraryOnlyKey(key: string): boolean {
  return key.startsWith('_');
}

const METADATA_KEYS = new Set(['location', 'parent', 'leadingComments', 'trailingComments']);

/**
 * Recursively removes everything the ClickHouse-native AST JSON does not
 * contain: `location`, `parent`, comments, and underscore-prefixed
 * library-only fields. Underscore keys are stripped on every object, not just
 * AST nodes — the native JSON never emits a `_`-prefixed key (verified across
 * the reference corpus), so this can only remove our library-only additions
 * (e.g. the per-element `_nonfinite` on `Array`/`Tuple` literal `value`
 * elements, which have no `type` discriminator). `Set.changes` keeps all of
 * its entries because ClickHouse setting names are never `_`-prefixed.
 *
 * The result of `stripAstMeta(parse(sql))` must equal ClickHouse's
 * `EXPLAIN AST json = 1` output for the same statements.
 */
export function stripAstMeta(value: unknown): unknown {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value;
  }

  if (Array.isArray(value)) {
    return value.map(stripAstMeta);
  }

  const result: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
    if (METADATA_KEYS.has(k)) continue;
    if (isLibraryOnlyKey(k)) continue;
    result[k] = stripAstMeta(v);
  }
  return result;
}

/**
 * Recursively removes only the volatile keys (`location`, `parent`, and
 * `_with_trailing`) that legitimately differ between two parses of equivalent
 * SQL. Comments and other library-only fields are kept, so round-trip
 * comparisons still exercise their fidelity.
 *
 * `_with_trailing` records whether a `WITH` clause appeared before an enclosing
 * `INSERT` / propagated into a later UNION member, purely so the explain
 * projection can reproduce ClickHouse's child ordering. `format()` canonicalizes
 * `WITH` placement, so the flag may flip across a reformat — like `location`, it
 * is not a semantic property and is excluded from round-trip comparison.
 *
 * The authentication-method keys (`auth_type`, `contains_password`,
 * `contains_hash`) are likewise excluded: `format()` intentionally re-emits
 * `IDENTIFIED BY '...'` without the `WITH <type>` qualifier (the native AST
 * preserves it, but the canonical SQL drops it), so these fields legitimately
 * differ after a reformat.
 *
 * `_settings_before_format` records that a query wrapper's (or `DescribeQuery`'s)
 * trailing `SETTINGS` preceded its `FORMAT` clause, purely so `formatExplain()`
 * can reproduce ClickHouse's AST child order. `format()` canonicalizes the order
 * (SETTINGS after FORMAT), so the flag may flip across a reformat — like
 * `_with_trailing`, it is not a semantic property and is excluded from round-trip
 * comparison.
 *
 * `_no_parens` records that an engine/codec/index-type function was written
 * without argument parens (`ENGINE = Memory`, not `Memory()`). `format()`
 * canonicalizes the no-argument form to empty parens (`Memory()`), so the flag
 * may flip across a reformat; it survives only so `formatExplain()` can
 * reproduce ClickHouse's byte-exact `Function`/`ExpressionList` child shape.
 *
 * `_settings_after_order_by` records that a storage `SETTINGS` clause followed
 * `ORDER BY` in the source. `format()` canonicalizes `SETTINGS` to the last
 * storage clause (its only valid position), so the flag may flip across a
 * reformat; it survives only so `formatExplain()` can reproduce ClickHouse's
 * source-order `Set` child.
 */
const VOLATILE_KEYS = new Set([
  'location',
  'parent',
  '_with_trailing',
  '_agg_repeat',
  '_settings_before_format',
  '_no_parens',
  '_settings_after_order_by',
  'auth_type',
  'contains_password',
  'contains_hash',
]);

export function stripVolatile(value: unknown, keepLocation = false): unknown {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value;
  }

  if (Array.isArray(value)) {
    return value.map((v) => stripVolatile(v, keepLocation));
  }

  const result: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
    // `location` is volatile for round-trip comparison, but callers that want
    // to inspect source positions (e.g. the parse script) can retain it.
    if (k === 'location') {
      if (!keepLocation) continue;
    } else if (VOLATILE_KEYS.has(k)) {
      continue;
    }
    result[k] = stripVolatile(v, keepLocation);
  }
  return result;
}
