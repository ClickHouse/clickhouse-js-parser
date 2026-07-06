import { join } from 'path';
import { parse } from '../src/index';
import { ASTNodeTypeMap } from '../src/ast';
import { CLICKHOUSE_DIR, discoverCases, readReferenceSql } from './helpers';

/**
 * With locations enabled (the default), the parser must attach a `location` to
 * **every** node whose `type` is a key of {@link ASTNodeTypeMap}. This is the
 * invariant that lets `NodeMetadata.location` be a *required* property. This
 * guard walks every parsed reference AST and asserts no such node is missing a
 * location.
 *
 * If this fails, a grammar rule was added that builds a node without threading
 * a source location onto it — fix the builder/rule so it wraps the node with
 * `loc()`/`withLoc()`/`spanOf()` (see src/grammar.pegjs).
 *
 * Inline non-node shapes (e.g. window-frame bounds, dictionary sub-clauses,
 * authentication data) are intentionally excluded: they are not in
 * `ASTNodeTypeMap` and carry no `location`.
 */
describe('node location coverage', () => {
  // The set of real AST node `type` discriminators. Mirrors ASTNodeTypeMap's
  // keys; the `satisfies` clause keeps it exhaustive at compile time.
  const KNOWN: ReadonlySet<string> = new Set(
    Object.keys({
      Literal: 0,
      Identifier: 0,
      Function: 0,
      Asterisk: 0,
      QualifiedAsterisk: 0,
      Subquery: 0,
      QueryParameter: 0,
      ExpressionList: 0,
      WindowDefinition: 0,
      OrderByElement: 0,
      InterpolateElement: 0,
      ColumnsRegexpMatcher: 0,
      ColumnsListMatcher: 0,
      QualifiedColumnsRegexpMatcher: 0,
      QualifiedColumnsListMatcher: 0,
      ColumnsTransformerList: 0,
      ColumnsApplyTransformer: 0,
      ColumnsExceptTransformer: 0,
      ColumnsReplaceTransformer: 0,
      'ColumnsReplaceTransformer::Replacement': 0,
      Settings: 0,
      DictionarySettings: 0,
      SelectQuery: 0,
      SelectWithUnionQuery: 0,
      SelectIntersectExceptQuery: 0,
      TablesInSelectQuery: 0,
      TablesInSelectQueryElement: 0,
      TableExpression: 0,
      TableIdentifier: 0,
      TableJoin: 0,
      ArrayJoin: 0,
      SampleRatio: 0,
      WithElement: 0,
      WindowListElement: 0,
      DropQuery: 0,
      DetachQuery: 0,
      TruncateQuery: 0,
      UndropQuery: 0,
      DropFunctionQuery: 0,
      InsertQuery: 0,
      CreateQuery: 0,
      Columns: 0,
      ColumnDeclaration: 0,
      DataType: 0,
      EnumDataType: 0,
      TupleDataType: 0,
      NameTypePair: 0,
      ObjectTypedPath: 0,
      ObjectTypeArgument: 0,
      Collation: 0,
      Storage: 0,
      StorageOrderByElement: 0,
      TTLElement: 0,
      Constraint: 0,
      Index: 0,
      Stat: 0,
      Projection: 0,
      ProjectionSelectQuery: 0,
      RefreshStrategy: 0,
      TimeInterval: 0,
      ViewTargets: 0,
      Dictionary: 0,
      DictionaryAttributeDeclaration: 0,
      FunctionWithKeyValueArguments: 0,
      pair: 0,
      CreateFunctionQuery: 0,
      CreateIndexQuery: 0,
      AlterQuery: 0,
      AlterCommand: 0,
      SYSTEM: 0,
      SHOW: 0,
      ShowTables: 0,
      ShowColumns: 0,
      ShowIndexes: 0,
      ShowFunctions: 0,
      ShowSetting: 0,
      ShowEngineQuery: 0,
      ShowAccessQuery: 0,
      ShowAccessEntitiesQuery: 0,
      ShowProcesslistQuery: 0,
      ShowGrantsQuery: 0,
      ShowPrivilegesQuery: 0,
      ShowCreateNamedCollectionQuery: 0,
      DropNamedCollectionQuery: 0,
      DropWorkloadQuery: 0,
      DropResourceQuery: 0,
      CreateUserQuery: 0,
      CreateRoleQuery: 0,
      CreateQuotaQuery: 0,
      CreateSettingsProfileQuery: 0,
      CreateNamedCollectionQuery: 0,
      CreateWorkloadQuery: 0,
      CreateResourceQuery: 0,
      GrantQuery: 0,
      SetRoleQuery: 0,
      BackupQuery: 0,
      RestoreQuery: 0,
      ParallelWithQuery: 0,
      DropIndexQuery: 0,
      Partition: 0,
      Partition_ID: 0,
      Assignment: 0,
      UseQuery: 0,
      TransactionControl: 0,
      UserNameWithHost: 0,
      UserNamesWithHost: 0,
      RolesOrUsersSet: 0,
      RowPolicyNames: 0,
      DatabaseOrNone: 0,
      SettingsProfileElement: 0,
      SettingsProfileElements: 0,
      AlterSettingsProfileElements: 0,
      DropAccessEntityQuery: 0,
      ShowCreateAccessEntityQuery: 0,
      CreateRowPolicyQuery: 0,
      RevokeQuery: 0,
      ExecuteAsQuery: 0,
      OptimizeQuery: 0,
      DescribeQuery: 0,
      ShowCreateTableQuery: 0,
      ShowCreateViewQuery: 0,
      ShowCreateDictionaryQuery: 0,
      ShowCreateDatabaseQuery: 0,
      ExistsTableQuery: 0,
      ExistsViewQuery: 0,
      ExistsDictionaryQuery: 0,
      ExistsDatabaseQuery: 0,
      CheckQuery: 0,
      CheckAllQuery: 0,
      AttachQuery: 0,
      Rename: 0,
      KillQueryQuery: 0,
      DeleteQuery: 0,
      UpdateQuery: 0,
      Explain: 0,
      EmptyQuery: 0,
    } satisfies Record<keyof ASTNodeTypeMap, 0>),
  );

  const cases = discoverCases();

  it('every ASTNodeTypeMap node has a location', { timeout: 120000 }, () => {
    const missing = new Map<string, string[]>();

    for (const name of cases) {
      let sql: string;
      try {
        sql = readReferenceSql(join(CLICKHOUSE_DIR, name));
      } catch {
        continue;
      }
      let statements: unknown[];
      try {
        statements = parse(sql) as unknown[];
      } catch {
        continue;
      }
      walk(statements, name);
    }

    function walk(node: unknown, src: string): void {
      if (node === null || node === undefined || typeof node !== 'object') return;
      if (Array.isArray(node)) {
        for (const item of node) walk(item, src);
        return;
      }
      const obj = node as Record<string, unknown>;
      const t = obj.type;
      if (typeof t === 'string' && KNOWN.has(t) && obj.location === undefined) {
        if (!missing.has(t)) missing.set(t, []);
        const examples = missing.get(t)!;
        if (examples.length < 3 && !examples.includes(src)) examples.push(src);
      }
      for (const key of Object.keys(obj)) {
        if (key === 'parent') continue;
        const v = obj[key];
        if (typeof v === 'object' && v !== null) walk(v, src);
      }
    }

    if (missing.size > 0) {
      const message = [...missing.entries()]
        .map(([t, files]) => `  ${t}  (e.g. ${files.join(', ')})`)
        .join('\n');
      throw new Error(`Found AST nodes missing a \`location\`:\n${message}`);
    }
  });
});
