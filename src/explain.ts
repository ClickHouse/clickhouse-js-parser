import {
  ArrayJoinNode,
  SampleRatioNode,
  ExpressionListNode,
  TableIdentifierNode,
  RefreshStrategyNode,
  ASTNode,
  QueryParameterNode,
  DropQueryNode,
  InsertQueryNode,
  UseQueryNode,
  ExplainQueryNode,
  ExecuteAsQueryNode,
  OptimizeQueryNode,
  DescribeQueryNode,
  CheckQueryNode,
  AttachQueryNode,
  RenameNode,
  KillQueryQueryNode,
  DeleteQueryNode,
  UpdateQueryNode,
  AssignmentNode,
  UserNameWithHostNode,
  DetachQueryNode,
  TruncateQueryNode,
  UndropQueryNode,
  SelectQueryNode,
  SelectWithUnionQueryNode,
  SelectIntersectExceptQueryNode,
  TableExpressionNode,
  TableJoinNode,
  TablesInSelectQueryNode,
  WithItem,
  ColumnsTransformerListNode,
  IdentifierPart,
  LiteralNode,
  LiteralElement,
  IdentifierNode,
  PartitionNode,
  PartitionIdNode,
  AccessQueryNode,
  FunctionNode,
  OrderByElementNode,
  CreateQueryNode,
  CreateFunctionQueryNode,
  CreateIndexQueryNode,
  AlterQueryNode,
  AlterCommandNode,
  SystemQueryNode,
  ShowFamilyQueryNode,
  BackupQueryNode,
  ParallelWithQueryNode,
  DropIndexQueryNode,
  Expression,
  Statement,
  WithoutLocations,
  StatementsSchema,
  StorageNode,
  WindowDefinitionNode,
  ColumnsNode,
  ColumnDeclarationNode,
  ProjectionNode,
  TTLElementNode,
  DictionaryAttributeDeclarationNode,
} from './ast';

type CreateLikeNode = CreateQueryNode & {
  attach?: boolean;
};

type ExplainNode = { label: string; children: ExplainNode[] };

function n(label: string, children: ExplainNode[] = []): ExplainNode {
  return { label, children };
}

// Canonical string rendering for an Identifier (plain name or query-param).
function id(x: IdentifierPart): string {
  return typeof x === 'string' ? x : `{${x.name}:${x.param_type}}`;
}

// `Identifier <name>` leaf — the ubiquitous EXPLAIN child for a bare name.
function identifier(name: string): ExplainNode {
  return n(`Identifier ${name}`);
}

// `ExpressionList` wrapping the explain projection of each expression. An empty
// input yields a childless `ExpressionList`, matching ClickHouse.
function exprList(exprs: Expression[]): ExplainNode {
  return n('ExpressionList', exprs.map(exprNode));
}

// `Function <name>` with its argument `ExpressionList` child (empty when there
// are no arguments) — ClickHouse always emits the list for parenthesized forms.
function functionNode(name: string, args: Expression[]): ExplainNode {
  return n(`Function ${name}`, [exprList(args)]);
}

// Childless `Set` node — every SETTINGS clause collapses to this in EXPLAIN
// output. Shared since it is immutable and render() only reads it.
const SET: ExplainNode = { label: 'Set', children: [] };

function render(node: ExplainNode, depth = 0): string {
  const indent = ' '.repeat(depth);
  const suffix = node.children.length > 0 ? ` (children ${node.children.length})` : '';
  const lines = [indent + node.label + suffix];
  for (const child of node.children) {
    lines.push(render(child, depth + 1));
  }
  return lines.join('\n');
}

function normalizeFloat(value: string): string {
  // Handle special ClickHouse float literals that parseFloat doesn't understand
  if (value === 'inf' || value === '-inf') return value;
  if (value === 'nan' || value === '-nan') return 'nan';
  const f = parseFloat(value);
  // Preserve negative zero
  if (f === 0 && 1 / f === -Infinity) return '-0';
  // Remove the '+' from exponent (e.g. e+307 → e307) to match ClickHouse output
  return f.toString().replace('e+', 'e');
}

function transformerListNode(
  list: ColumnsTransformerListNode | ColumnsTransformerListNode['children'],
): ExplainNode {
  // Accept either the `ColumnsTransformerList` node (qualified matchers) or
  // a flat transformer array (plain matchers / asterisks). The explain output
  // always wraps them in a synthetic `ColumnsTransformerList` node.
  const items = Array.isArray(list) ? list : list.children;
  return n(
    'ColumnsTransformerList',
    items.map((t) => {
      if (t.type === 'ColumnsApplyTransformer') return n('ColumnsApplyTransformer');
      if (t.type === 'ColumnsExceptTransformer') {
        // String-pattern EXCEPT has no children; column-list EXCEPT has Identifier children
        if (t.pattern !== undefined) return n('ColumnsExceptTransformer');
        return n('ColumnsExceptTransformer', (t.columns ?? []).map(exprNode));
      }
      // replace
      return n(
        'ColumnsReplaceTransformer',
        t.replacements.map((item) =>
          n('ColumnsReplaceTransformer::Replacement', [exprNode(item.expression)]),
        ),
      );
    }),
  );
}

// Escape a decoded string value for ClickHouse's quoted explain-label form.
// \a (0x07), \v (0x0B), and \e (0x1B) control characters pass through raw,
// matching ClickHouse EXPLAIN output.
function escapeStringValue(value: string): string {
  return (
    value
      .replace(/\\/g, '\\\\') // backslash → \\
      .replace(/'/g, "\\'") // escape single quotes: ' → \'
      // eslint-disable-next-line no-control-regex
      .replace(/\x08/g, '\\b') // actual backspace → \b
      .replace(/\t/g, '\\t') // actual tab char → \t
      .replace(/\n/g, '\\n') // actual newline → \n
      .replace(/\r/g, '\\r') // actual carriage return → \r
      .replace(/\f/g, '\\f') // actual form feed → \f
      .replace(/\0/g, '\\0')
  ); // actual null byte → \0
}

// Type-prefixed dump of a literal (or an Array_/Tuple_ element) for explain
// labels, e.g. `UInt64_1`, `Array_[UInt64_1, 'a']`. Mirrors ClickHouse's
// Literal::appendColumnName. `nonfinite` re-spells `inf`/`-0`, which the native
// JSON `value` collapses to `null`/`0`.
function literalDump(lit: LiteralElement): string {
  switch (lit.value_type) {
    case 'String':
      return `'${escapeStringValue(String(lit.value))}'`;
    case 'Null':
      return 'NULL';
    case 'Bool':
      return `Bool_${lit.value ? '1' : '0'}`;
    case 'Float64': {
      const spelled =
        lit.value === null
          ? (lit.nonfinite ?? 'nan')
          : lit.nonfinite === '-0'
            ? '-0'
            : String(lit.value);
      return `Float64_${normalizeFloat(spelled)}`;
    }
    case 'Int64':
      return `Int64_${String(lit.value)}`;
    case 'UInt64':
      // `value` is already the canonical decimal-digit string.
      return `UInt64_${String(lit.value)}`;
    case 'Array':
      return `Array_[${(Array.isArray(lit.value) ? lit.value : []).map(literalDump).join(', ')}]`;
    case 'Tuple':
      return `Tuple_(${(Array.isArray(lit.value) ? lit.value : []).map(literalDump).join(', ')})`;
    default:
      return String(lit.value);
  }
}

function literalLabel(expr: LiteralNode): string {
  return `Literal ${literalDump(expr)}`;
}

// Alias suffix for a node label: ` (alias x)` when an inline alias is present.
function aliasSuffix(expr: { alias?: string }): string {
  return expr.alias !== undefined ? ` (alias ${expr.alias})` : '';
}

// Build WindowDefinition node from a WindowDefinitionNode.
// Children: optional ExpressionList(PARTITION BY), optional ExpressionList(ORDER BY with OrderByElements),
// then frame bound offset expressions (only for Offset bounds).
function windowDefinitionNode(spec: WindowDefinitionNode): ExplainNode {
  const children: ExplainNode[] = [];
  if (spec.partition_by && spec.partition_by.length > 0) {
    children.push(exprList(spec.partition_by));
  }
  if (spec.order_by && spec.order_by.length > 0) {
    children.push(n('ExpressionList', spec.order_by.map(orderByNode)));
  }
  if (spec.frame_begin?.type === 'Offset') {
    children.push(exprNode(spec.frame_begin.offset));
  }
  if (spec.frame_end?.type === 'Offset') {
    children.push(exprNode(spec.frame_end.offset));
  }
  return n('WindowDefinition', children);
}

function exprNode(expr: Expression): ExplainNode {
  switch (expr.type) {
    case 'Literal':
      return n(literalLabel(expr) + aliasSuffix(expr));
    case 'Identifier':
      return n(`Identifier ${expr.name}` + aliasSuffix(expr));
    case 'Asterisk': {
      // (Includes tuple expansion `expr.*` — the base expression is not rendered.)
      if (expr.transformers !== undefined) {
        return n('Asterisk', [transformerListNode(expr.transformers)]);
      }
      return n('Asterisk');
    }
    case 'QualifiedAsterisk': {
      const qChildren: ExplainNode[] = [exprNode(expr.qualifier)];
      if (expr.transformers !== undefined) {
        qChildren.push(transformerListNode(expr.transformers));
      }
      return n('QualifiedAsterisk', qChildren);
    }
    case 'QueryParameter':
      return n(`QueryParameter ${expr.name}:${expr.param_type}` + aliasSuffix(expr));
    case 'Subquery':
      return n('Subquery' + aliasSuffix(expr), [stmtNode(expr.query)]);
    case 'ColumnsRegexpMatcher': {
      const tList = expr.transformers !== undefined ? [transformerListNode(expr.transformers)] : [];
      return n('ColumnsRegexpMatcher', tList);
    }
    case 'ColumnsListMatcher': {
      const tList = expr.transformers !== undefined ? [transformerListNode(expr.transformers)] : [];
      return n('ColumnsListMatcher', [exprList(expr.columns), ...tList]);
    }
    case 'QualifiedColumnsRegexpMatcher': {
      const children: ExplainNode[] = [exprNode(expr.qualifier)];
      if (expr.transformers !== undefined) children.push(transformerListNode(expr.transformers));
      return n('QualifiedColumnsRegexpMatcher', children);
    }
    case 'QualifiedColumnsListMatcher': {
      const children: ExplainNode[] = [exprNode(expr.qualifier), exprList(expr.columns)];
      if (expr.transformers !== undefined) children.push(transformerListNode(expr.transformers));
      return n('QualifiedColumnsListMatcher', children);
    }
    case 'Settings':
    case 'DictionarySettings':
      return SET;
    case 'SelectWithUnionQuery':
      // Bare SELECT used in expression position (e.g. view(SELECT ...))
      return stmtNode(expr);
    case 'Function': {
      // view(subquery) / view(SELECT ...) render the inner query directly, with
      // no Subquery wrapper.
      const arg0 = expr.arguments[0];
      if (
        expr.name.toLowerCase() === 'view' &&
        expr.arguments.length === 1 &&
        (arg0.type === 'Subquery' || arg0.type === 'SelectWithUnionQuery')
      ) {
        const inner = arg0.type === 'Subquery' ? arg0.query : arg0;
        return n(`Function ${expr.name}` + aliasSuffix(expr), [
          n('ExpressionList', [stmtNode(inner)]),
        ]);
      }
      const funcChildren: ExplainNode[] = [exprList(expr.arguments)];
      if (expr.parameters) {
        funcChildren.push(exprList(expr.parameters));
      }
      // Window function: add WindowDefinition node for inline OVER (spec) clause
      if (expr.window_definition) {
        funcChildren.push(windowDefinitionNode(expr.window_definition));
      }
      return n(`Function ${expr.name}` + aliasSuffix(expr), funcChildren);
    }
  }
}

// Convert a SampleRatio to a SampleRatio label for EXPLAIN output.
// Integers ≥ 1 with denominator 1 use integer display (e.g. SampleRatio 100).
// All other values use fraction display (e.g. SampleRatio 1 / 10).
function sampleRatioLabel(sample: SampleRatioNode): string {
  if (sample.denominator !== '1') {
    return `SampleRatio ${sample.numerator} / ${sample.denominator}`;
  }
  return `SampleRatio ${sample.numerator}`;
}

// Project a TableExpression node into explain children.
function tableExpressionExplainNode(te: TableExpressionNode): ExplainNode {
  const children: ExplainNode[] = [];
  if (te.database_and_table_name !== undefined) {
    const ti = te.database_and_table_name;
    const qualified = ti.database !== undefined ? `${id(ti.database)}.${id(ti.name)}` : id(ti.name);
    const label =
      ti.alias !== undefined
        ? `TableIdentifier ${qualified} (alias ${ti.alias})`
        : `TableIdentifier ${qualified}`;
    children.push(n(label));
  } else if (te.table_function !== undefined) {
    children.push(exprNode(te.table_function));
  } else if (te.subquery !== undefined) {
    children.push(exprNode(te.subquery));
  }
  if (te.column_aliases !== undefined) {
    children.push(exprList((te.column_aliases.children ?? []) as Expression[]));
  }
  if (te.sample_size !== undefined) {
    children.push(n(sampleRatioLabel(te.sample_size)));
    if (te.sample_offset !== undefined) children.push(n(sampleRatioLabel(te.sample_offset)));
  }
  return n('TableExpression', children);
}

function tableJoinExplainNode(j: TableJoinNode): ExplainNode {
  if (j.on !== undefined) return n('TableJoin', [exprNode(j.on)]);
  if (j.using !== undefined) {
    return n('TableJoin', [exprList(j.using)]);
  }
  return n('TableJoin');
}

function arrayJoinExplainNode(aj: ArrayJoinNode): ExplainNode {
  return n('ArrayJoin', [exprList(aj.expressions)]);
}

// Project the FROM clause.
// When rendering the WITH subtree that ClickHouse propagated into a later
// UNION member (a trailing WITH copy), the parser emits each joined element's
// `TableJoin` child before its `TableExpression`. This module-level flag scopes
// that reversal to such subtrees (see selectQueryNode's trailing-WITH block).
let reverseTrailingJoins = false;

function tablesExplainNode(tables: TablesInSelectQueryNode): ExplainNode {
  return n(
    'TablesInSelectQuery',
    tables.children.map((el) => {
      if (el.array_join !== undefined) {
        return n('TablesInSelectQueryElement', [arrayJoinExplainNode(el.array_join)]);
      }
      const teNode = tableExpressionExplainNode(el.table_expression!);
      if (el.table_join !== undefined) {
        const joinNode = tableJoinExplainNode(el.table_join);
        return n(
          'TablesInSelectQueryElement',
          reverseTrailingJoins ? [joinNode, teNode] : [teNode, joinNode],
        );
      }
      return n('TablesInSelectQueryElement', [teNode]);
    }),
  );
}

function orderByNode(item: OrderByElementNode): ExplainNode {
  const children = [exprNode(item.expression)];
  if (item.collation !== undefined) {
    children.push(exprNode(item.collation));
  }
  if (item.fill_from !== undefined) children.push(exprNode(item.fill_from));
  if (item.fill_to !== undefined) children.push(exprNode(item.fill_to));
  if (item.fill_step !== undefined) children.push(exprNode(item.fill_step));
  if (item.fill_staleness !== undefined) children.push(exprNode(item.fill_staleness));
  return n('OrderByElement', children);
}

// Project a WITH item (named subquery or aliased expression).
function withItemNode(w: WithItem): ExplainNode {
  if (w.type === 'WithElement') {
    return n('WithElement', [n('Subquery', [stmtNode(w.subquery.query)])]);
  }
  return exprNode(w);
}

// Build the inner SelectQuery node for a single SELECT
function selectQueryNode(stmt: SelectQueryNode): ExplainNode {
  // Synthetic `op ANY/ALL (subquery)` lowering: ClickHouse emits the
  // projection + tables twice in this SelectQuery's child vector.
  if (stmt.agg_repeat === true && stmt.from !== undefined) {
    const projection = (): ExplainNode => exprList(stmt.select);
    const tables = (): ExplainNode => tablesExplainNode(stmt.from!);
    return n('SelectQuery', [projection(), tables(), projection(), tables()]);
  }

  const children: ExplainNode[] = [];

  // CTEs from WITH clause go before the select columns, except when the WITH
  // was written before an enclosing INSERT (`with_trailing`), in which case
  // ClickHouse appends the WITH ExpressionList after the select body.
  if (stmt.with && stmt.with.length > 0 && stmt.with_trailing !== true) {
    children.push(n('ExpressionList', stmt.with.map(withItemNode)));
  }

  children.push(exprList(stmt.select));

  if (stmt.from) children.push(tablesExplainNode(stmt.from));
  if (stmt.prewhere) children.push(exprNode(stmt.prewhere));
  if (stmt.where) children.push(exprNode(stmt.where));
  if (stmt.group_by) {
    if (stmt.group_by_with_grouping_sets) {
      children.push(
        n(
          'ExpressionList',
          stmt.group_by.map((set) =>
            exprList(((set as ExpressionListNode).children ?? []) as Expression[]),
          ),
        ),
      );
    } else {
      children.push(exprList(stmt.group_by as Expression[]));
    }
  }
  if (stmt.having) children.push(exprNode(stmt.having));
  // WINDOW clause comes before ORDER BY in ClickHouse's explain output
  if (stmt.window && stmt.window.length > 0) {
    children.push(
      n(
        'ExpressionList',
        stmt.window.map(() => n('WindowListElement')),
      ),
    );
  }
  if (stmt.qualify) children.push(exprNode(stmt.qualify));
  let settingsPushed = false;
  if (stmt.order_by && stmt.order_by.length > 0) {
    children.push(n('ExpressionList', stmt.order_by.map(orderByNode)));
  }
  // INTERPOLATE clause
  if (stmt.interpolate !== undefined) {
    // SETTINGS comes before INTERPOLATE in ClickHouse's explain output
    if (stmt.settings) {
      children.push(SET);
      settingsPushed = true;
    }
    const interpNodes = stmt.interpolate.map((it) => {
      return n(`InterpolateElement (column ${it.column})`, [exprNode(it.expr)]);
    });
    children.push(n('ExpressionList', interpNodes));
  }
  // LIMIT BY: optional offset, then count, then by-expressions.
  if (stmt.limit_by !== undefined) {
    if (stmt.limit_by.offset !== undefined) children.push(exprNode(stmt.limit_by.offset));
    children.push(exprNode(stmt.limit_by.length));
    children.push(exprList(stmt.limit_by.by));
  }
  if (stmt.limit !== undefined) {
    if (stmt.offset !== undefined) children.push(exprNode(stmt.offset));
    children.push(exprNode(stmt.limit));
  } else if (stmt.offset !== undefined) {
    children.push(exprNode(stmt.offset));
  }
  if (!settingsPushed && stmt.settings) {
    children.push(SET);
  }

  // A WITH written before an enclosing INSERT, or propagated into a later UNION
  // member, is emitted after the select body. Within this propagated copy
  // ClickHouse also flips each joined element's TableJoin/TableExpression order.
  if (stmt.with && stmt.with.length > 0 && stmt.with_trailing === true) {
    const prev = reverseTrailingJoins;
    reverseTrailingJoins = true;
    children.push(n('ExpressionList', stmt.with.map(withItemNode)));
    reverseTrailingJoins = prev;
  }

  // CTE column aliases: WITH t (a, b) AS (...) → ExpressionList with Identifiers
  if (stmt.with) {
    for (const w of stmt.with) {
      if (w.type === 'WithElement' && w.aliases !== undefined) {
        children.push(exprList((w.aliases.children ?? []) as Expression[]));
      }
    }
  }

  return n('SelectQuery', children);
}

// ════════════════════════════════════════════════════════════════════════════
// Native CREATE explain rendering — builds the EXPLAIN AST tree directly from
// ClickHouse's reference fields on `CreateQueryNode`.
// ════════════════════════════════════════════════════════════════════════════

/** Convert a native data-type node to its EXPLAIN node tree. */
function typeNodeToExplain(node: ASTNode): ExplainNode {
  const t = (node as { type: string }).type;
  if (t === 'EnumDataType') return n(`EnumDataType ${(node as { name: string }).name}`);
  if (t === 'TupleDataType') {
    const tp = node as { name: string; arguments?: ASTNode[] };
    return n(`TupleDataType ${tp.name}`, [
      n('ExpressionList', (tp.arguments ?? []).map(typeArgToExplain)),
    ]);
  }
  if (t === 'NameTypePair') {
    const np = node as { name: string; data_type: ASTNode };
    return n(`NameTypePair ${np.name}`, [typeNodeToExplain(np.data_type)]);
  }
  const dt = node as { name: string; arguments?: ASTNode[] };
  if (dt.arguments === undefined) return n(`DataType ${dt.name}`);
  return n(`DataType ${dt.name}`, [n('ExpressionList', dt.arguments.map(typeArgToExplain))]);
}

function typeArgToExplain(node: ASTNode): ExplainNode {
  const t = (node as { type: string }).type;
  if (t === 'DataType' || t === 'EnumDataType' || t === 'TupleDataType' || t === 'NameTypePair') {
    return typeNodeToExplain(node);
  }
  if (t === 'ObjectTypeArgument') return jsonArgToExplain(node);
  return exprNode(node as Expression);
}

function jsonArgToExplain(node: ASTNode): ExplainNode {
  const ota = node as {
    path_with_type?: { name?: string; data_type?: ASTNode };
    skip_path?: ASTNode;
    skip_path_regexp?: ASTNode;
    parameter?: ASTNode;
  };
  if (ota.path_with_type) {
    const otp = ota.path_with_type;
    return n('ASTObjectTypeArgument', [
      n(
        `ObjectTypedPath ${otp.name ?? ''}`,
        otp.data_type ? [typeNodeToExplain(otp.data_type)] : [],
      ),
    ]);
  }
  if (ota.skip_path) return n('ASTObjectTypeArgument', [exprNode(ota.skip_path as Expression)]);
  if (ota.skip_path_regexp)
    return n('ASTObjectTypeArgument', [exprNode(ota.skip_path_regexp as Expression)]);
  if (ota.parameter) return n('ASTObjectTypeArgument', [exprNode(ota.parameter as Expression)]);
  return n('ASTObjectTypeArgument');
}

/** Native `CODEC(...)` / `STATISTICS(...)` function node → explain. */
function codecExplainNative(fnNode: FunctionNode): ExplainNode {
  const children = (fnNode.arguments as FunctionNode[]).map((c) =>
    c.no_parens === true ? n(`Function ${c.name}`) : functionNode(c.name, c.arguments),
  );
  return n(`Function ${fnNode.name}`, [n('ExpressionList', children)]);
}

/** Native index `TYPE name(args)` function node → explain (always ExpressionList). */
function indexTypeExplainNative(it: FunctionNode): ExplainNode {
  return functionNode(it.name, it.arguments);
}

/** Native ColumnDeclaration → explain node. */
function columnDeclExplainNative(col: ColumnDeclarationNode): ExplainNode {
  const children: ExplainNode[] = [];
  if (col.data_type) children.push(typeNodeToExplain(col.data_type));
  if (col.collation) children.push(n('Collation'));
  if (col.ephemeral_default) {
    children.push(n('Function defaultValueOfTypeName'));
  } else if (col.default_expression) {
    children.push(exprNode(col.default_expression));
  }
  if (col.codec) children.push(codecExplainNative(col.codec));
  if (col.settings) children.push(SET);
  if (col.statistics) children.push(codecExplainNative(col.statistics));
  if (col.ttl) children.push(exprNode(col.ttl));
  if (col.comment) children.push(exprNode(col.comment));
  return n(`ColumnDeclaration ${col.name}`, children);
}

/** Native Projection → explain node. */
function projectionExplainNative(proj: ProjectionNode): ExplainNode {
  if (proj.index !== undefined) {
    const piChildren: ExplainNode[] = [exprNode(proj.index)];
    if (proj.index_type !== undefined) piChildren.push(indexTypeExplainNative(proj.index_type));
    return n('Projection', piChildren);
  }
  const q = proj.query;
  const pqChildren: ExplainNode[] = [];
  if (q) {
    if (q.with && q.with.length > 0) {
      pqChildren.push(exprList(q.with));
    }
    if (q.select) pqChildren.push(exprList(q.select));
    if (q.group_by && q.group_by.length > 0) {
      pqChildren.push(exprList(q.group_by));
    }
    if (q.order_by && q.order_by.length > 0) {
      // Projection ORDER BY: a single key is a bare expression; multiple keys
      // collapse into `Function tuple(ExpressionList)`.
      if (q.order_by.length === 1) {
        pqChildren.push(exprNode(q.order_by[0]));
      } else {
        pqChildren.push(functionNode('tuple', q.order_by));
      }
    }
  }
  const projChildren: ExplainNode[] = [n('ProjectionSelectQuery', pqChildren)];
  if (proj.settings !== undefined) projChildren.push(SET);
  return n('Projection', projChildren);
}

/** Native engine `Function` node → explain (no-parens engines omit ExpressionList). */
function engineExplainNative(engine: FunctionNode): ExplainNode {
  if (engine.no_parens === true) return n(`Function ${engine.name}`);
  return functionNode(engine.name, engine.arguments);
}

/**
 * Push the storage ORDER BY explain child(ren) for a native Storage node,
 * derived from the canonical `order_by` Expression child (see
 * docs/underscore-fields.md). The explain children mirror the native shape:
 * a `tuple` carrying `StorageOrderByElement` items collapses to a childless
 * `Function tuple`, an operator-paren multi-key list keeps its `ExpressionList`,
 * a single DESC key is a `StorageOrderByElement`, and any other key (bare or a
 * single tuple-valued key) serializes via `exprNode`.
 */
function pushStorageOrderBy(children: ExplainNode[], storage: StorageNode): void {
  const structural = storage.order_by;
  if (structural === undefined) return;
  if (structural.type === 'StorageOrderByElement') {
    children.push(n('StorageOrderByElement', [exprNode(structural.expression)]));
    return;
  }
  if (structural.type === 'Function' && structural.name === 'tuple') {
    const args = structural.arguments;
    const hasSobe = args.some((a) => (a as { type?: string }).type === 'StorageOrderByElement');
    if (hasSobe) {
      children.push(n('Function tuple'));
    } else if (structural.is_operator === true) {
      children.push(n('Function tuple', [exprList(args)]));
    } else {
      children.push(exprNode(structural));
    }
    return;
  }
  children.push(exprNode(structural));
}

/** Native Storage node → `Storage definition` explain node (or null when empty). */
function storageExplainNative(storage: StorageNode, columnsHavePk: boolean): ExplainNode | null {
  const children: ExplainNode[] = [];
  if (storage.engine) children.push(engineExplainNative(storage.engine));
  const settingsAfterOb = storage.settings_after_order_by === true;
  if (storage.settings && !settingsAfterOb) children.push(SET);
  if (storage.partition_by !== undefined) children.push(exprNode(storage.partition_by));
  // In ClickHouse's storage AST the PRIMARY KEY child is placed after ORDER BY
  // only when it comes from the column list (schema-level or column-level PK);
  // a standalone storage `PRIMARY KEY` clause is always emitted before ORDER BY
  // regardless of its source position.
  const pkAfterOb = columnsHavePk;
  if (storage.primary_key !== undefined && !pkAfterOb) children.push(exprNode(storage.primary_key));
  pushStorageOrderBy(children, storage);
  if (storage.primary_key !== undefined && pkAfterOb) children.push(exprNode(storage.primary_key));
  if (storage.sample_by !== undefined) children.push(exprNode(storage.sample_by));
  if (storage.ttl_table !== undefined) {
    const items = storage.ttl_table.children as TTLElementNode[];
    children.push(n('ExpressionList', items.map(nativeTTLElementExplain)));
  }
  if (storage.settings && settingsAfterOb) children.push(SET);
  if (children.length === 0) return null;
  return n('Storage definition', children);
}

/** True when the column list owns the primary key. */
function columnsOwnPk(node: CreateLikeNode): boolean {
  const cl = node.columns_list as
    | (ColumnsNode & { primary_key_from_columns?: Expression })
    | undefined;
  return !!cl && (cl.primary_key !== undefined || cl.primary_key_from_columns !== undefined);
}

/** Native `Columns` block → `Columns definition` explain node (or null when empty). */
function columnsDefExplainNative(cols: ColumnsNode): ExplainNode | null {
  const cl = cols as ColumnsNode & { primary_key_from_columns?: Expression };
  const colsDefChildren: ExplainNode[] = [];
  if (cols.columns && cols.columns.length > 0) {
    colsDefChildren.push(n('ExpressionList', cols.columns.map(columnDeclExplainNative)));
  }
  if (cols.constraints && cols.constraints.length > 0) {
    colsDefChildren.push(
      n(
        'ExpressionList',
        cols.constraints.map((c) => n('Constraint', [exprNode(c.expression)])),
      ),
    );
  }
  if (cols.indices && cols.indices.length > 0) {
    colsDefChildren.push(
      n(
        'ExpressionList',
        cols.indices.map((idx) =>
          n('Index', [exprNode(idx.expression!), indexTypeExplainNative(idx.index_type!)]),
        ),
      ),
    );
  }
  if (cols.projections && cols.projections.length > 0) {
    colsDefChildren.push(n('ExpressionList', cols.projections.map(projectionExplainNative)));
  }
  // Schema/column PRIMARY KEY as a direct child of `Columns definition`.
  if (cl.primary_key_from_columns !== undefined) {
    colsDefChildren.push(exprNode(cl.primary_key_from_columns));
  } else if (cols.primary_key !== undefined) {
    colsDefChildren.push(exprNode(cols.primary_key));
  }
  if (colsDefChildren.length === 0) return null;
  return n('Columns definition', colsDefChildren);
}

/** Render `[db] table` identifier children + label suffix for a CREATE node. */
function createLabelAndIdents(
  node: CreateLikeNode,
  base: string,
): { label: string; idents: ExplainNode[] } {
  const idents: ExplainNode[] = [];
  let label = node.attach ? 'AttachQuery' : base;
  if (node.database !== undefined) {
    idents.push(identifier(id(node.database.name)));
  }
  if (node.table !== undefined) {
    idents.push(identifier(id(node.table.name)));
  }
  const dbPart = node.database !== undefined ? ` ${id(node.database.name)}` : '';
  const tblPart = node.table !== undefined ? ` ${id(node.table.name)}` : '';
  label += dbPart + tblPart;
  return { label, idents };
}

/** True when an AttachQuery carries a full CREATE schema (vs bare ATTACH). */
function isSchemaFormAttachExplain(node: AttachQueryNode): boolean {
  const nn = node as unknown as CreateLikeNode;
  return (
    nn.columns_list !== undefined ||
    nn.storage !== undefined ||
    nn.select !== undefined ||
    nn.as_table !== undefined ||
    nn.as_table_function !== undefined ||
    nn.dictionary !== undefined ||
    nn.dictionary_attributes !== undefined ||
    nn.targets !== undefined ||
    nn.aliases !== undefined ||
    nn.comment !== undefined ||
    nn.is_materialized_view === true ||
    nn.is_ordinary_view === true ||
    nn.attach_as_replicated !== undefined ||
    nn.attach_from_path !== undefined
  );
}

/** Main entry: native CreateQuery / schema-form AttachQuery → explain node. */
function createQueryExplainNode(node: CreateLikeNode): ExplainNode {
  if (node.is_dictionary) return createDictionaryExplainNative(node);
  if (node.is_materialized_view) return createMaterializedViewExplainNative(node);
  if (node.is_ordinary_view) return createViewExplainNative(node);
  if (node.table === undefined && node.database !== undefined) {
    return createDatabaseExplainNative(node);
  }
  return createTableExplainNative(node);
}

function createTableExplainNative(node: CreateLikeNode): ExplainNode {
  const { label, idents } = createLabelAndIdents(node, 'CreateQuery');
  const children: ExplainNode[] = [...idents];
  if (node.columns_list !== undefined) {
    const cd = columnsDefExplainNative(node.columns_list);
    if (cd) children.push(cd);
  }
  if (node.storage !== undefined) {
    const sd = storageExplainNative(node.storage, columnsOwnPk(node));
    if (sd) children.push(sd);
  }
  if (node.select !== undefined) children.push(stmtNode(node.select));
  if (node.as_table_function !== undefined) {
    children.push(functionNode(node.as_table_function.name, node.as_table_function.arguments));
  }
  if (node.comment !== undefined) children.push(exprNode(node.comment));
  if (node.settings !== undefined) children.push(SET);
  if (node.format !== undefined) children.push(identifier(node.format));
  return n(label, children);
}

function createDatabaseExplainNative(node: CreateLikeNode): ExplainNode {
  const children: ExplainNode[] = [identifier(id(node.database!.name))];
  if (node.storage !== undefined) {
    const sd = storageExplainNative(node.storage, false);
    if (sd) children.push(sd);
  }
  // Query-level `CREATE DATABASE ... SETTINGS` (no storage node): a bare `Set`.
  if (node.settings !== undefined) children.push(SET);
  // A trailing FORMAT clause becomes an `Identifier <format>` child.
  if (node.format !== undefined) children.push(identifier(node.format));
  // Note: trailing space after dbname (ClickHouse quirk).
  return n(`CreateQuery ${id(node.database!.name)} `, children);
}

function createViewExplainNative(node: CreateLikeNode): ExplainNode {
  const { label, idents } = createLabelAndIdents(node, 'CreateQuery');
  const children: ExplainNode[] = [...idents];
  if (node.aliases !== undefined && node.aliases.length > 0) {
    children.push(
      n(
        'ExpressionList',
        node.aliases.map((a) => identifier(id(a.name))),
      ),
    );
  } else if (node.columns_list !== undefined) {
    const cd = columnsDefExplainNative(node.columns_list);
    if (cd) children.push(cd);
  }
  if (node.select !== undefined) children.push(stmtNode(node.select));
  return n(label, children);
}

// `Refresh strategy definition` explain node: one child per present clause —
// TimeInterval (period/offset/spread), ExpressionList (DEPENDS ON), Set
// (SETTINGS). APPEND / schedule_kind add no child.
function refreshStrategyExplainNode(r: RefreshStrategyNode): ExplainNode {
  const rc: ExplainNode[] = [];
  if (r.period !== undefined) rc.push(n('TimeInterval'));
  if (r.offset !== undefined) rc.push(n('TimeInterval'));
  if (r.spread !== undefined) rc.push(n('TimeInterval'));
  if (r.dependencies !== undefined) {
    rc.push(n('ExpressionList', (r.dependencies.children ?? []).map(statementChildNode)));
  }
  if (r.settings !== undefined) rc.push(SET);
  return n('Refresh strategy definition', rc);
}

function createMaterializedViewExplainNative(node: CreateLikeNode): ExplainNode {
  const { label, idents } = createLabelAndIdents(node, 'CreateQuery');
  const children: ExplainNode[] = [...idents];
  if (node.columns_list !== undefined) {
    const cd = columnsDefExplainNative(node.columns_list);
    if (cd) children.push(cd);
  }
  if (node.refresh !== undefined) {
    children.push(refreshStrategyExplainNode(node.refresh as RefreshStrategyNode));
  }
  if (node.select !== undefined) children.push(stmtNode(node.select));
  // ViewTargets (TO target / inner engine).
  const targets = node.targets?.targets;
  if (targets !== undefined && targets.length > 0) {
    const innerTarget = targets.find((t) => t.inner_engine !== undefined);
    if (innerTarget?.inner_engine !== undefined) {
      const sd = storageExplainNative(innerTarget.inner_engine, false);
      children.push(n('ViewTargets', sd ? [sd] : []));
    } else {
      children.push(n('ViewTargets'));
    }
  }
  if (node.format !== undefined) children.push(identifier(node.format));
  return n(label, children);
}

function dictAttrExplainNative(attr: DictionaryAttributeDeclarationNode): ExplainNode {
  const attrChildren: ExplainNode[] = [typeNodeToExplain(attr.data_type as ASTNode)];
  if (attr.default_value) attrChildren.push(exprNode(attr.default_value));
  if (attr.expression) attrChildren.push(exprNode(attr.expression));
  return n(`DictionaryAttributeDeclaration ${attr.name}`, attrChildren);
}

function createDictionaryExplainNative(node: CreateLikeNode): ExplainNode {
  const { label, idents } = createLabelAndIdents(node, 'CreateQuery');
  const children: ExplainNode[] = [...idents];
  if (node.dictionary_attributes && node.dictionary_attributes.length > 0) {
    children.push(n('ExpressionList', node.dictionary_attributes.map(dictAttrExplainNative)));
  }
  const dict = node.dictionary;
  if (dict !== undefined) {
    const defChildren: ExplainNode[] = [];
    if (dict.primary_key !== undefined) {
      defChildren.push(exprList(dict.primary_key));
    }
    if (dict.source !== undefined) {
      const pairNodes = dict.source.elements.map((p) => {
        if ((p.value as { type?: string }).type === 'ExpressionList') {
          const structPairs = ((p.value as { children?: ASTNode[] }).children ?? []).map((sp) => {
            const v = (sp as { value: ASTNode }).value;
            return n('pair', [exprNode(v as Expression)]);
          });
          return n('pair', [n('ExpressionList', structPairs)]);
        }
        return n('pair', [exprNode(p.value as Expression)]);
      });
      // Double space before source name (ClickHouse quirk).
      defChildren.push(
        n(`FunctionWithKeyValueArguments  ${dict.source.name}`, [n('ExpressionList', pairNodes)]),
      );
    }
    if (dict.lifetime !== undefined) defChildren.push(n('Dictionary lifetime'));
    if (dict.layout !== undefined) {
      const layoutPairs = (dict.layout.parameters ?? []).map((p) =>
        n('pair', [exprNode(p.value as Expression)]),
      );
      defChildren.push(n('Dictionary layout', [n('ExpressionList', layoutPairs)]));
    }
    if (dict.range !== undefined) defChildren.push(n('Dictionary range'));
    if (dict.settings !== undefined) defChildren.push(n('Dictionary settings'));
    children.push(n('Dictionary definition', defChildren));
  }
  if (node.comment !== undefined) children.push(exprNode(node.comment));
  return n(label, children);
}

// Build CreateIndexQuery explain node
// Format: CreateIndexQuery <database> tablename (children 3-4)
//   Identifier indexName
//   Index (children 1-2)
//     expr
//     [Function typeName ...]
//   [Identifier database]
//   Identifier tableName
// The label carries the database in a fixed slot; when the table is
// unqualified the slot is empty, leaving the historical double space.
function createIndexQueryNode(stmt: CreateIndexQueryNode): ExplainNode {
  const label = `CreateIndexQuery ${stmt.database ? id(stmt.database.name) : ''} ${id(stmt.table.name)}`;

  const children: ExplainNode[] = [];
  children.push(identifier(stmt.index_name.name));

  const decl = stmt.index_declaration;
  const indexChildren: ExplainNode[] = [];
  const indexExpr = decl.expression;
  if (indexExpr !== undefined) {
    // For multi-column indexes, ClickHouse EXPLAIN shows Function tuple with empty ExpressionList
    if (indexExpr.type === 'Function' && indexExpr.name === 'tuple') {
      indexChildren.push(functionNode('tuple', []));
    } else {
      indexChildren.push(exprNode(indexExpr));
    }
  }
  if (decl.index_type !== undefined) {
    indexChildren.push(functionNode(decl.index_type.name, decl.index_type.arguments));
  }
  children.push(n('Index', indexChildren));

  if (stmt.database !== undefined) children.push(identifier(id(stmt.database.name)));
  children.push(identifier(id(stmt.table.name)));

  return n(label, children);
}

function createFunctionQueryNode(stmt: CreateFunctionQueryNode): ExplainNode {
  const children: ExplainNode[] = [identifier(stmt.function_name.name)];
  children.push(exprNode(stmt.function_core));
  return n(`CreateFunctionQuery ${stmt.function_name.name}`, children);
}

// Name slot for a drop-family statement in a ParallelWithQuery label.
function dropFamilyLabelName(stmt: DropFamilyNode): string {
  if (stmt.table !== undefined) return stmt.table.name;
  if (stmt.database !== undefined) return stmt.database.name;
  return '';
}

function parallelWithQueryNode(queries: Statement[]): ExplainNode {
  const firstAny = queries[0];
  const firstType = (firstAny as { type?: string } | undefined)?.type;
  if (
    firstType === 'DropQuery' ||
    firstType === 'DetachQuery' ||
    firstType === 'TruncateQuery' ||
    firstType === 'DropFunctionQuery' ||
    firstType === 'InsertQuery' ||
    firstType === 'OptimizeQuery' ||
    firstType === 'DeleteQuery' ||
    firstType === 'UpdateQuery'
  ) {
    let firstTable = '';
    if (firstType === 'OptimizeQuery') {
      const opt = firstAny as OptimizeQueryNode;
      firstTable = opt.table?.name ?? '';
      if (opt.final) firstTable += '_final';
      if (opt.cleanup) firstTable += '_cleanup';
      if (opt.deduplicate) firstTable += '_deduplicate';
    } else if (firstType === 'DeleteQuery') {
      firstTable = (firstAny as DeleteQueryNode).table?.name ?? '';
    } else if (firstType === 'UpdateQuery') {
      firstTable = (firstAny as UpdateQueryNode).table?.name ?? '';
    } else if (firstType !== 'DropFunctionQuery' && firstType !== 'InsertQuery') {
      firstTable = dropFamilyLabelName(firstAny as DropFamilyNode);
    }
    const label = `ParallelWithQuery ${queries.length} ${firstType}__${firstTable}`;
    return n(label, queries.map(stmtNode));
  }
  if (firstType === 'CreateQuery') {
    const cq = firstAny as CreateLikeNode;
    const firstTable = cq.table !== undefined ? id(cq.table.name) : '';
    return n(
      `ParallelWithQuery ${queries.length} CreateQuery_${firstTable}`,
      queries.map(stmtNode),
    );
  }
  if (firstType === 'AlterQuery') {
    const src = firstAny as AlterQueryNode & { table?: IdentifierNode };
    const firstTable = id(src.table ? src.table.name : '');
    return n(`ParallelWithQuery ${queries.length} AlterQuery_${firstTable}`, queries.map(stmtNode));
  }
  // Fallback for an unrecognized first query type (the grammar only emits
  // ClickHouse-native AST types into PARALLEL WITH).
  const label = `ParallelWithQuery ${queries.length}`;
  return n(label, queries.map(stmtNode));
}

// ── ALTER TABLE explain helpers ──────────────────────────────────────────────

// Native `Partition` / `Partition_ID` operand (as ClickHouse's EXPLAIN AST
// exposes it). Main partition commands (DROP/ATTACH/REPLACE/MOVE/FETCH/FREEZE)
// render `ALL`/`tuple(...)` as an empty `Partition_ID`, while IN PARTITION
// sub-clauses (CLEAR/MATERIALIZE) render an expression as a `Partition`.
function nativePartitionExplain(p: PartitionNode | PartitionIdNode): ExplainNode {
  if (p.type === 'Partition_ID') {
    if (p.all || p.id === undefined) return n('Partition_ID ');
    if (p.id.type === 'QueryParameter') return n('Partition_ID', [exprNode(p.id)]);
    const text = escapeStringValue(p.id.type === 'Literal' ? String(p.id.value) : '');
    return n(`Partition_ID Literal_'${text}'`, [n(`Literal '${text}'`)]);
  }
  return n('Partition', [exprNode(p.value)]);
}

/**
 * A native alter-command partition operand, narrowed to the wrapped
 * `Partition` / `Partition_ID` nodes (the `PART 'name'` string-Literal form is
 * handled separately by callers).
 */
function partitionOperand(
  p: PartitionNode | PartitionIdNode | LiteralNode | undefined,
): PartitionNode | PartitionIdNode | undefined {
  return p !== undefined && p.type !== 'Literal' ? p : undefined;
}

// `Literal 'text'` leaf for a raw string-literal operand (e.g. a COMMENT value).
function stringLiteralNode(lit: LiteralNode): ExplainNode {
  return n(`Literal '${escapeStringValue(String(lit.value))}'`);
}

// Build an AlterCommand explain node from a native AlterCommand node.
function alterCommandNode(nc: AlterCommandNode): ExplainNode {
  const children: ExplainNode[] = [];
  const pushPartition = (): void => {
    const p = partitionOperand(nc.partition);
    if (p) children.push(nativePartitionExplain(p));
  };

  switch (nc.command_type) {
    case 'ADD_COLUMN':
      if (nc.column_declaration) children.push(columnDeclExplainNative(nc.column_declaration));
      if (nc.column) children.push(exprNode(nc.column));
      break;
    case 'DROP_COLUMN':
      if (nc.column) children.push(exprNode(nc.column));
      pushPartition();
      break;
    case 'MODIFY_COLUMN':
      if (nc.column_declaration) children.push(columnDeclExplainNative(nc.column_declaration));
      if (nc.settings_resets) children.push(exprList(nc.settings_resets.children));
      else if (nc.settings_changes) children.push(SET);
      if (nc.column) children.push(exprNode(nc.column));
      break;
    case 'RENAME_COLUMN':
      if (nc.column) children.push(exprNode(nc.column));
      if (nc.rename_to) children.push(exprNode(nc.rename_to));
      break;
    case 'COMMENT_COLUMN':
      if (nc.column) children.push(exprNode(nc.column));
      if (nc.comment) children.push(stringLiteralNode(nc.comment));
      break;
    case 'MATERIALIZE_COLUMN':
      if (nc.column) children.push(exprNode(nc.column));
      pushPartition();
      break;
    case 'ADD_INDEX': {
      if (nc.index_declaration) {
        const idx = nc.index_declaration;
        const idxChildren: ExplainNode[] = [];
        if (idx.expression) idxChildren.push(exprNode(idx.expression));
        if (idx.index_type) idxChildren.push(indexTypeExplainNative(idx.index_type));
        children.push(n('Index', idxChildren));
      }
      if (nc.index) children.push(exprNode(nc.index));
      break;
    }
    case 'DROP_INDEX':
    case 'MATERIALIZE_INDEX':
      if (nc.index) children.push(exprNode(nc.index));
      pushPartition();
      break;
    case 'ADD_PROJECTION':
      if (nc.projection_declaration)
        children.push(projectionExplainNative(nc.projection_declaration));
      break;
    case 'DROP_PROJECTION':
    case 'MATERIALIZE_PROJECTION':
      if (nc.projection) children.push(exprNode(nc.projection));
      pushPartition();
      break;
    case 'ADD_CONSTRAINT':
      if (nc.constraint_declaration)
        children.push(n('Constraint', [exprNode(nc.constraint_declaration.expression)]));
      break;
    case 'DROP_CONSTRAINT':
      if (nc.constraint) children.push(exprNode(nc.constraint));
      break;
    case 'ADD_STATISTICS':
    case 'MODIFY_STATISTICS': {
      const sd = nc.statistics_declaration;
      const statChildren: ExplainNode[] = [];
      if (sd?.columns && sd.columns.children.length > 0)
        statChildren.push(exprList(sd.columns.children));
      if (sd?.types && sd.types.children.length > 0)
        statChildren.push(
          n(
            'ExpressionList',
            sd.types.children.map((x) =>
              x.type === 'Function' ? indexTypeExplainNative(x) : exprNode(x),
            ),
          ),
        );
      children.push(n('Stat', statChildren));
      break;
    }
    case 'DROP_STATISTICS':
    case 'MATERIALIZE_STATISTICS': {
      const cols = nc.statistics_declaration?.columns;
      if (cols && cols.children.length > 0) children.push(n('Stat', [exprList(cols.children)]));
      break;
    }
    case 'UPDATE':
      pushPartition();
      if (nc.predicate) children.push(exprNode(nc.predicate));
      if (nc.assignments) {
        const assigns = nc.assignments.map((a) =>
          n(`Assignment ${a.column}`, [exprNode(a.expression)]),
        );
        children.push(n('ExpressionList', assigns));
      }
      break;
    case 'DELETE':
      if (nc.predicate) children.push(exprNode(nc.predicate));
      break;
    case 'DROP_PARTITION':
    case 'ATTACH_PARTITION':
    case 'DROP_DETACHED_PARTITION':
      // `part` marks the `DROP/DETACH PART 'name'` form, where `partition` holds
      // the name literal directly rather than a wrapped Partition node.
      if (nc.part && nc.partition?.type === 'Literal') children.push(exprNode(nc.partition));
      else pushPartition();
      break;
    case 'REPLACE_PARTITION':
    case 'MOVE_PARTITION':
    case 'FETCH_PARTITION':
    case 'FREEZE_PARTITION':
      pushPartition();
      break;
    case 'FREEZE_ALL':
      break;
    case 'MODIFY_TTL':
      if (nc.ttl) children.push(n('ExpressionList', nc.ttl.children.map(nativeTTLElementExplain)));
      break;
    case 'REMOVE_TTL':
    case 'REMOVE_SAMPLE_BY':
    case 'MATERIALIZE_TTL':
      break;
    case 'MODIFY_ORDER_BY':
      if (nc.order_by) children.push(exprNode(nc.order_by));
      break;
    case 'MODIFY_SAMPLE_BY':
      if (nc.sample_by) children.push(exprNode(nc.sample_by));
      break;
    case 'MODIFY_SETTING':
      children.push(SET);
      break;
    case 'RESET_SETTING':
      if (nc.settings_resets) children.push(exprList(nc.settings_resets.children));
      break;
    case 'MODIFY_QUERY':
      if (nc.select) children.push(stmtNode(nc.select));
      break;
    case 'MODIFY_COMMENT':
      if (nc.comment) children.push(stringLiteralNode(nc.comment));
      break;
    case 'APPLY_DELETED_MASK':
    case 'APPLY_PATCHES':
    case 'REWRITE_PARTS':
      pushPartition();
      break;
  }

  return n(`AlterCommand ${nc.command_type}`, children);
}

// TTLElement (native) → explain node.
function nativeTTLElementExplain(el: TTLElementNode): ExplainNode {
  const ttlChildren = [exprNode(el.ttl)];
  if (el.where) ttlChildren.push(exprNode(el.where));
  return n('TTLElement', ttlChildren);
}

// Build the AlterQuery explain node from a native AlterQuery node.
function alterQueryNode(node: AlterQueryNode): ExplainNode {
  const target = node.alter_object === 'DATABASE' ? node.database : node.table;
  const label = node.database
    ? `AlterQuery ${id(node.database.name)} ${target ? id(target.name) : ''}`
    : `AlterQuery  ${target ? id(target.name) : ''}`;

  const children: ExplainNode[] = [n('ExpressionList', node.commands.map(alterCommandNode))];
  if (node.alter_object !== 'DATABASE') {
    if (node.database) children.push(identifier(id(node.database.name)));
    if (node.table) children.push(identifier(id(node.table.name)));
  } else if (node.database) {
    children.push(identifier(id(node.database.name)));
  }
  if (node.format !== undefined) children.push(identifier(node.format));
  if (node.settings !== undefined) children.push(SET);

  return n(label, children);
}

// `ShowAccessEntitiesQuery` entity_type → the plural SHOW keyword (explain label).
const SHOW_ENTITY_PLURAL_EXPLAIN: Record<string, string> = {
  USER: 'USERS',
  ROLE: 'ROLES',
  QUOTA: 'QUOTAS',
  'SETTINGS PROFILE': 'SETTINGS PROFILES',
  'ROW POLICY': 'ROW POLICIES',
  'NAMED COLLECTION': 'NAMED COLLECTIONS',
  WARNING: 'WARNINGS',
};

// Build the explain node for a SHOW statement, entirely from native fields.
function showQueryNode(stmt: ShowFamilyQueryNode): ExplainNode {
  const fmt = stmt.format;
  const formatChild = (): ExplainNode[] => (fmt ? [identifier(fmt)] : []);
  switch (stmt.type) {
    // ClickHouse's explain text labels SHOW INDEX as `ShowColumns` too.
    case 'ShowColumns':
    case 'ShowIndexes':
      return n('ShowColumns');
    case 'ShowSetting':
      return n('ShowSetting');
    case 'ShowFunctions':
      return n('ShowFunctions');
    case 'ShowPrivilegesQuery':
      return n('ShowPrivilegesQuery');
    case 'ShowEngineQuery':
      return n('ShowEngineQuery');
    case 'ShowAccessQuery':
      return n('ShowAccessQuery');
    case 'ShowProcesslistQuery':
      return n('ShowProcesslistQuery');
    case 'ShowTables': {
      // The flag-only sub-forms (SETTINGS / CLUSTERS / CLUSTER / MERGES) have no
      // children; the listing forms expose from / SETTINGS / FORMAT children.
      if (stmt.show_settings || stmt.clusters || stmt.cluster || stmt.merges) {
        return n('ShowTables');
      }
      const children: ExplainNode[] = [];
      if (stmt.from !== undefined) children.push(identifier(stmt.from.name));
      if (stmt.settings !== undefined) children.push(SET);
      children.push(...formatChild());
      return n('ShowTables', children);
    }
    case 'ShowAccessEntitiesQuery': {
      const plural = SHOW_ENTITY_PLURAL_EXPLAIN[stmt.entity_type ?? ''] ?? stmt.entity_type ?? '';
      return n(`SHOW ${plural} query`);
    }
    case 'ShowGrantsQuery':
      return n('ShowGrantsQuery', formatChild());
    case 'ShowCreateNamedCollectionQuery':
      return n('ShowCreateNamedCollectionQuery', formatChild());
    case 'ShowCreateAccessEntityQuery': {
      const hasFormat = fmt !== undefined;
      if (stmt.entity_type === 'ROW POLICY') {
        const label = hasFormat ? 'SHOW CREATE ROW POLICIES query' : 'SHOW CREATE ROW POLICY query';
        return n(label, formatChild());
      }
      const labels: Record<string, [string, string]> = {
        USER: ['SHOW CREATE USER query', 'SHOW CREATE USERS query'],
        ROLE: ['SHOW CREATE ROLE query', 'SHOW CREATE ROLES query'],
        QUOTA: ['SHOW CREATE QUOTA query', 'SHOW CREATE QUOTAS query'],
        'SETTINGS PROFILE': [
          'SHOW CREATE SETTINGS PROFILE query',
          'SHOW CREATE SETTINGS PROFILES query',
        ],
      };
      const count = stmt.current_user ? 1 : (stmt.names?.length ?? 0);
      const pair = labels[stmt.entity_type ?? ''] ?? ['SHOW CREATE query', 'SHOW CREATE query'];
      const usePlural = count > 1 && !hasFormat;
      return n(pair[usePlural ? 1 : 0], formatChild());
    }
    default:
      return n('SHOW');
  }
}

// Build the explain node for a parsed top-level statement, dispatching on the
// node's ClickHouse-native `type` discriminator.
function stmtNode(anyStmt: Statement): ExplainNode {
  // ClickHouse-native statement nodes use a string `type` discriminator
  const nodeType = (anyStmt as { type?: string }).type;
  if (typeof nodeType === 'string') {
    if (nodeType === 'SelectWithUnionQuery') {
      return queryWrapperNode(anyStmt as SelectWithUnionQueryNode);
    }
    if (nodeType === 'SelectIntersectExceptQuery') {
      return n('SelectWithUnionQuery', [
        n('ExpressionList', [intersectExceptNode(anyStmt as SelectIntersectExceptQueryNode)]),
      ]);
    }
    if (nodeType === 'Settings') return SET;
    if (nodeType === 'DropFunctionQuery') return n('DropFunctionQuery');
    if (nodeType === 'InsertQuery') {
      const ins = anyStmt as InsertQueryNode;
      // Rebuild the children list ClickHouse's `EXPLAIN AST` shows from
      // the explicit fields: optional FROM INFILE path / compression,
      // target (table_function OR database? + table), PARTITION BY,
      // columns ExpressionList, inner SELECT, and the settings child.
      const children: ExplainNode[] = [];
      if (ins.infile !== undefined) children.push(exprNode(ins.infile));
      if (ins.compression !== undefined) children.push(exprNode(ins.compression));
      if (ins.table_function !== undefined) {
        children.push(exprNode(ins.table_function));
      } else {
        if (ins.database !== undefined) children.push(statementChildNode(ins.database));
        if (ins.table !== undefined) children.push(statementChildNode(ins.table));
      }
      if (ins.partition_by !== undefined) children.push(exprNode(ins.partition_by));
      if (ins.columns !== undefined && ins.columns.length > 0) {
        children.push(exprList(ins.columns));
      }
      if (ins.select !== undefined) children.push(statementChildNode(ins.select));
      if (ins.settings !== undefined) children.push(SET);
      return n('InsertQuery  ', children);
    }
    if (nodeType === 'CreateQuery') {
      return createQueryExplainNode(anyStmt as CreateLikeNode);
    }
    if (nodeType === 'CreateFunctionQuery') {
      return createFunctionQueryNode(anyStmt as CreateFunctionQueryNode);
    }
    if (nodeType === 'CreateIndexQuery') {
      return createIndexQueryNode(anyStmt as CreateIndexQueryNode);
    }
    if (nodeType === 'AlterQuery') {
      return alterQueryNode(anyStmt as AlterQueryNode);
    }
    if (nodeType === 'SYSTEM') {
      const sys = anyStmt as SystemQueryNode;
      return n('SYSTEM query', systemExplainChildren(sys));
    }
    if (
      nodeType === 'SHOW' ||
      nodeType === 'ShowTables' ||
      nodeType === 'ShowColumns' ||
      nodeType === 'ShowIndexes' ||
      nodeType === 'ShowFunctions' ||
      nodeType === 'ShowSetting' ||
      nodeType === 'ShowEngineQuery' ||
      nodeType === 'ShowAccessQuery' ||
      nodeType === 'ShowAccessEntitiesQuery' ||
      nodeType === 'ShowProcesslistQuery' ||
      nodeType === 'ShowGrantsQuery' ||
      nodeType === 'ShowPrivilegesQuery' ||
      nodeType === 'ShowCreateNamedCollectionQuery' ||
      nodeType === 'ShowCreateAccessEntityQuery'
    ) {
      return showQueryNode(anyStmt as ShowFamilyQueryNode);
    }
    if (nodeType === 'DropAccessEntityQuery') {
      // Native access-entity DROP: the explain label is `DROP <entity> query`.
      return n(`DROP ${(anyStmt as { entity_type: string }).entity_type} query`);
    }
    if (
      nodeType === 'DropNamedCollectionQuery' ||
      nodeType === 'DropWorkloadQuery' ||
      nodeType === 'DropResourceQuery'
    ) {
      return n(nodeType);
    }
    if (
      nodeType === 'CreateUserQuery' ||
      nodeType === 'CreateRoleQuery' ||
      nodeType === 'CreateQuotaQuery' ||
      nodeType === 'CreateSettingsProfileQuery' ||
      nodeType === 'CreateNamedCollectionQuery' ||
      nodeType === 'CreateWorkloadQuery' ||
      nodeType === 'CreateResourceQuery' ||
      nodeType === 'CreateRowPolicyQuery' ||
      nodeType === 'GrantQuery' ||
      nodeType === 'RevokeQuery' ||
      nodeType === 'SetRoleQuery'
    ) {
      // Access-entity queries: the label (and CREATE USER's AuthenticationData
      // children) are derived from native fields by accessQueryExplainNode.
      return accessQueryExplainNode(anyStmt as AccessQueryNode);
    }
    if (nodeType === 'BackupQuery' || nodeType === 'RestoreQuery') {
      return backupExplainNode(anyStmt as BackupQueryNode);
    }
    if (nodeType === 'DropIndexQuery') {
      const di = anyStmt as DropIndexQueryNode;
      const children = [di.index_name, ...(di.database ? [di.database] : []), di.table];
      // Label is "DropIndexQuery [db.]name" (unqualified uses one leading space;
      // qualified uses db.name).
      const tableName =
        di.database !== undefined ? `${di.database.name}.${di.table.name}` : ` ${di.table.name}`;
      return n(`DropIndexQuery ${tableName}`, children.map(statementChildNode));
    }
    if (nodeType === 'ParallelWithQuery') {
      return parallelWithQueryNode((anyStmt as ParallelWithQueryNode).children as Statement[]);
    }
    if (nodeType === 'Explain') {
      const ex = anyStmt as ExplainQueryNode;
      // Rebuild the children list ClickHouse's explain emits from the
      // explicit native/library fields. Order: explain-level settings,
      // the inner query, FORMAT identifier, post-format settings.
      const children: ExplainNode[] = [];
      if (ex.settings !== undefined) children.push(SET);
      if (ex.query !== undefined) children.push(statementChildNode(ex.query));
      if (ex.format !== undefined) children.push(identifier(ex.format));
      if (ex.output_settings !== undefined) children.push(SET);
      return n(`Explain ${ex.kind ?? 'EXPLAIN'}`, children);
    }
    if (nodeType === 'UseQuery') {
      const useStmt = anyStmt as UseQueryNode;
      return n(`UseQuery ${useStmt.database.name}`, [statementChildNode(useStmt.database)]);
    }
    if (nodeType === 'TransactionControl') return n('ASTTransactionControl');
    if (nodeType === 'ExecuteAsQuery') {
      const ea = anyStmt as ExecuteAsQueryNode;
      return n('ExecuteAsQuery', [
        statementChildNode(ea.target_user as ASTNode),
        statementChildNode(ea.subquery as ASTNode),
      ]);
    }
    if (nodeType === 'OptimizeQuery') return optimizeExplainNode(anyStmt as OptimizeQueryNode);
    if (nodeType === 'DescribeQuery') {
      const dq = anyStmt as DescribeQueryNode;
      // Rebuild children: TableExpression, then the optional FORMAT
      // Identifier / Settings in source order (preserved via
      // `settings_before_format`).
      const children: ExplainNode[] = [];
      if (dq.table_expression !== undefined) {
        children.push(statementChildNode(dq.table_expression));
      }
      if (dq.settings_before_format === true) {
        if (dq.settings !== undefined) children.push(SET);
        if (dq.format !== undefined) children.push(identifier(dq.format));
      } else {
        if (dq.format !== undefined) children.push(identifier(dq.format));
        if (dq.settings !== undefined) children.push(SET);
      }
      return n('DescribeQuery', children);
    }
    if (
      nodeType === 'ShowCreateTableQuery' ||
      nodeType === 'ShowCreateViewQuery' ||
      nodeType === 'ShowCreateDictionaryQuery' ||
      nodeType === 'ShowCreateDatabaseQuery' ||
      nodeType === 'ExistsTableQuery' ||
      nodeType === 'ExistsViewQuery' ||
      nodeType === 'ExistsDictionaryQuery' ||
      nodeType === 'ExistsDatabaseQuery' ||
      nodeType === 'CheckQuery'
    ) {
      return dropFamilyExplainNode(anyStmt as unknown as DropFamilyNode);
    }
    if (nodeType === 'CheckAllQuery') {
      const ck = anyStmt as CheckQueryNode;
      const children: ExplainNode[] = [];
      if (ck.settings !== undefined) children.push(SET);
      if (ck.format !== undefined) children.push(identifier(ck.format));
      return n('CheckAllQuery', children);
    }
    if (nodeType === 'AttachQuery') {
      // ATTACH with a full schema renders like CREATE; bare ATTACH uses the
      // drop-family label.
      const att = anyStmt as AttachQueryNode;
      if (isSchemaFormAttachExplain(att)) {
        return createQueryExplainNode(att as unknown as CreateLikeNode);
      }
      return attachExplainNode(att);
    }
    if (nodeType === 'Rename') {
      const ren = anyStmt as RenameNode;
      // Rebuild ClickHouse's children list: flattened from/to Identifier
      // sequence per pair (with db Identifier before the table when present),
      // then an optional Set.
      const idLabel = (n: string | QueryParameterNode): string =>
        typeof n === 'string' ? `Identifier ${n}` : `QueryParameter ${n.name}:${n.param_type}`;
      const children: ExplainNode[] = [];
      for (const el of ren.elements) {
        if (el.from_database !== undefined) {
          children.push(n(idLabel(el.from_database)));
        }
        if (el.from_table !== undefined) children.push(n(idLabel(el.from_table)));
        if (el.to_database !== undefined) {
          children.push(n(idLabel(el.to_database)));
        }
        if (el.to_table !== undefined) children.push(n(idLabel(el.to_table)));
      }
      if (ren.settings !== undefined) children.push(SET);
      return n('Rename', children);
    }
    if (nodeType === 'KillQueryQuery') {
      const kill = anyStmt as KillQueryQueryNode;
      const where = kill.where;
      const fnName = where.type === 'Function' ? where.name : '';
      const mode = kill.test ? 'TEST' : kill.sync ? 'SYNC' : 'ASYNC';
      const children: ExplainNode[] = [statementChildNode(where)];
      if (kill.settings !== undefined) children.push(SET);
      if (kill.format !== undefined) children.push(identifier(kill.format));
      return n(`KillQueryQuery Function_${fnName} ${mode}`, children);
    }
    if (nodeType === 'DeleteQuery') return deleteExplainNode(anyStmt as DeleteQueryNode);
    if (nodeType === 'UpdateQuery') return updateExplainNode(anyStmt as UpdateQueryNode);
    if (
      nodeType === 'DropQuery' ||
      nodeType === 'DetachQuery' ||
      nodeType === 'TruncateQuery' ||
      nodeType === 'UndropQuery'
    ) {
      return dropFamilyExplainNode(anyStmt as DropFamilyNode);
    }
    if (nodeType === 'EmptyQuery') return n('');
  }
  return n('');
}

// Explain projection for an {@link AccessQueryNode}. ClickHouse's explain text
// for these is just the node label (plus, for CREATE USER, an
// AuthenticationData child per method), so this reads the native fields rather
// than any structured payload.
function accessQueryExplainNode(node: AccessQueryNode): ExplainNode {
  if (node.type === 'SetRoleQuery') return n('SetRoleQuery');
  if (node.type === 'GrantQuery' || node.type === 'RevokeQuery') return n('GrantQuery');
  if (node.type === 'CreateUserQuery') {
    const methods = node.authentication_methods;
    if (!methods || methods.length === 0) return n('CreateUserQuery');
    const authChildren = methods.map((m) => {
      if (m.auth_type === 'SSH_KEY') {
        return n(
          'AuthenticationData',
          (m.arguments ?? []).map(() => n('PublicSSHKey')),
        );
      }
      const secret = m.arguments?.[0]?.value;
      if (secret !== undefined) return n('AuthenticationData', [n(`Literal '${secret}'`)]);
      return n('AuthenticationData');
    });
    return n('CreateUserQuery', authChildren);
  }
  if (node.type === 'CreateRoleQuery') return n('CreateRoleQuery');
  if (node.type === 'CreateQuotaQuery') return n('CreateQuotaQuery');
  if (node.type === 'CreateSettingsProfileQuery') return n('CreateSettingsProfileQuery');
  if (node.type === 'CreateRowPolicyQuery') return n('CREATE ROW POLICY or ALTER ROW POLICY query');
  if (node.type === 'CreateNamedCollectionQuery') return n('CreateNamedCollectionQuery');
  if (node.type === 'CreateWorkloadQuery') {
    const name = node.workload_name?.name ?? '';
    const children = [identifier(name)];
    const parent = node.workload_parent;
    if (parent) children.push(identifier(parent.name));
    return n(`CreateWorkloadQuery ${name}`, children);
  }
  if (node.type === 'CreateResourceQuery') {
    const name = node.resource_name?.name ?? '';
    return n(`CreateResourceQuery ${name}`, [identifier(name)]);
  }
  return n('');
}

// Explain projection for a native BackupQuery / RestoreQuery node.
function backupExplainNode(node: BackupQueryNode): ExplainNode {
  const label = node.kind === 'RESTORE' ? 'RestoreQuery' : 'BackupQuery';
  const children: ExplainNode[] = [];
  const fn = node.backup_name;
  const args = fn.arguments ?? [];
  const fnChildren: ExplainNode[] = args.length === 0 ? [] : [exprList(args)];
  children.push(n(`Function ${fn.name}`, fnChildren));
  if (node.format) children.push(identifier(node.format));
  return n(label, children);
}

// Project one member of a SelectWithUnionQuery's select list.
function queryMemberNode(
  m: SelectQueryNode | SelectIntersectExceptQueryNode | SelectWithUnionQueryNode,
): ExplainNode {
  if (m.type === 'SelectQuery') return selectQueryNode(m);
  if (m.type === 'SelectIntersectExceptQuery') return intersectExceptNode(m);
  return stmtNode(m);
}

function intersectExceptNode(q: SelectIntersectExceptQueryNode): ExplainNode {
  return n('SelectIntersectExceptQuery', q.selects.map(queryMemberNode));
}

// Project a SelectWithUnionQuery wrapper, including its trailing
// INTO OUTFILE / FORMAT / SETTINGS clauses.
type DropFamilyNode = DropQueryNode | DetachQueryNode | TruncateQueryNode | UndropQueryNode;

// Rebuild ClickHouse's SYSTEM explain children list from the native
// structured fields (byte-validated against ClickHouse). The `database` /
// `table` operands become `Identifier` children; the command family decides
// whether the target is duplicated (dictionary / distributed) and whether a
// trailing `Set` (SETTINGS) child is appended.
const SYSTEM_DUPLICATED_TARGET = new Set([
  'RELOAD DICTIONARY',
  'DROP DICTIONARY CACHE',
  'FLUSH DISTRIBUTED',
  'STOP DISTRIBUTED SENDS',
  'START DISTRIBUTED SENDS',
  'LOAD PRIMARY KEY',
  'UNLOAD PRIMARY KEY',
  'RESTORE REPLICA',
]);
const SYSTEM_WITH_SETTINGS_CHILD = new Set([
  'FLUSH DISTRIBUTED',
  'STOP DISTRIBUTED SENDS',
  'START DISTRIBUTED SENDS',
  'LOAD PRIMARY KEY',
  'UNLOAD PRIMARY KEY',
  'RESTORE REPLICA',
]);

function systemExplainChildren(sys: SystemQueryNode): ExplainNode[] {
  const st = sys.system_type ?? '';
  const mkTargets = (): ExplainNode[] => {
    const arr: ExplainNode[] = [];
    if (sys.database !== undefined) arr.push(identifier(sys.database.name));
    if (sys.table !== undefined) arr.push(identifier(sys.table.name));
    return arr;
  };

  if (SYSTEM_DUPLICATED_TARGET.has(st)) {
    const children = [...mkTargets(), ...mkTargets()];
    if (SYSTEM_WITH_SETTINGS_CHILD.has(st) && sys.settings !== undefined) {
      children.push(SET);
    }
    return children;
  }
  // Table/database-targeting commands — target is NOT duplicated.
  return mkTargets();
}

// Project a child of a children-array statement node (Identifier/Set/
// ExpressionList/TableIdentifier/nested query/expression) into its explain node.
function statementChildNode(c: ASTNode): ExplainNode {
  const t = (c as { type?: string }).type;
  if (t === 'ExpressionList') {
    const list = (c as ExpressionListNode).children ?? [];
    return n('ExpressionList', list.map(statementChildNode));
  }
  if (t === 'TableIdentifier') {
    const ti = c as TableIdentifierNode;
    return n(
      `TableIdentifier ${ti.database !== undefined ? `${id(ti.database)}.${id(ti.name)}` : id(ti.name)}`,
    );
  }
  if (t === 'Settings') return SET;
  if (t === 'Partition' || t === 'Partition_ID') {
    return nativePartitionExplain(c as PartitionNode | PartitionIdNode);
  }
  if (t === 'Assignment') {
    const a = c as AssignmentNode;
    return n(`Assignment ${a.column}`, [exprNode(a.expression)]);
  }
  if (t === 'UserNameWithHost') {
    const u = c as UserNameWithHostNode;
    return n('UserNameWithHost', [identifier(u.name ?? '')]);
  }
  if (t === 'TableExpression') {
    return tableExpressionExplainNode(c as TableExpressionNode);
  }
  if (t === 'SelectWithUnionQuery' || t === 'SelectIntersectExceptQuery') {
    return stmtNode(c as Statement);
  }
  if (t === undefined) {
    // Old-kind inner statement (e.g. EXECUTE AS <stmt>)
    return stmtNode(c as Statement);
  }
  if (STATEMENT_CHILD_TYPES.has(t) || t.startsWith('ShowCreate') || t.startsWith('Exists')) {
    return stmtNode(c as Statement);
  }
  return exprNode(c as Expression);
}

// Statement `type`s that can appear as a child of a children-array statement
// node and must be routed back through stmtNode (anything else is an expression).
const STATEMENT_CHILD_TYPES = new Set([
  'InsertQuery',
  'CreateQuery',
  'CreateFunctionQuery',
  'CreateIndexQuery',
  'AlterQuery',
  'SYSTEM',
  'DropIndexQuery',
  'DropQuery',
  'DetachQuery',
  'TruncateQuery',
  'UndropQuery',
  'DropFunctionQuery',
  'UseQuery',
  'TransactionControl',
  'OptimizeQuery',
  'DescribeQuery',
  'CheckQuery',
  'CheckAllQuery',
  'AttachQuery',
  'Rename',
  'KillQueryQuery',
  'DeleteQuery',
  'UpdateQuery',
  'Explain',
  'ExecuteAsQuery',
]);

function optimizeExplainNode(stmt: OptimizeQueryNode): ExplainNode {
  let suffix = '';
  if (stmt.final) suffix += '_final';
  if (stmt.cleanup) suffix += '_cleanup';
  if (stmt.deduplicate) suffix += '_deduplicate';
  const db = stmt.database?.name ?? '';
  const name = stmt.table?.name ?? '';
  const label =
    stmt.database !== undefined
      ? `OptimizeQuery ${db} ${name}${suffix}`
      : `OptimizeQuery  ${name}${suffix}`;
  // Rebuild the explain children: optional partition, db?/table identifiers,
  // optional Settings.
  const children: ExplainNode[] = [];
  if (stmt.partition !== undefined) children.push(statementChildNode(stmt.partition));
  if (stmt.database !== undefined) children.push(statementChildNode(stmt.database));
  if (stmt.table !== undefined) children.push(statementChildNode(stmt.table));
  if (stmt.settings !== undefined) children.push(SET);
  return n(label, children);
}

function attachExplainNode(stmt: AttachQueryNode): ExplainNode {
  const children: ExplainNode[] = [];
  if (stmt.database !== undefined) children.push(statementChildNode(stmt.database));
  if (stmt.table !== undefined) children.push(statementChildNode(stmt.table));
  let label: string;
  if (stmt.database !== undefined && stmt.table === undefined) {
    label = `AttachQuery ${stmt.database.name} `;
  } else if (stmt.database !== undefined && stmt.table !== undefined) {
    label = `AttachQuery ${stmt.database.name} ${stmt.table.name}`;
  } else {
    label = `AttachQuery ${stmt.table?.name ?? ''}`;
  }
  return n(label, children);
}

function deleteExplainNode(stmt: DeleteQueryNode): ExplainNode {
  const db = stmt.database?.name;
  const tbl = stmt.table?.name ?? '';
  const label = db !== undefined ? `DeleteQuery ${db} ${tbl}` : `DeleteQuery  ${tbl}`;
  // Rebuild children: partition?, predicate (WHERE), database?, table,
  // optional Settings.
  const children: ExplainNode[] = [];
  if (stmt.partition !== undefined) children.push(statementChildNode(stmt.partition));
  if (stmt.predicate !== undefined) children.push(exprNode(stmt.predicate));
  if (stmt.database !== undefined) children.push(statementChildNode(stmt.database));
  if (stmt.table !== undefined) children.push(statementChildNode(stmt.table));
  if (stmt.settings !== undefined) children.push(SET);
  return n(label, children);
}

function updateExplainNode(stmt: UpdateQueryNode): ExplainNode {
  const db = stmt.database?.name;
  const tbl = stmt.table?.name ?? '';
  const label = db !== undefined ? `UpdateQuery ${db} ${tbl}` : `UpdateQuery  ${tbl}`;
  // Rebuild children: database?, table, predicate, assignments list,
  // optional Settings.
  const children: ExplainNode[] = [];
  if (stmt.database !== undefined) children.push(statementChildNode(stmt.database));
  if (stmt.table !== undefined) children.push(statementChildNode(stmt.table));
  if (stmt.predicate !== undefined) children.push(exprNode(stmt.predicate));
  if (stmt.assignments !== undefined) {
    children.push(
      n(
        'ExpressionList',
        stmt.assignments.map((a) => statementChildNode(a)),
      ),
    );
  }
  if (stmt.settings !== undefined) children.push(SET);
  return n(label, children);
}

// Project a drop-family statement. The label carries the database/table name
// slots (empty slots collapse to consecutive spaces, mirroring ClickHouse).
function dropFamilyExplainNode(stmt: DropFamilyNode): ExplainNode {
  // Re-materialize the children list ClickHouse's `EXPLAIN AST` shows even
  // though the AST proper stores `database`/`table` as explicit fields:
  // ExpressionList of multi-tables (if any), then database Identifier (if
  // any), then table Identifier (if any), then optional Settings child,
  // then optional FORMAT Identifier.
  const children: ExplainNode[] = [];
  const multiTables =
    stmt.database_and_tables !== undefined
      ? ((stmt.database_and_tables.children ?? []) as TableIdentifierNode[])
      : undefined;
  if (multiTables !== undefined) {
    children.push(
      n(
        'ExpressionList',
        multiTables.map((ti) => statementChildNode(ti)),
      ),
    );
  } else {
    if (stmt.database !== undefined) children.push(statementChildNode(stmt.database));
    if (stmt.table !== undefined) children.push(statementChildNode(stmt.table));
  }
  if (stmt.format !== undefined) children.push(identifier(stmt.format));
  if (stmt.settings !== undefined) children.push(SET);

  let label: string;
  if (stmt.type === 'UndropQuery') {
    label =
      stmt.database !== undefined && stmt.table !== undefined
        ? `UndropQuery ${stmt.database.name}.${stmt.table.name}`
        : `UndropQuery  ${stmt.table?.name ?? ''}`;
  } else if (multiTables !== undefined) {
    label = `${stmt.type}  `;
  } else if (stmt.database !== undefined && stmt.table === undefined) {
    label = `${stmt.type} ${stmt.database.name} `;
  } else if (stmt.database !== undefined && stmt.table !== undefined) {
    label = `${stmt.type} ${stmt.database.name} ${stmt.table.name}`;
  } else if (stmt.table !== undefined) {
    label = `${stmt.type}  ${stmt.table.name}`;
  } else {
    label = `${stmt.type}  `;
  }
  return n(label, children);
}

function queryWrapperNode(q: SelectWithUnionQueryNode): ExplainNode {
  const children: ExplainNode[] = [n('ExpressionList', q.selects.map(queryMemberNode))];
  if (q.out_file !== undefined) {
    children.push(n(`Literal '${escapeStringValue(String(q.out_file.value))}'`));
  }
  // ClickHouse's AST child order follows the source order of SETTINGS vs FORMAT
  // (`settings_before_format`), so reproduce it here even though format()
  // canonicalizes the order.
  if (q.settings !== undefined && q.settings_before_format) children.push(SET);
  if (q.format !== undefined) children.push(identifier(q.format));
  if (q.settings !== undefined && !q.settings_before_format) children.push(SET);
  return n('SelectWithUnionQuery', children);
}

export function formatExplain(statements: WithoutLocations<Statement>[]): string {
  StatementsSchema.parse(statements);
  // formatExplain never reads `location`; treat the (possibly location-free)
  // input as the located type internally.
  return (statements as Statement[]).map((s) => render(stmtNode(s))).join('\n\n');
}
