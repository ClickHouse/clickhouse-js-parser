import { readFileSync } from 'fs';
import { join } from 'path';
import { parse } from '../src/index';
import { ASTNodeTypeMap } from '../src/ast';
import { CLICKHOUSE_DIR, discoverCases } from './helpers';

/**
 * The ClickHouse-native AST {@link ASTNodeTypeMap} must enumerate every
 * `type` discriminator the parser can emit. This guard walks every parsed
 * reference AST and asserts that each encountered `type` value is a key of
 * {@link ASTNodeTypeMap}.
 *
 * If this fails, a new node type was added to the grammar without being added
 * to `ASTNodeTypeMap` in `src/ast.ts` — fix the map so `findNodes` /
 * `transformNodes` stay type-safe.
 */
describe('ASTNodeTypeMap', () => {
  // Build the set of known type discriminator values at runtime from the
  // type map. We use a sentinel object whose keys mirror the type-map keys
  // so we can iterate them — the values aren't relevant.
  const KNOWN_TYPES: ReadonlySet<string> = new Set(
    // Listing each native type explicitly keeps this test honest: if a new
    // type is added to the parser but forgotten here, the test still flags
    // unknown types via the parsed corpus below.
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

  // The native AST may carry a handful of `_fmt_src`-internal nested nodes
  // that ClickHouse's EXPLAIN AST emits without a name (e.g. internal
  // explain-only types). Allow them through.
  const ALLOWED_EXTRA_TYPES = new Set<string>([
    // AuthenticationData / PublicSSHKey are CreateUserQuery children embedded
    // directly in the native node by the access-control wrapper.
    'AuthenticationData',
    'PublicSSHKey',
    // Window frame bound discriminators are inline `{type, ...}` shapes
    // (not standalone AST nodes) under WindowDefinition.frame_begin/frame_end.
    'Unbounded',
    'Current',
    'Offset',
    // CREATE DICTIONARY sub-clauses — inline `{type, ...}` shapes nested
    // under `dictionary` (DictionaryLifetime/Layout/Range/Settings).
    'DictionaryLifetime',
    'DictionaryLayout',
    'DictionaryRange',
    'DictionarySettings',
    // FunctionWithKeyValueArguments / pair are inline shapes used by
    // dictionary SOURCE/LAYOUT/parameters.
    'FunctionWithKeyValueArguments',
  ]);

  const cases = discoverCases();

  it('lists every node `type` value the parser can emit', { timeout: 120000 }, () => {
    const unknown = new Map<string, string[]>();
    for (const name of cases) {
      let sql: string;
      try {
        sql = readFileSync(join(CLICKHOUSE_DIR, name), 'utf8');
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
      if (node === null || node === undefined) return;
      if (Array.isArray(node)) {
        for (const item of node) walk(item, src);
        return;
      }
      if (typeof node !== 'object') return;
      const obj = node as Record<string, unknown>;
      const t = obj.type;
      // Only flag values that look like an AST node `type` discriminator —
      // PascalCase or a few canonical lowercase exceptions (`pair`). Internal
      // data-shape discriminators inside `_fmt_src` payloads (e.g.
      // `{type: 'listing'}` for SHOW TABLES, `{type: 'createAccess'}` for
      // structured grants) carry lowercase keywords and are not AST nodes.
      if (typeof t === 'string' && isLikelyNodeType(t)) {
        if (!KNOWN_TYPES.has(t) && !ALLOWED_EXTRA_TYPES.has(t)) {
          if (!unknown.has(t)) unknown.set(t, []);
          const examples = unknown.get(t)!;
          if (examples.length < 3 && !examples.includes(src)) examples.push(src);
        }
      }
      for (const key of Object.keys(obj)) {
        if (key === 'parent') continue;
        const v = obj[key];
        if (typeof v === 'object' && v !== null) walk(v, src);
      }
    }

    // Heuristic: a node `type` discriminator starts with an uppercase letter
    // or is one of the few canonical lowercase names (`pair`). Internal
    // `_fmt_src` shape discriminators use lowercase camelCase keywords like
    // `'listing'`, `'columns'`, `'grants'`, etc.
    function isLikelyNodeType(t: string): boolean {
      if (t === 'pair') return true;
      const first = t[0];
      return first !== undefined && first >= 'A' && first <= 'Z';
    }

    if (unknown.size > 0) {
      const message = [...unknown.entries()]
        .map(([t, files]) => `  ${t}  (e.g. ${files.join(', ')})`)
        .join('\n');
      throw new Error(`Found AST node \`type\` values not listed in ASTNodeTypeMap:\n${message}`);
    }
  });
});
