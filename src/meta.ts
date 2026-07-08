/**
 * Metadata this library attaches to (nearly) every AST node but that
 * ClickHouse's native JSON never emits. Absent from the reference AST.
 */
export const METADATA_KEYS = new Set(['location', 'parent', 'leadingComments', 'trailingComments']);

export type LibraryOnlyField = {
  /** Node `type` discriminators the field may appear on. */
  types: ReadonlySet<string>;
  /**
   * When true, the field may also appear on untyped helper objects (objects
   * with no `type` discriminator), e.g. `Array`/`Tuple` literal value elements.
   */
  onUntyped?: boolean;
  /**
   * When true, the field carries semantic information `format()` needs, so it
   * must survive a round trip (it is *not* volatile). When false/absent the
   * field is a non-semantic explain-only flag: read only by `formatExplain()`,
   * canonicalized away by `format()`, and therefore volatile across a reformat.
   */
  semantic?: boolean;
  /**
   * Reason why the field is required and cannot be dropped in favor of an existing
   * reference AST field.
   */
  rationale: string;
};

/**
 * Library-only node fields absent from ClickHouse's reference AST, keyed by
 * field name and mapped to the exact node `type` discriminators the field is
 * allowed to appear on.
 */
export const LIBRARY_ONLY_FIELDS: Record<string, LibraryOnlyField> = {
  no_parens: {
    types: new Set(['Function']),
    rationale: 'ClickHouse JSON AST does not distinguish no-parens vs empty-parens function calls',
  },
  with_trailing: {
    types: new Set(['SelectQuery']),
    rationale:
      'ClickHouse JSON AST does not preserve the original child order of a WITH clause that appeared before an enclosing INSERT or propagated into a later UNION member',
  },
  agg_repeat: {
    types: new Set(['SelectQuery']),
    rationale:
      'ClickHouse JSON AST does not preserve the synthetic SelectQuery produced when lowering expr op ANY/ALL (subquery), whose projection/tables ClickHouse text dump emits twice',
  },
  settings_before_format: {
    types: new Set(['SelectWithUnionQuery', 'SelectIntersectExceptQuery', 'DescribeQuery']),
    rationale:
      'ClickHouse JSON AST does not preserve the original child order of SETTINGS clauses before FORMAT, which is required in formatExplain',
  },
  settings_after_order_by: {
    types: new Set(['Storage']),
    rationale:
      'ClickHouse JSON AST does not preserve the original child order of SETTINGS clauses after ORDER BY, which is required in formatExplain',
  },
  nonfinite: {
    types: new Set(['Literal']),
    onUntyped: true,
    semantic: true,
    rationale:
      'ClickHouse JSON AST collapses non-finite Float64 values to null, losing the original source spelling',
  },
};

/**
 * Keys removed before a round-trip comparison because they may legitimately
 * differ between two parses of equivalent SQL.
 */
export const VOLATILE_KEYS: ReadonlySet<string> = new Set<string>([
  'location',
  'parent',
  ...Object.entries(LIBRARY_ONLY_FIELDS)
    .filter(([, field]) => !field.semantic)
    .map(([name]) => name),
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
