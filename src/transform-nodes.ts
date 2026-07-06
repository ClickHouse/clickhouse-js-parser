import type {
  Statement,
  Expression,
  ASTNodeTypeMap,
  ASTNodeLookupMap,
  WithoutLocations,
} from './ast';

/**
 * The AST node `type` values that occupy an **expression** position — anywhere
 * an {@link Expression} is accepted (SELECT items, WHERE, function arguments,
 * ...). A visitor for one of these kinds may return any other Expression, so
 * these keys widen to `Expression` in {@link NodePositionMap}.
 */
type ExpressionPositionKey =
  | 'Literal'
  | 'Identifier'
  | 'Function'
  | 'Asterisk'
  | 'QualifiedAsterisk'
  | 'Subquery'
  | 'QueryParameter'
  | 'ColumnsRegexpMatcher'
  | 'ColumnsListMatcher'
  | 'QualifiedColumnsRegexpMatcher'
  | 'QualifiedColumnsListMatcher';

/**
 * The AST node `type` values that occupy a **top-level statement** position (a
 * member of the parsed `Statement[]`, a subquery/CTE body, a UNION member, or
 * an explained inner statement). A visitor for one of these kinds may return
 * any other Statement, so these keys widen to `Statement` in
 * {@link NodePositionMap}.
 *
 * Note: `Settings` and `SelectWithUnionQuery` are dual-position (they also
 * appear in expression position — `f(x SETTINGS k=v)`, `view(SELECT ...)`).
 * The map can encode only one position per key; `SelectWithUnionQuery` is
 * treated as a statement and `Settings` (below) as its own node type.
 */
type StatementPositionKey =
  | 'SelectQuery'
  | 'SelectWithUnionQuery'
  | 'SelectIntersectExceptQuery'
  | 'Explain'
  | 'EmptyQuery'
  | 'DropQuery'
  | 'DetachQuery'
  | 'TruncateQuery'
  | 'UndropQuery'
  | 'DropFunctionQuery'
  | 'InsertQuery'
  | 'CreateQuery'
  | 'CreateFunctionQuery'
  | 'CreateIndexQuery'
  | 'AlterQuery'
  | 'SYSTEM'
  | 'SHOW'
  | 'ShowTables'
  | 'ShowColumns'
  | 'ShowIndexes'
  | 'ShowFunctions'
  | 'ShowSetting'
  | 'ShowEngineQuery'
  | 'ShowAccessEntitiesQuery'
  | 'ShowAccessQuery'
  | 'ShowProcesslistQuery'
  | 'ShowGrantsQuery'
  | 'ShowPrivilegesQuery'
  | 'ShowCreateNamedCollectionQuery'
  | 'ShowCreateAccessEntityQuery'
  | 'DropAccessEntityQuery'
  | 'DropNamedCollectionQuery'
  | 'DropWorkloadQuery'
  | 'DropResourceQuery'
  | 'CREATE'
  | 'CreateUserQuery'
  | 'CreateRoleQuery'
  | 'CreateQuotaQuery'
  | 'CreateSettingsProfileQuery'
  | 'CreateNamedCollectionQuery'
  | 'CreateWorkloadQuery'
  | 'CreateResourceQuery'
  | 'CreateRowPolicyQuery'
  | 'GrantQuery'
  | 'RevokeQuery'
  | 'SetRoleQuery'
  | 'BackupQuery'
  | 'RestoreQuery'
  | 'ParallelWithQuery'
  | 'DropIndexQuery'
  | 'UseQuery'
  | 'TransactionControl'
  | 'ExecuteAsQuery'
  | 'OptimizeQuery'
  | 'DescribeQuery'
  | 'ShowCreateTableQuery'
  | 'ShowCreateViewQuery'
  | 'ShowCreateDictionaryQuery'
  | 'ShowCreateDatabaseQuery'
  | 'ExistsTableQuery'
  | 'ExistsViewQuery'
  | 'ExistsDictionaryQuery'
  | 'ExistsDatabaseQuery'
  | 'CheckQuery'
  | 'CheckAllQuery'
  | 'AttachQuery'
  | 'Rename'
  | 'KillQueryQuery'
  | 'DeleteQuery'
  | 'UpdateQuery';

/**
 * Maps each AST node `type` to the type a visitor may return when replacing a
 * node of that kind — i.e. the union representing the position where the node
 * appears. This ensures a visitor can only return a node compatible with the
 * original node's position (e.g. an Expression node can only be replaced with
 * another Expression).
 *
 * Derived directly from {@link ASTNodeTypeMap} so it can never drift: every
 * known node type is covered automatically. Expression-position keys widen to
 * {@link Expression} and statement-position keys widen to {@link Statement};
 * every other (structural sub-node) key defaults to its own node type, so a
 * newly-added node type is transformable in place with no manual edit here.
 */
export type NodePositionMap = {
  [K in keyof ASTNodeTypeMap]: K extends ExpressionPositionKey
    ? Expression
    : K extends StatementPositionKey
      ? Statement
      : ASTNodeTypeMap[K];
};

// Compile-time drift guard: every ASTNodeTypeMap key must be covered by
// NodePositionMap. The mapped type above guarantees this structurally; this
// assertion documents the invariant and fails the build if the relationship
// is ever broken (e.g. by refactoring NodePositionMap away from the map).
type _AssertNodePositionMapIsTotal = keyof ASTNodeTypeMap extends keyof NodePositionMap
  ? true
  : never;
const _assertNodePositionMapIsTotal: _AssertNodePositionMapIsTotal = true;
void _assertNodePositionMapIsTotal;

/**
 * Immutably transforms all AST nodes of the given `kind` by applying a
 * visitor function. Returns a new AST — the original is not modified.
 *
 * The visitor receives each matching node and returns a replacement that must
 * be compatible with the same position (e.g. an Expression node can only be
 * replaced with another Expression). The visitor is called bottom-up: children
 * are visited before their parents, so the visitor always sees
 * already-transformed subtrees.
 *
 * Only the paths from the root to changed nodes are shallow-copied; unchanged
 * subtrees are shared with the original AST.
 *
 * @example
 * ```ts
 * import { parse, transformNodes } from '@clickhouse/parser';
 *
 * const ast = parse('SELECT * FROM t WHERE id = {id:UInt64}');
 *
 * // Replace query parameters with literal values
 * const transformed = transformNodes(ast, 'QueryParameter', (node) => ({
 *   type: 'Literal',
 *   value_type: 'UInt64',
 *   value: '42',
 * }));
 * ```
 */
export function transformNodes<K extends keyof ASTNodeLookupMap>(
  statements: WithoutLocations<Statement>[],
  kind: K,
  visitor: (node: WithoutLocations<ASTNodeLookupMap[K]>) => WithoutLocations<NodePositionMap[K]>,
): WithoutLocations<Statement>[] {
  function walkChildren(obj: Record<string, unknown>): Record<string, unknown> {
    let copy: Record<string, unknown> | undefined;

    for (const key of Object.keys(obj)) {
      if (key === 'parent') continue;
      const value = obj[key];
      if (typeof value === 'object' && value !== null) {
        const transformed = walk(value);
        if (transformed !== value) {
          if (!copy) copy = { ...obj };
          copy[key] = transformed;
        }
      }
    }

    return copy ?? obj;
  }

  function walk(node: unknown): unknown {
    if (node === null || node === undefined || typeof node !== 'object') {
      return node;
    }

    if (Array.isArray(node)) {
      let copy: unknown[] | undefined;
      for (let i = 0; i < node.length; i++) {
        const transformed = walk(node[i]);
        if (transformed !== node[i]) {
          if (!copy) copy = node.slice();
          copy[i] = transformed;
        }
      }
      return copy ?? node;
    }

    const obj = node as Record<string, unknown>;

    // Bottom-up: recurse into children first
    const withChildren = walkChildren(obj);

    // Visit matching AST nodes
    // New-shape nodes match on `type`; old-shape nodes match on `kind`.
    // (`type` checked first: native Function nodes carry a data field named `kind`.)
    if (typeof obj.type === 'string' ? obj.type === kind : obj.kind === kind) {
      const visited = visitor(
        withChildren as WithoutLocations<ASTNodeLookupMap[K]>,
      ) as unknown as Record<string, unknown>;
      return visited === withChildren && withChildren === obj ? obj : visited;
    }

    return withChildren;
  }

  return walk(statements) as WithoutLocations<Statement>[];
}
