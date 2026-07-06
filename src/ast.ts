import { z } from 'zod';

// ── Source location ──────────────────────────────────────────────────────────

/**
 * Source location range from the original SQL input.
 * Compatible with peggy's `LocationRange`.
 */
export type SourceLocation = {
  start: { offset: number; line: number; column: number };
  end: { offset: number; line: number; column: number };
};

/** Zod schema for {@link SourceLocation}. */
export const SourceLocationSchema = z.object({
  start: z.object({ offset: z.number(), line: z.number(), column: z.number() }),
  end: z.object({ offset: z.number(), line: z.number(), column: z.number() }),
});

/**
 * Validator for an arbitrary AST node, used in positions that legitimately
 * hold any node type: generic `children` arrays, `data_type`/`arguments`
 * operands, the back-reference `parent`, and other type-erased slots. Every AST
 * node carries a string `type` discriminator, so this asserts node-shape
 * without descending into the node's own fields. A full recursive union over
 * every node type is intentionally avoided — it is expensive and would recurse
 * forever through the `parent` back-edge. Deep validation of a node's own
 * fields happens through the specific node schemas reachable from
 * {@link StatementSchema}, which the reference-AST test suite exercises for the
 * whole corpus.
 */
export const ASTNodeSchema: z.ZodType<WithoutLocations<ASTNode>> = z.custom<ASTNode>(
  (val) =>
    typeof val === 'object' && val !== null && typeof (val as { type?: unknown }).type === 'string',
);

/**
 * Loose validator that asserts AST-node shape (an object with a string `type`)
 * but yields a caller-chosen node type. For fields whose deep shape is
 * context-specific and irregular — e.g. a storage `ORDER BY` key that may be a
 * `tuple(...)` Function embedding `StorageOrderByElement` operands, which the
 * generic {@link Expression} schema would reject.
 */
const looseNode = <T>(): z.ZodType<T> =>
  z.custom<T>(
    (val) =>
      typeof val === 'object' &&
      val !== null &&
      typeof (val as { type?: unknown }).type === 'string',
  );

// ── Leaf schemas (no recursion) ───────────────────────────────────────────────

const ExprMetadataFields = {
  leadingComments: z.array(z.string()).optional(),
  trailingComments: z.array(z.string()).optional(),
  location: SourceLocationSchema.optional(),
  parent: ASTNodeSchema.optional(),
};

// ── ClickHouse-native expression nodes ────────────────────────────────────────
// These node types mirror ClickHouse's own AST: the `type` discriminator and all
// non-underscore fields must match `EXPLAIN AST json = 1` output exactly (the
// reference ast suite compares them via `stripAstMeta`). Underscore-prefixed
// fields carry library-only data the native JSON loses but that format() and
// formatExplain() need. See CLAUDE.md and src/meta.ts.

/**
 * A query parameter placeholder: `{name:Type}`. Library-extension node type —
 * ClickHouse cannot serialize statements with unsubstituted parameters, so this
 * never appears in compared reference output.
 *
 * @example `{x:UInt64}` → `{ type: 'QueryParameter', name: 'x', param_type: 'UInt64' }`
 */
export type QueryParameterNode = {
  type: 'QueryParameter';
  name: string;
  /** The declared parameter type text, e.g. `'UInt64'` or `'Identifier'`. */
  param_type: string;
  alias?: string;
} & NodeMetadata;

/** Zod schema for {@link QueryParameterNode}. */
export const QueryParameterSchema: z.ZodType<WithoutLocations<QueryParameterNode>> = z.object({
  type: z.literal('QueryParameter'),
  name: z.string(),
  param_type: z.string(),
  alias: z.string().optional(),
  ...ExprMetadataFields,
});

/**
 * One segment of a (possibly compound) identifier: a plain name or a
 * query-parameter used in identifier position (`{db:Identifier}.table`).
 */
export type IdentifierPart = string | QueryParameterNode;

/** Zod schema for {@link IdentifierPart}. */
export const IdentifierPartSchema: z.ZodType<WithoutLocations<IdentifierPart>> = z.lazy(() =>
  z.union([z.string(), QueryParameterSchema]),
);

/**
 * One element of an `Array`/`Tuple`/`Map` literal `value` list. It mirrors a
 * {@link LiteralNode} without the `type`/`alias`/metadata: just the element's
 * `value_type`, its decoded `value` (recursively a list for nested
 * collections), and—for non-finite/`-0` `Float64` elements—the same
 * `_nonfinite` discriminator a top-level Float64 literal carries (the native
 * JSON collapses those to `null`/`0`, so it is needed to re-spell `inf`/`-0`
 * in `format()`/`formatExplain()`).
 */
export type LiteralElement = {
  value_type: LiteralNode['value_type'];
  value: number | string | boolean | null | LiteralElement[];
  _nonfinite?: LiteralNode['_nonfinite'];
};

/** Zod schema for {@link LiteralElement}. */
export const LiteralElementSchema: z.ZodType<WithoutLocations<LiteralElement>> = z.lazy(() =>
  z.object({
    value_type: z.union([
      z.literal('UInt64'),
      z.literal('Int64'),
      z.literal('Float64'),
      z.literal('String'),
      z.literal('Bool'),
      z.literal('Null'),
      z.literal('Array'),
      z.literal('Tuple'),
      z.literal('Map'),
    ]),
    value: z.union([
      z.custom<number>((v) => typeof v === 'number'),
      z.string(),
      z.boolean(),
      z.null(),
      z.array(LiteralElementSchema),
    ]),
    _nonfinite: z
      .union([
        z.literal('inf'),
        z.literal('-inf'),
        z.literal('nan'),
        z.literal('-nan'),
        z.literal('-0'),
      ])
      .optional(),
  }),
);

/**
 * A literal value.
 *
 * `value` holds the fully-decoded, JSON-typed value exactly as ClickHouse
 * serializes it: `UInt64`/`Int64` as decimal-digit strings (preserves
 * precision beyond `Number.MAX_SAFE_INTEGER`), `Float64`/`Bool` as JS
 * primitives, `String` decoded, `Null` as `null`, and `Array`/`Tuple`/`Map`
 * literals as a list of {@link LiteralElement} (each its own `value_type` +
 * `value`), matching ClickHouse's typed-element serialization.
 *
 * @example `42` → `{ type: 'Literal', value_type: 'UInt64', value: '42' }`
 * @example `'a\nb'` → `{ type: 'Literal', value_type: 'String', value: 'a\nb' }`
 * @example `[1, 2]` → `{ type: 'Literal', value_type: 'Array', value: [{ value_type: 'UInt64', value: '1' }, { value_type: 'UInt64', value: '2' }] }`
 */
export type LiteralNode = {
  type: 'Literal';
  value_type:
    | 'UInt64'
    | 'Int64'
    | 'Float64'
    | 'String'
    | 'Bool'
    | 'Null'
    | 'Array'
    | 'Tuple'
    | 'Map';
  value: number | string | boolean | null | LiteralElement[];
  alias?: string;
  /**
   * Discriminator for `Float64` values the native AST's `value` cannot carry:
   * non-finite values collapse to `null` (JSON has no infinity/NaN) and
   * negative zero collapses to `0`. It is the only library-only field numeric
   * literals need — all other finite values round-trip through `value` itself
   * (decimal strings for UInt64/Int64, the IEEE double for Float64), and
   * format()/formatExplain() reconstruct the canonical spelling from that.
   * Hex/large-integer source spelling is intentionally not preserved
   * (`0xFF` formats as `255`).
   */
  _nonfinite?: 'inf' | '-inf' | 'nan' | '-nan' | '-0';
} & NodeMetadata;

/** Zod schema for {@link LiteralNode}. */
export const LiteralNodeSchema: z.ZodType<WithoutLocations<LiteralNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Literal'),
    value_type: z.union([
      z.literal('UInt64'),
      z.literal('Int64'),
      z.literal('Float64'),
      z.literal('String'),
      z.literal('Bool'),
      z.literal('Null'),
      z.literal('Array'),
      z.literal('Tuple'),
      z.literal('Map'),
    ]),
    // A custom check is needed because z.number() rejects NaN and Infinity
    // (e.g. `SELECT nan`, `SELECT inf`).
    value: z.union([
      z.custom<number>((v) => typeof v === 'number'),
      z.string(),
      z.boolean(),
      z.null(),
      z.array(LiteralElementSchema),
    ]),
    alias: z.string().optional(),
    _nonfinite: z
      .union([
        z.literal('inf'),
        z.literal('-inf'),
        z.literal('nan'),
        z.literal('-nan'),
        z.literal('-0'),
      ])
      .optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A column or name reference, possibly compound (`db.table.col`).
 *
 * `name` is the dot-joined display form; `name_parts` is present only for
 * compound names and is authoritative (parts may contain literal dots from
 * quoted identifiers).
 *
 * @example `col` → `{ type: 'Identifier', name: 'col' }`
 * @example `t.col` → `{ type: 'Identifier', name: 't.col', name_parts: ['t', 'col'] }`
 */
export type IdentifierNode = {
  type: 'Identifier';
  name: string;
  name_parts?: IdentifierPart[];
  alias?: string;
} & NodeMetadata;

/** Zod schema for {@link IdentifierNode}. */
export const IdentifierNodeSchema: z.ZodType<WithoutLocations<IdentifierNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Identifier'),
    name: z.string(),
    name_parts: z.array(IdentifierPartSchema).optional(),
    alias: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/** The `kind` data field ClickHouse sets on special function roles. */
export type FunctionKind =
  | 'LAMBDA_FUNCTION'
  | 'WINDOW_FUNCTION'
  | 'TABLE_ENGINE'
  | 'DATABASE_ENGINE'
  | 'CODEC'
  | 'STATISTICS'
  | 'BACKUP_NAME';

/**
 * A function application. All operators, casts, lambdas, subscripts, CASE
 * expressions, intervals, array/tuple construction etc. normalize to this node,
 * mirroring ClickHouse (`a > 2` → `greater(a, 2)` with `is_operator`).
 *
 * Note: `kind` here is ClickHouse's own data field (e.g. `TABLE_ENGINE`), not a
 * discriminator — the discriminator is `type`.
 */
export type FunctionNode = {
  type: 'Function';
  name: string;
  arguments: Expression[];
  /** Parametric arguments — the first list in `quantile(0.5)(x)`. */
  parameters?: Expression[];
  is_operator?: boolean;
  is_lambda_function?: boolean;
  is_window_function?: boolean;
  kind?: FunctionKind;
  window_definition?: WindowDefinitionNode;
  window_name?: string;
  nulls_action?: 'RESPECT NULLS' | 'IGNORE NULLS';
  alias?: string;
  /**
   * Library-only: `true` for an engine/codec/index-type function written
   * without parentheses (`ENGINE = MergeTree`). ClickHouse's JSON AST shows
   * `arguments: []` for both the no-parens and empty-parens forms, but its
   * EXPLAIN/SHOW CREATE output distinguishes them.
   */
  _no_parens?: boolean;
} & NodeMetadata;

/** Zod schema for {@link FunctionNode}. */
export const FunctionNodeSchema: z.ZodType<WithoutLocations<FunctionNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Function'),
    name: z.string(),
    arguments: z.array(ExpressionSchema),
    parameters: z.array(ExpressionSchema).optional(),
    is_operator: z.boolean().optional(),
    is_lambda_function: z.boolean().optional(),
    is_window_function: z.boolean().optional(),
    kind: z
      .union([
        z.literal('LAMBDA_FUNCTION'),
        z.literal('WINDOW_FUNCTION'),
        z.literal('TABLE_ENGINE'),
        z.literal('DATABASE_ENGINE'),
        z.literal('CODEC'),
        z.literal('STATISTICS'),
        z.literal('BACKUP_NAME'),
      ])
      .optional(),
    window_definition: WindowDefinitionSchema.optional(),
    window_name: z.string().optional(),
    nulls_action: z.union([z.literal('RESPECT NULLS'), z.literal('IGNORE NULLS')]).optional(),
    alias: z.string().optional(),
    _no_parens: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A window definition: the parenthesized spec in `OVER (...)` or `WINDOW w AS (...)`.
 *
 * Frame bounds nest a `{type, preceding?, offset?}` object under
 * `frame_begin` / `frame_end`. `type` is `'Unbounded'`, `'Current'`, or
 * `'Offset'`; `offset` holds the row count expression for `'Offset'`; and
 * `preceding` is `true` for PRECEDING and `false`/omitted for FOLLOWING.
 */
export type WindowFrameBoundNode =
  | { type: 'Unbounded'; preceding?: boolean }
  | { type: 'Current'; preceding?: boolean }
  | { type: 'Offset'; offset: Expression; preceding?: boolean };

export type WindowDefinitionNode = {
  type: 'WindowDefinition';
  /** Parent window name for window inheritance: `OVER (w ORDER BY x)`. */
  parent_window_name?: string;
  partition_by?: Expression[];
  order_by?: OrderByElementNode[];
  frame_type?: 'ROWS' | 'RANGE' | 'GROUPS';
  frame_begin?: WindowFrameBoundNode;
  frame_end?: WindowFrameBoundNode;
} & NodeMetadata;

const WindowFrameBoundSchema: z.ZodType<WithoutLocations<WindowFrameBoundNode>> = z.lazy(() =>
  z.union([
    z.object({ type: z.literal('Unbounded'), preceding: z.boolean().optional() }),
    z.object({ type: z.literal('Current'), preceding: z.boolean().optional() }),
    z.object({
      type: z.literal('Offset'),
      offset: ExpressionSchema,
      preceding: z.boolean().optional(),
    }),
  ]),
);

/** Zod schema for {@link WindowDefinitionNode}. */
export const WindowDefinitionSchema: z.ZodType<WithoutLocations<WindowDefinitionNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('WindowDefinition'),
      parent_window_name: z.string().optional(),
      partition_by: z.array(ExpressionSchema).optional(),
      order_by: z.array(OrderByElementSchema).optional(),
      frame_type: z.union([z.literal('ROWS'), z.literal('RANGE'), z.literal('GROUPS')]).optional(),
      frame_begin: WindowFrameBoundSchema.optional(),
      frame_end: WindowFrameBoundSchema.optional(),
      ...ExprMetadataFields,
    }),
);

/**
 * A single element of an ORDER BY list (statement-level, window specs, and
 * WITH FILL modifiers).
 */
export type OrderByElementNode = {
  type: 'OrderByElement';
  expression: Expression;
  direction: 'ASC' | 'DESC';
  /** COLLATE locale as a String literal. */
  collation?: LiteralNode;
  nulls_first?: boolean;
  with_fill?: boolean;
  fill_from?: Expression;
  fill_to?: Expression;
  fill_step?: Expression;
  fill_staleness?: Expression;
} & NodeMetadata;

/** Zod schema for {@link OrderByElementNode}. */
export const OrderByElementSchema: z.ZodType<WithoutLocations<OrderByElementNode>> = z.lazy(() =>
  z.object({
    type: z.literal('OrderByElement'),
    expression: ExpressionSchema,
    direction: z.union([z.literal('ASC'), z.literal('DESC')]),
    collation: LiteralNodeSchema.optional(),
    nulls_first: z.boolean().optional(),
    with_fill: z.boolean().optional(),
    fill_from: ExpressionSchema.optional(),
    fill_to: ExpressionSchema.optional(),
    fill_step: ExpressionSchema.optional(),
    fill_staleness: ExpressionSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A single column in an INTERPOLATE clause: `INTERPOLATE (col AS expr)`.
 */
export type InterpolateElementNode = {
  type: 'InterpolateElement';
  column: string;
  expr: Expression;
} & NodeMetadata;

/** Zod schema for {@link InterpolateElementNode}. */
export const InterpolateElementSchema: z.ZodType<WithoutLocations<InterpolateElementNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('InterpolateElement'),
      column: z.string(),
      expr: ExpressionSchema,
      ...ExprMetadataFields,
    }),
);

/**
 * A subquery used as an expression: `(SELECT ...)`.
 */
export type SubqueryNode = {
  type: 'Subquery';
  query: QueryStatement;
  alias?: string;
} & NodeMetadata;

/** Zod schema for {@link SubqueryNode}. */
export const SubqueryNodeSchema: z.ZodType<WithoutLocations<SubqueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Subquery'),
    query: QueryStatementSchema,
    alias: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * APPLY column transformer: `* APPLY (toString)` or `* APPLY x -> f(x)`.
 */
export type ColumnsApplyTransformerNode = {
  type: 'ColumnsApplyTransformer';
  func_name?: string;
  /** Parametric arguments when the applied function is parameterized. */
  parameters?: ExpressionListNode;
  /** Lambda form: `APPLY x -> expr`. */
  lambda?: FunctionNode;
  lambda_arg?: string;
} & NodeMetadata;

/** Zod schema for {@link ColumnsApplyTransformerNode}. */
export const ColumnsApplyTransformerSchema: z.ZodType<
  WithoutLocations<ColumnsApplyTransformerNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('ColumnsApplyTransformer'),
    func_name: z.string().optional(),
    parameters: ExpressionListNodeSchema.optional(),
    lambda: FunctionNodeSchema.optional(),
    lambda_arg: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * EXCEPT column transformer: `* EXCEPT (a, b)` or `* EXCEPT 'regex'`.
 * The regex form serializes with no children — the pattern lives in `pattern`.
 */
export type ColumnsExceptTransformerNode = {
  type: 'ColumnsExceptTransformer';
  is_strict?: boolean;
  columns?: IdentifierNode[];
  /** Regex pattern for the string form (`* EXCEPT 'regex'`). */
  pattern?: string;
} & NodeMetadata;

/** Zod schema for {@link ColumnsExceptTransformerNode}. */
export const ColumnsExceptTransformerSchema: z.ZodType<
  WithoutLocations<ColumnsExceptTransformerNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('ColumnsExceptTransformer'),
    is_strict: z.boolean().optional(),
    columns: z.array(IdentifierNodeSchema).optional(),
    pattern: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * One replacement inside a REPLACE transformer: `expr AS name`.
 */
export type ColumnsReplaceTransformerReplacementNode = {
  type: 'ColumnsReplaceTransformer::Replacement';
  name: string;
  expression: Expression;
} & NodeMetadata;

/** Zod schema for {@link ColumnsReplaceTransformerReplacementNode}. */
export const ColumnsReplaceTransformerReplacementSchema: z.ZodType<
  WithoutLocations<ColumnsReplaceTransformerReplacementNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('ColumnsReplaceTransformer::Replacement'),
    name: z.string(),
    expression: ExpressionSchema,
    ...ExprMetadataFields,
  }),
);

/**
 * REPLACE column transformer: `* REPLACE (a + 1 AS a)`.
 */
export type ColumnsReplaceTransformerNode = {
  type: 'ColumnsReplaceTransformer';
  is_strict?: boolean;
  replacements: ColumnsReplaceTransformerReplacementNode[];
} & NodeMetadata;

/** Zod schema for {@link ColumnsReplaceTransformerNode}. */
export const ColumnsReplaceTransformerSchema: z.ZodType<
  WithoutLocations<ColumnsReplaceTransformerNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('ColumnsReplaceTransformer'),
    is_strict: z.boolean().optional(),
    replacements: z.array(ColumnsReplaceTransformerReplacementSchema),
    ...ExprMetadataFields,
  }),
);

/** Any single column transformer. */
export type ColumnsTransformerNode =
  | ColumnsApplyTransformerNode
  | ColumnsExceptTransformerNode
  | ColumnsReplaceTransformerNode;

/** Zod schema for {@link ColumnsTransformerNode}. */
export const ColumnsTransformerSchema: z.ZodType<WithoutLocations<ColumnsTransformerNode>> = z.lazy(
  () =>
    z.union([
      ColumnsApplyTransformerSchema,
      ColumnsExceptTransformerSchema,
      ColumnsReplaceTransformerSchema,
    ]),
);

/**
 * The list of transformers attached to `*`, `t.*`, or `COLUMNS(...)`.
 */
export type ColumnsTransformerListNode = {
  type: 'ColumnsTransformerList';
  children: ColumnsTransformerNode[];
} & NodeMetadata;

/** Zod schema for {@link ColumnsTransformerListNode}. */
export const ColumnsTransformerListSchema: z.ZodType<WithoutLocations<ColumnsTransformerListNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('ColumnsTransformerList'),
      children: z.array(ColumnsTransformerSchema),
      ...ExprMetadataFields,
    }),
  );

/**
 * Bare `*` wildcard, with optional transformers. Tuple expansion `expr.*` is
 * also an Asterisk with the base in `expression`.
 */
export type AsteriskNode = {
  type: 'Asterisk';
  /** Native AST stores transformers as a flat array on plain `Asterisk` nodes. */
  transformers?: ColumnsTransformerListNode['children'];
  /** Base expression for tuple expansion `expr.*`. */
  expression?: Expression;
} & NodeMetadata;

/** Zod schema for {@link AsteriskNode}. */
export const AsteriskNodeSchema: z.ZodType<WithoutLocations<AsteriskNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Asterisk'),
    transformers: z.array(ColumnsTransformerSchema).optional(),
    expression: ExpressionSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * Qualified `table.*` or `db.table.*` wildcard.
 */
export type QualifiedAsteriskNode = {
  type: 'QualifiedAsterisk';
  qualifier: IdentifierNode;
  /** Native AST stores transformers as a flat array on `QualifiedAsterisk`. */
  transformers?: ColumnsTransformerListNode['children'];
} & NodeMetadata;

/** Zod schema for {@link QualifiedAsteriskNode}. */
export const QualifiedAsteriskNodeSchema: z.ZodType<WithoutLocations<QualifiedAsteriskNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('QualifiedAsterisk'),
      qualifier: IdentifierNodeSchema,
      transformers: z.array(ColumnsTransformerSchema).optional(),
      ...ExprMetadataFields,
    }),
  );

/**
 * A generic ordered list of nodes — ClickHouse's `ExpressionList` wrapper as it
 * appears in the native JSON (e.g. inside `QualifiedColumnsListMatcher.children`).
 */
export type ExpressionListNode = {
  type: 'ExpressionList';
  children?: ASTNode[];
} & NodeMetadata;

/** Zod schema for {@link ExpressionListNode}. */
export const ExpressionListNodeSchema: z.ZodType<WithoutLocations<ExpressionListNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('ExpressionList'),
      // Children may be any node type; validated loosely to avoid a global ASTNode schema union.
      children: z.array(ASTNodeSchema).optional(),
      ...ExprMetadataFields,
    }),
);

/**
 * `COLUMNS('regex')` matcher.
 */
export type ColumnsRegexpMatcherNode = {
  type: 'ColumnsRegexpMatcher';
  pattern: string;
  /** Plain matchers store transformers as a flat array. */
  transformers?: ColumnsTransformerListNode['children'];
} & NodeMetadata;

/** Zod schema for {@link ColumnsRegexpMatcherNode}. */
export const ColumnsRegexpMatcherSchema: z.ZodType<WithoutLocations<ColumnsRegexpMatcherNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('ColumnsRegexpMatcher'),
      pattern: z.string(),
      transformers: z.array(ColumnsTransformerSchema).optional(),
      ...ExprMetadataFields,
    }),
  );

/**
 * `COLUMNS(a, b, ...)` matcher.
 */
export type ColumnsListMatcherNode = {
  type: 'ColumnsListMatcher';
  columns: Expression[];
  /** Plain matchers store transformers as a flat array. */
  transformers?: ColumnsTransformerListNode['children'];
} & NodeMetadata;

/** Zod schema for {@link ColumnsListMatcherNode}. */
export const ColumnsListMatcherSchema: z.ZodType<WithoutLocations<ColumnsListMatcherNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('ColumnsListMatcher'),
      columns: z.array(ExpressionSchema),
      transformers: z.array(ColumnsTransformerSchema).optional(),
      ...ExprMetadataFields,
    }),
);

/**
 * `qualifier.COLUMNS('regex')` matcher.
 */
export type QualifiedColumnsRegexpMatcherNode = {
  type: 'QualifiedColumnsRegexpMatcher';
  pattern: string;
  qualifier: IdentifierNode;
  /** Qualified matchers wrap transformers in a `ColumnsTransformerList` node. */
  transformers?: ColumnsTransformerListNode;
} & NodeMetadata;

/** Zod schema for {@link QualifiedColumnsRegexpMatcherNode}. */
export const QualifiedColumnsRegexpMatcherSchema: z.ZodType<
  WithoutLocations<QualifiedColumnsRegexpMatcherNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('QualifiedColumnsRegexpMatcher'),
    pattern: z.string(),
    qualifier: IdentifierNodeSchema,
    transformers: ColumnsTransformerListSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * `qualifier.COLUMNS(a, b)` matcher.
 */
export type QualifiedColumnsListMatcherNode = {
  type: 'QualifiedColumnsListMatcher';
  qualifier: IdentifierNode;
  columns: Expression[];
  /** Qualified matchers wrap transformers in a `ColumnsTransformerList` node. */
  transformers?: ColumnsTransformerListNode;
} & NodeMetadata;

/** Zod schema for {@link QualifiedColumnsListMatcherNode}. */
export const QualifiedColumnsListMatcherSchema: z.ZodType<
  WithoutLocations<QualifiedColumnsListMatcherNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('QualifiedColumnsListMatcher'),
    qualifier: IdentifierNodeSchema,
    columns: z.array(ExpressionSchema),
    transformers: ColumnsTransformerListSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A SETTINGS clause / settings changes node. Inside function calls
 * (`f(x SETTINGS k=1)`) ClickHouse appends a `Set` node to the arguments.
 *
 * Matches ClickHouse's native AST: `changes` is a flat name→scalar map (lossy
 * — it loses ordering on duplicates, identifier-vs-string distinction, and any
 * expression structure beyond what {@link Expression}-to-compact-text encoding
 * can preserve), and `default_settings` captures the names of `SET x = DEFAULT`
 * resets. Query parameters (`SET param_x = ...`) are also stored in `changes`
 * (the native AST drops them entirely, but the formatter needs them to
 * round-trip; the reference-AST test strips library-only `param_*` keys
 * before comparing).
 */
export type SettingsNode = {
  type: 'Settings' | 'DictionarySettings';
  changes?: Record<
    string,
    string | number | boolean | null | LiteralElement[] | Record<string, LiteralElement>
  >;
  default_settings?: string[];
} & NodeMetadata;

/** Zod schema for {@link SettingsNode}. */
export const SettingsNodeSchema: z.ZodType<WithoutLocations<SettingsNode>> = z.lazy(() =>
  z.object({
    type: z.union([z.literal('Settings'), z.literal('DictionarySettings')]),
    changes: z
      .record(
        z.string(),
        z.union([
          z.string(),
          // Custom check: z.number() rejects NaN/Infinity (e.g. SET x = inf)
          z.custom<number>((v) => typeof v === 'number'),
          z.boolean(),
          z.null(),
          // Array/tuple-valued settings: typed element list.
          z.array(LiteralElementSchema),
          // Map-valued settings: map object {key: {value_type, value}}.
          z.record(z.string(), LiteralElementSchema),
        ]),
      )
      .optional(),
    default_settings: z.array(z.string()).optional(),
    ...ExprMetadataFields,
  }),
);

// ── ClickHouse-native statement nodes (SELECT family) ────────────────────────

/**
 * A table named in a FROM clause: `db.table [AS alias]`.
 *
 * `name` and `database` are plain strings for ordinary table references,
 * matching ClickHouse's native AST. When a name is written as an
 * identifier-position query parameter (`{db:Identifier}.t`), that segment is
 * a {@link QueryParameterNode} instead — ClickHouse itself cannot serialize an
 * unsubstituted parameter (it errors), so this is a library-only extension
 * that keeps the parameter's structure in-place rather than encoding it as a
 * raw `{name:Type}` string.
 */
export type TableIdentifierNode = {
  type: 'TableIdentifier';
  name: IdentifierPart;
  database?: IdentifierPart;
  alias?: string;
} & NodeMetadata;

/** Zod schema for {@link TableIdentifierNode}. */
export const TableIdentifierSchema: z.ZodType<WithoutLocations<TableIdentifierNode>> = z.lazy(() =>
  z.object({
    type: z.literal('TableIdentifier'),
    name: IdentifierPartSchema,
    database: IdentifierPartSchema.optional(),
    alias: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A sample ratio in a SAMPLE clause, normalized to a fraction. The source
 * spelling is not preserved — `SAMPLE 0.1` canonicalizes to `SAMPLE 1/10`.
 *
 * @example `SAMPLE 1/10` → `{ numerator: '1', denominator: '10' }`
 * @example `SAMPLE 0.1` → `{ numerator: '1', denominator: '10' }`
 */
export type SampleRatioNode = {
  type: 'SampleRatio';
  numerator: string;
  denominator: string;
} & NodeMetadata;

/** Zod schema for {@link SampleRatioNode}. */
export const SampleRatioSchema: z.ZodType<WithoutLocations<SampleRatioNode>> = z.object({
  type: z.literal('SampleRatio'),
  numerator: z.string(),
  denominator: z.string(),
  ...ExprMetadataFields,
});

/**
 * One source in a FROM clause: a named table, table function, or subquery,
 * with FINAL/SAMPLE modifiers.
 */
export type TableExpressionNode = {
  type: 'TableExpression';
  database_and_table_name?: TableIdentifierNode;
  table_function?: FunctionNode;
  subquery?: SubqueryNode;
  final?: boolean;
  sample_size?: SampleRatioNode;
  sample_offset?: SampleRatioNode;
  /** Column aliases after a subquery alias: `(SELECT ...) AS t (a, b)`. */
  column_aliases?: ExpressionListNode;
} & NodeMetadata;

/** Zod schema for {@link TableExpressionNode}. */
export const TableExpressionSchema: z.ZodType<WithoutLocations<TableExpressionNode>> = z.lazy(() =>
  z.object({
    type: z.literal('TableExpression'),
    database_and_table_name: TableIdentifierSchema.optional(),
    table_function: FunctionNodeSchema.optional(),
    subquery: SubqueryNodeSchema.optional(),
    final: z.boolean().optional(),
    sample_size: SampleRatioSchema.optional(),
    sample_offset: SampleRatioSchema.optional(),
    column_aliases: ExpressionListNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * A JOIN's kind/strictness/condition.
 */
export type TableJoinNode = {
  type: 'TableJoin';
  kind: 'INNER' | 'LEFT' | 'RIGHT' | 'FULL' | 'CROSS' | 'COMMA' | 'PASTE';
  strictness?: 'ANY' | 'ALL' | 'ASOF' | 'SEMI' | 'ANTI';
  locality?: 'GLOBAL';
  using?: Expression[];
  on?: Expression;
} & NodeMetadata;

/** Zod schema for {@link TableJoinNode}. */
export const TableJoinSchema: z.ZodType<WithoutLocations<TableJoinNode>> = z.lazy(() =>
  z.object({
    type: z.literal('TableJoin'),
    kind: z.union([
      z.literal('INNER'),
      z.literal('LEFT'),
      z.literal('RIGHT'),
      z.literal('FULL'),
      z.literal('CROSS'),
      z.literal('COMMA'),
      z.literal('PASTE'),
    ]),
    strictness: z
      .union([
        z.literal('ANY'),
        z.literal('ALL'),
        z.literal('ASOF'),
        z.literal('SEMI'),
        z.literal('ANTI'),
      ])
      .optional(),
    locality: z.literal('GLOBAL').optional(),
    using: z.array(ExpressionSchema).optional(),
    on: ExpressionSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * An ARRAY JOIN clause.
 */
export type ArrayJoinNode = {
  type: 'ArrayJoin';
  /** `'INNER'` for plain ARRAY JOIN, `'LEFT'` for LEFT ARRAY JOIN. */
  kind: 'INNER' | 'LEFT';
  expressions: Expression[];
} & NodeMetadata;

/** Zod schema for {@link ArrayJoinNode}. */
export const ArrayJoinSchema: z.ZodType<WithoutLocations<ArrayJoinNode>> = z.lazy(() =>
  z.object({
    type: z.literal('ArrayJoin'),
    kind: z.union([z.literal('INNER'), z.literal('LEFT')]),
    expressions: z.array(ExpressionSchema),
    ...ExprMetadataFields,
  }),
);

/**
 * One element of a FROM clause: a table expression, optionally preceded by the
 * join that connects it to the previous element, or an ARRAY JOIN.
 */
export type TablesInSelectQueryElementNode = {
  type: 'TablesInSelectQueryElement';
  table_expression?: TableExpressionNode;
  table_join?: TableJoinNode;
  array_join?: ArrayJoinNode;
} & NodeMetadata;

/** Zod schema for {@link TablesInSelectQueryElementNode}. */
export const TablesInSelectQueryElementSchema: z.ZodType<
  WithoutLocations<TablesInSelectQueryElementNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('TablesInSelectQueryElement'),
    table_expression: TableExpressionSchema.optional(),
    table_join: TableJoinSchema.optional(),
    array_join: ArrayJoinSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * The full FROM clause: a flat list of table elements joined in order.
 */
export type TablesInSelectQueryNode = {
  type: 'TablesInSelectQuery';
  children: TablesInSelectQueryElementNode[];
} & NodeMetadata;

/** Zod schema for {@link TablesInSelectQueryNode}. */
export const TablesInSelectQuerySchema: z.ZodType<WithoutLocations<TablesInSelectQueryNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('TablesInSelectQuery'),
      children: z.array(TablesInSelectQueryElementSchema),
      ...ExprMetadataFields,
    }),
  );

/**
 * A subquery CTE in a WITH clause: `WITH name AS (SELECT ...)`.
 */
export type WithElementNode = {
  type: 'WithElement';
  name: string;
  subquery: SubqueryNode;
  /** Column aliases: `WITH t (a, b) AS (...)`. */
  aliases?: ExpressionListNode;
} & NodeMetadata;

/** Zod schema for {@link WithElementNode}. */
export const WithElementSchema: z.ZodType<WithoutLocations<WithElementNode>> = z.lazy(() =>
  z.object({
    type: z.literal('WithElement'),
    name: z.string(),
    subquery: SubqueryNodeSchema,
    aliases: ExpressionListNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/** A WITH clause item: a named subquery or an (aliased) expression. */
export type WithItem = Expression | WithElementNode;

/** Zod schema for {@link WithItem}. */
export const WithItemSchema: z.ZodType<WithoutLocations<WithItem>> = z.lazy(() =>
  z.union([WithElementSchema, ExpressionSchema]),
);

/**
 * A named window definition: `WINDOW name AS (spec)`.
 */
export type WindowListElementNode = {
  type: 'WindowListElement';
  name: string;
  definition: WindowDefinitionNode;
} & NodeMetadata;

/** Zod schema for {@link WindowListElementNode}. */
export const WindowListElementSchema: z.ZodType<WithoutLocations<WindowListElementNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('WindowListElement'),
      name: z.string(),
      definition: WindowDefinitionSchema,
      ...ExprMetadataFields,
    }),
);

/**
 * A single SELECT query (one member of a SelectWithUnionQuery).
 */
export type SelectQueryNode = {
  type: 'SelectQuery';
  with?: WithItem[];
  recursive_with?: boolean;
  /**
   * Library-only: set when the `WITH` clause was written before an enclosing
   * `INSERT` (`WITH ... INSERT INTO ... SELECT ...`). ClickHouse appends the
   * WITH ExpressionList after the select body in EXPLAIN AST; this flag lets
   * the explain projection reproduce that ordering.
   */
  _with_trailing?: boolean;
  /**
   * Library-only: marks the synthetic SelectQuery produced when lowering
   * `expr op ANY/ALL (subquery)`. ClickHouse's EXPLAIN AST text dumps the
   * projection + tables twice for this node; the flag drives that doubling.
   */
  _agg_repeat?: boolean;
  distinct?: boolean;
  select: Expression[];
  from?: TablesInSelectQueryNode;
  prewhere?: Expression;
  where?: Expression;
  group_by?: (Expression | ExpressionListNode)[];
  group_by_all?: boolean;
  group_by_with_totals?: boolean;
  group_by_with_rollup?: boolean;
  group_by_with_cube?: boolean;
  group_by_with_grouping_sets?: boolean;
  having?: Expression;
  window?: WindowListElementNode[];
  qualify?: Expression;
  order_by?: OrderByElementNode[];
  order_by_all?: boolean;
  interpolate?: InterpolateElementNode[];
  /**
   * `LIMIT n BY cols [OFFSET m]` is grouped into a single object matching
   * ClickHouse's native AST shape. `by` is the list of columns to limit
   * groups by; `length` is the per-group row count; optional `offset`
   * skips that many leading rows in each group.
   */
  limit_by?: {
    length: Expression;
    offset?: Expression;
    by: Expression[];
  };
  /** Row count for the trailing `LIMIT n [OFFSET m]` clause. */
  limit?: Expression;
  /** Skip count for the trailing `LIMIT/OFFSET` clause. */
  offset?: Expression;
  settings?: SettingsNode;
  /**
   * `true` when LIMIT/FETCH/TOP ... WITH TIES was specified. WITH TIES is
   * semantically meaningful (extends the result set to include rows tied with
   * the last row at the limit), so this flag is preserved across canonical
   * `LIMIT n WITH TIES` formatting regardless of the original syntactic form.
   */
  limit_with_ties?: boolean;
} & NodeMetadata;

/** Zod schema for {@link SelectQueryNode}. */
export const SelectQuerySchema: z.ZodType<WithoutLocations<SelectQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('SelectQuery'),
    with: z.array(WithItemSchema).optional(),
    recursive_with: z.boolean().optional(),
    _with_trailing: z.boolean().optional(),
    _agg_repeat: z.boolean().optional(),
    distinct: z.boolean().optional(),
    select: z.array(ExpressionSchema),
    from: TablesInSelectQuerySchema.optional(),
    prewhere: ExpressionSchema.optional(),
    where: ExpressionSchema.optional(),
    group_by: z.array(z.union([ExpressionSchema, ExpressionListNodeSchema])).optional(),
    group_by_all: z.boolean().optional(),
    group_by_with_totals: z.boolean().optional(),
    group_by_with_rollup: z.boolean().optional(),
    group_by_with_cube: z.boolean().optional(),
    group_by_with_grouping_sets: z.boolean().optional(),
    having: ExpressionSchema.optional(),
    window: z.array(WindowListElementSchema).optional(),
    qualify: ExpressionSchema.optional(),
    order_by: z.array(OrderByElementSchema).optional(),
    order_by_all: z.boolean().optional(),
    interpolate: z.array(InterpolateElementSchema).optional(),
    limit_by: z
      .object({
        length: ExpressionSchema,
        offset: ExpressionSchema.optional(),
        by: z.array(ExpressionSchema),
      })
      .optional(),
    limit: ExpressionSchema.optional(),
    offset: ExpressionSchema.optional(),
    settings: SettingsNodeSchema.optional(),
    limit_with_ties: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * Trailing output clauses shared by query wrappers (INTO OUTFILE, FORMAT, and
 * the trailing SETTINGS clause). All are native fields that ClickHouse's JSON
 * exposes on the query wrapper (`ASTQueryWithOutput`).
 */
export type QueryTrailingFields = {
  /** Native trailing `INTO OUTFILE 'path'` target literal. */
  out_file?: LiteralNode;
  /** Native `TRUNCATE` flag on `INTO OUTFILE` (present only when set). */
  outfile_truncate?: boolean;
  /** Native trailing `FORMAT name`. */
  format?: string;
  /**
   * Native trailing `SETTINGS` clause. ClickHouse allows `SETTINGS` on either
   * side of `FORMAT`, but this is a purely syntactic difference (both land in
   * the same wrapper-level settings and apply identically).
   */
  settings?: SettingsNode;
  /**
   * Library-only: `true` when the trailing SETTINGS was written *before* the
   * FORMAT clause (`... SETTINGS x FORMAT F`). ClickHouse's native JSON drops
   * this ordering, but its EXPLAIN AST child order preserves it, so
   * `formatExplain()` needs it to match ClickHouse exactly. `format()` does
   * *not* use it — it canonicalizes to ClickHouse's re-emitted order (SETTINGS
   * after FORMAT) — so the flag may flip across a reformat and is treated as
   * volatile in round-trip comparisons.
   */
  _settings_before_format?: boolean;
};

const QueryTrailingSchemaFields = {
  out_file: LiteralNodeSchema.optional(),
  outfile_truncate: z.boolean().optional(),
  format: z.string().optional(),
  settings: SettingsNodeSchema.optional(),
  _settings_before_format: z.boolean().optional(),
};

/**
 * The wrapper around one or more SELECTs combined with UNION. Every query
 * statement is wrapped in one of these, mirroring ClickHouse.
 */
export type SelectWithUnionQueryNode = {
  type: 'SelectWithUnionQuery';
  selects: (SelectQueryNode | SelectIntersectExceptQueryNode | SelectWithUnionQueryNode)[];
  union_mode?: 'UNION_ALL' | 'UNION_DISTINCT';
} & QueryTrailingFields &
  NodeMetadata;

/** Zod schema for {@link SelectWithUnionQueryNode}. */
export const SelectWithUnionQuerySchema: z.ZodType<WithoutLocations<SelectWithUnionQueryNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('SelectWithUnionQuery'),
      selects: z.array(
        z.union([SelectQuerySchema, SelectIntersectExceptQuerySchema, SelectWithUnionQuerySchema]),
      ),
      union_mode: z.union([z.literal('UNION_ALL'), z.literal('UNION_DISTINCT')]).optional(),
      ...QueryTrailingSchemaFields,
      ...ExprMetadataFields,
    }),
  );

/**
 * An INTERSECT/EXCEPT combination of two queries.
 *
 * The operator is always stored as the fully-qualified `INTERSECT/EXCEPT
 * ALL/DISTINCT` form. ClickHouse defaults bare `INTERSECT`/`EXCEPT` to the
 * `ALL` variant; format() always emits the canonical fully-qualified form.
 */
export type SelectIntersectExceptQueryNode = {
  type: 'SelectIntersectExceptQuery';
  operator: 'INTERSECT ALL' | 'INTERSECT DISTINCT' | 'EXCEPT ALL' | 'EXCEPT DISTINCT';
  selects: (SelectQueryNode | SelectIntersectExceptQueryNode | SelectWithUnionQueryNode)[];
} & QueryTrailingFields &
  NodeMetadata;

/** Zod schema for {@link SelectIntersectExceptQueryNode}. */
export const SelectIntersectExceptQuerySchema: z.ZodType<
  WithoutLocations<SelectIntersectExceptQueryNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('SelectIntersectExceptQuery'),
    operator: z.union([
      z.literal('INTERSECT ALL'),
      z.literal('INTERSECT DISTINCT'),
      z.literal('EXCEPT ALL'),
      z.literal('EXCEPT DISTINCT'),
    ]),
    selects: z.array(
      z.union([SelectQuerySchema, SelectIntersectExceptQuerySchema, SelectWithUnionQuerySchema]),
    ),
    ...QueryTrailingSchemaFields,
    ...ExprMetadataFields,
  }),
);

/**
 * Union of all expression node types. Use the `type` field to discriminate.
 */
export type Expression =
  | LiteralNode
  | IdentifierNode
  | FunctionNode
  | AsteriskNode
  | QualifiedAsteriskNode
  | SubqueryNode
  | QueryParameterNode
  | ColumnsRegexpMatcherNode
  | ColumnsListMatcherNode
  | QualifiedColumnsRegexpMatcherNode
  | QualifiedColumnsListMatcherNode
  // Set appears in expression position as a trailing Function argument for
  // f(x SETTINGS k = v).
  | SettingsNode
  // Bare SELECT arguments (`view(SELECT ...)`) are unwrapped query nodes.
  | SelectWithUnionQueryNode;

/**
 * Zod schema for {@link Expression}. Uses `z.lazy` for recursive references.
 */
export const ExpressionSchema: z.ZodType<WithoutLocations<Expression>> = z.lazy(() =>
  z.union([
    LiteralNodeSchema,
    IdentifierNodeSchema,
    FunctionNodeSchema,
    AsteriskNodeSchema,
    QualifiedAsteriskNodeSchema,
    SubqueryNodeSchema,
    QueryParameterSchema,
    ColumnsRegexpMatcherSchema,
    ColumnsListMatcherSchema,
    QualifiedColumnsRegexpMatcherSchema,
    QualifiedColumnsListMatcherSchema,
    SettingsNodeSchema,
    SelectWithUnionQuerySchema,
  ]),
);

// ── Transitional aliases (kind→type rewrite) ─────────────────────────────────

/** Old name for {@link QueryParameterNode}, kept while statement types migrate. */
export type QueryParam = QueryParameterNode;
/** An identifier-position value: plain string or an Identifier query parameter. */
export type Identifier = IdentifierPart;
/** Old name for {@link OrderByElementNode}, kept while statement types migrate. */
export type OrderByItem = OrderByElementNode;
/** Old name for {@link WindowDefinitionNode}, kept while statement types migrate. */
export type WindowSpec = WindowDefinitionNode;
/** Old name for {@link LiteralNode}, kept while statement types migrate. */
export type Literal = LiteralNode;
/**
 * A single ratio value used in SAMPLE clauses.
 *
 * @example Fraction form: `SAMPLE 1/10` → `{ num: '1', den: '10' }`
 * @example Simple number: `SAMPLE 0.1` → `{ num: '0.1' }`
 */
export type SampleRatioValue = {
  /** The numerator (or the entire value for non-fraction form). */
  num: string;
  /** The denominator, present only for fraction form (e.g. `1/10`). */
  den?: string;
};

/**
 * A SAMPLE clause on a table reference.
 *
 * @example `SAMPLE 1/10` → `{ ratio: { num: '1', den: '10' } }`
 * @example `SAMPLE 1/10 OFFSET 1/2` → `{ ratio: { num: '1', den: '10' }, offset: { num: '1', den: '2' } }`
 */
export type SampleClause = {
  /** The sample ratio. */
  ratio: SampleRatioValue;
  /** Optional offset ratio for the sample. */
  offset?: SampleRatioValue;
};

/**
 * A table reference in a FROM clause.
 *
 * @example `system.one` → `{ kind: 'tableRef', database: 'system', table: 'one' }`
 * @example `t FINAL` → `{ kind: 'tableRef', table: 't', final: true }`
 * @example `t AS alias` → `{ kind: 'tableRef', table: 't', alias: 'alias' }`
 */
export type TableRef = {
  kind: 'tableRef';
  database?: Identifier;
  table: Identifier;
  alias?: string;
  final?: boolean;
  sample?: SampleClause;
} & NodeMetadata;

/**
/**
 * A single key-value setting: `name = value`.
 *
 * Used in SETTINGS clauses and function-level settings.
 *
 * @example `max_threads = 4` → `{ name: 'max_threads', value: { kind: 'literal', type: 'UInt64', value: '4' } }`
 */
export type SettingItem = {
  /** The setting name. */
  name: string;
  /** The setting value expression. */
  value: Expression;
};

/**
 * Metadata fields common to all AST nodes: comments, source location, and parent reference.
 */
export type NodeMetadata = {
  /** Comments appearing before this node. Each string is the full comment text including delimiters. */
  leadingComments?: string[];
  /** Comments appearing on the same line as the end of this node (inline trailing). */
  trailingComments?: string[];
  /**
   * Source location in the original SQL input. Every node the parser emits
   * carries one when `parse` runs with locations enabled (the default), so it
   * is a required property. `parse(sql, { locations: false })` strips it — the
   * returned AST is then typed as {@link WithoutLocations}, where the property
   * is absent entirely.
   */
  location: SourceLocation;
  /** Reference to the parent AST node. Set by {@link setParents}. */
  parent?: ASTNode;
};

/**
 * Recursively removes the `location` metadata property from `T` and every
 * nested node/array within it.
 *
 * Two uses:
 *  - The return type of `parse(sql, { locations: false })`: the resulting AST
 *    provably carries no `location` anywhere, so accessing `.location` is a
 *    compile-time error and the tree is JSON-serializable w.r.t. source
 *    positions.
 *  - The **input** type of the AST-consuming functions (`format`,
 *    `formatExplain`, `formatNode`, `transformNodes`). Those functions have no
 *    need for locations (and a transform cannot keep them accurate once it
 *    changes the SQL), so they accept the location-free view. Because a fully
 *    located node is assignable to its `WithoutLocations` counterpart (an extra
 *    property is allowed) but not vice-versa, these functions transparently
 *    accept both a parsed (located) AST and a `{ locations: false }` one, while
 *    never letting a location-free AST reach a context that requires locations.
 */
export type WithoutLocations<T> = T extends (infer U)[]
  ? WithoutLocations<U>[]
  : T extends object
    ? { [K in keyof T as K extends 'location' ? never : K]: WithoutLocations<T[K]> }
    : T;

/**
 * Union of statement types that produce query results. These can appear in
 * subqueries, CTEs, UNION members, and other contexts that expect a result set.
 */
export type QueryStatement =
  | SelectWithUnionQueryNode
  | SelectIntersectExceptQueryNode
  | ExplainQueryNode;

/**
 * `EXPLAIN [kind] [settings] [statement]` in ClickHouse's native shape.
 * `kind` is the full keyword string (`"EXPLAIN"`, `"EXPLAIN AST"`,
 * `"EXPLAIN SYNTAX"`, ...). `query` carries the explained statement
 * directly. EXPLAIN-level settings live in `settings` (a native field);
 * post-format SETTINGS live in `output_settings` (a native field).
 */
export type ExplainQueryNode = {
  type: 'Explain';
  /** EXPLAIN keyword phrase: `"EXPLAIN"`, `"EXPLAIN AST"`, `"EXPLAIN SYNTAX"`, ... */
  kind?: string;
  /** The explained inner statement. */
  query?: Statement;
  /** EXPLAIN-level settings written as `EXPLAIN AST setting = value SELECT ...` */
  settings?: SettingsNode;
  /** Native trailing FORMAT name. */
  format?: string;
  /** Native post-format SETTINGS trailer (after FORMAT). */
  output_settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link ExplainQueryNode}. */
export const ExplainQueryNodeSchema: z.ZodType<WithoutLocations<ExplainQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Explain'),
    kind: z.string().optional(),
    query: z.lazy(() => StatementSchema).optional(),
    settings: SettingsNodeSchema.optional(),
    format: z.string().optional(),
    output_settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

// ── Role target ──────────────────────────────────────────────────────────────

/** A target clause for role/user specifications (TO ALL/NONE/names). */
export type RoleTarget =
  | { kind: 'all'; except?: string[] }
  | { kind: 'none' }
  | { kind: 'names'; names: string[] };

/** Default role clause (same structure as RoleTarget). */
export type DefaultRoleClause = RoleTarget;

// ── Access control shared types ──────────────────────────────────────────────

/** Name with optional @'host' for access control entities. */
export type AccessControlName = { name: string; host?: string };

/** HOST specification items for CREATE USER. */
export type HostItem =
  | { kind: 'any' }
  | { kind: 'none' }
  | { kind: 'local' }
  | { kind: 'name'; value: string }
  | { kind: 'regexp'; value: string }
  | { kind: 'like'; value: string }
  | { kind: 'ip'; value: string };

/**
 * Access control SETTINGS items (different from query-level SettingItem).
 * Used in CREATE USER, CREATE ROLE, CREATE SETTINGS PROFILE.
 */
export type AccessControlSettingsItem =
  | { kind: 'profile'; name: string }
  | { kind: 'inherit'; name: string }
  | {
      kind: 'setting';
      name: string;
      value?: Expression;
      min?: Expression;
      max?: Expression;
      modifier?: 'CONST' | 'WRITABLE' | 'READONLY';
    };

// ── CREATE TABLE types ───────────────────────────────────────────────────────

/** An index type, e.g. `minmax`, `set(100)`, `bloom_filter(0.01)`. */
export type IndexType = {
  /** Type name, e.g. `'minmax'`, `'set'`, `'bloom_filter'`. */
  name: string;
  /** Type arguments. `undefined` means no parentheses. */
  args?: Expression[];
};

export type TableOrderByItem = { expr: Expression; dir?: 'ASC' | 'DESC' };

/** Authentication data for a CREATE USER statement. */
export type AuthenticationData = {
  /** Secret value (password, hash, realm, server name). */
  secret?: string;
  /** SSH public keys (for the `ssh_key` auth type): `KEY '<key>' TYPE '<type>'`. */
  sshKeys?: { key: string; type: string }[];
};

// ── ALTER TABLE statement ─────────────────────────────────────────────────────

/**
 * The kind of partition expression in an ALTER command.
 */
export type AlterPartitionExpr =
  | { partitionKind: 'all' }
  | { partitionKind: 'id'; id: Literal | QueryParam }
  | { partitionKind: 'expr'; expr: Expression };

/** A single privilege in a GRANT/REVOKE statement, e.g. `SELECT(col1, col2)`. */
export type GrantPrivilege = {
  /** The privilege name (may be multi-word, e.g. `CREATE TEMPORARY TABLE`). */
  name: string;
  /** Optional column list for column-level privileges. */
  columns?: string[];
};

/**
 * The `ON` target of a privilege grant.
 *
 * Parts may be `*` (wildcard) or wildcard-suffixed identifiers like `test*`.
 *
 * @example `db1.*` → `{ database: 'db1', table: '*' }`
 * @example `*.*` → `{ database: '*', table: '*' }`
 * @example `S3` → `{ table: 'S3' }`
 */
export type GrantTarget = {
  /** Database part (absent for single-part targets). */
  database?: string;
  /** Table/object part. */
  table: string;
};

/**
 * One `privileges ON target` element of a privilege grant.
 *
 * A single GRANT may grant several privileges on several targets, e.g.
 * `GRANT SELECT ON a.*, INSERT ON b.* TO u`.
 */
export type GrantElement = {
  /** Privileges granted/revoked on this target. */
  privileges: GrantPrivilege[];
  /** The `ON` target. */
  target: GrantTarget;
};

/**
 * A GRANT or REVOKE statement.
 *
 * Either `elements` (privilege grant) or `roles` (role grant) is set.
 *
 * @example `GRANT SELECT ON db.* TO u` →
 *   `{ kind: 'grant', operation: 'GRANT', elements: [{ privileges: [{ name: 'SELECT' }], target: { database: 'db', table: '*' } }], grantees: ['u'] }`
 */
export type GrantStatement = {
  kind: 'grant';
  /** Whether this grants or revokes. */
  operation: 'GRANT' | 'REVOKE';
  /** Privilege-on-target elements (privilege grant). */
  elements?: GrantElement[];
  /** Role names being granted/revoked (role grant). */
  roles?: string[];
  /** The users/roles receiving (GRANT) or losing (REVOKE) the grant. */
  grantees: string[];
  /** Optional ON CLUSTER clause. */
  onCluster?: string;
  /** REVOKE `GRANT OPTION FOR` / `ADMIN OPTION FOR` prefix. */
  optionFor?: 'GRANT' | 'ADMIN';
  /** Trailing `WITH ... OPTION` modifiers. */
  withOptions?: ('GRANT' | 'ADMIN' | 'REPLACE')[];
} & NodeMetadata;

/** A single clause of an ALTER USER statement. */
export type AlterUserClause =
  | { kind: 'rename'; to: AccessControlName }
  | { kind: 'identified'; auth: AuthenticationData[] }
  | { kind: 'notIdentified' }
  | { kind: 'host'; mode?: 'ADD' | 'DROP'; hosts: HostItem[] }
  | { kind: 'settings'; settings: AccessControlSettingsItem[] | 'NONE' }
  | { kind: 'defaultRole'; roles: RoleTarget }
  | { kind: 'defaultDatabase'; database: string }
  | { kind: 'grantees'; grantees: RoleTarget }
  | { kind: 'validUntil'; value: string };

/**
 * An empty statement — a bare `;` between real statements. Preserved so AST
 * indices align with ClickHouse's EXPLAIN AST output (which emits an error
 * placeholder for the empty statement).
 */
export type EmptyQueryNode = {
  type: 'EmptyQuery';
} & NodeMetadata;

/** Zod schema for {@link EmptyQueryNode}. */
export const EmptyQueryNodeSchema: z.ZodType<WithoutLocations<EmptyQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('EmptyQuery'),
    ...ExprMetadataFields,
  }),
);

/**
 * Union of all top-level statement types.
 *
 * Use the `kind` field to discriminate between variants.
 */

/**
 * Shared table-target shape used by drop-family statements and by the
 * sibling node types that mirror ClickHouse's identical native AST layout
 * (`ShowCreate*`, `Exists*`, `CheckQuery`, `AttachQuery`). The native JSON
 * splits the target into explicit `database` / `table` Identifier fields
 * (with `_multi_tables` for the uncommon multi-table form) and exposes flat
 * modifier flags (`if_exists`, `temporary`, `is_dictionary`, `is_view`,
 * `sync`) plus `cluster`. Library-only underscore fields preserve target
 * keyword disambiguation, SETTINGS/FORMAT trailers, etc.
 */
type TableTargetFields = {
  /** Bare table name Identifier (e.g. `foo` in `DROP TABLE db.foo`). */
  table?: IdentifierNode;
  /** Database name Identifier (qualifier for `table`, or sole target for `DROP DATABASE`). */
  database?: IdentifierNode;
  if_exists?: boolean;
  if_empty?: boolean;
  temporary?: boolean;
  is_dictionary?: boolean;
  is_view?: boolean;
  sync?: boolean;
  /** ON CLUSTER cluster name. */
  cluster?: string;
  /** Explicit `UUID '...'` (only `UNDROP TABLE` carries one in this family). */
  uuid?: string;
  /**
   * Multi-table list (`DROP TABLE t1, t2, ...`) serialized as an
   * `ExpressionList` of `TableIdentifier`s — matches ClickHouse's native AST.
   */
  database_and_tables?: ExpressionListNode;
  /** Library-only SETTINGS trailer. */
  settings?: SettingsNode;
  /** Native FORMAT trailer (`FORMAT Null`, `FORMAT JSON`, ...). */
  format?: string;
} & NodeMetadata;

/**
 * Drop-family extension that adds the native `kind` discriminator (matches
 * the node `type` minus the `Query` suffix). `UndropQuery` doesn't carry
 * `kind` in the native AST and its grammar override leaves it unset.
 */
type DropFamilyFields = {
  /** Action keyword. Omitted from `UndropQuery`. */
  kind?: 'DROP' | 'DETACH' | 'TRUNCATE';
} & TableTargetFields;

/** `DROP TABLE/DATABASE/DICTIONARY/VIEW ...` */
export type DropQueryNode = { type: 'DropQuery' } & DropFamilyFields;

/** `DETACH TABLE/DATABASE/VIEW/DICTIONARY ...` */
export type DetachQueryNode = {
  type: 'DetachQuery';
  permanently?: boolean;
} & DropFamilyFields;

/** `TRUNCATE TABLE/DATABASE/ALL TABLES FROM ...` */
export type TruncateQueryNode = {
  type: 'TruncateQuery';
  /** `true` when the `ALL` keyword was present (`TRUNCATE ALL TABLES FROM db`). */
  has_all?: boolean;
  /** `true` when the `TABLES` keyword was present (`TRUNCATE [ALL] TABLES FROM db`). */
  has_tables?: boolean;
  /** `[NOT] [I]LIKE 'pattern'` filter on `TRUNCATE ALL TABLES FROM db`. */
  like?: string;
  /** `true` when the LIKE filter was written as `NOT LIKE` / `NOT ILIKE`. */
  not_like?: boolean;
  /** `true` when the LIKE filter used the case-insensitive `ILIKE` form. */
  case_insensitive_like?: boolean;
} & DropFamilyFields;

/** `DROP FUNCTION name` — ClickHouse's JSON keeps `function_name` and `if_exists`. */
export type DropFunctionQueryNode = {
  type: 'DropFunctionQuery';
  /** The user-defined function name being dropped. */
  function_name: string;
  /** `true` for `DROP FUNCTION IF EXISTS`. */
  if_exists?: boolean;
  /** Library-only: the `ON CLUSTER` name (the native JSON does not emit it). */
  cluster?: string;
} & NodeMetadata;

/** Zod schema for {@link DropFunctionQueryNode}. */
export const DropFunctionQueryNodeSchema: z.ZodType<WithoutLocations<DropFunctionQueryNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('DropFunctionQuery'),
      function_name: z.string(),
      if_exists: z.boolean().optional(),
      cluster: z.string().optional(),
      ...ExprMetadataFields,
    }),
  );

/**
 * `DROP USER / ROLE / ROW POLICY / SETTINGS PROFILE / QUOTA / NAMED COLLECTION
 * / WORKLOAD / RESOURCE`. All forms are fully structured: the access-entity
 * drops carry the native `entity_type` + `names` / `row_policy_names` (+
 * `if_exists` / `cluster` / `storage_name`), and the collection / workload /
 * resource drops carry `collection_name` / `workload_name` / `resource_name`.
 * `format()` re-emits everything from these fields.
 */
export type AccessDropQueryNode = {
  type:
    | 'DropAccessEntityQuery'
    | 'DropNamedCollectionQuery'
    | 'DropWorkloadQuery'
    | 'DropResourceQuery';
  /**
   * The access-entity kind for `DropAccessEntityQuery`, e.g. `'USER'`,
   * `'ROLE'`, `'QUOTA'`, `'SETTINGS PROFILE'`, `'ROW POLICY'`.
   */
  entity_type?: string;
  /** `true` when `IF EXISTS` was given. */
  if_exists?: boolean;
  /** `ON CLUSTER` name. */
  cluster?: string;
  /** Dropped entity names (non-row-policy entities). */
  names?: string[];
  /** Access storage the entities are dropped from (`FROM <storage>`). */
  storage_name?: string;
  /** Dropped row policies (for `entity_type === 'ROW POLICY'`). */
  row_policy_names?: RowPolicyNamesNode;
  /** Named-collection name (for `DropNamedCollectionQuery`). */
  collection_name?: string;
  /** Workload name (for `DropWorkloadQuery`). */
  workload_name?: string;
  /** Resource name (for `DropResourceQuery`). */
  resource_name?: string;
} & NodeMetadata;

/** Zod schema for {@link AccessDropQueryNode}. */
export const AccessDropQueryNodeSchema: z.ZodType<WithoutLocations<AccessDropQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.union([
        z.literal('DropAccessEntityQuery'),
        z.literal('DropNamedCollectionQuery'),
        z.literal('DropWorkloadQuery'),
        z.literal('DropResourceQuery'),
      ]),
      collection_name: z.string().optional(),
      workload_name: z.string().optional(),
      resource_name: z.string().optional(),
      ...ExprMetadataFields,
    }),
);

/** `DROP INDEX name ON [db.]table`. */
export type DropIndexQueryNode = {
  type: 'DropIndexQuery';
  table: IdentifierNode;
  database?: IdentifierNode;
  index_name: IdentifierNode;
  if_exists?: boolean;
} & NodeMetadata;

/** Zod schema for {@link DropIndexQueryNode}. */
export const DropIndexQueryNodeSchema: z.ZodType<WithoutLocations<DropIndexQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('DropIndexQuery'),
      table: IdentifierNodeSchema,
      database: IdentifierNodeSchema.optional(),
      index_name: IdentifierNodeSchema,
      if_exists: z.boolean().optional(),
      ...ExprMetadataFields,
    }),
);

/** A single element in a {@link BackupQueryNode}'s native `elements` list. */
export type BackupQueryElement = {
  /** `TABLE`, `DATABASE`, `ALL`, `FUNCTION`, or `NAMED_COLLECTION`. */
  element_type: string;
  /** Table name (for `TABLE` elements). */
  table?: string;
  /** Source database (when the table/database is qualified). */
  database?: string;
  /** `AS` rename target table. */
  new_table?: string;
  /** `AS` rename target database. */
  new_database?: string;
  /** Function name (for `FUNCTION` elements). */
  function_name?: string;
  /** Named-collection name (for `NAMED_COLLECTION` elements). */
  collection_name?: string;
  /** `PARTITION(S)` list (each wrapped as a `Partition` node). */
  partitions?: { type: 'Partition'; value: ASTNode }[];
  /** `EXCEPT TABLES` list (`DATABASE` / `ALL` elements). */
  except_tables?: { database?: string; table: string }[];
  /** `ALL EXCEPT DATABASES` list. */
  except_databases?: string[];
};

/** Zod schema for {@link BackupQueryElement}. */
export const BackupQueryElementSchema: z.ZodType<WithoutLocations<BackupQueryElement>> = z.lazy(
  () =>
    z.object({
      element_type: z.string(),
      table: z.string().optional(),
      database: z.string().optional(),
      new_table: z.string().optional(),
      new_database: z.string().optional(),
      function_name: z.string().optional(),
      collection_name: z.string().optional(),
      partitions: z
        .array(z.object({ type: z.literal('Partition'), value: ASTNodeSchema }))
        .optional(),
      except_tables: z
        .array(z.object({ database: z.string().optional(), table: z.string() }))
        .optional(),
      except_databases: z.array(z.string()).optional(),
    }),
);

/**
 * `BACKUP <items> TO <destination>` and `RESTORE`. Every operand lives in a
 * native field: the operation `kind`, the target `elements` (with per-element
 * `partitions` / `except_tables` / `except_databases`), the `backup_name`
 * destination function, the trailing `FORMAT name`, and optional `cluster` /
 * `settings` (the `SYNC` / `ASYNC` wait mode rides inside `settings` as a
 * boolean `async` change, matching ClickHouse).
 */
export type BackupQueryNode = {
  type: 'BackupQuery' | 'RestoreQuery';
  /** `BACKUP` or `RESTORE`. */
  kind: 'BACKUP' | 'RESTORE';
  /** The backup/restore target list. */
  elements: BackupQueryElement[];
  /** The TO (BACKUP) / FROM (RESTORE) destination function. */
  backup_name: FunctionNode;
  /** Optional `ON CLUSTER` name. */
  cluster?: string;
  /** Optional `SETTINGS` node. */
  settings?: SettingsNode;
  /** Trailing `FORMAT name` clause. */
  format?: string;
} & NodeMetadata;

/** Zod schema for {@link BackupQueryNode}. */
export const BackupQueryNodeSchema: z.ZodType<WithoutLocations<BackupQueryNode>> = z.lazy(() =>
  z.object({
    type: z.union([z.literal('BackupQuery'), z.literal('RestoreQuery')]),
    kind: z.enum(['BACKUP', 'RESTORE']),
    elements: z.array(BackupQueryElementSchema),
    backup_name: FunctionNodeSchema,
    cluster: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    format: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * `PARALLEL WITH` chain: a sequence of CREATE/INSERT/DROP/... statements
 * executed in parallel. Children are the inner queries in source order.
 */
export type ParallelWithQueryNode = {
  type: 'ParallelWithQuery';
  children: ASTNode[];
} & NodeMetadata;

/** Zod schema for {@link ParallelWithQueryNode}. */
export const ParallelWithQueryNodeSchema: z.ZodType<WithoutLocations<ParallelWithQueryNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('ParallelWithQuery'),
      children: z.array(ASTNodeSchema),
      ...ExprMetadataFields,
    }),
  );

/**
 * A NAMED COLLECTION / WORKLOAD setting value in ClickHouse's reference AST: a
 * literal keeps its native `value_type`/`value`; any other expression
 * serializes to a `CustomType` whose `value` is the compact SQL text.
 */
export type TypedSettingValue = {
  value_type: string;
  value: string | number | boolean | null;
};

/** One `CREATE WORKLOAD` setting: `name = value [FOR resource]`. */
export type WorkloadChange = {
  name: string;
  value: TypedSettingValue;
  resource?: string;
};

/** One `CREATE RESOURCE` operation: `READ`/`WRITE` against a `disk` (or any disk). */
export type ResourceOperation = {
  mode: string;
  disk?: string;
};

// ── Native access-control field shapes ──────────────────────────────────────
// These mirror ClickHouse's `EXPLAIN AST json = 1` shape for the plain (typeless)
// data objects the access-control grammar emits. Typed sub-nodes that carry
// their own `type` discriminator (RolesOrUsersSet, UserNamesWithHost,
// SettingsProfileElements, ...) are defined further below and referenced here.

/** One argument of a native {@link NativeAuthenticationData} method. */
export type NativeAuthenticationArgument = {
  /** `'PublicSSHKey'` for SSH keys; `'Literal'` for a password/secret. */
  type?: string;
  /** Secret/password value (for a `Literal` argument). */
  value?: string;
  /** Base64-encoded SSH public key (for a `PublicSSHKey` argument). */
  key_base64?: string;
  /** SSH key type (for a `PublicSSHKey` argument). */
  key_type?: string;
} & NodeMetadata;

/** A native `AuthenticationData` method node (CREATE/ALTER USER `IDENTIFIED`). */
export type NativeAuthenticationData = {
  type?: 'AuthenticationData';
  /** Native auth-type enum (e.g. `SHA256_PASSWORD`, `SSH_KEY`, `NO_PASSWORD`). */
  auth_type?: string;
  arguments?: NativeAuthenticationArgument[];
  valid_until?: string;
  contains_hash?: boolean;
  contains_password?: boolean;
} & NodeMetadata;

/** A native `AllowedClientHosts` object (typeless data bag). */
export type NativeHosts = {
  any_host?: boolean;
  local_host?: boolean;
  names?: string[];
  name_regexps?: string[];
  like_patterns?: string[];
  addresses?: string[];
  subnets?: string[];
};

/** A native quota `limits` interval (typeless data bag). */
export type NativeQuotaLimit = {
  duration_sec: string;
  randomize_interval?: boolean;
  drop?: boolean;
  /** Per-limit-name maximum values, keyed by native limit name. */
  max?: Record<string, string>;
};

/** A single native `access_rights` element (one privilege on one target). */
export type NativeAccessRight = {
  access_types?: string[];
  database?: string;
  table?: string;
  default_database?: boolean;
  parameter?: string;
  columns?: string[];
  wildcard?: boolean;
  grant_option?: boolean;
};

/** A native row-policy `filters` element. */
export type NativeRowPolicyFilter = {
  filter_type?: string;
  condition?: Expression;
};

/**
 * Fields common to every access-control query node: the shared native flags.
 */
type AccessQueryCommon = {
  /** Set when this node represents an `ALTER ...` (rather than a `CREATE ...`). */
  alter?: boolean;
  or_replace?: boolean;
  if_not_exists?: boolean;
  if_exists?: boolean;
  cluster?: string;
} & NodeMetadata;

/** `CREATE / ALTER USER` (`ALTER` when {@link AccessQueryCommon.alter} is set). */
export type CreateUserQueryNode = {
  type: 'CreateUserQuery';
  /** Target user names (with optional host patterns). */
  names?: UserNamesWithHostNode;
  /** `ALTER USER ... RENAME TO` target. */
  new_name?: string;
  authentication_methods?: NativeAuthenticationData[];
  replace_authentication_methods?: boolean;
  hosts?: NativeHosts;
  add_hosts?: NativeHosts;
  remove_hosts?: NativeHosts;
  /** `ALTER USER ... SETTINGS` (replace-all) element set. */
  alter_settings?: AlterSettingsProfileElementsNode;
  /** `CREATE USER ... SETTINGS` element list. */
  settings?: SettingsProfileElementsNode;
  default_roles?: RolesOrUsersSetNode;
  default_database?: DatabaseOrNoneNode;
  grantees?: RolesOrUsersSetNode;
} & AccessQueryCommon;

/** `CREATE / ALTER ROLE`. */
export type CreateRoleQueryNode = {
  type: 'CreateRoleQuery';
  names?: string[];
  new_name?: string;
  settings?: SettingsProfileElementsNode;
  alter_settings?: AlterSettingsProfileElementsNode;
} & AccessQueryCommon;

/** `CREATE / ALTER QUOTA`. */
export type CreateQuotaQueryNode = {
  type: 'CreateQuotaQuery';
  names?: string[];
  new_name?: string;
  /** Native `key_type` enum (e.g. `USER_NAME`, `CLIENT_KEY_OR_USER_NAME`, `NONE`). */
  key_type?: string;
  limits?: NativeQuotaLimit[];
  /** `TO` role/user target. */
  roles?: RolesOrUsersSetNode;
} & AccessQueryCommon;

/** `CREATE / ALTER SETTINGS PROFILE`. */
export type CreateSettingsProfileQueryNode = {
  type: 'CreateSettingsProfileQuery';
  names?: string[];
  new_name?: string;
  settings?: SettingsProfileElementsNode;
  alter_settings?: AlterSettingsProfileElementsNode;
  /** `TO` role/user target. */
  to_roles?: RolesOrUsersSetNode;
} & AccessQueryCommon;

/** `CREATE / ALTER ROW POLICY`. */
export type CreateRowPolicyQueryNode = {
  type: 'CreateRowPolicyQuery';
  names?: RowPolicyNamesNode;
  new_short_name?: string;
  is_restrictive?: boolean;
  filters?: NativeRowPolicyFilter[];
  /** `TO` role/user target. */
  roles?: RolesOrUsersSetNode;
} & AccessQueryCommon;

/** `CREATE NAMED COLLECTION`. */
export type CreateNamedCollectionQueryNode = {
  type: 'CreateNamedCollectionQuery';
  collection_name?: string;
  /** A `key → {value_type, value}` map of collection settings. */
  changes?: Record<string, TypedSettingValue>;
  overridability?: Record<string, boolean>;
} & AccessQueryCommon;

/** `CREATE WORKLOAD`. */
export type CreateWorkloadQueryNode = {
  type: 'CreateWorkloadQuery';
  workload_name?: IdentifierNode;
  workload_parent?: IdentifierNode;
  /** An ordered list of `{name, value, resource?}` settings. */
  changes?: WorkloadChange[];
} & AccessQueryCommon;

/** `CREATE RESOURCE`. */
export type CreateResourceQueryNode = {
  type: 'CreateResourceQuery';
  resource_name?: IdentifierNode;
  unit?: string;
  operations?: ResourceOperation[];
} & AccessQueryCommon;

/** `GRANT` / `REVOKE`. */
export type GrantQueryNode = {
  type: 'GrantQuery' | 'RevokeQuery';
  grantees?: RolesOrUsersSetNode;
  access_rights?: NativeAccessRight[];
  replace_access?: boolean;
  /** Granted/revoked role names (role grant). */
  roles?: RolesOrUsersSetNode;
  replace_granted_roles?: boolean;
} & AccessQueryCommon;

/** `SET DEFAULT ROLE`. */
export type SetRoleQueryNode = {
  type: 'SetRoleQuery';
  /** Native discriminator (`SET_DEFAULT_ROLE`). */
  kind?: string;
  roles?: RolesOrUsersSetNode;
  to_users?: RolesOrUsersSetNode;
} & AccessQueryCommon;

/**
 * `CREATE / ALTER USER, ROLE, QUOTA, SETTINGS PROFILE, ROW POLICY, NAMED
 * COLLECTION, WORKLOAD, RESOURCE` and `GRANT / REVOKE / SET DEFAULT ROLE`.
 *
 * A discriminated union keyed on `type`. Each member carries ClickHouse's
 * native fields for its subtype; `format()` reconstructs the full DDL from
 * those native fields alone, accepting ClickHouse's canonical form.
 */
export type AccessQueryNode =
  | CreateUserQueryNode
  | CreateRoleQueryNode
  | CreateQuotaQueryNode
  | CreateSettingsProfileQueryNode
  | CreateRowPolicyQueryNode
  | CreateNamedCollectionQueryNode
  | CreateWorkloadQueryNode
  | CreateResourceQueryNode
  | GrantQueryNode
  | SetRoleQueryNode;

/** Zod schema for {@link AccessQueryNode}. */
const accessQuerySubSchema = <T extends string>(t: T) =>
  z.object({ type: z.literal(t), ...ExprMetadataFields });
export const AccessQueryNodeSchema: z.ZodType<WithoutLocations<AccessQueryNode>> = z.lazy(() =>
  z.union([
    accessQuerySubSchema('CreateUserQuery'),
    accessQuerySubSchema('CreateRoleQuery'),
    accessQuerySubSchema('CreateQuotaQuery'),
    accessQuerySubSchema('CreateSettingsProfileQuery'),
    accessQuerySubSchema('CreateRowPolicyQuery'),
    accessQuerySubSchema('CreateNamedCollectionQuery'),
    accessQuerySubSchema('CreateWorkloadQuery'),
    accessQuerySubSchema('CreateResourceQuery'),
    accessQuerySubSchema('GrantQuery'),
    accessQuerySubSchema('RevokeQuery'),
    accessQuerySubSchema('SetRoleQuery'),
  ]),
);

/**
 * `INSERT INTO ...` in ClickHouse's native children-array shape.
 * Children order: FROM INFILE path Literal (+ compression Literal), optional
 * database Identifier + table Identifier (or a Function target), optional
 * PARTITION BY expression, optional ExpressionList of insert columns,
 * optional query (INSERT ... SELECT), optional Set (a copy of the INSERT- or
 * SELECT-level SETTINGS). VALUES/FORMAT payloads are not part of the AST.
 */
export type InsertQueryNode = {
  type: 'InsertQuery';
  /** Target table Identifier. */
  table?: IdentifierNode;
  /** Database qualifier Identifier (for `db.table` targets). */
  database?: IdentifierNode;
  /** Target table function (for `INSERT INTO function(...)` syntax). */
  table_function?: FunctionNode;
  /** Insert column list. Identifier nodes named in `INSERT INTO t (a, b, c)`. */
  columns?: Expression[];
  /** Inline `SELECT ...` source for `INSERT INTO ... SELECT ...`. */
  select?: Statement;
  /** FORMAT name (e.g. `Values`, `JSON`). */
  format?: string;
  /** SETTINGS payload — INSERT-level or inner-SELECT, collapsed by ClickHouse. */
  settings?: SettingsNode;
  /** `FROM INFILE 'path'` literal. */
  infile?: LiteralNode;
  /** `FROM INFILE ... COMPRESSION 'name'` literal. */
  compression?: LiteralNode;
  /** `PARTITION BY <expr>` clause. */
  partition_by?: Expression;
} & NodeMetadata;

/** Zod schema for {@link InsertQueryNode}. */
export const InsertQueryNodeSchema: z.ZodType<WithoutLocations<InsertQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('InsertQuery'),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    table_function: FunctionNodeSchema.optional(),
    columns: z.array(ExpressionSchema).optional(),
    select: z.lazy(() => StatementSchema).optional(),
    format: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    infile: LiteralNodeSchema.optional(),
    compression: LiteralNodeSchema.optional(),
    partition_by: ExpressionSchema.optional(),
    ...ExprMetadataFields,
  }),
);

export type CreateQueryNode = {
  type: 'CreateQuery';
  /** Target table Identifier (omitted for CREATE DATABASE). */
  table?: IdentifierNode;
  /** Database Identifier (qualifier for `table`, or sole target for CREATE DATABASE). */
  database?: IdentifierNode;
  /** Column / constraint / index / projection definitions block. */
  columns_list?: ColumnsNode;
  /** Bare column-name list on a view (`CREATE VIEW v (a, b) AS ...`). */
  aliases?: IdentifierNode[];
  /** Storage definition (engine / partition / order / sample / ttl / settings). */
  storage?: StorageNode;
  /** Inline `AS SELECT ...` source. */
  select?: Statement;
  /** `AS function(...)` source. */
  as_table_function?: FunctionNode;
  /** `AS other_table` source table (bare name). */
  as_table?: string;
  /** Database qualifier of `as_table` (when AS source was `db.table`). */
  as_database?: string;
  /** Table-level COMMENT clause. */
  comment?: LiteralNode;
  /** View targets / inner-table engine spec for materialized views. */
  targets?: ViewTargetsNode;
  /** Dictionary attribute list + definition (CREATE DICTIONARY only). */
  dictionary?: DictionaryNode;
  dictionary_attributes?: DictionaryAttributeDeclarationNode[];
  if_not_exists?: boolean;
  temporary?: boolean;
  is_dictionary?: boolean;
  is_materialized_view?: boolean;
  is_ordinary_view?: boolean;
  is_populate?: boolean;
  is_create_empty?: boolean;
  is_clone_as?: boolean;
  create_or_replace?: boolean;
  replace_table?: boolean;
  replace_view?: boolean;
  /** ON CLUSTER name. */
  cluster?: string;
  /** Explicit `UUID '...'`. */
  uuid?: string;
  /** `ATTACH TABLE t FROM '/path'` source path. */
  attach_from_path?: string;
  /** `ATTACH TABLE t AS [NOT] REPLICATED` conversion marker. */
  attach_as_replicated?: boolean;
  /** Native trailing FORMAT name (`FORMAT Null`, ...). */
  format?: string;
  /** Native query-level SETTINGS clause (e.g. `CREATE ... SETTINGS x=y` after
   * the storage/COMMENT clause, or `CREATE DATABASE ... SETTINGS`). Distinct
   * from engine `storage.settings`. */
  settings?: SettingsNode;
  /** Native refreshable-MV `REFRESH` strategy node. */
  refresh?: RefreshStrategyNode;
} & NodeMetadata;

/** Inline target for CREATE MATERIALIZED VIEW: either a `TO [db.]table` target
 * (carrying `database`/`table`) or an inner-table engine spec (`inner_engine`). */
export type ViewTargetNode = {
  kind: 'to';
  database?: IdentifierPart;
  table?: IdentifierPart;
  inner_engine?: StorageNode;
};

/** Zod schema for {@link CreateQueryNode}. */
export const CreateQueryNodeSchema: z.ZodType<WithoutLocations<CreateQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('CreateQuery'),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    columns_list: ColumnsNodeSchema.optional(),
    aliases: z.array(IdentifierNodeSchema).optional(),
    storage: StorageNodeSchema.optional(),
    select: z.lazy(() => StatementSchema).optional(),
    as_table_function: FunctionNodeSchema.optional(),
    as_table: z.string().optional(),
    as_database: z.string().optional(),
    comment: LiteralNodeSchema.optional(),
    targets: ViewTargetsSchema.optional(),
    dictionary: DictionaryNodeSchema.optional(),
    dictionary_attributes: z.array(DictionaryAttributeDeclarationNodeSchema).optional(),
    if_not_exists: z.boolean().optional(),
    temporary: z.boolean().optional(),
    is_dictionary: z.boolean().optional(),
    is_materialized_view: z.boolean().optional(),
    is_ordinary_view: z.boolean().optional(),
    is_populate: z.boolean().optional(),
    is_create_empty: z.boolean().optional(),
    is_clone_as: z.boolean().optional(),
    create_or_replace: z.boolean().optional(),
    replace_table: z.boolean().optional(),
    replace_view: z.boolean().optional(),
    cluster: z.string().optional(),
    uuid: z.string().optional(),
    attach_from_path: z.string().optional(),
    attach_as_replicated: z.boolean().optional(),
    format: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

// ── DDL sub-node schemas (children of CreateQuery) ──────────────────────────
// These validate the `CreateQuery` sub-tree referenced above. Node-typed leaf
// operands (`data_type`, tuple `arguments`, ...) delegate to `ASTNodeSchema`;
// deep validation of those is covered end-to-end by the reference-AST suite.

/** Zod schema for {@link DataTypeNode}. */
export const DataTypeNodeSchema: z.ZodType<WithoutLocations<DataTypeNode>> = z.lazy(() =>
  z.object({
    type: z.literal('DataType'),
    name: z.string(),
    arguments: z.array(ASTNodeSchema).optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link EnumDataTypeNode}. */
export const EnumDataTypeNodeSchema: z.ZodType<WithoutLocations<EnumDataTypeNode>> = z.lazy(() =>
  z.object({
    type: z.literal('EnumDataType'),
    name: z.string(),
    values: z.array(z.object({ name: z.string(), value: z.number() })).optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link TupleDataTypeNode}. */
export const TupleDataTypeNodeSchema: z.ZodType<WithoutLocations<TupleDataTypeNode>> = z.lazy(() =>
  z.object({
    type: z.literal('TupleDataType'),
    name: z.string(),
    arguments: z.array(ASTNodeSchema).optional(),
    element_names: z.array(z.string().nullable()).optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link CollationNode}. */
export const CollationNodeSchema: z.ZodType<WithoutLocations<CollationNode>> = z.lazy(() =>
  z.object({ type: z.literal('Collation'), name: z.string(), ...ExprMetadataFields }),
);

/** Zod schema for {@link ColumnDeclarationNode}. */
export const ColumnDeclarationNodeSchema: z.ZodType<WithoutLocations<ColumnDeclarationNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('ColumnDeclaration'),
      name: z.string(),
      data_type: ASTNodeSchema.optional(),
      default_specifier: z
        .enum(['DEFAULT', 'MATERIALIZED', 'ALIAS', 'EPHEMERAL', 'AUTO_INCREMENT'])
        .optional(),
      default_expression: ExpressionSchema.optional(),
      codec: FunctionNodeSchema.optional(),
      statistics: FunctionNodeSchema.optional(),
      settings: SettingsNodeSchema.optional(),
      ttl: ExpressionSchema.optional(),
      comment: LiteralNodeSchema.optional(),
      collation: CollationNodeSchema.optional(),
      null_modifier: z.boolean().optional(),
      primary_key_specifier: z.boolean().optional(),
      ephemeral_default: z.boolean().optional(),
      ...ExprMetadataFields,
    }),
  );

/** Zod schema for {@link ConstraintNode}. */
export const ConstraintNodeSchema: z.ZodType<WithoutLocations<ConstraintNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Constraint'),
    name: z.string(),
    constraint_type: z.string(),
    expression: ExpressionSchema,
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link IndexNode}. */
export const IndexNodeSchema: z.ZodType<WithoutLocations<IndexNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Index'),
    name: z.string().optional(),
    expression: ExpressionSchema.optional(),
    index_type: FunctionNodeSchema.optional(),
    granularity: z.number().optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link ProjectionSelectQueryNode}. */
export const ProjectionSelectQueryNodeSchema: z.ZodType<
  WithoutLocations<ProjectionSelectQueryNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('ProjectionSelectQuery'),
    with: z.array(ExpressionSchema).optional(),
    select: z.array(ExpressionSchema).optional(),
    group_by: z.array(ExpressionSchema).optional(),
    order_by: z.array(ExpressionSchema).optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link ProjectionNode}. */
export const ProjectionNodeSchema: z.ZodType<WithoutLocations<ProjectionNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Projection'),
    name: z.string(),
    query: ProjectionSelectQueryNodeSchema.optional(),
    index: ExpressionSchema.optional(),
    index_type: FunctionNodeSchema.optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link StorageOrderByElementNode}. */
export const StorageOrderByElementNodeSchema: z.ZodType<
  WithoutLocations<StorageOrderByElementNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('StorageOrderByElement'),
    expression: ExpressionSchema,
    direction: z.enum(['ASC', 'DESC']),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link StorageNode}. */
export const StorageNodeSchema: z.ZodType<WithoutLocations<StorageNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Storage'),
    engine: FunctionNodeSchema.optional(),
    partition_by: ExpressionSchema.optional(),
    primary_key: ExpressionSchema.optional(),
    // A bare/tuple key is an Expression; a single `DESC` key is a
    // StorageOrderByElement; a mixed-direction key is a `tuple(...)` embedding
    // StorageOrderByElement operands — validated loosely as a node.
    order_by: looseNode<Expression | StorageOrderByElementNode>().optional(),
    sample_by: ExpressionSchema.optional(),
    ttl_table: ExpressionListNodeSchema.optional(),
    settings: SettingsNodeSchema.optional(),
    _settings_after_order_by: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link ColumnsNode}. */
export const ColumnsNodeSchema: z.ZodType<WithoutLocations<ColumnsNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Columns'),
    columns: z.array(ColumnDeclarationNodeSchema),
    constraints: z.array(ConstraintNodeSchema).optional(),
    indices: z.array(IndexNodeSchema).optional(),
    projections: z.array(ProjectionNodeSchema).optional(),
    primary_key: ExpressionSchema.optional(),
    primary_key_from_columns: ExpressionSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link ViewTargetsNode}. */
export const ViewTargetsSchema: z.ZodType<WithoutLocations<ViewTargetsNode>> = z.lazy(() =>
  z.object({
    type: z.literal('ViewTargets'),
    targets: z
      .array(
        z.object({
          kind: z.literal('to'),
          database: IdentifierPartSchema.optional(),
          table: IdentifierPartSchema.optional(),
          inner_engine: StorageNodeSchema.optional(),
        }),
      )
      .optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link DictionaryNode}. */
export const DictionaryNodeSchema: z.ZodType<WithoutLocations<DictionaryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Dictionary'),
    primary_key: z.array(ExpressionSchema).optional(),
    source: z
      .object({
        type: z.literal('FunctionWithKeyValueArguments'),
        name: z.string(),
        elements: z.array(
          z.object({
            type: z.literal('pair'),
            key: z.string(),
            value: z.union([ExpressionSchema, ExpressionListNodeSchema]),
          }),
        ),
      })
      .optional(),
    lifetime: z
      .object({
        type: z.literal('DictionaryLifetime'),
        min_sec: z.number().optional(),
        max_sec: z.number().optional(),
      })
      .optional(),
    layout: z
      .object({
        type: z.literal('DictionaryLayout'),
        layout_type: z.string(),
        parameters: z.array(
          z.object({ type: z.literal('pair'), key: z.string(), value: ExpressionSchema }),
        ),
      })
      .optional(),
    range: z
      .object({
        type: z.literal('DictionaryRange'),
        min_attr_name: z.string(),
        max_attr_name: z.string(),
      })
      .optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link DictionaryAttributeDeclarationNode}. */
export const DictionaryAttributeDeclarationNodeSchema: z.ZodType<
  WithoutLocations<DictionaryAttributeDeclarationNode>
> = z.lazy(() =>
  z.object({
    type: z.literal('DictionaryAttributeDeclaration'),
    name: z.string(),
    data_type: z.union([DataTypeNodeSchema, EnumDataTypeNodeSchema, TupleDataTypeNodeSchema]),
    default_value: ExpressionSchema.optional(),
    expression: ExpressionSchema.optional(),
    hierarchical: z.boolean().optional(),
    injective: z.boolean().optional(),
    is_object_id: z.boolean().optional(),
    bidirectional: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

// ── DDL sub-nodes (children of CreateQuery) ─────────────────────────────────
// These mirror ClickHouse's native shapes: a `type` discriminator plus a
// `children` array, with everything the native JSON drops kept in `_`-fields.

/**
 * The `Columns` definition block: explicit `columns`/`constraints`/
 * `indices`/`projections` arrays, plus an optional `primary_key` expression
 * (used when the PRIMARY KEY appears inside the column list rather than as
 * a separate clause).
 */
export type ColumnsNode = {
  type: 'Columns';
  columns: ColumnDeclarationNode[];
  constraints?: ConstraintNode[];
  indices?: IndexNode[];
  projections?: ProjectionNode[];
  /** Schema-level `PRIMARY KEY expr` clause inside the column list. */
  primary_key?: Expression;
  /** Column-level PRIMARY KEY modifiers collapsed into a tuple. */
  primary_key_from_columns?: Expression;
} & NodeMetadata;

/**
 * One column declaration. Mirrors ClickHouse's native AST shape: explicit
 * `name`/`data_type` plus optional default/codec/ttl/comment/settings/
 * statistics fields. Library-only underscores carry modifiers the native
 * AST drops (COLLATE, NULLABLE, column-level PRIMARY KEY marker).
 */
export type ColumnDeclarationNode = {
  type: 'ColumnDeclaration';
  name: string;
  data_type?: ASTNode;
  default_specifier?: 'DEFAULT' | 'MATERIALIZED' | 'ALIAS' | 'EPHEMERAL' | 'AUTO_INCREMENT';
  default_expression?: Expression;
  codec?: FunctionNode;
  statistics?: FunctionNode;
  settings?: SettingsNode;
  ttl?: Expression;
  comment?: LiteralNode;
  /** Native `COLLATE` clause node (carries the collation `name`). */
  collation?: CollationNode;
  /** `true` for `NULL`, `false` for `NOT NULL`; omitted when unspecified. */
  null_modifier?: boolean;
  /** `true` when the column carried a column-level `PRIMARY KEY` modifier. */
  primary_key_specifier?: boolean;
  /** `true` when the column is a bare `EPHEMERAL` (no explicit default expression). */
  ephemeral_default?: boolean;
} & NodeMetadata;

/** A data type. `name` is the type name; `arguments` carries inner types or settings. */
export type DataTypeNode = {
  type: 'DataType';
  name: string;
  arguments?: ASTNode[];
} & NodeMetadata;

/** An `Enum8`/`Enum16` type whose values are all explicitly assigned. */
export type EnumDataTypeNode = {
  type: 'EnumDataType';
  name: string;
  /**
   * The explicit value pairs, mirroring ClickHouse's native `values` array.
   * format() rebuilds `Enum8('a' = 1, ...)` from this.
   */
  values?: { name: string; value: number }[];
} & NodeMetadata;

/** A `Tuple(...)` type. */
export type TupleDataTypeNode = {
  type: 'TupleDataType';
  name: string;
  arguments?: ASTNode[];
  /**
   * Named-element names (aligned with `arguments`; `null` for an unnamed
   * element), mirroring ClickHouse's native `element_names` array.
   */
  element_names?: (string | null)[];
} & NodeMetadata;

/** A `name Type` pair inside a `Nested(...)` / `Tuple(...)` type. */
export type NameTypePairNode = {
  type: 'NameTypePair';
  name: string;
  data_type: DataTypeNode | EnumDataTypeNode | TupleDataTypeNode;
} & NodeMetadata;

/** A typed path inside a `JSON(...)` type, e.g. `a.b.c UInt32`. */
export type ObjectTypedPathNode = {
  type: 'ObjectTypedPath';
  /** The (possibly dotted) path name. */
  name: string;
  /** The path's declared type. */
  data_type: ASTNode;
} & NodeMetadata;

/**
 * A `JSON(...)` type argument wrapper. Exactly one of the optional fields is
 * set, mirroring ClickHouse's native `ASTObjectTypeArgument` shape:
 *  - `path_with_type` for `a.b.c UInt32`
 *  - `skip_path` for `SKIP a.b.c`
 *  - `skip_path_regexp` for `SKIP REGEXP '...'`
 *  - `parameter` for `max_dynamic_paths = N`
 */
export type ObjectTypeArgumentNode = {
  type: 'ObjectTypeArgument';
  path_with_type?: ObjectTypedPathNode;
  skip_path?: ASTNode;
  skip_path_regexp?: ASTNode;
  parameter?: FunctionNode;
} & NodeMetadata;

/** A `COLLATE` clause on a column (the collation name is in the source). */
export type CollationNode = { type: 'Collation'; name: string } & NodeMetadata;

/**
 * The `Storage` definition (engine / partition / order / sample / ttl /
 * settings). Mirrors ClickHouse's native shape — each clause is exposed
 * as an explicit field rather than buried in a `children` array.
 */
export type StorageNode = {
  type: 'Storage';
  engine?: FunctionNode;
  partition_by?: Expression;
  primary_key?: Expression;
  /**
   * The storage `ORDER BY` key. A bare/tuple key is an {@link Expression}; a
   * single `DESC` key is wrapped in a {@link StorageOrderByElementNode}.
   */
  order_by?: Expression | StorageOrderByElementNode;
  sample_by?: Expression;
  ttl_table?: ExpressionListNode;
  settings?: SettingsNode;
  /** Library-only: `true` when storage `SETTINGS` appeared after `ORDER BY`. */
  _settings_after_order_by?: boolean;
} & NodeMetadata;

/** A single descending storage ORDER BY element. */
export type StorageOrderByElementNode = {
  type: 'StorageOrderByElement';
  expression: Expression;
  /**
   * Per-key sort direction. ClickHouse wraps a storage-key item in this node
   * whenever any sibling is `DESC`; the wrapped item then carries its own
   * explicit `ASC`/`DESC` (reverse sorting keys can mix directions).
   */
  direction: 'ASC' | 'DESC';
} & NodeMetadata;

/**
 * One `TTL` element. `mode` selects the action (DELETE / MOVE / GROUP_BY /
 * RECOMPRESS); `ttl` carries the TTL expression. Optional `where`,
 * `group_by_columns`, `group_by_assignments`, and `recompression_codec`
 * fields cover the per-mode payload.
 */
export type TTLElementNode = {
  type: 'TTLElement';
  mode?: 'DELETE' | 'MOVE' | 'GROUP_BY' | 'RECOMPRESS';
  ttl: Expression;
  where?: Expression;
  destination_type?: 'DISK' | 'VOLUME';
  destination_name?: string;
  if_exists?: boolean;
  recompression_codec?: FunctionNode;
  /** `GROUP BY` key expressions for a `GROUP_BY`-mode TTL (native field). */
  group_by_key?: Expression[];
  /** `SET column = expression` assignments for a `GROUP_BY`-mode TTL (native `Assignment` nodes). */
  group_by_assignments?: AssignmentNode[];
} & NodeMetadata;

/** A table `CONSTRAINT`. */
export type ConstraintNode = {
  type: 'Constraint';
  name: string;
  /** Constraint kind: `'CHECK'` or `'ASSUME'`. */
  constraint_type: string;
  expression: Expression;
} & NodeMetadata;

/**
 * A data-skipping `INDEX` table element. Native AST stores the name,
 * expression, and optional index_type (a Function for `TYPE name(args)`)
 * with an optional `granularity` integer. The same shape is used for
 * `CREATE INDEX` declarations and for `INDEX` entries inside CREATE TABLE
 * column lists.
 */
export type IndexNode = {
  type: 'Index';
  name?: string;
  expression?: Expression;
  index_type?: FunctionNode;
  granularity?: number;
} & NodeMetadata;

/**
 * A `STATISTICS` clause inside an ALTER STATISTICS / MATERIALIZE STATISTICS
 * command. Mirrors ClickHouse's native shape: the target `columns` and the
 * statistic `types` are each an `ExpressionList` (the type entries are native
 * `Function` nodes rendered as bare type names).
 */
export type StatNode = {
  type: 'Stat';
  columns?: { type?: 'ExpressionList'; children: Expression[] };
  types?: { type?: 'ExpressionList'; children: Expression[] };
} & NodeMetadata;

/** A `PROJECTION` table element. */
export type ProjectionNode = {
  type: 'Projection';
  name: string;
  /** Body for the normal `PROJECTION p (SELECT ...)` form. */
  query?: ProjectionSelectQueryNode;
  /** Indexed-projection `PROJECTION p INDEX expr` expression. */
  index?: Expression;
  /** Indexed-projection `TYPE name(args)` type (native field). */
  index_type?: FunctionNode;
  /** `WITH SETTINGS(...)` suffix on the projection clause (native field). */
  settings?: SettingsNode;
} & NodeMetadata;

/** A projection's inner SELECT (native, fully structured). */
export type ProjectionSelectQueryNode = {
  type: 'ProjectionSelectQuery';
  /** `WITH ...` CTE / alias items. */
  with?: Expression[];
  select?: Expression[];
  group_by?: Expression[];
  /** `ORDER BY` keys (a flat list of key expressions). */
  order_by?: Expression[];
} & NodeMetadata;

/** A time interval (e.g. inside REFRESH). */
export type TimeIntervalNode = {
  type: 'TimeInterval';
  /** Interval components, e.g. `[{ kind: 'Month', value: '1' }]`. */
  interval?: { kind: string; value: string }[];
} & NodeMetadata;

/** A refreshable-MV `REFRESH EVERY/AFTER ...` strategy. */
export type RefreshStrategyNode = {
  type: 'RefreshStrategy';
  /** `'EVERY'` or `'AFTER'`. */
  schedule_kind: string;
  /** The refresh period (`EVERY`/`AFTER <interval>`). */
  period?: TimeIntervalNode;
  /** `OFFSET <interval>`. */
  offset?: TimeIntervalNode;
  /** `RANDOMIZE FOR <interval>`. */
  spread?: TimeIntervalNode;
  /** `DEPENDS ON <table>, ...` (an ExpressionList of TableIdentifier). */
  dependencies?: ExpressionListNode;
  /** Trailing `SETTINGS` clause. */
  settings?: SettingsNode;
  /** `true` for `APPEND`. */
  append?: boolean;
} & NodeMetadata;

/** Inner-table / TO targets of a materialized view (`CreateQuery.targets`). */
export type ViewTargetsNode = {
  type: 'ViewTargets';
  targets?: ViewTargetNode[];
} & NodeMetadata;

/** A `Dictionary` definition (CREATE DICTIONARY clauses). */
export type DictionaryNode = {
  type: 'Dictionary';
  primary_key?: Expression[];
  source?: FunctionWithKeyValueArgumentsNode;
  lifetime?: {
    type: 'DictionaryLifetime';
    min_sec?: number;
    max_sec?: number;
  };
  layout?: {
    type: 'DictionaryLayout';
    layout_type: string;
    parameters: Array<{ type: 'pair'; key: string; value: Expression }>;
  };
  range?: {
    type: 'DictionaryRange';
    min_attr_name: string;
    max_attr_name: string;
  };
  settings?: SettingsNode;
} & NodeMetadata;

/** One attribute declaration inside a dictionary. */
export type DictionaryAttributeDeclarationNode = {
  type: 'DictionaryAttributeDeclaration';
  name: string;
  data_type: DataTypeNode | EnumDataTypeNode | TupleDataTypeNode;
  default_value?: Expression;
  expression?: Expression;
  hierarchical?: boolean;
  injective?: boolean;
  is_object_id?: boolean;
  bidirectional?: boolean;
} & NodeMetadata;

/** One key/value pair inside a dictionary SOURCE/LAYOUT. */
export type PairNode = {
  type: 'pair';
  key: string;
  value: Expression | ExpressionListNode;
} & NodeMetadata;

/** A dictionary SOURCE function call with key/value argument pairs. */
export type FunctionWithKeyValueArgumentsNode = {
  type: 'FunctionWithKeyValueArguments';
  name: string;
  elements: PairNode[];
} & NodeMetadata;

/**
 * `CREATE [OR REPLACE] FUNCTION [IF NOT EXISTS] name [ON CLUSTER cluster] AS lambda`.
 * `children` holds `[Identifier(name), Expression(lambda)]` mirroring ClickHouse's
 * native AST. All header modifiers live as underscore fields.
 */
export type CreateFunctionQueryNode = {
  type: 'CreateFunctionQuery';
  function_name: IdentifierNode;
  /**
   * Function body expression. Typically a `Function` lambda node, but the
   * grammar accepts any expression (matching ClickHouse, which only fails
   * the validation at execution time).
   */
  function_core: Expression;
  or_replace?: boolean;
  if_not_exists?: boolean;
  cluster?: string;
} & NodeMetadata;

/** Zod schema for {@link CreateFunctionQueryNode}. */
export const CreateFunctionQueryNodeSchema: z.ZodType<WithoutLocations<CreateFunctionQueryNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('CreateFunctionQuery'),
      function_name: IdentifierNodeSchema,
      function_core: ExpressionSchema,
      or_replace: z.boolean().optional(),
      if_not_exists: z.boolean().optional(),
      cluster: z.string().optional(),
      ...ExprMetadataFields,
    }),
  );

/**
 * `CREATE INDEX [IF NOT EXISTS] name ON [db.]table (expr) [TYPE type] [GRANULARITY n]`.
 *
 * `children` mirrors ClickHouse's native shape: `[Identifier(name), Index{[expr, indexType?]}, Identifier([database,] table)]`.
 * When the target table is qualified, ClickHouse's native AST carries the
 * database as a separate `Identifier` field (before `table`); modifiers and
 * granularity live on library fields.
 */
export type CreateIndexQueryNode = {
  type: 'CreateIndexQuery';
  /** Database qualifier of the target table (native `Identifier`, present only when qualified). */
  database?: IdentifierNode;
  table: IdentifierNode;
  index_name: IdentifierNode;
  index_declaration: IndexNode;
  if_not_exists?: boolean;
  unique?: boolean;
} & NodeMetadata;

/** Zod schema for {@link CreateIndexQueryNode}. */
export const CreateIndexQueryNodeSchema: z.ZodType<WithoutLocations<CreateIndexQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('CreateIndexQuery'),
      database: IdentifierNodeSchema.optional(),
      table: IdentifierNodeSchema,
      index_name: IdentifierNodeSchema,
      index_declaration: z.lazy(() =>
        z.object({
          type: z.literal('Index'),
          name: z.string().optional(),
          expression: ExpressionSchema.optional(),
          index_type: FunctionNodeSchema.optional(),
          granularity: z.number().optional(),
        }),
      ),
      if_not_exists: z.boolean().optional(),
      unique: z.boolean().optional(),
      ...ExprMetadataFields,
    }),
);

/**
 * `ALTER TABLE [db.]name [ON CLUSTER ...] cmd, cmd, ... [SETTINGS ...] [FORMAT ...]`
 * in ClickHouse's native children-array shape. `children` holds (in
 * ClickHouse's order) the `ExpressionList` of `AlterCommand` nodes, an
 * optional database `Identifier`, the name `Identifier`, an optional extra
 * `Identifier` (for `MOVE PARTITION TO another_table`), and an optional `Set`.
 * Everything the native JSON drops (ON CLUSTER, FORMAT, the per-command
 * details, ...) is reconstructed for `format()`/`formatExplain()` from the
 * structured `_alter` payload.
 */
export type AlterQueryNode = {
  type: 'AlterQuery';
  /** `"TABLE"` (most cases) or `"DATABASE"` for ALTER DATABASE. */
  alter_object: string;
  /** Target table Identifier (omitted for ALTER DATABASE). */
  table?: IdentifierNode;
  /** Database qualifier Identifier (or the database name for ALTER DATABASE). */
  database?: IdentifierNode;
  /** Ordered list of ALTER commands. */
  commands: AlterCommandNode[];
  /** ON CLUSTER cluster name. */
  cluster?: string;
  /** Native trailing `SETTINGS` clause. */
  settings?: SettingsNode;
  /** Native trailing `FORMAT name`. */
  format?: string;
} & NodeMetadata;

/** Zod schema for {@link AlterQueryNode}. */
export const AlterQueryNodeSchema: z.ZodType<WithoutLocations<AlterQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('AlterQuery'),
    alter_object: z.string(),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    commands: z.array(AlterCommandNodeSchema),
    cluster: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    format: z.string().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * One `AlterCommand` inside an `AlterQuery`. Mirrors ClickHouse's `EXPLAIN AST
 * json = 1` shape: the `command_type` keyword plus one explicit field per
 * operand. Every operand field is optional and command-specific; `format()` and
 * `formatExplain()` reconstruct the command entirely from these native fields.
 */
export type AlterCommandNode = {
  type: 'AlterCommand';
  /** Command keyword (`"ADD_COLUMN"`, `"DROP_PARTITION"`, ...). */
  command_type: string;
  if_exists?: boolean;
  if_not_exists?: boolean;
  first?: boolean;
  clear_column?: boolean;
  clear_index?: boolean;
  clear_projection?: boolean;
  clear_statistics?: boolean;
  detach?: boolean;
  part?: boolean;
  replace?: boolean;
  column_declaration?: ColumnDeclarationNode;
  index_declaration?: IndexNode;
  projection_declaration?: ProjectionNode;
  constraint_declaration?: ConstraintNode;
  statistics_declaration?: StatNode;
  /** Column operand (`AFTER col`, target column, ...) — a native Identifier. */
  column?: Expression;
  index?: Expression;
  projection?: Expression;
  constraint?: Expression;
  rename_to?: Expression;
  /**
   * Partition operand. A `Partition` / `Partition_ID` node for the PARTITION
   * form, or a string-`Literal` for the `PART 'name'` form (`part` is set).
   */
  partition?: PartitionNode | PartitionIdNode | LiteralNode;
  comment?: LiteralNode;
  remove_property?: string;
  settings_changes?: SettingsNode;
  /** `RESET SETTING a, b` — an ExpressionList of setting-name Identifiers. */
  settings_resets?: { type?: 'ExpressionList'; children: Expression[] };
  assignments?: AssignmentNode[];
  predicate?: Expression;
  /** `MODIFY TTL ...` — an ExpressionList of `TTLElement` nodes. */
  ttl?: { type?: 'ExpressionList'; children: TTLElementNode[] };
  order_by?: Expression;
  sample_by?: Expression;
  /** `MODIFY QUERY <select>` payload. */
  select?: Statement;
  move_destination_type?: string;
  move_destination_name?: string;
  to_table?: string;
  to_database?: string;
  from_table?: string;
  from_database?: string;
  from?: string;
  with_name?: string;
  refresh?: RefreshStrategyNode;
} & NodeMetadata;

/** Zod schema for {@link AlterCommandNode}. */
export const AlterCommandNodeSchema: z.ZodType<WithoutLocations<AlterCommandNode>> = z.lazy(() =>
  z.object({
    type: z.literal('AlterCommand'),
    command_type: z.string(),
    ...ExprMetadataFields,
  }),
);

/**
 * `SYSTEM ...` admin commands (RELOAD CONFIG, FLUSH LOGS, SYNC REPLICA, ...).
 * Every operand is captured in structured native fields (`system_type`,
 * `table`/`database`, `tables`, `sync_replica_mode`, `replica_zk_path`,
 * `server_type`, `settings`, ...) matching ClickHouse's `EXPLAIN AST json = 1`,
 * so `format()` and `formatExplain()` reconstruct the command with no verbatim
 * text.
 */
export type SystemQueryNode = {
  type: 'SYSTEM';
  /** Subcommand keyword phrase, e.g. `"FLUSH LOGS"`, `"SYNC REPLICA"`. */
  system_type?: string;
  /** Target table Identifier (when the SYSTEM command targets a table). */
  table?: IdentifierNode;
  /** Database qualifier Identifier (when the target is `db.table`). */
  database?: IdentifierNode;
  /** ON CLUSTER cluster name, when ClickHouse preserves it in native AST. */
  cluster?: string;
  /** Replica name for `SYSTEM DROP REPLICA ...`. */
  replica?: string;
  /** Target table list for `FLUSH LOGS` / `FLUSH ASYNC INSERT QUEUE`. */
  tables?: { database?: string; table: string }[];
  /** Wait mode for `SYNC REPLICA` (`PULL` / `LIGHTWEIGHT` / `STRICT`). */
  sync_replica_mode?: string;
  /** Fail-point identifier for `ENABLE`/`DISABLE FAILPOINT`. */
  fail_point_name?: string;
  /** Tag for `CLEAR QUERY CACHE TAG '...'`. */
  query_result_cache_tag?: string;
  /** Storage type for `CLEAR SCHEMA CACHE FOR ...`. */
  schema_cache_storage?: string;
  /** Format for `CLEAR FORMAT SCHEMA CACHE FOR ...`. */
  schema_cache_format?: string;
  /** ZooKeeper path for `DROP REPLICA ... FROM ZKPATH '...'`. */
  replica_zk_path?: string;
  /** Shard for `DROP DATABASE REPLICA ... FROM SHARD '...'`. */
  shard?: string;
  /** Source replica list for `SYNC REPLICA ... LIGHTWEIGHT FROM '...'`. */
  src_replicas?: string[];
  /** Seconds for `SUSPEND FOR <n> SECOND`. */
  seconds?: number;
  /** Cache name for `CLEAR FILESYSTEM CACHE '<name>'`. */
  filesystem_cache_name?: string;
  /** Key for `CLEAR FILESYSTEM CACHE ... KEY <k>`. */
  key_to_drop?: string;
  /** Offset for `CLEAR FILESYSTEM CACHE ... OFFSET <n>`. */
  offset_to_drop?: number;
  /** Backup name for `UNFREEZE WITH NAME '<name>'`. */
  backup_name?: string;
  /** Server type for `START`/`STOP LISTEN <server-type>`. */
  server_type?: { type: string; custom_name?: string; exclude_types?: string[] };
  /** Trailing `SETTINGS` clause (e.g. `FLUSH DISTRIBUTED ... SETTINGS ...`). */
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link SystemQueryNode}. */
export const SystemQueryNodeSchema: z.ZodType<WithoutLocations<SystemQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('SYSTEM'),
    system_type: z.string().optional(),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    cluster: z.string().optional(),
    replica: z.string().optional(),
    tables: z.array(z.object({ database: z.string().optional(), table: z.string() })).optional(),
    sync_replica_mode: z.string().optional(),
    fail_point_name: z.string().optional(),
    query_result_cache_tag: z.string().optional(),
    schema_cache_storage: z.string().optional(),
    schema_cache_format: z.string().optional(),
    replica_zk_path: z.string().optional(),
    shard: z.string().optional(),
    src_replicas: z.array(z.string()).optional(),
    seconds: z.number().optional(),
    filesystem_cache_name: z.string().optional(),
    key_to_drop: z.string().optional(),
    offset_to_drop: z.number().optional(),
    backup_name: z.string().optional(),
    server_type: z
      .object({
        type: z.string(),
        custom_name: z.string().optional(),
        exclude_types: z.array(z.string()).optional(),
      })
      .optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * The `SHOW ...` family in ClickHouse's native shape — a node whose `type`
 * selects one of many literals (`ShowTables`/`ShowColumns`/`ShowIndexes`/...).
 * Every variant is now fully structured and rendered from native fields alone;
 * there is no library-only payload. Highlights:
 *  - `ShowTables` covers SHOW TABLES/DATABASES/DICTIONARIES plus the flag-only
 *    sub-forms SHOW SETTINGS (`show_settings`), SHOW CLUSTERS (`clusters`),
 *    SHOW CLUSTER (`cluster` + `cluster_str`), and SHOW MERGES (`merges`).
 *  - `ShowAccessEntitiesQuery` covers SHOW USERS/ROLES/QUOTAS/SETTINGS
 *    PROFILES/ROW POLICIES (`entity_type` + `all`/`current_roles`/`enabled_roles`).
 *  - `ShowColumns` / `ShowIndexes` carry `table`/`database`/`extended`/`full`/
 *    `like`/`where`/`limit`; `ShowSetting` carries `setting_name`;
 *    `ShowGrantsQuery` carries `for_roles`/`with_implicit`/`final`;
 *    `ShowCreateAccessEntityQuery` carries `entity_type` +
 *    `names`/`row_policy_names`/`short_name`/`current_user`.
 * Some spellings are canonicalized (SHOW FIELDS → SHOW COLUMNS, SHOW INDEX →
 * SHOW INDEXES, `user@'host'` → `` `user@host` ``) to match ClickHouse's own
 * lossy native AST.
 */
export type ShowFamilyQueryNode = {
  type:
    | 'SHOW'
    | 'ShowTables'
    | 'ShowColumns'
    | 'ShowIndexes'
    | 'ShowFunctions'
    | 'ShowSetting'
    | 'ShowEngineQuery'
    | 'ShowAccessQuery'
    | 'ShowAccessEntitiesQuery'
    | 'ShowProcesslistQuery'
    | 'ShowGrantsQuery'
    | 'ShowPrivilegesQuery'
    | 'ShowCreateNamedCollectionQuery'
    | 'ShowCreateAccessEntityQuery';
  /** `SHOW GRANTS FOR ...` target set. */
  for_roles?: RolesOrUsersSetNode;
  /** `SHOW GRANTS ... WITH IMPLICIT`. */
  with_implicit?: boolean;
  /** `SHOW GRANTS ... FINAL`. */
  final?: boolean;
  /** `SHOW CREATE USER/ROLE/...` / `ShowAccessEntitiesQuery` entity kind. */
  entity_type?: string;
  /** `SHOW USERS`/`ROLES`/... (`ShowAccessEntitiesQuery`, all entities). */
  all?: boolean;
  /** `SHOW CURRENT ROLES`. */
  current_roles?: boolean;
  /** `SHOW ENABLED ROLES`. */
  enabled_roles?: boolean;
  /** `SHOW CREATE USER/ROLE/QUOTA/SETTINGS PROFILE` names. */
  names?: string[];
  /** `SHOW CREATE USER CURRENT_USER`. */
  current_user?: boolean;
  /** `SHOW CREATE NAMED COLLECTION <name>`. */
  collection_name?: string;
  /** `SHOW CREATE ROW POLICY name ON table` policies. */
  row_policy_names?: RowPolicyNamesNode;
  /** `SHOW CREATE ROW POLICY name` (no table) short name. */
  short_name?: string;
  /** `SHOW TABLES FROM <db>` / `SHOW DICTIONARIES FROM <db>`. */
  from?: IdentifierNode;
  /** `SHOW COLUMNS`/`ShowIndexes` target table name (plain string). */
  table?: string;
  /** `SHOW COLUMNS`/`ShowIndexes` target database name (plain string). */
  database?: string;
  /** True for `SHOW EXTENDED COLUMNS`/`INDEXES`. */
  extended?: boolean;
  /** True for `SHOW FULL COLUMNS`. */
  full?: boolean;
  /** `SHOW SETTING <name>` setting name. */
  setting_name?: string;
  /** `SHOW TABLES LIKE 'pat'` / `SHOW TABLES NOT LIKE 'pat'` pattern text. */
  like?: string;
  /** True when the LIKE clause was written as `NOT LIKE`. */
  not_like?: boolean;
  /** True when the LIKE clause was written as `ILIKE` (case-insensitive). */
  case_insensitive_like?: boolean;
  /** `SHOW DATABASES`. */
  databases?: boolean;
  /** `SHOW DICTIONARIES`. */
  dictionaries?: boolean;
  /** `SHOW TEMPORARY TABLES`. */
  temporary?: boolean;
  /** True for `SHOW SETTINGS` (serialized as a ShowTables node). */
  show_settings?: boolean;
  /** True for `SHOW CHANGED SETTINGS`. */
  changed?: boolean;
  /** True for `SHOW CLUSTERS` (serialized as a ShowTables node). */
  clusters?: boolean;
  /** True for `SHOW CLUSTER '<name>'` (serialized as a ShowTables node). */
  cluster?: boolean;
  /** The cluster name for `SHOW CLUSTER '<name>'`. */
  cluster_str?: string;
  /** True for `SHOW MERGES` (serialized as a ShowTables node). */
  merges?: boolean;
  /** `SHOW TABLES ... WHERE <expr>` filter expression. */
  where?: ASTNode;
  /** `SHOW TABLES ... LIMIT <expr>` limit expression. */
  limit?: ASTNode;
  /** Native trailing `SETTINGS` clause (`SHOW TABLES ... SETTINGS x = y`). */
  settings?: SettingsNode;
  /** Native trailing `FORMAT name` clause. */
  format?: string;
} & NodeMetadata;

/** Zod schema for {@link ShowFamilyQueryNode}. */
export const ShowFamilyQueryNodeSchema: z.ZodType<WithoutLocations<ShowFamilyQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.union([
        z.literal('SHOW'),
        z.literal('ShowTables'),
        z.literal('ShowColumns'),
        z.literal('ShowIndexes'),
        z.literal('ShowFunctions'),
        z.literal('ShowSetting'),
        z.literal('ShowEngineQuery'),
        z.literal('ShowAccessQuery'),
        z.literal('ShowAccessEntitiesQuery'),
        z.literal('ShowProcesslistQuery'),
        z.literal('ShowGrantsQuery'),
        z.literal('ShowPrivilegesQuery'),
        z.literal('ShowCreateNamedCollectionQuery'),
        z.literal('ShowCreateAccessEntityQuery'),
      ]),
      for_roles: RolesOrUsersSetNodeSchema.optional(),
      with_implicit: z.boolean().optional(),
      final: z.boolean().optional(),
      entity_type: z.string().optional(),
      all: z.boolean().optional(),
      current_roles: z.boolean().optional(),
      enabled_roles: z.boolean().optional(),
      names: z.array(z.string()).optional(),
      current_user: z.boolean().optional(),
      collection_name: z.string().optional(),
      row_policy_names: RowPolicyNamesNodeSchema.optional(),
      short_name: z.string().optional(),
      from: IdentifierNodeSchema.optional(),
      table: z.string().optional(),
      database: z.string().optional(),
      extended: z.boolean().optional(),
      full: z.boolean().optional(),
      setting_name: z.string().optional(),
      like: z.string().optional(),
      not_like: z.boolean().optional(),
      case_insensitive_like: z.boolean().optional(),
      databases: z.boolean().optional(),
      dictionaries: z.boolean().optional(),
      temporary: z.boolean().optional(),
      show_settings: z.boolean().optional(),
      changed: z.boolean().optional(),
      clusters: z.boolean().optional(),
      cluster: z.boolean().optional(),
      cluster_str: z.string().optional(),
      merges: z.boolean().optional(),
      where: ASTNodeSchema.optional(),
      limit: ASTNodeSchema.optional(),
      settings: SettingsNodeSchema.optional(),
      format: z.string().optional(),
      ...ExprMetadataFields,
    }),
);

/** `UNDROP TABLE ...` */
export type UndropQueryNode = {
  type: 'UndropQuery';
} & DropFamilyFields;

const TableTargetSchemaFields = {
  table: IdentifierNodeSchema.optional(),
  database: IdentifierNodeSchema.optional(),
  if_exists: z.boolean().optional(),
  if_empty: z.boolean().optional(),
  temporary: z.boolean().optional(),
  is_dictionary: z.boolean().optional(),
  is_view: z.boolean().optional(),
  sync: z.boolean().optional(),
  cluster: z.string().optional(),
  uuid: z.string().optional(),
  database_and_tables: ExpressionListNodeSchema.optional(),
  settings: z.lazy(() => SettingsNodeSchema).optional(),
  format: z.string().optional(),
};

const DropFamilySchemaFields = {
  kind: z.union([z.literal('DROP'), z.literal('DETACH'), z.literal('TRUNCATE')]).optional(),
  ...TableTargetSchemaFields,
};

/** Zod schema for {@link DropQueryNode}. */
export const DropQueryNodeSchema: z.ZodType<WithoutLocations<DropQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('DropQuery'),
    ...DropFamilySchemaFields,
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link DetachQueryNode}. */
export const DetachQueryNodeSchema: z.ZodType<WithoutLocations<DetachQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('DetachQuery'),
    permanently: z.boolean().optional(),
    ...DropFamilySchemaFields,
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link TruncateQueryNode}. */
export const TruncateQueryNodeSchema: z.ZodType<WithoutLocations<TruncateQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('TruncateQuery'),
    has_all: z.boolean().optional(),
    has_tables: z.boolean().optional(),
    like: z.string().optional(),
    not_like: z.boolean().optional(),
    case_insensitive_like: z.boolean().optional(),
    ...DropFamilySchemaFields,
    ...ExprMetadataFields,
  }),
);

/** Zod schema for {@link UndropQueryNode}. */
export const UndropQueryNodeSchema: z.ZodType<WithoutLocations<UndropQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('UndropQuery'),
    ...DropFamilySchemaFields,
    ...ExprMetadataFields,
  }),
);

/** `PARTITION expr` clause child. */
export type PartitionNode = {
  type: 'Partition';
  /** The partition expression. */
  value: Expression;
} & NodeMetadata;

/** Zod schema for {@link PartitionNode}. */
export const PartitionNodeSchema: z.ZodType<WithoutLocations<PartitionNode>> = z.lazy(() =>
  z.object({ type: z.literal('Partition'), value: ExpressionSchema, ...ExprMetadataFields }),
);

/** `PARTITION ID 'x'` / `PARTITION ALL` clause child (no `id` for ALL). */
export type PartitionIdNode = {
  type: 'Partition_ID';
  /** The literal ID. Omitted for `PARTITION ALL`. */
  id?: Expression;
  /** `true` for the bare `PARTITION ALL` form. */
  all?: boolean;
} & NodeMetadata;

/** Zod schema for {@link PartitionIdNode}. */
export const PartitionIdNodeSchema: z.ZodType<WithoutLocations<PartitionIdNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Partition_ID'),
    id: ExpressionSchema.optional(),
    all: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

/** `col = expr` assignment in UPDATE / ALTER UPDATE. */
export type AssignmentNode = {
  type: 'Assignment';
  /** Column name being assigned to. */
  column: string;
  /** Right-hand-side expression. */
  expression: Expression;
} & NodeMetadata;

/** Zod schema for {@link AssignmentNode}. */
export const AssignmentNodeSchema: z.ZodType<WithoutLocations<AssignmentNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Assignment'),
    column: z.string(),
    expression: ExpressionSchema,
    ...ExprMetadataFields,
  }),
);

/** `USE db`. */
export type UseQueryNode = {
  type: 'UseQuery';
  database: IdentifierNode;
} & NodeMetadata;

/** Zod schema for {@link UseQueryNode}. */
export const UseQueryNodeSchema: z.ZodType<WithoutLocations<UseQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('UseQuery'),
    database: IdentifierNodeSchema,
    ...ExprMetadataFields,
  }),
);

/** `BEGIN/START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SET TRANSACTION SNAPSHOT n`. */
export type TransactionControlNode = {
  type: 'TransactionControl';
  /** The transaction action, mirroring ClickHouse's native enum. */
  action: 'BEGIN' | 'COMMIT' | 'ROLLBACK' | 'SET_SNAPSHOT';
  /** Snapshot value for `SET TRANSACTION SNAPSHOT` (`action === 'SET_SNAPSHOT'`). */
  snapshot?: string;
} & NodeMetadata;

/** Zod schema for {@link TransactionControlNode}. */
export const TransactionControlNodeSchema: z.ZodType<WithoutLocations<TransactionControlNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('TransactionControl'),
      action: z.union([
        z.literal('BEGIN'),
        z.literal('COMMIT'),
        z.literal('ROLLBACK'),
        z.literal('SET_SNAPSHOT'),
      ]),
      snapshot: z.string().optional(),
      ...ExprMetadataFields,
    }),
  );

/** A user name (optionally with host pattern) inside access-control statements. */
export type UserNameWithHostNode = {
  type: 'UserNameWithHost';
  /** The user name. */
  name?: string;
  /** The host pattern (`@'host'`), absent for any-host (`@'%'`). */
  host_pattern?: string;
} & NodeMetadata;

/** Zod schema for {@link UserNameWithHostNode}. */
export const UserNameWithHostNodeSchema: z.ZodType<WithoutLocations<UserNameWithHostNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('UserNameWithHost'),
      name: z.string().optional(),
      host_pattern: z.string().optional(),
      ...ExprMetadataFields,
    }),
);

/** A `UserNamesWithHost` list wrapper (CREATE USER target names). */
export type UserNamesWithHostNode = {
  type: 'UserNamesWithHost';
  users: UserNameWithHostNode[];
} & NodeMetadata;

/** Zod schema for {@link UserNamesWithHostNode}. */
export const UserNamesWithHostNodeSchema: z.ZodType<WithoutLocations<UserNamesWithHostNode>> =
  z.lazy(() =>
    z.object({
      type: z.literal('UserNamesWithHost'),
      users: z.array(UserNameWithHostNodeSchema),
      ...ExprMetadataFields,
    }),
  );

/** A native `RolesOrUsersSet` (ALL / names / CURRENT_USER / ALL EXCEPT). */
export type RolesOrUsersSetNode = {
  type: 'RolesOrUsersSet';
  all?: boolean;
  names?: string[];
  except_names?: string[];
  current_user?: boolean;
} & NodeMetadata;

/** Zod schema for {@link RolesOrUsersSetNode}. */
export const RolesOrUsersSetNodeSchema: z.ZodType<WithoutLocations<RolesOrUsersSetNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('RolesOrUsersSet'),
      all: z.boolean().optional(),
      names: z.array(z.string()).optional(),
      except_names: z.array(z.string()).optional(),
      current_user: z.boolean().optional(),
      ...ExprMetadataFields,
    }),
);

/** A single policy reference inside {@link RowPolicyNamesNode}. */
export type RowPolicyNameItem = {
  short_name: string;
  database?: string;
  table?: string;
};

/** Zod schema for {@link RowPolicyNameItem}. */
export const RowPolicyNameItemSchema: z.ZodType<WithoutLocations<RowPolicyNameItem>> = z.object({
  short_name: z.string(),
  database: z.string().optional(),
  table: z.string().optional(),
});

/** A native `RowPolicyNames` list wrapper. */
export type RowPolicyNamesNode = {
  type: 'RowPolicyNames';
  policies: RowPolicyNameItem[];
} & NodeMetadata;

/** Zod schema for {@link RowPolicyNamesNode}. */
export const RowPolicyNamesNodeSchema: z.ZodType<WithoutLocations<RowPolicyNamesNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('RowPolicyNames'),
      policies: z.array(RowPolicyNameItemSchema),
      ...ExprMetadataFields,
    }),
);

/** A `DEFAULT DATABASE <db>` / `DEFAULT DATABASE NONE` target. */
export type DatabaseOrNoneNode = {
  type: 'DatabaseOrNone';
  /** The database name; absent for `NONE`. */
  database?: string;
} & NodeMetadata;

/** A single element of a {@link SettingsProfileElementsNode}. */
export type SettingsProfileElementNode = {
  type: 'SettingsProfileElement';
  /** Inherited profile name (`PROFILE`/`INHERIT`/bare). */
  parent_profile?: string;
  /** Setting name (for a `name = value` element). */
  setting_name?: string;
  /** Setting value (string, number, or null). */
  value?: string | number | null;
  min_value?: string | number | null;
  max_value?: string | number | null;
  /** `'CONST'` / `'WRITABLE'`. */
  writability?: string;
} & NodeMetadata;

/** A `SETTINGS ...` element list on a user/role/profile. */
export type SettingsProfileElementsNode = {
  type: 'SettingsProfileElements';
  elements: SettingsProfileElementNode[];
} & NodeMetadata;

/** An `ALTER ... SETTINGS` (replace-all) element set. */
export type AlterSettingsProfileElementsNode = {
  type: 'AlterSettingsProfileElements';
  add_settings?: SettingsProfileElementsNode;
  drop_all_settings?: boolean;
  drop_all_profiles?: boolean;
} & NodeMetadata;

/** `EXECUTE AS user <statement>`. */
export type ExecuteAsQueryNode = {
  type: 'ExecuteAsQuery';
  /** The user to execute as. */
  target_user: UserNameWithHostNode;
  /** The statement to run. */
  subquery: ASTNode;
} & NodeMetadata;

/** Zod schema for {@link ExecuteAsQueryNode}. */
export const ExecuteAsQueryNodeSchema: z.ZodType<WithoutLocations<ExecuteAsQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('ExecuteAsQuery'),
      target_user: UserNameWithHostNodeSchema,
      subquery: ASTNodeSchema,
      ...ExprMetadataFields,
    }),
);

/**
 * `OPTIMIZE TABLE ...`. Mirrors ClickHouse's native AST: explicit
 * `table`/`database` Identifier fields, optional `partition`, and the flat
 * `final`/`deduplicate`/`cleanup` modifier booleans. Library-only fields
 * cover the lossy bits (ON CLUSTER, DEDUPLICATE BY expression list).
 */
export type OptimizeQueryNode = {
  type: 'OptimizeQuery';
  table?: IdentifierNode;
  database?: IdentifierNode;
  partition?: PartitionNode | PartitionIdNode;
  final?: boolean;
  deduplicate?: boolean;
  cleanup?: boolean;
  cluster?: string;
  /** `DEDUPLICATE BY (col1, col2, ...)` columns as an ExpressionList. */
  deduplicate_by_columns?: ExpressionListNode;
  /** Library-only: SETTINGS trailer. */
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link OptimizeQueryNode}. */
export const OptimizeQueryNodeSchema: z.ZodType<WithoutLocations<OptimizeQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('OptimizeQuery'),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    partition: z.union([PartitionNodeSchema, PartitionIdNodeSchema]).optional(),
    final: z.boolean().optional(),
    deduplicate: z.boolean().optional(),
    cleanup: z.boolean().optional(),
    cluster: z.string().optional(),
    deduplicate_by_columns: ExpressionListNodeSchema.optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * `DESCRIBE TABLE ...`. Children: TableExpression, then Set / format Identifier.
 *
 * The original source order of SETTINGS vs FORMAT is not preserved: format()
 * always emits the canonical `... FORMAT name SETTINGS ...` ordering, which
 * is semantically equivalent to the alternative.
 */
export type DescribeQueryNode = {
  type: 'DescribeQuery';
  /** The target table expression (FROM-clause syntax). */
  table_expression?: TableExpressionNode;
  format?: string;
  settings?: SettingsNode;
  /** Library-only: true when SETTINGS appeared before FORMAT in the source. */
  _settings_before_format?: boolean;
} & NodeMetadata;

/** Zod schema for {@link DescribeQueryNode}. */
export const DescribeQueryNodeSchema: z.ZodType<WithoutLocations<DescribeQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('DescribeQuery'),
    table_expression: TableExpressionSchema.optional(),
    format: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    _settings_before_format: z.boolean().optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * `SHOW CREATE TABLE/VIEW/DICTIONARY/DATABASE ...` (drop-family child layout).
 *
 * The `SHOW TABLE`/`SHOW VIEW`/`SHOW DATABASE` shorthand parses to the same
 * node shape and canonicalizes to the fully-qualified `SHOW CREATE ...` form
 * on format() — both spellings are exact aliases in ClickHouse.
 */
export type ShowCreateQueryNode = {
  type:
    | 'ShowCreateTableQuery'
    | 'ShowCreateViewQuery'
    | 'ShowCreateDictionaryQuery'
    | 'ShowCreateDatabaseQuery';
} & TableTargetFields;

/** Zod schema for {@link ShowCreateQueryNode}. */
export const ShowCreateQueryNodeSchema: z.ZodType<WithoutLocations<ShowCreateQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.union([
        z.literal('ShowCreateTableQuery'),
        z.literal('ShowCreateViewQuery'),
        z.literal('ShowCreateDictionaryQuery'),
        z.literal('ShowCreateDatabaseQuery'),
      ]),
      ...TableTargetSchemaFields,
      ...ExprMetadataFields,
    }),
);

/** `EXISTS TABLE/VIEW/DICTIONARY/DATABASE ...` (drop-family child layout). */
export type ExistsQueryNode = {
  type: 'ExistsTableQuery' | 'ExistsViewQuery' | 'ExistsDictionaryQuery' | 'ExistsDatabaseQuery';
} & TableTargetFields;

/** Zod schema for {@link ExistsQueryNode}. */
export const ExistsQueryNodeSchema: z.ZodType<WithoutLocations<ExistsQueryNode>> = z.lazy(() =>
  z.object({
    type: z.union([
      z.literal('ExistsTableQuery'),
      z.literal('ExistsViewQuery'),
      z.literal('ExistsDictionaryQuery'),
      z.literal('ExistsDatabaseQuery'),
    ]),
    ...TableTargetSchemaFields,
    ...ExprMetadataFields,
  }),
);

/** `CHECK TABLE/DATABASE/ALL TABLES` with an optional `PART '...'` or `PARTITION ...` clause. */
export type CheckQueryNode = {
  type: 'CheckQuery' | 'CheckAllQuery';
  partition?: PartitionNode | PartitionIdNode;
  part_name?: string;
} & TableTargetFields;

/** Zod schema for {@link CheckQueryNode}. */
export const CheckQueryNodeSchema: z.ZodType<WithoutLocations<CheckQueryNode>> = z.lazy(() =>
  z.object({
    type: z.union([z.literal('CheckQuery'), z.literal('CheckAllQuery')]),
    partition: z.union([PartitionNodeSchema, PartitionIdNodeSchema]).optional(),
    part_name: z.string().optional(),
    ...TableTargetSchemaFields,
    ...ExprMetadataFields,
  }),
);

/** Simple `ATTACH TABLE/VIEW/DICTIONARY/DATABASE name` (no schema). */
export type AttachQueryNode = {
  type: 'AttachQuery';
  /** `true` for ATTACH (the native AST distinguishes it from CREATE this way). */
  attach?: boolean;
  if_not_exists?: boolean;
  /** `ATTACH TABLE t FROM '/path'` source path. */
  attach_from_path?: string;
  /** `ATTACH TABLE t AS [NOT] REPLICATED` conversion marker. */
  attach_as_replicated?: boolean;
} & TableTargetFields;

/** Zod schema for {@link AttachQueryNode}. */
export const AttachQueryNodeSchema: z.ZodType<WithoutLocations<AttachQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('AttachQuery'),
    attach: z.boolean().optional(),
    if_not_exists: z.boolean().optional(),
    attach_from_path: z.string().optional(),
    attach_as_replicated: z.boolean().optional(),
    ...TableTargetSchemaFields,
    ...ExprMetadataFields,
  }),
);

/**
 * `RENAME/EXCHANGE TABLE a TO b [, ...]`. Native AST exposes the rename
 * pairs as an `elements` list of plain objects with optional database
 * qualifiers. Library-only fields capture target kind (TABLE/DATABASE/
 * DICTIONARY), IF EXISTS, ON CLUSTER, and SETTINGS.
 */
export type RenameElement = {
  /** Source database name; can be a query parameter (`{p:Identifier}`). */
  from_database?: string | QueryParameterNode;
  /** Source table name; omitted for `RENAME DATABASE` elements. */
  from_table?: string | QueryParameterNode;
  to_database?: string | QueryParameterNode;
  to_table?: string | QueryParameterNode;
  /** `RENAME TABLE IF EXISTS ...` flag, carried on each element by the native AST. */
  if_exists?: boolean;
};

export type RenameNode = {
  type: 'Rename';
  /** Rename/exchange pairs in source order. */
  elements: RenameElement[];
  /** `true` for `EXCHANGE TABLES ...`; absent for `RENAME ...`. */
  exchange?: boolean;
  /** `true` for `RENAME DICTIONARY ...`. */
  dictionary?: boolean;
  /** `true` for `RENAME DATABASE ...`. */
  database?: boolean;
  cluster?: string;
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link RenameNode}. */
export const RenameNodeSchema: z.ZodType<WithoutLocations<RenameNode>> = z.lazy(() =>
  z.object({
    type: z.literal('Rename'),
    elements: z.array(
      z.object({
        from_database: z.union([z.string(), QueryParameterSchema]).optional(),
        from_table: z.union([z.string(), QueryParameterSchema]).optional(),
        to_database: z.union([z.string(), QueryParameterSchema]).optional(),
        to_table: z.union([z.string(), QueryParameterSchema]).optional(),
        if_exists: z.boolean().optional(),
      }),
    ),
    exchange: z.boolean().optional(),
    dictionary: z.boolean().optional(),
    database: z.boolean().optional(),
    cluster: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/** `KILL QUERY/MUTATION WHERE ...`. */
export type KillQueryQueryNode = {
  type: 'KillQueryQuery';
  /** Categorical: `'QUERY'` or `'MUTATION'`, native AST field. */
  kill_type: 'QUERY' | 'MUTATION';
  where: Expression;
  /** True for `SYNC`. The mode is `test ? TEST : sync ? SYNC : ASYNC`. */
  sync?: boolean;
  /** True for `TEST`. */
  test?: boolean;
  format?: string;
  cluster?: string;
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link KillQueryQueryNode}. */
export const KillQueryQueryNodeSchema: z.ZodType<WithoutLocations<KillQueryQueryNode>> = z.lazy(
  () =>
    z.object({
      type: z.literal('KillQueryQuery'),
      kill_type: z.union([z.literal('QUERY'), z.literal('MUTATION')]),
      where: ExpressionSchema,
      sync: z.boolean().optional(),
      test: z.boolean().optional(),
      format: z.string().optional(),
      cluster: z.string().optional(),
      settings: SettingsNodeSchema.optional(),
      ...ExprMetadataFields,
    }),
);

/**
 * `DELETE FROM ...` (lightweight DELETE). Native shape: explicit
 * `table`/`database` Identifier fields, `predicate` (the WHERE expression),
 * and optional `partition` clause.
 */
export type DeleteQueryNode = {
  type: 'DeleteQuery';
  table?: IdentifierNode;
  database?: IdentifierNode;
  cluster?: string;
  partition?: PartitionNode | PartitionIdNode;
  predicate?: Expression;
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link DeleteQueryNode}. */
export const DeleteQueryNodeSchema: z.ZodType<WithoutLocations<DeleteQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('DeleteQuery'),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    cluster: z.string().optional(),
    partition: z.union([PartitionNodeSchema, PartitionIdNodeSchema]).optional(),
    predicate: ExpressionSchema.optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * Lightweight `UPDATE t SET ... WHERE ...` in ClickHouse's native shape:
 * explicit `table`/`database` Identifier fields, an `assignments` list,
 * and `predicate` (the WHERE expression).
 */
export type UpdateQueryNode = {
  type: 'UpdateQuery';
  table?: IdentifierNode;
  database?: IdentifierNode;
  assignments?: AssignmentNode[];
  predicate?: Expression;
  cluster?: string;
  settings?: SettingsNode;
} & NodeMetadata;

/** Zod schema for {@link UpdateQueryNode}. */
export const UpdateQueryNodeSchema: z.ZodType<WithoutLocations<UpdateQueryNode>> = z.lazy(() =>
  z.object({
    type: z.literal('UpdateQuery'),
    table: IdentifierNodeSchema.optional(),
    database: IdentifierNodeSchema.optional(),
    assignments: z.array(AssignmentNodeSchema).optional(),
    predicate: ExpressionSchema.optional(),
    cluster: z.string().optional(),
    settings: SettingsNodeSchema.optional(),
    ...ExprMetadataFields,
  }),
);

/**
 * Union of all top-level statement types — all ClickHouse-native nodes with
 * a `type` discriminator.
 */
export type Statement =
  | QueryStatement
  | SettingsNode
  | EmptyQueryNode
  | DropQueryNode
  | DetachQueryNode
  | TruncateQueryNode
  | UndropQueryNode
  | DropFunctionQueryNode
  | InsertQueryNode
  | CreateQueryNode
  | CreateFunctionQueryNode
  | CreateIndexQueryNode
  | AlterQueryNode
  | SystemQueryNode
  | ShowFamilyQueryNode
  | AccessDropQueryNode
  | AccessQueryNode
  | BackupQueryNode
  | ParallelWithQueryNode
  | DropIndexQueryNode
  | UseQueryNode
  | TransactionControlNode
  | ExecuteAsQueryNode
  | OptimizeQueryNode
  | DescribeQueryNode
  | ShowCreateQueryNode
  | ExistsQueryNode
  | CheckQueryNode
  | AttachQueryNode
  | RenameNode
  | KillQueryQueryNode
  | DeleteQueryNode
  | UpdateQueryNode
  | ExplainQueryNode;

// ── AST node kind map ────────────────────────────────────────────────────────

/**
 * Maps each legacy `kind` discriminator value to its TypeScript type.
 *
 * The public AST is the ClickHouse-native {@link ASTNodeTypeMap}. The legacy
 * `kind`-discriminated nodes listed here still appear inside the structured
 * `_alter` payload on {@link AlterQueryNode}, so the formatter and explain
 * renderer can re-emit DDL exactly. (SHOW, BACKUP/RESTORE, SYSTEM, GRANT,
 * access-control entities, NAMED COLLECTION / WORKLOAD / RESOURCE, and
 * CREATE/ATTACH DDL no longer use a structured payload — they are rendered
 * directly from their native fields.)
 * Users who introspect those payloads may call {@link findNodes} with these keys.
 */
// ── AST node type map (ClickHouse-native nodes) ───────────────────────────────

/**
 * Maps each ClickHouse-native AST node `type` string to its TypeScript type.
 * Every node type emitted by the parser must be included here.
 *
 * Used by {@link findNodes} to provide type-safe return values.
 */
export interface ASTNodeTypeMap {
  Literal: LiteralNode;
  Identifier: IdentifierNode;
  Function: FunctionNode;
  Asterisk: AsteriskNode;
  QualifiedAsterisk: QualifiedAsteriskNode;
  Subquery: SubqueryNode;
  QueryParameter: QueryParameterNode;
  ExpressionList: ExpressionListNode;
  WindowDefinition: WindowDefinitionNode;
  OrderByElement: OrderByElementNode;
  InterpolateElement: InterpolateElementNode;
  ColumnsRegexpMatcher: ColumnsRegexpMatcherNode;
  ColumnsListMatcher: ColumnsListMatcherNode;
  QualifiedColumnsRegexpMatcher: QualifiedColumnsRegexpMatcherNode;
  QualifiedColumnsListMatcher: QualifiedColumnsListMatcherNode;
  ColumnsTransformerList: ColumnsTransformerListNode;
  ColumnsApplyTransformer: ColumnsApplyTransformerNode;
  ColumnsExceptTransformer: ColumnsExceptTransformerNode;
  ColumnsReplaceTransformer: ColumnsReplaceTransformerNode;
  'ColumnsReplaceTransformer::Replacement': ColumnsReplaceTransformerReplacementNode;
  Settings: SettingsNode;
  DictionarySettings: SettingsNode;
  SelectQuery: SelectQueryNode;
  SelectWithUnionQuery: SelectWithUnionQueryNode;
  SelectIntersectExceptQuery: SelectIntersectExceptQueryNode;
  TablesInSelectQuery: TablesInSelectQueryNode;
  TablesInSelectQueryElement: TablesInSelectQueryElementNode;
  TableExpression: TableExpressionNode;
  TableIdentifier: TableIdentifierNode;
  TableJoin: TableJoinNode;
  ArrayJoin: ArrayJoinNode;
  SampleRatio: SampleRatioNode;
  WithElement: WithElementNode;
  WindowListElement: WindowListElementNode;
  DropQuery: DropQueryNode;
  DetachQuery: DetachQueryNode;
  TruncateQuery: TruncateQueryNode;
  UndropQuery: UndropQueryNode;
  DropFunctionQuery: DropFunctionQueryNode;
  InsertQuery: InsertQueryNode;
  CreateQuery: CreateQueryNode;
  Columns: ColumnsNode;
  ColumnDeclaration: ColumnDeclarationNode;
  DataType: DataTypeNode;
  EnumDataType: EnumDataTypeNode;
  TupleDataType: TupleDataTypeNode;
  NameTypePair: NameTypePairNode;
  ObjectTypedPath: ObjectTypedPathNode;
  ObjectTypeArgument: ObjectTypeArgumentNode;
  Collation: CollationNode;
  Storage: StorageNode;
  StorageOrderByElement: StorageOrderByElementNode;
  TTLElement: TTLElementNode;
  Constraint: ConstraintNode;
  Index: IndexNode;
  Stat: StatNode;
  Projection: ProjectionNode;
  ProjectionSelectQuery: ProjectionSelectQueryNode;
  RefreshStrategy: RefreshStrategyNode;
  TimeInterval: TimeIntervalNode;
  ViewTargets: ViewTargetsNode;
  Dictionary: DictionaryNode;
  DictionaryAttributeDeclaration: DictionaryAttributeDeclarationNode;
  FunctionWithKeyValueArguments: FunctionWithKeyValueArgumentsNode;
  pair: PairNode;
  CreateFunctionQuery: CreateFunctionQueryNode;
  CreateIndexQuery: CreateIndexQueryNode;
  AlterQuery: AlterQueryNode;
  AlterCommand: AlterCommandNode;
  SYSTEM: SystemQueryNode;
  SHOW: ShowFamilyQueryNode;
  ShowTables: ShowFamilyQueryNode;
  ShowColumns: ShowFamilyQueryNode;
  ShowIndexes: ShowFamilyQueryNode;
  ShowFunctions: ShowFamilyQueryNode;
  ShowSetting: ShowFamilyQueryNode;
  ShowEngineQuery: ShowFamilyQueryNode;
  ShowAccessQuery: ShowFamilyQueryNode;
  ShowAccessEntitiesQuery: ShowFamilyQueryNode;
  ShowProcesslistQuery: ShowFamilyQueryNode;
  ShowGrantsQuery: ShowFamilyQueryNode;
  ShowPrivilegesQuery: ShowFamilyQueryNode;
  ShowCreateNamedCollectionQuery: ShowFamilyQueryNode;
  ShowCreateAccessEntityQuery: ShowFamilyQueryNode;
  DropNamedCollectionQuery: AccessDropQueryNode;
  DropWorkloadQuery: AccessDropQueryNode;
  DropResourceQuery: AccessDropQueryNode;
  CreateUserQuery: CreateUserQueryNode;
  CreateRoleQuery: CreateRoleQueryNode;
  CreateQuotaQuery: CreateQuotaQueryNode;
  CreateSettingsProfileQuery: CreateSettingsProfileQueryNode;
  CreateNamedCollectionQuery: CreateNamedCollectionQueryNode;
  CreateWorkloadQuery: CreateWorkloadQueryNode;
  CreateResourceQuery: CreateResourceQueryNode;
  CreateRowPolicyQuery: CreateRowPolicyQueryNode;
  GrantQuery: GrantQueryNode;
  RevokeQuery: GrantQueryNode;
  SetRoleQuery: SetRoleQueryNode;
  BackupQuery: BackupQueryNode;
  RestoreQuery: BackupQueryNode;
  ParallelWithQuery: ParallelWithQueryNode;
  DropIndexQuery: DropIndexQueryNode;
  Partition: PartitionNode;
  Partition_ID: PartitionIdNode;
  Assignment: AssignmentNode;
  UseQuery: UseQueryNode;
  TransactionControl: TransactionControlNode;
  UserNameWithHost: UserNameWithHostNode;
  UserNamesWithHost: UserNamesWithHostNode;
  RolesOrUsersSet: RolesOrUsersSetNode;
  RowPolicyNames: RowPolicyNamesNode;
  DatabaseOrNone: DatabaseOrNoneNode;
  SettingsProfileElement: SettingsProfileElementNode;
  SettingsProfileElements: SettingsProfileElementsNode;
  AlterSettingsProfileElements: AlterSettingsProfileElementsNode;
  DropAccessEntityQuery: AccessDropQueryNode;
  ExecuteAsQuery: ExecuteAsQueryNode;
  OptimizeQuery: OptimizeQueryNode;
  DescribeQuery: DescribeQueryNode;
  ShowCreateTableQuery: ShowCreateQueryNode;
  ShowCreateViewQuery: ShowCreateQueryNode;
  ShowCreateDictionaryQuery: ShowCreateQueryNode;
  ShowCreateDatabaseQuery: ShowCreateQueryNode;
  ExistsTableQuery: ExistsQueryNode;
  ExistsViewQuery: ExistsQueryNode;
  ExistsDictionaryQuery: ExistsQueryNode;
  ExistsDatabaseQuery: ExistsQueryNode;
  CheckQuery: CheckQueryNode;
  CheckAllQuery: CheckQueryNode;
  AttachQuery: AttachQueryNode;
  Rename: RenameNode;
  KillQueryQuery: KillQueryQueryNode;
  DeleteQuery: DeleteQueryNode;
  UpdateQuery: UpdateQueryNode;
  Explain: ExplainQueryNode;
  EmptyQuery: EmptyQueryNode;
}

/**
 * All valid ClickHouse-native AST node `type` values.
 */
export type ASTNodeType = keyof ASTNodeTypeMap;

/**
 * Lookup map for {@link findNodes} / {@link transformNodes}. The parsed AST is
 * entirely ClickHouse-native, so this is simply {@link ASTNodeTypeMap}.
 */
export type ASTNodeLookupMap = ASTNodeTypeMap;

/**
 * Union of all AST node types. The parser emits only ClickHouse-native
 * `type`-discriminated nodes.
 */
export type ASTNode = ASTNodeTypeMap[ASTNodeType];

// ── Zod schemas for statement types ──────────────────────────────────────────

/** Zod schema for {@link QueryStatement}. */
export const QueryStatementSchema: z.ZodType<WithoutLocations<QueryStatement>> = z.lazy(() =>
  z.union([SelectWithUnionQuerySchema, SelectIntersectExceptQuerySchema, ExplainQueryNodeSchema]),
);

/** Zod schema for {@link Statement}. */
export const StatementSchema: z.ZodType<WithoutLocations<Statement>> = z.lazy(() =>
  z.union([
    SelectWithUnionQuerySchema,
    SelectIntersectExceptQuerySchema,
    SettingsNodeSchema,
    EmptyQueryNodeSchema,
    DropQueryNodeSchema,
    DetachQueryNodeSchema,
    TruncateQueryNodeSchema,
    UndropQueryNodeSchema,
    DropFunctionQueryNodeSchema,
    InsertQueryNodeSchema,
    CreateQueryNodeSchema,
    CreateFunctionQueryNodeSchema,
    CreateIndexQueryNodeSchema,
    AlterQueryNodeSchema,
    SystemQueryNodeSchema,
    ShowFamilyQueryNodeSchema,
    AccessDropQueryNodeSchema,
    AccessQueryNodeSchema,
    BackupQueryNodeSchema,
    ParallelWithQueryNodeSchema,
    DropIndexQueryNodeSchema,
    UseQueryNodeSchema,
    TransactionControlNodeSchema,
    ExecuteAsQueryNodeSchema,
    OptimizeQueryNodeSchema,
    DescribeQueryNodeSchema,
    ShowCreateQueryNodeSchema,
    ExistsQueryNodeSchema,
    CheckQueryNodeSchema,
    AttachQueryNodeSchema,
    RenameNodeSchema,
    KillQueryQueryNodeSchema,
    DeleteQueryNodeSchema,
    UpdateQueryNodeSchema,
    ExplainQueryNodeSchema,
  ]),
);

/** Zod schema for an array of {@link Statement}s (the top-level parse result). */
export const StatementsSchema: z.ZodType<WithoutLocations<Statement>[]> = z.array(StatementSchema);
