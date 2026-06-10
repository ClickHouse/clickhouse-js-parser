import type { ASTNode, ASTNodeType, ASTNodeTypeMap, AccessQueryNode } from './ast';

/**
 * Returns a type guard that narrows an {@link ASTNode} to the specific type
 * corresponding to the given ClickHouse-native `type`.
 *
 * @example
 * ```ts
 * import { isNodeType } from '@clickhouse/parser';
 *
 * const node: ASTNode = ...;
 * if (isNodeType(node, 'Literal')) {
 *   node.value; // narrowed to LiteralNode
 * }
 * ```
 */
export function isNodeType<T extends ASTNodeType>(
  node: ASTNode | undefined,
  type: T,
): node is ASTNodeTypeMap[T] {
  return node !== undefined && (node as { type?: string }).type === type;
}

// ── ClickHouse-native node guards ─────────────────────────────────────────────

/** Type guard for {@link import('./ast').LiteralNode | Literal} nodes. */
export function isLiteral(node: ASTNode | undefined): node is ASTNodeTypeMap['Literal'] {
  return isNodeType(node, 'Literal');
}

/** Type guard for {@link import('./ast').IdentifierNode | Identifier} nodes. */
export function isIdentifier(node: ASTNode | undefined): node is ASTNodeTypeMap['Identifier'] {
  return isNodeType(node, 'Identifier');
}

/** Type guard for {@link import('./ast').FunctionNode | Function} nodes. */
export function isFunction(node: ASTNode | undefined): node is ASTNodeTypeMap['Function'] {
  return isNodeType(node, 'Function');
}

/** Type guard for {@link import('./ast').AsteriskNode | Asterisk} nodes. */
export function isAsterisk(node: ASTNode | undefined): node is ASTNodeTypeMap['Asterisk'] {
  return isNodeType(node, 'Asterisk');
}

/** Type guard for {@link import('./ast').QualifiedAsteriskNode | QualifiedAsterisk} nodes. */
export function isQualifiedAsterisk(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['QualifiedAsterisk'] {
  return isNodeType(node, 'QualifiedAsterisk');
}

/** Type guard for {@link import('./ast').SubqueryNode | Subquery} nodes. */
export function isSubquery(node: ASTNode | undefined): node is ASTNodeTypeMap['Subquery'] {
  return isNodeType(node, 'Subquery');
}

/** Type guard for {@link import('./ast').QueryParameterNode | QueryParameter} nodes. */
export function isQueryParameter(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['QueryParameter'] {
  return isNodeType(node, 'QueryParameter');
}

/** Type guard for {@link import('./ast').OrderByElementNode | OrderByElement} nodes. */
export function isOrderByElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['OrderByElement'] {
  return isNodeType(node, 'OrderByElement');
}

// ── Statement guards ─────────────────────────────────────────────────────────

/** Type guard for {@link import('./ast').SelectQueryNode | SelectQuery} nodes. */
export function isSelectQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['SelectQuery'] {
  return isNodeType(node, 'SelectQuery');
}

/** Type guard for {@link import('./ast').SelectWithUnionQueryNode | SelectWithUnionQuery} nodes. */
export function isSelectWithUnionQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['SelectWithUnionQuery'] {
  return isNodeType(node, 'SelectWithUnionQuery');
}

/** Type guard for {@link import('./ast').SelectIntersectExceptQueryNode | SelectIntersectExceptQuery} nodes. */
export function isSelectIntersectExceptQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['SelectIntersectExceptQuery'] {
  return isNodeType(node, 'SelectIntersectExceptQuery');
}

/** Type guard for {@link import('./ast').ExplainQueryNode | Explain} nodes. */
export function isExplainQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['Explain'] {
  return isNodeType(node, 'Explain');
}

/** Type guard for {@link import('./ast').SettingsNode | Settings} nodes. */
export function isSetStatement(node: ASTNode | undefined): node is ASTNodeTypeMap['Settings'] {
  return isNodeType(node, 'Settings');
}

/** Type guard for {@link import('./ast').TransactionControlNode | TransactionControl} nodes. */
export function isTransactionControl(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TransactionControl'] {
  return isNodeType(node, 'TransactionControl');
}

/** Type guard for {@link import('./ast').AccessQueryNode | SetRoleQuery} nodes. */
export function isSetRoleQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['SetRoleQuery'] {
  return isNodeType(node, 'SetRoleQuery');
}

/** Type guard for {@link import('./ast').UseQueryNode | UseQuery} nodes. */
export function isUseQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['UseQuery'] {
  return isNodeType(node, 'UseQuery');
}

/** Type guard for {@link import('./ast').SystemQueryNode | SYSTEM} nodes. */
export function isSystemQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['SYSTEM'] {
  return isNodeType(node, 'SYSTEM');
}

/** Type guard for {@link import('./ast').CreateQueryNode | CreateQuery} nodes. */
export function isCreateQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['CreateQuery'] {
  return isNodeType(node, 'CreateQuery');
}

/** Type guard for {@link import('./ast').AlterQueryNode | AlterQuery} nodes. */
export function isAlterQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['AlterQuery'] {
  return isNodeType(node, 'AlterQuery');
}

/** Type guard for {@link import('./ast').InsertQueryNode | InsertQuery} nodes. */
export function isInsertQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['InsertQuery'] {
  return isNodeType(node, 'InsertQuery');
}

/** Type guard for {@link import('./ast').DropQueryNode | DropQuery} nodes. */
export function isDropQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['DropQuery'] {
  return isNodeType(node, 'DropQuery');
}

// ── Native node guards ────────────────────────────────────────────────────────

/** Type guard for {@link import('./ast').ExpressionListNode | ExpressionList} nodes. */
export function isExpressionList(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ExpressionList'] {
  return isNodeType(node, 'ExpressionList');
}

/** Type guard for {@link import('./ast').WindowDefinitionNode | WindowDefinition} nodes. */
export function isWindowDefinition(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['WindowDefinition'] {
  return isNodeType(node, 'WindowDefinition');
}

/** Type guard for {@link import('./ast').InterpolateElementNode | InterpolateElement} nodes. */
export function isInterpolateElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['InterpolateElement'] {
  return isNodeType(node, 'InterpolateElement');
}

/** Type guard for {@link import('./ast').ColumnsRegexpMatcherNode | ColumnsRegexpMatcher} nodes. */
export function isColumnsRegexpMatcher(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsRegexpMatcher'] {
  return isNodeType(node, 'ColumnsRegexpMatcher');
}

/** Type guard for {@link import('./ast').ColumnsListMatcherNode | ColumnsListMatcher} nodes. */
export function isColumnsListMatcher(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsListMatcher'] {
  return isNodeType(node, 'ColumnsListMatcher');
}

/** Type guard for {@link import('./ast').QualifiedColumnsRegexpMatcherNode | QualifiedColumnsRegexpMatcher} nodes. */
export function isQualifiedColumnsRegexpMatcher(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['QualifiedColumnsRegexpMatcher'] {
  return isNodeType(node, 'QualifiedColumnsRegexpMatcher');
}

/** Type guard for {@link import('./ast').QualifiedColumnsListMatcherNode | QualifiedColumnsListMatcher} nodes. */
export function isQualifiedColumnsListMatcher(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['QualifiedColumnsListMatcher'] {
  return isNodeType(node, 'QualifiedColumnsListMatcher');
}

/** Type guard for {@link import('./ast').ColumnsTransformerListNode | ColumnsTransformerList} nodes. */
export function isColumnsTransformerList(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsTransformerList'] {
  return isNodeType(node, 'ColumnsTransformerList');
}

/** Type guard for {@link import('./ast').ColumnsApplyTransformerNode | ColumnsApplyTransformer} nodes. */
export function isColumnsApplyTransformer(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsApplyTransformer'] {
  return isNodeType(node, 'ColumnsApplyTransformer');
}

/** Type guard for {@link import('./ast').ColumnsExceptTransformerNode | ColumnsExceptTransformer} nodes. */
export function isColumnsExceptTransformer(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsExceptTransformer'] {
  return isNodeType(node, 'ColumnsExceptTransformer');
}

/** Type guard for {@link import('./ast').ColumnsReplaceTransformerNode | ColumnsReplaceTransformer} nodes. */
export function isColumnsReplaceTransformer(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsReplaceTransformer'] {
  return isNodeType(node, 'ColumnsReplaceTransformer');
}

/** Type guard for {@link import('./ast').ColumnsReplaceTransformerReplacementNode | ColumnsReplaceTransformer::Replacement} nodes. */
export function isColumnsReplaceTransformerReplacement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnsReplaceTransformer::Replacement'] {
  return isNodeType(node, 'ColumnsReplaceTransformer::Replacement');
}

/** Type guard for {@link import('./ast').TablesInSelectQueryNode | TablesInSelectQuery} nodes. */
export function isTablesInSelectQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TablesInSelectQuery'] {
  return isNodeType(node, 'TablesInSelectQuery');
}

/** Type guard for {@link import('./ast').TablesInSelectQueryElementNode | TablesInSelectQueryElement} nodes. */
export function isTablesInSelectQueryElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TablesInSelectQueryElement'] {
  return isNodeType(node, 'TablesInSelectQueryElement');
}

/** Type guard for {@link import('./ast').TableExpressionNode | TableExpression} nodes. */
export function isTableExpression(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TableExpression'] {
  return isNodeType(node, 'TableExpression');
}

/** Type guard for {@link import('./ast').TableIdentifierNode | TableIdentifier} nodes. */
export function isTableIdentifier(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TableIdentifier'] {
  return isNodeType(node, 'TableIdentifier');
}

/** Type guard for {@link import('./ast').TableJoinNode | TableJoin} nodes. */
export function isTableJoin(node: ASTNode | undefined): node is ASTNodeTypeMap['TableJoin'] {
  return isNodeType(node, 'TableJoin');
}

/** Type guard for {@link import('./ast').ArrayJoinNode | ArrayJoin} nodes. */
export function isArrayJoin(node: ASTNode | undefined): node is ASTNodeTypeMap['ArrayJoin'] {
  return isNodeType(node, 'ArrayJoin');
}

/** Type guard for {@link import('./ast').SampleRatioNode | SampleRatio} nodes. */
export function isSampleRatio(node: ASTNode | undefined): node is ASTNodeTypeMap['SampleRatio'] {
  return isNodeType(node, 'SampleRatio');
}

/** Type guard for {@link import('./ast').WithElementNode | WithElement} nodes. */
export function isWithElement(node: ASTNode | undefined): node is ASTNodeTypeMap['WithElement'] {
  return isNodeType(node, 'WithElement');
}

/** Type guard for {@link import('./ast').WindowListElementNode | WindowListElement} nodes. */
export function isWindowListElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['WindowListElement'] {
  return isNodeType(node, 'WindowListElement');
}

/** Type guard for {@link import('./ast').DetachQueryNode | DetachQuery} nodes. */
export function isDetachQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['DetachQuery'] {
  return isNodeType(node, 'DetachQuery');
}

/** Type guard for {@link import('./ast').TruncateQueryNode | TruncateQuery} nodes. */
export function isTruncateQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TruncateQuery'] {
  return isNodeType(node, 'TruncateQuery');
}

/** Type guard for {@link import('./ast').UndropQueryNode | UndropQuery} nodes. */
export function isUndropQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['UndropQuery'] {
  return isNodeType(node, 'UndropQuery');
}

/** Type guard for {@link import('./ast').DropFunctionQueryNode | DropFunctionQuery} nodes. */
export function isDropFunctionQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DropFunctionQuery'] {
  return isNodeType(node, 'DropFunctionQuery');
}

/** Type guard for {@link import('./ast').ColumnsNode | Columns} nodes. */
export function isColumns(node: ASTNode | undefined): node is ASTNodeTypeMap['Columns'] {
  return isNodeType(node, 'Columns');
}

/** Type guard for {@link import('./ast').ColumnDeclarationNode | ColumnDeclaration} nodes. */
export function isColumnDeclaration(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ColumnDeclaration'] {
  return isNodeType(node, 'ColumnDeclaration');
}

/** Type guard for {@link import('./ast').DataTypeNode | DataType} nodes. */
export function isDataType(node: ASTNode | undefined): node is ASTNodeTypeMap['DataType'] {
  return isNodeType(node, 'DataType');
}

/** Type guard for {@link import('./ast').EnumDataTypeNode | EnumDataType} nodes. */
export function isEnumDataType(node: ASTNode | undefined): node is ASTNodeTypeMap['EnumDataType'] {
  return isNodeType(node, 'EnumDataType');
}

/** Type guard for {@link import('./ast').TupleDataTypeNode | TupleDataType} nodes. */
export function isTupleDataType(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['TupleDataType'] {
  return isNodeType(node, 'TupleDataType');
}

/** Type guard for {@link import('./ast').NameTypePairNode | NameTypePair} nodes. */
export function isNameTypePair(node: ASTNode | undefined): node is ASTNodeTypeMap['NameTypePair'] {
  return isNodeType(node, 'NameTypePair');
}

/** Type guard for {@link import('./ast').ObjectTypedPathNode | ObjectTypedPath} nodes. */
export function isObjectTypedPath(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ObjectTypedPath'] {
  return isNodeType(node, 'ObjectTypedPath');
}

/** Type guard for {@link import('./ast').ObjectTypeArgumentNode | ObjectTypeArgument} nodes. */
export function isObjectTypeArgument(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ObjectTypeArgument'] {
  return isNodeType(node, 'ObjectTypeArgument');
}

/** Type guard for {@link import('./ast').CollationNode | Collation} nodes. */
export function isCollation(node: ASTNode | undefined): node is ASTNodeTypeMap['Collation'] {
  return isNodeType(node, 'Collation');
}

/** Type guard for {@link import('./ast').StorageNode | Storage} nodes. */
export function isStorage(node: ASTNode | undefined): node is ASTNodeTypeMap['Storage'] {
  return isNodeType(node, 'Storage');
}

/** Type guard for {@link import('./ast').StorageOrderByElementNode | StorageOrderByElement} nodes. */
export function isStorageOrderByElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['StorageOrderByElement'] {
  return isNodeType(node, 'StorageOrderByElement');
}

/** Type guard for {@link import('./ast').TTLElementNode | TTLElement} nodes. */
export function isTTLElement(node: ASTNode | undefined): node is ASTNodeTypeMap['TTLElement'] {
  return isNodeType(node, 'TTLElement');
}

/** Type guard for {@link import('./ast').ConstraintNode | Constraint} nodes. */
export function isConstraint(node: ASTNode | undefined): node is ASTNodeTypeMap['Constraint'] {
  return isNodeType(node, 'Constraint');
}

/** Type guard for {@link import('./ast').IndexNode | Index} nodes. */
export function isIndex(node: ASTNode | undefined): node is ASTNodeTypeMap['Index'] {
  return isNodeType(node, 'Index');
}

/** Type guard for {@link import('./ast').StatNode | Stat} nodes. */
export function isStat(node: ASTNode | undefined): node is ASTNodeTypeMap['Stat'] {
  return isNodeType(node, 'Stat');
}

/** Type guard for {@link import('./ast').ProjectionNode | Projection} nodes. */
export function isProjection(node: ASTNode | undefined): node is ASTNodeTypeMap['Projection'] {
  return isNodeType(node, 'Projection');
}

/** Type guard for {@link import('./ast').ProjectionSelectQueryNode | ProjectionSelectQuery} nodes. */
export function isProjectionSelectQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ProjectionSelectQuery'] {
  return isNodeType(node, 'ProjectionSelectQuery');
}

/** Type guard for {@link import('./ast').RefreshStrategyNode | RefreshStrategy} nodes. */
export function isRefreshStrategy(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['RefreshStrategy'] {
  return isNodeType(node, 'RefreshStrategy');
}

/** Type guard for {@link import('./ast').TimeIntervalNode | TimeInterval} nodes. */
export function isTimeInterval(node: ASTNode | undefined): node is ASTNodeTypeMap['TimeInterval'] {
  return isNodeType(node, 'TimeInterval');
}

/** Type guard for {@link import('./ast').ViewTargetsNode | ViewTargets} nodes. */
export function isViewTargets(node: ASTNode | undefined): node is ASTNodeTypeMap['ViewTargets'] {
  return isNodeType(node, 'ViewTargets');
}

/** Type guard for {@link import('./ast').DictionaryNode | Dictionary} nodes. */
export function isDictionary(node: ASTNode | undefined): node is ASTNodeTypeMap['Dictionary'] {
  return isNodeType(node, 'Dictionary');
}

/** Type guard for {@link import('./ast').DictionaryAttributeDeclarationNode | DictionaryAttributeDeclaration} nodes. */
export function isDictionaryAttributeDeclaration(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DictionaryAttributeDeclaration'] {
  return isNodeType(node, 'DictionaryAttributeDeclaration');
}

/** Type guard for {@link import('./ast').FunctionWithKeyValueArgumentsNode | FunctionWithKeyValueArguments} nodes. */
export function isFunctionWithKeyValueArguments(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['FunctionWithKeyValueArguments'] {
  return isNodeType(node, 'FunctionWithKeyValueArguments');
}

/** Type guard for {@link import('./ast').PairNode | pair} nodes. */
export function isPair(node: ASTNode | undefined): node is ASTNodeTypeMap['pair'] {
  return isNodeType(node, 'pair');
}

/** Type guard for {@link import('./ast').CreateFunctionQueryNode | CreateFunctionQuery} nodes. */
export function isCreateFunctionQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['CreateFunctionQuery'] {
  return isNodeType(node, 'CreateFunctionQuery');
}

/** Type guard for {@link import('./ast').CreateIndexQueryNode | CreateIndexQuery} nodes. */
export function isCreateIndexQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['CreateIndexQuery'] {
  return isNodeType(node, 'CreateIndexQuery');
}

/** Type guard for {@link import('./ast').AlterCommandNode | AlterCommand} nodes. */
export function isAlterCommandNode(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['AlterCommand'] {
  return isNodeType(node, 'AlterCommand');
}

/** Type guard for {@link import('./ast').ShowFamilyQueryNode | ShowFamilyQueryNode} nodes. */
export function isShowQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['SHOW'] {
  return (
    isNodeType(node, 'SHOW') ||
    isNodeType(node, 'ShowTables') ||
    isNodeType(node, 'ShowColumns') ||
    isNodeType(node, 'ShowIndexes') ||
    isNodeType(node, 'ShowFunctions') ||
    isNodeType(node, 'ShowSetting') ||
    isNodeType(node, 'ShowEngineQuery') ||
    isNodeType(node, 'ShowAccessQuery') ||
    isNodeType(node, 'ShowAccessEntitiesQuery') ||
    isNodeType(node, 'ShowProcesslistQuery') ||
    isNodeType(node, 'ShowGrantsQuery') ||
    isNodeType(node, 'ShowPrivilegesQuery') ||
    isNodeType(node, 'ShowCreateNamedCollectionQuery') ||
    isNodeType(node, 'ShowCreateAccessEntityQuery')
  );
}

/** Type guard for {@link import('./ast').AccessDropQueryNode | AccessDropQueryNode} nodes. */
export function isAccessDropQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DropNamedCollectionQuery'] {
  return (
    isNodeType(node, 'DropNamedCollectionQuery') ||
    isNodeType(node, 'DropWorkloadQuery') ||
    isNodeType(node, 'DropResourceQuery') ||
    isNodeType(node, 'DropAccessEntityQuery')
  );
}

/** Type guard for {@link import('./ast').AccessQueryNode | AccessQueryNode} nodes. */
export function isAccessQuery(node: ASTNode | undefined): node is AccessQueryNode {
  return (
    isNodeType(node, 'CreateUserQuery') ||
    isNodeType(node, 'CreateRoleQuery') ||
    isNodeType(node, 'CreateQuotaQuery') ||
    isNodeType(node, 'CreateSettingsProfileQuery') ||
    isNodeType(node, 'CreateNamedCollectionQuery') ||
    isNodeType(node, 'CreateWorkloadQuery') ||
    isNodeType(node, 'CreateResourceQuery') ||
    isNodeType(node, 'CreateRowPolicyQuery') ||
    isNodeType(node, 'GrantQuery') ||
    isNodeType(node, 'RevokeQuery') ||
    isNodeType(node, 'SetRoleQuery')
  );
}

/** Type guard for {@link import('./ast').BackupQueryNode | BackupQueryNode} nodes. */
export function isBackupQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['BackupQuery'] {
  return isNodeType(node, 'BackupQuery') || isNodeType(node, 'RestoreQuery');
}

/** Type guard for {@link import('./ast').ParallelWithQueryNode | ParallelWithQuery} nodes. */
export function isParallelWithQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ParallelWithQuery'] {
  return isNodeType(node, 'ParallelWithQuery');
}

/** Type guard for {@link import('./ast').DropIndexQueryNode | DropIndexQuery} nodes. */
export function isDropIndexQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DropIndexQuery'] {
  return isNodeType(node, 'DropIndexQuery');
}

/** Type guard for {@link import('./ast').PartitionNode | Partition} nodes. */
export function isPartition(node: ASTNode | undefined): node is ASTNodeTypeMap['Partition'] {
  return isNodeType(node, 'Partition');
}

/** Type guard for {@link import('./ast').PartitionIdNode | Partition_ID} nodes. */
export function isPartitionId(node: ASTNode | undefined): node is ASTNodeTypeMap['Partition_ID'] {
  return isNodeType(node, 'Partition_ID');
}

/** Type guard for {@link import('./ast').AssignmentNode | Assignment} nodes. */
export function isAssignment(node: ASTNode | undefined): node is ASTNodeTypeMap['Assignment'] {
  return isNodeType(node, 'Assignment');
}

/** Type guard for {@link import('./ast').UserNameWithHostNode | UserNameWithHost} nodes. */
export function isUserNameWithHost(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['UserNameWithHost'] {
  return isNodeType(node, 'UserNameWithHost');
}

/** Type guard for {@link import('./ast').UserNamesWithHostNode | UserNamesWithHost} nodes. */
export function isUserNamesWithHost(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['UserNamesWithHost'] {
  return isNodeType(node, 'UserNamesWithHost');
}

/** Type guard for {@link import('./ast').RolesOrUsersSetNode | RolesOrUsersSet} nodes. */
export function isRolesOrUsersSet(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['RolesOrUsersSet'] {
  return isNodeType(node, 'RolesOrUsersSet');
}

/** Type guard for {@link import('./ast').RowPolicyNamesNode | RowPolicyNames} nodes. */
export function isRowPolicyNames(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['RowPolicyNames'] {
  return isNodeType(node, 'RowPolicyNames');
}

/** Type guard for {@link import('./ast').DatabaseOrNoneNode | DatabaseOrNone} nodes. */
export function isDatabaseOrNone(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DatabaseOrNone'] {
  return isNodeType(node, 'DatabaseOrNone');
}

/** Type guard for {@link import('./ast').SettingsProfileElementNode | SettingsProfileElement} nodes. */
export function isSettingsProfileElement(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['SettingsProfileElement'] {
  return isNodeType(node, 'SettingsProfileElement');
}

/** Type guard for {@link import('./ast').SettingsProfileElementsNode | SettingsProfileElements} nodes. */
export function isSettingsProfileElements(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['SettingsProfileElements'] {
  return isNodeType(node, 'SettingsProfileElements');
}

/** Type guard for {@link import('./ast').AlterSettingsProfileElementsNode | AlterSettingsProfileElements} nodes. */
export function isAlterSettingsProfileElements(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['AlterSettingsProfileElements'] {
  return isNodeType(node, 'AlterSettingsProfileElements');
}

/** Type guard for {@link import('./ast').ExecuteAsQueryNode | ExecuteAsQuery} nodes. */
export function isExecuteAsQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ExecuteAsQuery'] {
  return isNodeType(node, 'ExecuteAsQuery');
}

/** Type guard for {@link import('./ast').OptimizeQueryNode | OptimizeQuery} nodes. */
export function isOptimizeQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['OptimizeQuery'] {
  return isNodeType(node, 'OptimizeQuery');
}

/** Type guard for {@link import('./ast').DescribeQueryNode | DescribeQuery} nodes. */
export function isDescribeQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['DescribeQuery'] {
  return isNodeType(node, 'DescribeQuery');
}

/** Type guard for {@link import('./ast').ShowCreateQueryNode | ShowCreateQueryNode} nodes. */
export function isShowCreateQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ShowCreateTableQuery'] {
  return (
    isNodeType(node, 'ShowCreateTableQuery') ||
    isNodeType(node, 'ShowCreateViewQuery') ||
    isNodeType(node, 'ShowCreateDictionaryQuery') ||
    isNodeType(node, 'ShowCreateDatabaseQuery')
  );
}

/** Type guard for {@link import('./ast').ExistsQueryNode | ExistsQueryNode} nodes. */
export function isExistsQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['ExistsTableQuery'] {
  return (
    isNodeType(node, 'ExistsTableQuery') ||
    isNodeType(node, 'ExistsViewQuery') ||
    isNodeType(node, 'ExistsDictionaryQuery') ||
    isNodeType(node, 'ExistsDatabaseQuery')
  );
}

/** Type guard for {@link import('./ast').CheckQueryNode | CheckQueryNode} nodes. */
export function isCheckQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['CheckQuery'] {
  return isNodeType(node, 'CheckQuery') || isNodeType(node, 'CheckAllQuery');
}

/** Type guard for {@link import('./ast').AttachQueryNode | AttachQuery} nodes. */
export function isAttachQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['AttachQuery'] {
  return isNodeType(node, 'AttachQuery');
}

/** Type guard for {@link import('./ast').RenameNode | Rename} nodes. */
export function isRename(node: ASTNode | undefined): node is ASTNodeTypeMap['Rename'] {
  return isNodeType(node, 'Rename');
}

/** Type guard for {@link import('./ast').KillQueryQueryNode | KillQueryQuery} nodes. */
export function isKillQueryQuery(
  node: ASTNode | undefined,
): node is ASTNodeTypeMap['KillQueryQuery'] {
  return isNodeType(node, 'KillQueryQuery');
}

/** Type guard for {@link import('./ast').DeleteQueryNode | DeleteQuery} nodes. */
export function isDeleteQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['DeleteQuery'] {
  return isNodeType(node, 'DeleteQuery');
}

/** Type guard for {@link import('./ast').UpdateQueryNode | UpdateQuery} nodes. */
export function isUpdateQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['UpdateQuery'] {
  return isNodeType(node, 'UpdateQuery');
}

/** Type guard for {@link import('./ast').EmptyQueryNode | EmptyQuery} nodes. */
export function isEmptyQuery(node: ASTNode | undefined): node is ASTNodeTypeMap['EmptyQuery'] {
  return isNodeType(node, 'EmptyQuery');
}
