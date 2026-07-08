import { parse as peggyParse } from './parser';
import { Statement, WithoutLocations } from './ast';

// ── Error Types ──────────────────────────────────────────────────────────────

export { SyntaxError as ParseError } from './parser';
export type { LocationRange, Location, Expectation } from './parser';

// ── AST Types ─────────────────────────────────────────────────────────────────

export type {
  // ── ClickHouse-native AST surface ───────────────────────────────────────────
  // Top-level discriminated unions.
  ASTNode,
  ASTNodeType,
  ASTNodeTypeMap,
  Statement,
  Expression,
  NodeMetadata,
  WithoutLocations,
  SourceLocation,

  // Expression / sub-node types.
  LiteralNode,
  IdentifierNode,
  IdentifierPart,
  FunctionNode,
  FunctionKind,
  AsteriskNode,
  QualifiedAsteriskNode,
  SubqueryNode,
  QueryParameterNode,
  ExpressionListNode,
  WindowDefinitionNode,
  OrderByElementNode,
  InterpolateElementNode,
  ColumnsRegexpMatcherNode,
  ColumnsListMatcherNode,
  QualifiedColumnsRegexpMatcherNode,
  QualifiedColumnsListMatcherNode,
  ColumnsTransformerNode,
  ColumnsTransformerListNode,
  ColumnsApplyTransformerNode,
  ColumnsExceptTransformerNode,
  ColumnsReplaceTransformerNode,
  ColumnsReplaceTransformerReplacementNode,
  SettingsNode,

  // SELECT family.
  SelectQueryNode,
  SelectWithUnionQueryNode,
  SelectIntersectExceptQueryNode,
  TablesInSelectQueryNode,
  TablesInSelectQueryElementNode,
  TableExpressionNode,
  TableIdentifierNode,
  TableJoinNode,
  ArrayJoinNode,
  SampleRatioNode,
  WithElementNode,
  WithItem,
  WindowListElementNode,

  // ── Data-shape helper types ────────────────────────────────────────────────
  // Utility types used within the ClickHouse-native AST nodes.
  TypedSettingValue,
  WorkloadChange,
  ResourceOperation,
  AccessControlName,
  HostItem,
  AccessControlSettingsItem,
  RoleTarget,
  DefaultRoleClause,
  IndexType,
  Literal,
  OrderByItem,
  QueryParam,
} from './ast';

// ── Post-parse cleanup ───────────────────────────────────────────────────────

/**
 * Strips parser-internal, parse-time-only markers from the returned AST.
 *
 * Three markers are handled:
 *
 * - `parenthesized: true` — set on (a) expression nodes (Literal,
 *   Identifier, Function, Asterisk, SelectQuery, SelectWithUnionQuery,
 *   SelectIntersectExceptQuery) and on (b) the storage `orderBy` array.
 *   Read at parse time by the unary-minus folding rule, tuple/array element
 *   decisions, union grouping, and the storage ORDER BY tuple-vs-bare
 *   decision. Not part of the public AST contract: parens
 *   around an expression are recoverable from operator precedence and AST
 *   nesting (see `wrapChildCore` / `wrapNaryOperandCore` in format.ts). For
 *   the storage `orderBy` array, the flag is transferred to a typed sibling
 *   `orderByParenthesized` field on the parent statement (set by the
 *   grammar itself); we just delete the array-property version here.
 *
 * - `cast_operand` — set on the stringified first argument of a
 *   pure-literal `::` cast (`1::UInt8` folds the operand to `Literal
 *   String '1'`, matching ClickHouse's native AST). Read at parse time
 *   only, by the unary-minus negate-fold, to distinguish a folded `::`
 *   cast (which should negate-fold to `CAST('-1','Int8')`) from a
 *   user-written `CAST('1','Int8')` (which must stay as
 *   `negate(CAST('1','Int8'))`). After parsing, the public AST cannot
 *   distinguish the two forms; the formatter accepts the canonicalization
 *   `1::UInt8` → `CAST('1' AS UInt8)` at output time.
 *
 * - `neg_folded: true` — set on a `UInt64(0)` literal produced by folding
 *   `-0`. Read at parse time only, by the unary-minus rule, so that
 *   `- -0` falls through to `negate(0)` (matching ClickHouse) instead of
 *   re-folding to a bare `UInt64(0)`. The public AST cannot distinguish
 *   `0` from `-0` (both are `UInt64 0`); the marker only governs the
 *   parse-time wrapping decision.
 *
 * - `change_value_types` — records the source literal type of each
 *   `Settings.changes` entry. Consumed only during parsing (by the grammar's
 *   EXPLAIN-settings and INSERT/SELECT settings-merge rules); `format()` and
 *   `formatExplain()` canonicalize numeric settings to the quoted form and
 *   never read it, so it is dropped from the returned AST.
 */
function stripParseTimeMarkers(value: unknown): void {
  if (value === null || typeof value !== 'object') return;

  if (Array.isArray(value)) {
    // Delete the non-index `parenthesized` array property (storage ORDER BY).
    delete (value as unknown as { parenthesized?: boolean }).parenthesized;
    for (const item of value) stripParseTimeMarkers(item);
    return;
  }

  const obj = value as Record<string, unknown>;
  if ('parenthesized' in obj) delete obj.parenthesized;
  if ('cast_operand' in obj) delete obj.cast_operand;
  if ('neg_folded' in obj) delete obj.neg_folded;
  if ('change_value_types' in obj) delete obj.change_value_types;
  for (const v of Object.values(obj)) stripParseTimeMarkers(v);
}

// ── Parent assignment ────────────────────────────────────────────────────────

function setParents(statements: Statement[]): void {
  const seen = new Set<unknown>();

  function walk(node: unknown, parent: unknown): void {
    if (node === null || node === undefined || typeof node !== 'object') {
      return;
    }
    if (seen.has(node)) return;
    seen.add(node);

    if (Array.isArray(node)) {
      for (const item of node) {
        walk(item, parent);
      }
      return;
    }

    const obj = node as Record<string, unknown>;
    // An AST node has a string `type` discriminator. (TRANSITION kind→type
    // rewrite: old-shape nodes use `kind`; drop the fallback when they're gone.
    // The `type` check must come first — native `Function` nodes carry a data
    // field also named `kind`, e.g. TABLE_ENGINE.)
    if (typeof obj.type === 'string' || 'kind' in obj) {
      obj.parent = parent;
      for (const [key, value] of Object.entries(obj)) {
        if (key === 'parent') continue;
        if (typeof value === 'object' && value !== null) {
          walk(value, obj);
        }
      }
    } else {
      for (const value of Object.values(obj)) {
        if (typeof value === 'object' && value !== null) {
          walk(value, parent);
        }
      }
    }
  }

  walk(statements, undefined);
}

// ── Location stripping ─────────────────────────────────────────────────────────

/**
 * Recursively removes the `location` metadata key from every node. Used when
 * `parse` is called with `{ locations: false }` to return a leaner AST without
 * source-position information.
 */
function stripLocations(value: unknown): void {
  if (value === null || typeof value !== 'object') return;

  if (Array.isArray(value)) {
    for (const item of value) stripLocations(item);
    return;
  }

  const obj = value as Record<string, unknown>;
  if ('location' in obj) delete obj.location;
  for (const [key, v] of Object.entries(obj)) {
    if (key === 'parent') continue;
    stripLocations(v);
  }
}

// ── Public API ────────────────────────────────────────────────────────────────

export type ParseOptions = {
  /**
   * When true, sets the `parent` reference on each AST node. The returned AST
   * nodes will have circular references, breaking JSON serialization.
   *
   * Default: false
   **/
  setParents?: boolean;

  /**
   * When true, each AST node carries a `location` field with its source range
   * (line/column/offset) in the input SQL. Set to false to omit locations and
   * return a leaner, fully JSON-serializable AST.
   *
   * Default: true
   **/
  locations?: boolean;
};

// When `locations: false` is passed as a literal, the returned AST is typed
// with every `location` property removed (see {@link WithoutLocations}); any
// other options object yields the default `Statement[]` (location optional).
export function parse(
  sql: string,
  options: ParseOptions & { locations: false },
): WithoutLocations<Statement>[];
export function parse(sql: string, options?: ParseOptions): Statement[];
export function parse(
  sql: string,
  options?: ParseOptions,
): Statement[] | WithoutLocations<Statement>[] {
  const statements = peggyParse(sql) as Statement[];
  stripParseTimeMarkers(statements);
  if (options?.locations === false) {
    stripLocations(statements);
  }
  if (options?.setParents) {
    setParents(statements);
  }
  return statements;
}

export { format, formatNode } from './format';
export { formatExplain } from './explain';
export { formatExplainJson } from './json-explain';
export { findNodes } from './find-nodes';
export { transformNodes, type NodePositionMap } from './transform-nodes';
export {
  // Generic narrowing helper.
  isNodeType,
  // ClickHouse-native AST node guards.
  isLiteral,
  isIdentifier,
  isFunction,
  isAsterisk,
  isQualifiedAsterisk,
  isQueryParameter,
  isSubquery,
  isOrderByElement,
  isSelectQuery,
  isSelectWithUnionQuery,
  isSelectIntersectExceptQuery,
  isExplainQuery,
  isSetStatement,
  isTransactionControl,
  isSetRoleQuery,
  isUseQuery,
  isSystemQuery,
  isCreateQuery,
  isAlterQuery,
  isInsertQuery,
  isDropQuery,
  // ClickHouse-native node guards (one per distinct node interface).
  isExpressionList,
  isWindowDefinition,
  isInterpolateElement,
  isColumnsRegexpMatcher,
  isColumnsListMatcher,
  isQualifiedColumnsRegexpMatcher,
  isQualifiedColumnsListMatcher,
  isColumnsTransformerList,
  isColumnsApplyTransformer,
  isColumnsExceptTransformer,
  isColumnsReplaceTransformer,
  isColumnsReplaceTransformerReplacement,
  isTablesInSelectQuery,
  isTablesInSelectQueryElement,
  isTableExpression,
  isTableIdentifier,
  isTableJoin,
  isArrayJoin,
  isSampleRatio,
  isWithElement,
  isWindowListElement,
  isDetachQuery,
  isTruncateQuery,
  isUndropQuery,
  isDropFunctionQuery,
  isColumns,
  isColumnDeclaration,
  isDataType,
  isEnumDataType,
  isTupleDataType,
  isNameTypePair,
  isObjectTypedPath,
  isObjectTypeArgument,
  isCollation,
  isStorage,
  isStorageOrderByElement,
  isTTLElement,
  isConstraint,
  isIndex,
  isStat,
  isProjection,
  isProjectionSelectQuery,
  isRefreshStrategy,
  isTimeInterval,
  isViewTargets,
  isDictionary,
  isDictionaryAttributeDeclaration,
  isFunctionWithKeyValueArguments,
  isPair,
  isCreateFunctionQuery,
  isCreateIndexQuery,
  isAlterCommandNode,
  isShowQuery,
  isAccessDropQuery,
  isAccessQuery,
  isBackupQuery,
  isParallelWithQuery,
  isDropIndexQuery,
  isPartition,
  isPartitionId,
  isAssignment,
  isUserNameWithHost,
  isUserNamesWithHost,
  isRolesOrUsersSet,
  isRowPolicyNames,
  isDatabaseOrNone,
  isSettingsProfileElement,
  isSettingsProfileElements,
  isAlterSettingsProfileElements,
  isExecuteAsQuery,
  isOptimizeQuery,
  isDescribeQuery,
  isShowCreateQuery,
  isExistsQuery,
  isCheckQuery,
  isAttachQuery,
  isRename,
  isKillQueryQuery,
  isDeleteQuery,
  isUpdateQuery,
  isEmptyQuery,
} from './guards';
