import {
  AccessControlName,
  AccessControlSettingsItem,
  AlterUserClause,
  ASTNode,
  WithoutLocations,
  AuthenticationData,
  GrantElement,
  GrantPrivilege,
  GrantStatement,
  GrantTarget,
  Identifier,
  ColumnsListMatcherNode,
  ColumnsRegexpMatcherNode,
  ColumnsTransformerListNode,
  ColumnsTransformerNode,
  CreateQueryNode,
  CreateFunctionQueryNode,
  CreateIndexQueryNode,
  AlterQueryNode,
  AlterCommandNode,
  SystemQueryNode,
  ShowFamilyQueryNode,
  BackupQueryNode,
  BackupQueryElement,
  AccessQueryNode,
  CreateUserQueryNode,
  CreateRoleQueryNode,
  CreateQuotaQueryNode,
  CreateSettingsProfileQueryNode,
  CreateRowPolicyQueryNode,
  CreateNamedCollectionQueryNode,
  CreateWorkloadQueryNode,
  CreateResourceQueryNode,
  GrantQueryNode,
  SetRoleQueryNode,
  RolesOrUsersSetNode,
  UserNamesWithHostNode,
  RowPolicyNamesNode,
  DatabaseOrNoneNode,
  SettingsProfileElementsNode,
  SettingsProfileElementNode,
  AlterSettingsProfileElementsNode,
  NativeAuthenticationData,
  NativeHosts,
  NativeQuotaLimit,
  NativeAccessRight,
  TypedSettingValue,
  Expression,
  FunctionNode,
  HostItem,
  InterpolateElementNode,
  IdentifierNode,
  LiteralElement,
  LiteralNode,
  OrderByElementNode,
  QualifiedAsteriskNode,
  QualifiedColumnsListMatcherNode,
  QualifiedColumnsRegexpMatcherNode,
  QueryParameterNode,
  AsteriskNode,
  RoleTarget,
  SampleClause,
  SampleRatioNode,
  SampleRatioValue,
  SettingsNode,
  StorageNode,
  StorageOrderByElementNode,
  SelectQueryNode,
  SelectWithUnionQueryNode,
  SelectIntersectExceptQueryNode,
  TablesInSelectQueryNode,
  TableExpressionNode,
  WithItem,
  ExpressionListNode,
  TimeIntervalNode,
  TableIdentifierNode,
  DropQueryNode,
  InsertQueryNode,
  ExplainQueryNode,
  OptimizeQueryNode,
  DescribeQueryNode,
  ShowCreateQueryNode,
  ExistsQueryNode,
  CheckQueryNode,
  AttachQueryNode,
  RenameNode,
  KillQueryQueryNode,
  DeleteQueryNode,
  UpdateQueryNode,
  PartitionNode,
  PartitionIdNode,
  DetachQueryNode,
  TruncateQueryNode,
  UndropQueryNode,
  SettingItem,
  SubqueryNode,
  Statement,
  StatementsSchema,
  TableRef,
  WindowSpec,
  TableOrderByItem,
  ColumnsNode,
  ColumnDeclarationNode,
  IndexNode,
  ProjectionNode,
  ProjectionSelectQueryNode,
  TTLElementNode,
  DictionaryNode,
  DictionaryAttributeDeclarationNode,
} from './ast';
import { isNodeType } from './guards';

// Keywords that cannot be used as bare identifiers (must be backtick-quoted)
const KEYWORDS = new Set([
  'SELECT',
  'FROM',
  'WHERE',
  'PREWHERE',
  'GROUP',
  'HAVING',
  'ORDER',
  'BY',
  'LIMIT',
  'OFFSET',
  'WITH',
  'ASC',
  'AS',
  'AND',
  'OR',
  'DESC',
  'NULL',
  'NOT',
  'INTERSECT',
  'INTO',
  'IN',
  'DISTINCT',
  'JOIN',
  'ON',
  'USING',
  'FINAL',
  'SETTINGS',
  'UNION',
  'ILIKE',
  'LIKE',
  'BETWEEN',
  'ALL',
  'ANY',
  'EXCEPT',
  'WINDOW',
  'OVER',
  'QUALIFY',
  'SAMPLE',
  'FORMAT',
  'SET',
  'USE',
  'SYSTEM',
  'EXPLAIN',
  'LEFT',
  'RIGHT',
  'INNER',
  'FULL',
  'CROSS',
  'PASTE',
  'ARRAY',
  'GLOBAL',
  'IS',
  'TRUE',
  'FALSE',
  'INF',
  'NAN',
  'TOP',
  'DIV',
  'MOD',
  'FETCH',
  'NEXT',
  'ROW',
  'ROWS',
  'ONLY',
  'TIES',
  'CASE',
  'WHEN',
  'THEN',
  'ELSE',
  'END',
  'INTERVAL',
  'COLUMNS',
  'APPLY',
  'REPLACE',
  'STRICT',
  'PARTITION',
  'RANGE',
  'GROUPS',
  'UNBOUNDED',
  'PRECEDING',
  'FOLLOWING',
  'CURRENT',
  'TOTALS',
  'ROLLUP',
  'CUBE',
  'PREWHERE',
  'RESPECT',
  'IGNORE',
  'NULLS',
  'FIRST',
  'LAST',
  'COLLATE',
  'FILL',
  'STEP',
  'STALENESS',
  'INTERPOLATE',
  'EXISTS',
  'ISNULL',
]);

// Quote an identifier with backticks if it needs quoting. Accepts either a
// plain string or a {@link QueryParam} node (identifier-position query param).
// Whether the string is safe as a bare (unquoted) identifier: starts with
// letter/underscore, only alphanum/underscore/`$`, and not a reserved keyword.
function isBareIdent(s: string): boolean {
  return /^[a-zA-Z_][a-zA-Z0-9_$]*$/.test(s) && !KEYWORDS.has(s.toUpperCase());
}

// Backtick-quote: escape backticks by doubling, backslashes by doubling.
function backtickQuote(s: string): string {
  return '`' + s.replace(/\\/g, '\\\\').replace(/`/g, '``') + '`';
}

function quoteIdent(s: Identifier): string {
  if (typeof s !== 'string') return `{${s.name}:${s.param_type}}`;
  if (isBareIdent(s)) return s;
  // `*` in qualified-asterisk position passes through
  if (s === '*') return s;
  return backtickQuote(s);
}

// Escape a decoded string value for output inside single quotes.
// Backslashes and control characters are re-escaped so the output re-parses to
// the same decoded value (\a, \v, \e control chars pass through raw).
function escapeString(s: string): string {
  return (
    s
      .replace(/\\/g, '\\\\')
      .replace(/'/g, "''")
      // eslint-disable-next-line no-control-regex
      .replace(/\x08/g, '\\b')
      .replace(/\t/g, '\\t')
      .replace(/\n/g, '\\n')
      .replace(/\r/g, '\\r')
      .replace(/\f/g, '\\f')
      .replace(/\0/g, '\\0')
  );
}

// Accumulates trailing comments from the very last expression of a statement.
// These must be placed after the semicolon to avoid `;` being swallowed by the comment.
let _endComments: string[] = [];

// Flush pending end comments into the lines array (appended to last line).
// Call this when a new clause starts, meaning the previous end comments are no longer
// at the end of the statement and can be safely placed inline.
function flushEndComments(lines: string[]): void {
  if (_endComments.length > 0 && lines.length > 0) {
    lines[lines.length - 1] += ' ' + _endComments.join(' ');
    _endComments = [];
  }
}

// The two query wrappers that carry trailing INTO OUTFILE/FORMAT/SETTINGS.
type QueryWrapperNode = SelectWithUnionQueryNode | SelectIntersectExceptQueryNode;

function isQueryWrapper(node: { type?: string } | undefined): node is QueryWrapperNode {
  return node?.type === 'SelectWithUnionQuery' || node?.type === 'SelectIntersectExceptQuery';
}

// A top-level union/intersect that owns its own trailing SETTINGS clause must
// wrap its body in parens so the clause re-parses as the wrapper's, not the
// last inner SELECT's, after format → parse. FORMAT and INTO OUTFILE always
// attach to the outermost wrapper regardless of parens, so they do not trigger
// the wrap on their own.
function needsSettingsWrap(s: QueryWrapperNode): boolean {
  if (s.settings === undefined) return false;
  return (
    s.type === 'SelectIntersectExceptQuery' ||
    s.selects.length > 1 ||
    s.selects[0].type !== 'SelectQuery'
  );
}

// Statement-end trailing comments may attach to the statement itself or, for
// union/intersect trees, to the last query member (where the parser puts them).
function collectStatementTrailingComments(s: Statement): string[] {
  const comments = [...(s.trailingComments ?? [])];
  let node: QueryWrapperNode | undefined = isQueryWrapper(s) ? s : undefined;
  while (node !== undefined) {
    const next = node.selects[node.selects.length - 1];
    if (next.trailingComments?.length) comments.push(...next.trailingComments);
    node = isQueryWrapper(next) ? next : undefined;
  }
  return comments;
}

function formatTopLevelStatement(s: Statement): string {
  _endComments = [];
  let result = s.leadingComments?.length ? s.leadingComments.join('\n') + '\n' : '';

  if (isQueryWrapper(s) && needsSettingsWrap(s)) {
    // Hoist leading comments on the first inner member out of the parens so
    // they re-parse with the same attachment: inside the parens a comment
    // before the first SELECT would attach to the outer wrapper instead.
    const firstMember = s.selects[0];
    const hoisted = firstMember.leadingComments ?? [];
    if (hoisted.length > 0) result += hoisted.join('\n') + '\n';
    const trailing = formatQueryTrailing(s, '');
    const strippedFirst =
      hoisted.length > 0 ? { ...firstMember, leadingComments: undefined } : firstMember;
    const inner = formatStatement(
      {
        ...s,
        selects: [strippedFirst, ...s.selects.slice(1)],
        out_file: undefined,
        outfile_truncate: undefined,
        format: undefined,
        settings: undefined,
      },
      '',
    );
    result += `(${inner.trimStart()})${trailing}`;
  } else {
    result += formatStatement(s, '');
  }

  // Flush any remaining end comments before the semicolon.
  if (_endComments.length > 0) {
    result += ' ' + _endComments.join(' ');
    _endComments = [];
  }
  result += ';';

  const trailing = collectStatementTrailingComments(s);
  if (trailing.length > 0) {
    result += ' ' + trailing[0];
    for (let i = 1; i < trailing.length; i++) result += '\n' + trailing[i];
  }
  return result;
}

export function format(statements: WithoutLocations<Statement>[]): string {
  StatementsSchema.parse(statements);
  // The formatter never reads `location`; treat the (possibly location-free)
  // input as the located type internally.
  return (statements as Statement[]).map(formatTopLevelStatement).join('\n\n');
}

// Native AST `type` values that represent top-level statements (used by
// {@link formatNode} to route to {@link formatStatement} instead of
// {@link formatExpr}).
const STATEMENT_TYPES = new Set<string>([
  'SelectWithUnionQuery',
  'SelectIntersectExceptQuery',
  'Settings',
  'DropQuery',
  'DetachQuery',
  'TruncateQuery',
  'UndropQuery',
  'DropFunctionQuery',
  'InsertQuery',
  'CreateQuery',
  'CreateFunctionQuery',
  'CreateIndexQuery',
  'AlterQuery',
  'SYSTEM',
  'SHOW',
  'ShowTables',
  'ShowColumns',
  'ShowIndexes',
  'ShowFunctions',
  'ShowSetting',
  'ShowEngineQuery',
  'ShowAccessQuery',
  'ShowAccessEntitiesQuery',
  'ShowProcesslistQuery',
  'ShowGrantsQuery',
  'ShowPrivilegesQuery',
  'ShowCreateNamedCollectionQuery',
  'DropAccessEntityQuery',
  'DropNamedCollectionQuery',
  'DropWorkloadQuery',
  'DropResourceQuery',
  'CreateUserQuery',
  'CreateRoleQuery',
  'CreateQuotaQuery',
  'CreateSettingsProfileQuery',
  'CreateNamedCollectionQuery',
  'CreateWorkloadQuery',
  'CreateResourceQuery',
  'GrantQuery',
  'SetRoleQuery',
  'BackupQuery',
  'RestoreQuery',
  'ParallelWithQuery',
  'DropIndexQuery',
  'UseQuery',
  'TransactionControl',
  'ExecuteAsQuery',
  'OptimizeQuery',
  'DescribeQuery',
  'ShowCreateTableQuery',
  'ShowCreateViewQuery',
  'ShowCreateDictionaryQuery',
  'ShowCreateDatabaseQuery',
  'ExistsTableQuery',
  'ExistsViewQuery',
  'ExistsDictionaryQuery',
  'ExistsDatabaseQuery',
  'CheckQuery',
  'CheckAllQuery',
  'AttachQuery',
  'Rename',
  'KillQueryQuery',
  'DeleteQuery',
  'UpdateQuery',
  'Explain',
  'EmptyQuery',
]);

// Format any AST node by dispatching to the appropriate type-specific formatter.
//
// ClickHouse-native nodes dispatch on their `type` discriminator. The legacy
// `kind`-discriminated statement/element nodes (CREATE DDL, ALTER access,
// column/index defs, FROM atoms) are not present in the parsed AST but remain
// accepted by this public API, so they are routed to their formatters here.
export function formatNode(astNode: WithoutLocations<ASTNode>, indent: string = ''): string {
  // The parsed AST is entirely ClickHouse-native, discriminated by a string
  // `type`. OrderBy/Interpolate elements and statements have dedicated
  // formatters; everything else is an expression. The formatter never reads
  // `location`, so the location-free input is treated as the located type.
  const typed = astNode as Expression | OrderByElementNode | InterpolateElementNode | Statement;
  if (typed.type === 'OrderByElement') return formatOrderByItem(typed, indent);
  if (typed.type === 'InterpolateElement') return formatInterpolateItem(typed, indent);
  if (STATEMENT_TYPES.has(typed.type)) return formatStatement(typed as Statement, indent);
  return formatExpr(typed as Expression, indent);
}

// Format a comma-separated list of expressions, reading leadingComments/trailingComments
// from each expression node. Returns [formatted string, end comments].
// End comments are trailing comments on the very last item — they must be placed after
// the statement's semicolon to avoid being swallowed by the comment.
function formatExprList(items: Expression[], indent: string): [string, string[]] {
  const parts: string[] = [];
  const endComments: string[] = [];
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    const isLast = i === items.length - 1;
    const comma = isLast ? '' : ',';
    // Leading comments: on their own lines before the item
    if (item.leadingComments && item.leadingComments.length > 0) {
      for (const c of item.leadingComments) {
        parts.push(`${indent}${c}`);
      }
    }
    // Trailing comments on the last item are returned separately
    if (isLast && item.trailingComments && item.trailingComments.length > 0) {
      parts.push(`${indent}${formatExprCore(item, indent)}`);
      endComments.push(...item.trailingComments);
    } else if (item.trailingComments && item.trailingComments.length > 0) {
      parts.push(`${indent}${formatExprCore(item, indent)}${comma} ${item.trailingComments[0]}`);
      for (let c = 1; c < item.trailingComments.length; c++) {
        parts.push(`${indent}${item.trailingComments[c]}`);
      }
    } else {
      parts.push(`${indent}${formatExprCore(item, indent)}${comma}`);
    }
  }
  return [parts.join('\n'), endComments];
}

// Format a single function argument, wrapping a lambda in parens so the
// preceding/following comma doesn't get absorbed into the lambda's param
// list on reparse (`f(x, y -> z)` would otherwise parse as `f((x, y) -> z)`).
function formatFunctionArg(a: Expression, indent: string): string {
  const s = formatExprCore(a, indent);
  if (a.type === 'Function' && a.is_lambda_function === true && a.is_operator === true) {
    return `(${s})`;
  }
  return s;
}

// Format a comma-separated list of expressions for function args.
// Uses inline format when no comments are present, multiline otherwise.
function formatArgList(items: Expression[], indent: string): string {
  const hasComments = items.some(
    (a) =>
      (a.leadingComments && a.leadingComments.length > 0) ||
      (a.trailingComments && a.trailingComments.length > 0),
  );
  if (!hasComments) {
    return items.map((a) => formatFunctionArg(a, indent)).join(', ');
  }
  const parts: string[] = [];
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    const comma = i < items.length - 1 ? ',' : '';
    if (item.leadingComments && item.leadingComments.length > 0) {
      for (const c of item.leadingComments) {
        parts.push(`${indent}${c}`);
      }
    }
    if (item.trailingComments && item.trailingComments.length > 0) {
      parts.push(
        `${indent}${formatFunctionArg(item, indent)}${comma} ${item.trailingComments.join(' ')}`,
      );
    } else {
      parts.push(`${indent}${formatFunctionArg(item, indent)}${comma}`);
    }
  }
  return '\n' + parts.join('\n') + '\n';
}

// ── Access-control formatting ────────────────────────────────────────────────
// The access query nodes expose only ClickHouse-native fields. `format()`
// renders each `AccessQueryNode` directly from those native fields (via the
// `native*` extraction helpers below), accepting ClickHouse's canonical form
// for the lossy bits the native AST drops (clause order, privilege aliases,
// quota durations normalized to seconds, host source spellings, ...).

function nativeSetToTarget(set: RolesOrUsersSetNode | undefined): RoleTarget | undefined {
  if (!set) return undefined;
  if (set.all) return { kind: 'all', except: set.except_names };
  const names: string[] = [];
  if (set.names) names.push(...set.names);
  if (set.current_user) names.push('CURRENT_USER');
  if (names.length > 0) return { kind: 'names', names };
  return { kind: 'none' };
}

/** Plain name list (GRANT roles/grantees) from a native `RolesOrUsersSet`. */
function nativeSetToNames(set: RolesOrUsersSetNode | undefined): string[] {
  const names: string[] = [];
  if (set?.names) names.push(...set.names);
  if (set?.current_user) names.push('CURRENT_USER');
  return names;
}

function nativeAuthToAuth(
  methods: NativeAuthenticationData[] | undefined,
): AuthenticationData[] | undefined {
  if (!methods) return undefined;
  return methods.map((m) => {
    if (m.auth_type === 'SSH_KEY') {
      return {
        sshKeys: (m.arguments ?? []).map((k) => ({
          key: k.key_base64 ?? '',
          type: k.key_type ?? '',
        })),
      };
    }
    const secret = m.arguments?.[0]?.value;
    if (secret === undefined) return {}; // NO_PASSWORD / NOT IDENTIFIED
    // Reconstruct the source auth keyword and secret introducer from the native
    // `auth_type` enum plus the `contains_hash`/`contains_password` flags (the
    // inverse of the grammar's mapping), so `format()` re-emits the `WITH`
    // qualifier and the field round-trips exactly.
    switch (m.auth_type) {
      case 'PLAINTEXT_PASSWORD':
        return { secret, authType: 'plaintext_password' };
      case 'SHA256_PASSWORD':
        return { secret, authType: m.contains_hash ? 'sha256_hash' : 'sha256_password' };
      case 'DOUBLE_SHA1_PASSWORD':
        return { secret, authType: m.contains_hash ? 'double_sha1_hash' : 'double_sha1_password' };
      case 'BCRYPT_PASSWORD':
        return { secret, authType: m.contains_hash ? 'bcrypt_hash' : 'bcrypt_password' };
      case 'KERBEROS':
        return { secret, authType: 'kerberos', secretKeyword: 'REALM' as const };
      case 'LDAP':
        return { secret, authType: 'ldap', secretKeyword: 'SERVER' as const };
      default:
        // No `auth_type` — a bare `IDENTIFIED BY '...'` (server-default method).
        return { secret };
    }
  });
}

/** `VALID UNTIL` value carried on a native AuthenticationData node, if any. */
function nativeValidUntil(methods: NativeAuthenticationData[] | undefined): string | undefined {
  return methods?.find((m) => m.valid_until !== undefined)?.valid_until;
}

// ── Native → structured reverse converters ──────────────────────────────────

/** Native `UserNamesWithHost` → `AccessControlName[]` (host quoted for re-parse). */
function nativeUserNamesToNames(names: UserNamesWithHostNode | undefined): AccessControlName[] {
  return (names?.users ?? []).map((u) =>
    u.host_pattern !== undefined
      ? { name: u.name ?? '', host: `'${u.host_pattern}'` }
      : { name: u.name ?? '' },
  );
}

/** Native plain string name list → `AccessControlName[]`. */
function nativeStringNamesToNames(names: string[] | undefined): AccessControlName[] {
  return (names ?? []).map((n) => ({ name: n }));
}

/** Native `hosts` object → `HostItem[]` (empty object → `HOST NONE`). */
function nativeHostsToItems(hosts: NativeHosts | undefined): HostItem[] | undefined {
  if (hosts === undefined) return undefined;
  const items: HostItem[] = [];
  if (hosts.any_host) items.push({ kind: 'any' });
  if (hosts.local_host) items.push({ kind: 'local' });
  for (const v of hosts.names ?? []) items.push({ kind: 'name', value: v });
  for (const v of hosts.name_regexps ?? []) items.push({ kind: 'regexp', value: v });
  for (const v of hosts.like_patterns ?? []) items.push({ kind: 'like', value: v });
  for (const v of hosts.addresses ?? []) items.push({ kind: 'ip', value: v });
  for (const v of hosts.subnets ?? []) items.push({ kind: 'ip', value: v });
  if (items.length === 0) items.push({ kind: 'none' });
  return items;
}

function literalExpr(
  valueType: LiteralNode['value_type'],
  value: LiteralNode['value'],
): LiteralNode {
  // Synthetic literal built for formatting only (never read for its location).
  return { type: 'Literal', value_type: valueType, value } as LiteralNode;
}

/** Native settings/limit scalar → a `Literal` expression that re-emits it. */
function nativeScalarToExpr(v: string | number | null): Expression {
  if (v === null) return literalExpr('Null', null);
  if (typeof v === 'number') return literalExpr('Float64', v);
  if (/^-?[0-9]+$/.test(v)) return literalExpr(v.startsWith('-') ? 'Int64' : 'UInt64', v);
  return literalExpr('String', v);
}

/** Native `SettingsProfileElements` → access-control settings ('NONE' if empty). */
function nativeSettingsToItems(
  settings: SettingsProfileElementsNode | undefined,
): AccessControlSettingsItem[] | 'NONE' | undefined {
  if (settings === undefined) return undefined;
  const elements = settings.elements ?? [];
  if (elements.length === 0) return 'NONE';
  return elements.map((e: SettingsProfileElementNode): AccessControlSettingsItem => {
    if (e.parent_profile !== undefined) return { kind: 'profile', name: e.parent_profile };
    const item: AccessControlSettingsItem = { kind: 'setting', name: e.setting_name ?? '' };
    if (e.value !== undefined) item.value = nativeScalarToExpr(e.value);
    if (e.min_value !== undefined) item.min = nativeScalarToExpr(e.min_value);
    if (e.max_value !== undefined) item.max = nativeScalarToExpr(e.max_value);
    if (e.writability !== undefined)
      item.modifier = e.writability as 'CONST' | 'WRITABLE' | 'READONLY';
    return item;
  });
}

/** Native `AlterSettingsProfileElements` → access-control settings ('NONE' if no adds). */
function nativeAlterSettingsToItems(
  alter: AlterSettingsProfileElementsNode,
): AccessControlSettingsItem[] | 'NONE' {
  if (alter.add_settings === undefined) return 'NONE';
  const items = nativeSettingsToItems(alter.add_settings);
  return items === undefined || items === 'NONE' ? 'NONE' : items;
}

function nativeDatabaseOrNone(db: DatabaseOrNoneNode | undefined): string | undefined {
  if (db === undefined) return undefined;
  return db.database ?? 'NONE';
}

/** Native ALTER USER fields → an ordered `AlterUserClause[]` (canonical order). */
function nativeAlterUserClauses(n: CreateUserQueryNode): AlterUserClause[] {
  const clauses: AlterUserClause[] = [];
  if (n.new_name !== undefined) clauses.push({ kind: 'rename', to: { name: n.new_name } });
  if (n.authentication_methods !== undefined) {
    const auth = nativeAuthToAuth(n.authentication_methods) ?? [];
    const empty = auth.length === 1 && !auth[0].secret && auth[0].sshKeys === undefined;
    if (empty) clauses.push({ kind: 'notIdentified' });
    else clauses.push({ kind: 'identified', auth });
    const vu = nativeValidUntil(n.authentication_methods);
    if (vu !== undefined) clauses.push({ kind: 'validUntil', value: vu });
  }
  if (n.hosts !== undefined)
    clauses.push({ kind: 'host', hosts: nativeHostsToItems(n.hosts) ?? [] });
  if (n.add_hosts !== undefined)
    clauses.push({ kind: 'host', mode: 'ADD', hosts: nativeHostsToItems(n.add_hosts) ?? [] });
  if (n.remove_hosts !== undefined)
    clauses.push({ kind: 'host', mode: 'DROP', hosts: nativeHostsToItems(n.remove_hosts) ?? [] });
  if (n.alter_settings !== undefined)
    clauses.push({ kind: 'settings', settings: nativeAlterSettingsToItems(n.alter_settings) });
  if (n.default_roles !== undefined)
    clauses.push({
      kind: 'defaultRole',
      roles: nativeSetToTarget(n.default_roles) ?? { kind: 'none' },
    });
  const ddb = nativeDatabaseOrNone(n.default_database);
  if (ddb !== undefined) clauses.push({ kind: 'defaultDatabase', database: ddb });
  if (n.grantees !== undefined)
    clauses.push({ kind: 'grantees', grantees: nativeSetToTarget(n.grantees) ?? { kind: 'none' } });
  return clauses;
}

/** Native quota `key_type` enum → structured KEYED clause. */
function nativeKeyTypeToKeyed(
  keyType: string | undefined,
): { notKeyed: true } | { keys: string[] } | undefined {
  if (keyType === undefined) return undefined;
  if (keyType === 'NONE') return { notKeyed: true };
  return { keys: keyType.toLowerCase().split('_or_') };
}

type QuotaInterval = {
  randomized?: boolean;
  duration: string;
  unit: string;
  trackingOnly?: boolean;
  noLimits?: boolean;
  limits?: { name: string; value: Expression }[];
};

/** Native quota `limits` → structured intervals (durations canonicalized to SECOND). */
function nativeLimitsToIntervals(
  limits: NativeQuotaLimit[] | undefined,
): QuotaInterval[] | undefined {
  if (limits === undefined) return undefined;
  return limits.map((l) => {
    const iv: QuotaInterval = {
      duration: l.duration_sec,
      unit: 'SECOND',
    };
    if (l.randomize_interval) iv.randomized = true;
    if (l.max) {
      iv.limits = Object.entries(l.max).map(([name, val]) => ({
        name,
        value:
          name === 'EXECUTION_TIME'
            ? literalExpr('Float64', Number(val) / 1e9)
            : nativeScalarToExpr(val),
      }));
    } else if (l.drop) {
      iv.noLimits = true;
    } else {
      // An interval with neither limits nor an explicit drop is, in
      // ClickHouse's canonical form, a tracking-only interval.
      iv.trackingOnly = true;
    }
    return iv;
  });
}

/** Native `access_rights` entry → a single-privilege `GrantElement`. */
function nativeAccessRightToElement(r: NativeAccessRight): GrantElement {
  const priv: GrantPrivilege = {
    name: r.access_types && r.access_types.length > 0 ? r.access_types[0] : 'NONE',
  };
  if (r.columns) priv.columns = r.columns;
  let target: GrantTarget;
  if (r.parameter !== undefined) {
    target = { table: r.parameter };
  } else if (r.default_database) {
    const tbl = r.table === undefined ? '*' : r.wildcard ? r.table + '*' : r.table;
    target = { table: tbl };
  } else if (r.database !== undefined) {
    let db = r.database;
    let tbl = r.table;
    if (r.wildcard) {
      if (tbl !== undefined) tbl = tbl + '*';
      else {
        db = db + '*';
        tbl = '*';
      }
    } else if (tbl === undefined) {
      tbl = '*';
    }
    target = { database: db, table: tbl };
  } else {
    target = { database: '*', table: '*' };
  }
  return { privileges: [priv], target };
}

/** Native GRANT/REVOKE node → structured {@link GrantStatement}. */
function nativeGrantToStatement(n: GrantQueryNode): GrantStatement {
  const operation: 'GRANT' | 'REVOKE' = n.type === 'RevokeQuery' ? 'REVOKE' : 'GRANT';
  const stmt = {
    kind: 'grant',
    operation,
    grantees: nativeSetToNames(n.grantees),
  } as GrantStatement;
  const withOptions: ('GRANT' | 'ADMIN' | 'REPLACE')[] = [];
  let grantOption = false;
  if (n.access_rights !== undefined) {
    stmt.elements = n.access_rights.map(nativeAccessRightToElement);
    grantOption = n.access_rights.some((r) => r.grant_option);
    if (n.replace_access) withOptions.push('REPLACE');
  } else {
    const roles = nativeSetToNames(n.roles);
    stmt.roles = roles.length > 0 ? roles : ['NONE'];
    if (n.replace_granted_roles) withOptions.push('REPLACE');
  }
  if (grantOption) {
    if (operation === 'REVOKE') stmt.optionFor = 'GRANT';
    else withOptions.unshift('GRANT');
  }
  if (n.cluster !== undefined) stmt.onCluster = n.cluster;
  if (withOptions.length > 0) stmt.withOptions = withOptions;
  return stmt;
}

type RowPolicyTarget = { names: string[]; table: TableRef };

/** Native `RowPolicyNames` → structured row-policy targets. */
function nativeRowPolicyTargets(names: RowPolicyNamesNode | undefined): RowPolicyTarget[] {
  return (names?.policies ?? []).map((p) => ({
    names: [p.short_name],
    table: {
      kind: 'tableRef',
      table: p.table ?? '*',
      ...(p.database !== undefined ? { database: p.database } : {}),
    } as TableRef,
  }));
}

/** Dispatch an access-control query node directly to its native formatter. */
function formatAccessQuery(node: AccessQueryNode, indent: string): string {
  const alter = node.alter === true;
  switch (node.type) {
    case 'CreateUserQuery':
      return alter ? formatAlterAccessQuery(node, indent) : formatCreateUserQuery(node, indent);
    case 'CreateRoleQuery':
      return alter ? formatAlterAccessQuery(node, indent) : formatCreateRoleQuery(node, indent);
    case 'CreateQuotaQuery':
      return alter ? formatAlterAccessQuery(node, indent) : formatCreateQuotaQuery(node, indent);
    case 'CreateSettingsProfileQuery':
      return alter
        ? formatAlterAccessQuery(node, indent)
        : formatCreateSettingsProfileQuery(node, indent);
    case 'CreateRowPolicyQuery':
      return alter
        ? formatAlterAccessQuery(node, indent)
        : formatCreateRowPolicyQuery(node, indent);
    case 'GrantQuery':
    case 'RevokeQuery':
      return formatGrantQuery(node, indent);
    case 'SetRoleQuery':
      return formatSetRoleQuery(node, indent);
    default:
      throw new Error(`formatAccessQuery: unexpected node type ${node.type}`);
  }
}

// Switching on `stmt.type` (rather than a hoisted local) lets TypeScript narrow
// the discriminated `Statement` union per case, so the branches need no casts.
function formatStatement(stmt: Statement, indent: string): string {
  switch (stmt.type) {
    case 'SelectWithUnionQuery':
      return formatSelectWithUnion(stmt, indent);
    case 'SelectIntersectExceptQuery':
      return formatIntersectExcept(stmt, indent);
    case 'Settings':
      return formatSetStatement(stmt, indent);
    case 'InsertQuery':
      return formatInsertQuery(stmt, indent);
    case 'Explain':
      return formatExplainQuery(stmt, indent);
    case 'UseQuery':
      return `${indent}USE ${formatPlainIdent(stmt.database)}`;
    case 'TransactionControl':
      if (stmt.action === 'BEGIN') return `${indent}BEGIN TRANSACTION`;
      if (stmt.action === 'COMMIT') return `${indent}COMMIT`;
      if (stmt.action === 'ROLLBACK') return `${indent}ROLLBACK`;
      return `${indent}SET TRANSACTION SNAPSHOT ${stmt.snapshot ?? ''}`;
    case 'ExecuteAsQuery':
      return `${indent}EXECUTE AS ${quoteIdent(stmt.target_user.name ?? '')} ${formatStatement(stmt.subquery as Statement, indent)}`;
    case 'OptimizeQuery':
      return formatOptimizeQuery(stmt, indent);
    case 'DescribeQuery':
      return formatDescribeQuery(stmt, indent);
    case 'ShowCreateTableQuery':
    case 'ShowCreateViewQuery':
    case 'ShowCreateDictionaryQuery':
    case 'ShowCreateDatabaseQuery':
      return formatShowCreateQuery(stmt, indent);
    case 'ExistsTableQuery':
    case 'ExistsViewQuery':
    case 'ExistsDictionaryQuery':
    case 'ExistsDatabaseQuery':
      return formatExistsQuery(stmt, indent);
    case 'CheckQuery':
    case 'CheckAllQuery':
      return formatCheckQuery(stmt, indent);
    case 'AttachQuery':
      // Schema-form ATTACH reuses the CreateQuery shape (native fields).
      return isSchemaFormAttach(stmt)
        ? formatCreateQueryNode(stmt as unknown as CreateLikeNode, indent)
        : formatAttachQuery(stmt, indent);
    case 'Rename':
      return formatRenameQuery(stmt, indent);
    case 'KillQueryQuery':
      return formatKillQueryQuery(stmt, indent);
    case 'DeleteQuery':
      return formatDeleteQuery(stmt, indent);
    case 'UpdateQuery':
      return formatUpdateQuery(stmt, indent);
    case 'DropFunctionQuery': {
      let result = `${indent}DROP FUNCTION`;
      if (stmt.if_exists) result += ' IF EXISTS';
      result += ` ${quoteIdent(stmt.function_name)}`;
      if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
      return result;
    }
    case 'DropQuery':
    case 'DetachQuery':
    case 'TruncateQuery':
    case 'UndropQuery':
      return formatDropFamily(stmt, indent);
    case 'CreateQuery':
      return formatCreateQueryNode(stmt, indent);
    case 'CreateFunctionQuery':
      return formatCreateFunctionQuery(stmt, indent);
    case 'CreateIndexQuery':
      return formatCreateIndexQuery(stmt, indent);
    case 'AlterQuery':
      return formatAlterQueryNative(stmt, indent);
    case 'SYSTEM':
      return formatSystemQuery(stmt, indent);
    case 'SHOW':
    case 'ShowTables':
    case 'ShowColumns':
    case 'ShowIndexes':
    case 'ShowFunctions':
    case 'ShowSetting':
    case 'ShowEngineQuery':
    case 'ShowAccessQuery':
    case 'ShowAccessEntitiesQuery':
    case 'ShowProcesslistQuery':
    case 'ShowGrantsQuery':
    case 'ShowPrivilegesQuery':
    case 'ShowCreateNamedCollectionQuery':
    case 'ShowCreateAccessEntityQuery':
      return formatShowFamilyQuery(stmt, indent);
    case 'DropNamedCollectionQuery':
    case 'DropWorkloadQuery':
    case 'DropResourceQuery': {
      // Fully structured natively — re-emit from the native fields (name +
      // IF EXISTS + ON CLUSTER) rather than verbatim text.
      const keyword =
        stmt.type === 'DropNamedCollectionQuery'
          ? 'NAMED COLLECTION'
          : stmt.type === 'DropWorkloadQuery'
            ? 'WORKLOAD'
            : 'RESOURCE';
      const name = stmt.collection_name ?? stmt.workload_name ?? stmt.resource_name ?? '';
      let s = `${indent}DROP ${keyword}`;
      if (stmt.if_exists) s += ' IF EXISTS';
      s += ` ${quoteIdent(name)}`;
      if (stmt.cluster) s += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
      return s;
    }
    case 'DropAccessEntityQuery': {
      let s = `${indent}DROP ${stmt.entity_type}`;
      if (stmt.if_exists) s += ' IF EXISTS';
      if (stmt.entity_type === 'ROW POLICY') {
        const policies = (stmt.row_policy_names?.policies ?? []).map((p) => {
          const table = p.table !== undefined ? quoteIdent(p.table) : '*';
          const target = p.database !== undefined ? `${quoteIdent(p.database)}.${table}` : table;
          return `${quoteIdent(p.short_name)} ON ${target}`;
        });
        s += ` ${policies.join(', ')}`;
        if (stmt.cluster) s += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
        if (stmt.storage_name) s += ` FROM ${quoteIdent(stmt.storage_name)}`;
      } else {
        s += ` ${(stmt.names ?? []).map(quoteIdent).join(', ')}`;
        // ClickHouse only accepts `FROM <storage>` before `ON CLUSTER` here.
        if (stmt.storage_name) s += ` FROM ${quoteIdent(stmt.storage_name)}`;
        if (stmt.cluster) s += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
      }
      return s;
    }
    // The non-access entities NAMED COLLECTION / WORKLOAD / RESOURCE are
    // formatted directly from their native fields (no kind-based intermediate).
    case 'CreateNamedCollectionQuery':
      return formatNamedCollectionQuery(stmt, indent);
    case 'CreateWorkloadQuery':
      return formatWorkloadQuery(stmt, indent);
    case 'CreateResourceQuery':
      return formatResourceQuery(stmt, indent);
    case 'CreateUserQuery':
    case 'CreateRoleQuery':
    case 'CreateQuotaQuery':
    case 'CreateSettingsProfileQuery':
    case 'CreateRowPolicyQuery':
    case 'GrantQuery':
    case 'RevokeQuery':
    case 'SetRoleQuery':
      // Rendered directly from the native AccessQueryNode fields.
      return formatAccessQuery(stmt, indent);
    case 'BackupQuery':
    case 'RestoreQuery':
      return formatBackupStatement(stmt, indent);
    case 'DropIndexQuery': {
      const tableRef =
        stmt.database !== undefined
          ? `${formatPlainIdent(stmt.database)}.${formatPlainIdent(stmt.table)}`
          : formatPlainIdent(stmt.table);
      let result = `${indent}DROP INDEX`;
      if (stmt.if_exists) result += ' IF EXISTS';
      result += ` ${formatPlainIdent(stmt.index_name)} ON ${tableRef}`;
      return result;
    }
    case 'ParallelWithQuery':
      return stmt.children
        .map((q) => formatStatement(q as Statement, indent))
        .join('\nPARALLEL WITH\n');
    default:
      return '';
  }
}

// Format a single scalar value from Set.changes as it should appear in a
// `name = value` SETTINGS pair. The Set node lost the original Expression
// structure (matching ClickHouse's native AST), so string values are always
// emitted as quoted string literals; identifier-vs-string and operator/
// function-call expression source forms are not recoverable.
function formatSettingScalar(
  v: string | number | boolean | null | LiteralElement[] | Record<string, LiteralElement>,
): string {
  if (v === null) return 'NULL';
  // Array/tuple-valued settings are stored as a typed element list; render
  // them as the canonical array literal (e.g. `[1, 2, 3]`).
  if (Array.isArray(v)) return formatLiteralValue('Array', v, undefined);
  // Map-valued settings (e.g. `additional_table_filters`) are stored as a map
  // object {key: {value_type, value}}; render as `[('key', value), ...]`.
  if (typeof v === 'object') {
    const pairs = Object.entries(v).map(
      ([k, el]) =>
        `('${escapeString(k)}', ${formatLiteralValue(el.value_type, el.value, el.nonfinite)})`,
    );
    return `[${pairs.join(', ')}]`;
  }
  if (typeof v === 'boolean') return v ? 'true' : 'false';
  if (typeof v === 'number') {
    if (Number.isNaN(v)) return 'nan';
    if (v === Infinity) return 'inf';
    if (v === -Infinity) return '-inf';
    // Float64 setting values are stored as JS numbers — spell integers with a
    // trailing `.` so they re-parse as Float64 (not UInt64).
    return Number.isInteger(v) ? `${v}.` : String(v);
  }
  // String-stored setting values — including UInt64/Int64 kept as decimal
  // strings — are emitted quoted. ClickHouse accepts the quoted form for
  // numeric settings and coerces it, so format() canonicalizes `x = 8` to
  // `x = '8'` rather than recovering the original unquoted spelling.
  return `'${escapeString(v)}'`;
}

// Render the `name = value` pairs of a Set node (changes first in insertion
// order, then any `DEFAULT` resets). Returns an empty array when the Set
// carries nothing renderable.
function formatSetPairs(set: SettingsNode): string[] {
  const pairs: string[] = [];
  if (set.changes !== undefined) {
    for (const name of Object.keys(set.changes)) {
      pairs.push(`${name} = ${formatSettingScalar(set.changes[name])}`);
    }
  }
  if (set.default_settings !== undefined) {
    for (const name of set.default_settings) {
      pairs.push(`${name} = DEFAULT`);
    }
  }
  return pairs;
}

function formatSetStatement(stmt: SettingsNode, indent: string): string {
  return `${indent}SET ${formatSetPairs(stmt).join(', ')}`;
}

function formatSetRoleQuery(node: SetRoleQueryNode, indent: string): string {
  const roles = nativeSetToTarget(node.roles) ?? { kind: 'none' as const };
  const users: string[] = (node.to_users && node.to_users.names) || [];
  return `${indent}SET DEFAULT ROLE ${formatRoleTarget(roles)} TO ${users.join(', ')}`;
}

function formatRoleTarget(target: RoleTarget): string {
  switch (target.kind) {
    case 'all':
      return target.except && target.except.length > 0
        ? `ALL EXCEPT ${target.except.join(', ')}`
        : 'ALL';
    case 'none':
      return 'NONE';
    case 'names':
      return target.names.join(', ');
  }
}

function formatAccessControlName(name: AccessControlName): string {
  // Names starting with ', ", `, or { are already quoted/special
  const n = /^['"`{]/.test(name.name) ? name.name : quoteIdent(name.name);
  return name.host ? `${n}@${name.host}` : n;
}

function formatAccessControlNames(names: AccessControlName[]): string {
  return names.map(formatAccessControlName).join(', ');
}

function formatHostItems(items: HostItem[]): string {
  const parts: string[] = [];
  for (const item of items) {
    switch (item.kind) {
      case 'any':
        parts.push('ANY');
        break;
      case 'none':
        parts.push('NONE');
        break;
      case 'local':
        parts.push('LOCAL');
        break;
      case 'name':
        parts.push(`NAME '${item.value}'`);
        break;
      case 'regexp':
        parts.push(`REGEXP '${item.value}'`);
        break;
      case 'like':
        parts.push(`LIKE '${item.value}'`);
        break;
      case 'ip':
        parts.push(`IP '${item.value}'`);
        break;
    }
  }
  return parts.join(', ');
}

function formatAccessControlSettingsItem(item: AccessControlSettingsItem, indent: string): string {
  switch (item.kind) {
    case 'profile':
      return `PROFILE ${item.name}`;
    case 'inherit':
      return `INHERIT ${item.name}`;
    case 'setting': {
      let result = item.name;
      if (item.value !== undefined) result += `=${formatExpr(item.value, indent)}`;
      if (item.min !== undefined) result += ` MIN ${formatExpr(item.min, indent)}`;
      if (item.max !== undefined) result += ` MAX ${formatExpr(item.max, indent)}`;
      if (item.modifier) result += ` ${item.modifier}`;
      return result;
    }
  }
}

function formatAccessControlSettings(
  settings: AccessControlSettingsItem[] | 'NONE',
  indent: string,
): string {
  if (settings === 'NONE') return 'NONE';
  return settings.map((s) => formatAccessControlSettingsItem(s, indent)).join(', ');
}

// Render a `PARTITION ...` clause from an AST Partition / Partition_ID node.
function formatPartitionClause(partition: PartitionNode | PartitionIdNode, indent: string): string {
  if (partition.type === 'Partition_ID') {
    if (partition.all) return 'PARTITION ALL';
    if (partition.id !== undefined) return `PARTITION ID ${formatExpr(partition.id, indent)}`;
    return 'PARTITION';
  }
  return `PARTITION ${formatExpr(partition.value, indent)}`;
}

// ALTER command types whose trailing clause is an open-ended comma list /
// expression: unparenthesized, they greedily swallow the following command's
// leading comma and fail to parse. ClickHouse's `ALTER` command list is
// all-or-nothing parenthesized, so the whole list must be wrapped when any such
// command is not last. See docs/underscore-fields.md, "Case study:
// _command_parens".
const ABSORBING_ALTER_COMMANDS = new Set([
  'MODIFY_SETTING',
  'RESET_SETTING',
  'MODIFY_TTL',
  'MODIFY_QUERY',
]);

/**
 * Derives whether a multi-command `ALTER`'s commands must be wrapped in `(...)`
 * from the command_type sequence alone (the native AST drops the source parens).
 * Wrapping is required — and, being all-or-nothing, applied to every command —
 * iff some non-last command has an open-ended trailing list.
 */
function alterCommandsNeedParens(commands: AlterCommandNode[]): boolean {
  return commands.some(
    (c, i) => i < commands.length - 1 && ABSORBING_ALTER_COMMANDS.has(c.command_type),
  );
}

function formatAlterQueryNative(node: AlterQueryNode, indent: string): string {
  const fmtId = (x: Expression): string => formatExpr(x, indent);
  let target: string;
  if (node.alter_object === 'DATABASE') {
    target = `DATABASE ${fmtId(node.database!)}`;
  } else {
    const ref = node.database
      ? `${fmtId(node.database)}.${fmtId(node.table!)}`
      : fmtId(node.table!);
    target = `TABLE ${ref}`;
  }
  let result = `${indent}ALTER ${target}`;
  if (node.cluster) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;
  const cmdNodes = node.commands;
  const wrap = alterCommandsNeedParens(cmdNodes);
  const commands = cmdNodes.map((c) => {
    const s = formatAlterCommandNative(c, indent);
    return wrap ? `(${s})` : s;
  });
  result += ` ${commands.join(', ')}`;
  if (node.settings !== undefined) {
    const pairs = formatSetPairs(node.settings);
    if (pairs.length > 0) result += ` SETTINGS ${pairs.join(', ')}`;
  }
  if (node.format !== undefined) result += ` FORMAT ${node.format}`;
  return result;
}

function formatAlterCommandNative(nc: AlterCommandNode, indent: string): string {
  const fmtId = (x: Expression): string => formatExpr(x, indent);
  const ifExists = nc.if_exists ? ' IF EXISTS' : '';
  const ifNotExists = nc.if_not_exists ? ' IF NOT EXISTS' : '';
  const qualify = (db: string | undefined, tbl: string): string =>
    db ? `${quoteIdent(db)}.${quoteIdent(tbl)}` : quoteIdent(tbl);
  // `IN PARTITION ...` suffix (partition is a `Partition`/`Partition_ID` node here).
  const inPartition =
    nc.partition && !nc.part
      ? ` IN ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`
      : '';

  switch (nc.command_type) {
    case 'ADD_COLUMN': {
      let s = `ADD COLUMN${ifNotExists} ${formatColumnDeclNode(nc.column_declaration!, '')}`;
      if (nc.column) s += ` AFTER ${fmtId(nc.column)}`;
      else if (nc.first) s += ` FIRST`;
      return s;
    }
    case 'DROP_COLUMN':
      return `${nc.clear_column ? 'CLEAR' : 'DROP'} COLUMN${ifExists} ${fmtId(nc.column!)}${inPartition}`;
    case 'MODIFY_COLUMN': {
      let s = `MODIFY COLUMN${ifExists} ${formatColumnDeclNode(nc.column_declaration!, '')}`;
      if (nc.remove_property) s += ` REMOVE ${nc.remove_property}`;
      if (nc.settings_changes)
        s += ` MODIFY SETTING ${formatSetPairs(nc.settings_changes).join(', ')}`;
      if (nc.settings_resets)
        s += ` RESET SETTING ${nc.settings_resets.children.map(fmtId).join(', ')}`;
      if (nc.column) s += ` AFTER ${fmtId(nc.column)}`;
      else if (nc.first) s += ` FIRST`;
      return s;
    }
    case 'RENAME_COLUMN':
      return `RENAME COLUMN${ifExists} ${fmtId(nc.column!)} TO ${fmtId(nc.rename_to!)}`;
    case 'COMMENT_COLUMN':
      return `COMMENT COLUMN${ifExists} ${fmtId(nc.column!)} ${formatExpr(nc.comment!, indent)}`;
    case 'MATERIALIZE_COLUMN':
      return `MATERIALIZE COLUMN ${fmtId(nc.column!)}${inPartition}`;
    case 'ADD_INDEX': {
      let s = `ADD INDEX${ifNotExists} ${formatNativeIndexElem(nc.index_declaration!, '').replace(/^INDEX /, '')}`;
      if (nc.index) s += ` AFTER ${fmtId(nc.index)}`;
      else if (nc.first) s += ` FIRST`;
      return s;
    }
    case 'DROP_INDEX':
      return `${nc.clear_index ? 'CLEAR' : 'DROP'} INDEX${ifExists} ${fmtId(nc.index!)}${inPartition}`;
    case 'MATERIALIZE_INDEX':
      return `MATERIALIZE INDEX${ifExists} ${fmtId(nc.index!)}${inPartition}`;
    case 'ADD_PROJECTION':
      return `ADD PROJECTION${ifNotExists} ${formatNativeProjection(nc.projection_declaration!, '').replace(/^PROJECTION /, '')}`;
    case 'DROP_PROJECTION':
      return `${nc.clear_projection ? 'CLEAR' : 'DROP'} PROJECTION${ifExists} ${fmtId(nc.projection!)}${inPartition}`;
    case 'MATERIALIZE_PROJECTION':
      return `MATERIALIZE PROJECTION${ifExists} ${fmtId(nc.projection!)}${inPartition}`;
    case 'ADD_CONSTRAINT': {
      const cd = nc.constraint_declaration!;
      return `ADD CONSTRAINT${ifNotExists} ${quoteIdent(cd.name)} ${cd.constraint_type} ${formatExpr(cd.expression, indent)}`;
    }
    case 'DROP_CONSTRAINT':
      return `DROP CONSTRAINT${ifExists} ${fmtId(nc.constraint!)}`;
    case 'ADD_STATISTICS':
    case 'MODIFY_STATISTICS': {
      const kw =
        nc.command_type === 'ADD_STATISTICS' ? `ADD STATISTICS${ifNotExists}` : 'MODIFY STATISTICS';
      const sd = nc.statistics_declaration!;
      const cols = (sd.columns?.children ?? []).map(fmtId).join(', ');
      // Statistics types are native Function nodes rendered as bare type names
      // (STATISTICS types never carry arguments in ClickHouse's canonical form).
      const types = (sd.types?.children ?? [])
        .map((x) => (x.type === 'Function' ? x.name : formatExpr(x, indent)))
        .join(', ');
      return `${kw} ${cols} TYPE ${types}`;
    }
    case 'DROP_STATISTICS': {
      const verb = nc.clear_statistics ? 'CLEAR' : 'DROP';
      const cols = nc.statistics_declaration?.columns?.children;
      if (cols && cols.length > 0)
        return `${verb} STATISTICS${ifExists} ${cols.map(fmtId).join(', ')}`;
      return `${verb} STATISTICS${ifExists} ALL`;
    }
    case 'MATERIALIZE_STATISTICS': {
      const cols = nc.statistics_declaration?.columns?.children;
      if (cols && cols.length > 0)
        return `MATERIALIZE STATISTICS${ifExists} ${cols.map(fmtId).join(', ')}`;
      return `MATERIALIZE STATISTICS${ifExists} ALL`;
    }
    case 'UPDATE': {
      const assigns = (nc.assignments ?? [])
        .map((a) => `${quoteIdent(a.column)} = ${formatExpr(a.expression, indent)}`)
        .join(', ');
      return `UPDATE ${assigns}${inPartition} WHERE ${formatExpr(nc.predicate!, indent)}`;
    }
    case 'DELETE':
      return `DELETE${inPartition} WHERE ${formatExpr(nc.predicate!, indent)}`;
    case 'DROP_PARTITION': {
      const kw = nc.detach ? 'DETACH' : 'DROP';
      if (nc.part) return `${kw} PART ${formatExpr(nc.partition as LiteralNode, indent)}`;
      if (nc.partition)
        return `${kw} ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
      return `${kw} PARTITION`;
    }
    case 'ATTACH_PARTITION':
      if (nc.part) return `ATTACH PART ${formatExpr(nc.partition as LiteralNode, indent)}`;
      if (nc.partition)
        return `ATTACH ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
      return 'ATTACH PARTITION';
    case 'DROP_DETACHED_PARTITION':
      if (nc.part) return `DROP DETACHED PART ${formatExpr(nc.partition as LiteralNode, indent)}`;
      return `DROP DETACHED ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
    case 'REPLACE_PARTITION': {
      // ATTACH ... FROM shares this command type; `replace === false` is ATTACH.
      const verb = nc.replace === false ? 'ATTACH' : 'REPLACE';
      return `${verb} ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)} FROM ${qualify(nc.from_database, nc.from_table!)}`;
    }
    case 'MOVE_PARTITION': {
      let s = `MOVE ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
      if (nc.move_destination_type === 'TABLE')
        s += ` TO TABLE ${qualify(nc.to_database, nc.to_table!)}`;
      else if (nc.move_destination_type)
        s += ` TO ${nc.move_destination_type} ${formatStringLiteral(nc.move_destination_name!)}`;
      return s;
    }
    case 'FETCH_PARTITION': {
      let s = `FETCH ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
      if (nc.from !== undefined) s += ` FROM ${formatStringLiteral(nc.from)}`;
      return s;
    }
    case 'FREEZE_PARTITION': {
      let s = `FREEZE ${formatPartitionClause(nc.partition as PartitionNode | PartitionIdNode, indent)}`;
      if (nc.with_name !== undefined) s += ` WITH NAME ${formatStringLiteral(nc.with_name)}`;
      return s;
    }
    case 'FREEZE_ALL': {
      let s = 'FREEZE';
      if (nc.with_name !== undefined) s += ` WITH NAME ${formatStringLiteral(nc.with_name)}`;
      return s;
    }
    case 'MODIFY_TTL':
      return `MODIFY TTL ${(nc.ttl?.children ?? []).map((el) => formatNativeTTLElement(el, indent)).join(', ')}`;
    case 'REMOVE_TTL':
      return 'REMOVE TTL';
    case 'REMOVE_SAMPLE_BY':
      return 'REMOVE SAMPLE BY';
    case 'MATERIALIZE_TTL':
      return `MATERIALIZE TTL${inPartition}`;
    case 'MODIFY_ORDER_BY':
      return `MODIFY ORDER BY ${formatExpr(nc.order_by!, indent)}`;
    case 'MODIFY_SAMPLE_BY':
      return `MODIFY SAMPLE BY ${formatExpr(nc.sample_by!, indent)}`;
    case 'MODIFY_SETTING':
      return `MODIFY SETTING ${formatSetPairs(nc.settings_changes!).join(', ')}`;
    case 'RESET_SETTING':
      return `RESET SETTING ${(nc.settings_resets?.children ?? []).map(fmtId).join(', ')}`;
    case 'MODIFY_QUERY':
      return `MODIFY QUERY ${formatStatement(nc.select!, indent)}`;
    case 'MODIFY_COMMENT':
      return `MODIFY COMMENT ${formatExpr(nc.comment!, indent)}`;
    case 'MODIFY_REFRESH':
      return `MODIFY REFRESH ${formatRefreshStrategy(nc.refresh!, indent)}`;
    case 'APPLY_DELETED_MASK':
      return `APPLY DELETED MASK${inPartition}`;
    case 'APPLY_PATCHES':
      return `APPLY PATCHES${inPartition}`;
    case 'REWRITE_PARTS':
      return `REWRITE PARTS${inPartition}`;
    default:
      return nc.command_type;
  }
}

// Render the trailing `(NOT) (I)LIKE 'pat'` clause from the native `like` /
// `not_like` / `case_insensitive_like` fields.
function formatShowLikeNative(stmt: ShowFamilyQueryNode): string {
  if (stmt.like === undefined) return '';
  const kw = stmt.case_insensitive_like ? 'ILIKE' : 'LIKE';
  return ` ${stmt.not_like ? 'NOT ' : ''}${kw} ${formatStringLiteral(stmt.like)}`;
}

// `ShowAccessEntitiesQuery` entity_type → the plural SHOW keyword.
const SHOW_ENTITY_PLURAL: Record<string, string> = {
  USER: 'USERS',
  ROLE: 'ROLES',
  QUOTA: 'QUOTAS',
  'SETTINGS PROFILE': 'SETTINGS PROFILES',
  'ROW POLICY': 'ROW POLICIES',
  'NAMED COLLECTION': 'NAMED COLLECTIONS',
  WARNING: 'WARNINGS',
};

// Quote an access-entity name string (already-quoted / special-prefixed names
// pass through, mirroring formatAccessControlName).
function quoteAccessName(n: string): string {
  return /^['"`{]/.test(n) ? n : quoteIdent(n);
}

// Every SHOW variant is rendered from native fields alone.
function formatShowFamilyQuery(stmt: ShowFamilyQueryNode, indent: string): string {
  const fmt = stmt.format ? ` FORMAT ${stmt.format}` : '';
  const q = (body: string): string => `${indent}${body}${fmt}`;

  switch (stmt.type) {
    case 'ShowPrivilegesQuery':
      return q('SHOW PRIVILEGES');
    case 'ShowAccessQuery':
      return q('SHOW ACCESS');
    case 'ShowEngineQuery':
      return q('SHOW ENGINES');
    case 'ShowProcesslistQuery':
      return q('SHOW PROCESSLIST');
    case 'ShowColumns':
    case 'ShowIndexes': {
      const ref =
        stmt.database !== undefined
          ? `${quoteIdent(stmt.database)}.${quoteIdent(stmt.table!)}`
          : quoteIdent(stmt.table!);
      let s = 'SHOW';
      if (stmt.extended) s += ' EXTENDED';
      if (stmt.full) s += ' FULL';
      s += stmt.type === 'ShowColumns' ? ` COLUMNS FROM ${ref}` : ` INDEXES FROM ${ref}`;
      s += formatShowLikeNative(stmt);
      if (stmt.where) s += ` WHERE ${formatExpr(stmt.where as Expression, indent)}`;
      if (stmt.limit) s += ` LIMIT ${formatExpr(stmt.limit as Expression, indent)}`;
      return q(s);
    }
    case 'ShowSetting':
      return q(`SHOW SETTING ${quoteIdent(stmt.setting_name!)}`);
    case 'ShowFunctions':
      return q(`SHOW FUNCTIONS${formatShowLikeNative(stmt)}`);
    case 'ShowTables': {
      let obj: string;
      if (stmt.databases) obj = 'DATABASES';
      else if (stmt.dictionaries) obj = 'DICTIONARIES';
      else if (stmt.clusters) obj = 'CLUSTERS';
      else if (stmt.merges) obj = 'MERGES';
      else if (stmt.cluster) obj = `CLUSTER ${formatStringLiteral(stmt.cluster_str ?? '')}`;
      else if (stmt.show_settings) obj = stmt.changed ? 'CHANGED SETTINGS' : 'SETTINGS';
      else obj = stmt.temporary ? 'TEMPORARY TABLES' : 'TABLES';
      let s = `SHOW ${obj}`;
      if (stmt.from !== undefined) s += ` FROM ${quoteIdent(stmt.from.name)}`;
      s += formatShowLikeNative(stmt);
      if (stmt.where) s += ` WHERE ${formatExpr(stmt.where as Expression, indent)}`;
      if (stmt.limit) s += ` LIMIT ${formatExpr(stmt.limit as Expression, indent)}`;
      if (stmt.settings !== undefined) {
        const pairs = formatSetPairs(stmt.settings);
        if (pairs.length > 0) s += ` SETTINGS ${pairs.join(', ')}`;
      }
      return q(s);
    }
    case 'ShowAccessEntitiesQuery': {
      let obj: string;
      if (stmt.current_roles) obj = 'CURRENT ROLES';
      else if (stmt.enabled_roles) obj = 'ENABLED ROLES';
      else obj = SHOW_ENTITY_PLURAL[stmt.entity_type ?? ''] ?? stmt.entity_type ?? '';
      return q(`SHOW ${obj}`);
    }
    case 'ShowGrantsQuery': {
      let s = 'SHOW GRANTS';
      const fr = stmt.for_roles;
      // A bare `current_user` set is the default and needs no FOR clause.
      if (fr && !(fr.current_user && !fr.names && !fr.all)) {
        const target = nativeSetToTarget(fr);
        if (target) s += ` FOR ${formatRoleTarget(target)}`;
      }
      if (stmt.with_implicit) s += ' WITH IMPLICIT';
      if (stmt.final) s += ' FINAL';
      return q(s);
    }
    case 'ShowCreateNamedCollectionQuery':
      return q(`SHOW CREATE NAMED COLLECTION ${quoteIdent(stmt.collection_name!)}`);
    case 'ShowCreateAccessEntityQuery': {
      let target: string;
      if (stmt.current_user) {
        target = 'CURRENT_USER';
      } else if (stmt.row_policy_names !== undefined) {
        target = nativeRowPolicyTargets(stmt.row_policy_names)
          .map((t) => {
            const tbl = t.table as { table?: string; database?: string } | undefined;
            const names = t.names.join(', ');
            if (tbl && tbl.table !== undefined) {
              const ref =
                tbl.database !== undefined
                  ? `${quoteIdent(tbl.database)}.${quoteIdent(tbl.table)}`
                  : quoteIdent(tbl.table);
              return `${names} ON ${ref}`;
            }
            return names;
          })
          .join(', ');
      } else if (stmt.short_name !== undefined) {
        target = stmt.short_name;
      } else {
        target = (stmt.names ?? []).map(quoteAccessName).join(', ');
      }
      return q(`SHOW CREATE ${stmt.entity_type} ${target}`);
    }
    default:
      return q('SHOW');
  }
}

// Formats the text after the IDENTIFIED keyword from an auth-method array.
// Shared by CREATE USER and ALTER USER (the caller supplies the IDENTIFIED keyword).
//
// The auth-method type is re-emitted as `WITH <authType>` (e.g.
// `WITH sha256_hash`) whenever it was recorded, so the qualifier round-trips;
// a bare `IDENTIFIED BY '...'` (no explicit method) omits it. The secret is
// introduced by `BY`/`REALM`/`SERVER` per {@link AuthenticationData.secretKeyword},
// and SSH keys are reproduced verbatim.
function formatAuthMethods(auth: AuthenticationData[]): string {
  const parts = auth
    .map((a) => {
      if (a.sshKeys !== undefined) {
        const keys = a.sshKeys.map(
          (k) => `KEY '${escapeString(k.key)}' TYPE '${escapeString(k.type)}'`,
        );
        return `WITH ssh_key BY ${keys.join(', ')}`;
      }
      if (a.secret === undefined) return '';
      const secretText = `${a.secretKeyword ?? 'BY'} '${escapeString(a.secret)}'`;
      return a.authType !== undefined ? `WITH ${a.authType} ${secretText}` : secretText;
    })
    .filter(Boolean);
  return parts.join(', ');
}

type AlterAccessStmt =
  | {
      kind: 'alterUser';
      names: AccessControlName[];
      clauses: AlterUserClause[];
      ifExists?: boolean;
      onCluster?: string;
    }
  | {
      kind: 'alterRole';
      names: AccessControlName[];
      onCluster?: string;
      ifExists?: boolean;
      renameTo?: AccessControlName;
      settings?: AccessControlSettingsItem[] | 'NONE';
    }
  | {
      kind: 'alterQuota';
      names: string[];
      keyed?: { notKeyed: true } | { keys: string[] };
      intervals?: QuotaInterval[];
      onCluster?: string;
      to?: RoleTarget;
      ifExists?: boolean;
      renameTo?: string;
    }
  | {
      kind: 'alterRowPolicy';
      hasRowKeyword: boolean;
      targets: RowPolicyTarget[];
      using?: Expression;
      restrictive?: 'RESTRICTIVE' | 'PERMISSIVE';
      onCluster?: string;
      to?: RoleTarget;
      ifExists?: boolean;
      renameTo?: string;
      forSelect?: boolean;
    }
  | {
      kind: 'alterSettingsProfile';
      names: string[];
      hasSettingsKeyword: boolean;
      onCluster?: string;
      to?: RoleTarget;
      ifExists?: boolean;
      renameTo?: string;
      settings?: AccessControlSettingsItem[] | 'NONE';
    };

function formatAlterAccessQuery(node: AccessQueryNode, indent: string): string {
  const stmt: AlterAccessStmt =
    node.type === 'CreateUserQuery'
      ? {
          kind: 'alterUser',
          names: nativeUserNamesToNames(node.names),
          clauses: nativeAlterUserClauses(node),
          ifExists: node.if_exists,
          onCluster: node.cluster,
        }
      : node.type === 'CreateRoleQuery'
        ? {
            kind: 'alterRole',
            names: nativeStringNamesToNames(node.names),
            onCluster: node.cluster,
            ifExists: node.if_exists,
            renameTo: node.new_name !== undefined ? { name: node.new_name } : undefined,
            settings:
              node.alter_settings !== undefined
                ? nativeAlterSettingsToItems(node.alter_settings)
                : undefined,
          }
        : node.type === 'CreateQuotaQuery'
          ? {
              kind: 'alterQuota',
              names: node.names ?? [],
              keyed: nativeKeyTypeToKeyed(node.key_type),
              intervals: nativeLimitsToIntervals(node.limits),
              onCluster: node.cluster,
              to: nativeSetToTarget(node.roles),
              ifExists: node.if_exists,
              renameTo: node.new_name,
            }
          : node.type === 'CreateRowPolicyQuery'
            ? {
                kind: 'alterRowPolicy',
                hasRowKeyword: true,
                targets: nativeRowPolicyTargets(node.names),
                using:
                  node.filters && node.filters.length > 0
                    ? (node.filters[0].condition ??
                      ({ type: 'Identifier', name: 'NONE' } as IdentifierNode))
                    : undefined,
                restrictive:
                  node.is_restrictive !== undefined
                    ? node.is_restrictive
                      ? 'RESTRICTIVE'
                      : 'PERMISSIVE'
                    : undefined,
                onCluster: node.cluster,
                to: nativeSetToTarget(node.roles),
                ifExists: node.if_exists,
                renameTo: node.new_short_name,
                forSelect: undefined,
              }
            : node.type === 'CreateSettingsProfileQuery'
              ? {
                  kind: 'alterSettingsProfile',
                  names: node.names ?? [],
                  hasSettingsKeyword: true,
                  onCluster: node.cluster,
                  to: nativeSetToTarget(node.to_roles),
                  ifExists: node.if_exists,
                  renameTo: node.new_name,
                  settings:
                    node.alter_settings !== undefined
                      ? nativeAlterSettingsToItems(node.alter_settings)
                      : undefined,
                }
              : (() => {
                  throw new Error(`formatAlterAccessQuery: unexpected node type ${node.type}`);
                })();
  if (stmt.kind === 'alterUser') {
    let result = `${indent}ALTER USER`;
    if (stmt.ifExists) result += ' IF EXISTS';
    result += ` ${formatAccessControlNames(stmt.names)}`;
    if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
    for (const c of stmt.clauses) {
      switch (c.kind) {
        case 'rename':
          result += ` RENAME TO ${formatAccessControlName(c.to)}`;
          break;
        case 'identified':
          result += ` IDENTIFIED ${formatAuthMethods(c.auth)}`;
          break;
        case 'notIdentified':
          result += ' NOT IDENTIFIED';
          break;
        case 'host':
          result += c.mode ? ` ${c.mode} HOST` : ' HOST';
          result += ` ${formatHostItems(c.hosts)}`;
          break;
        case 'settings':
          result +=
            c.settings === 'NONE'
              ? ' SETTINGS NONE'
              : ` SETTINGS ${formatAccessControlSettings(c.settings, indent)}`;
          break;
        case 'defaultRole':
          result += ` DEFAULT ROLE ${formatRoleTarget(c.roles)}`;
          break;
        case 'defaultDatabase':
          result += ` DEFAULT DATABASE ${quoteIdent(c.database)}`;
          break;
        case 'grantees':
          result += ` GRANTEES ${formatRoleTarget(c.grantees)}`;
          break;
        case 'validUntil':
          result += ` VALID UNTIL ${formatStringLiteral(c.value)}`;
          break;
      }
    }
    return result;
  }
  if (stmt.kind === 'alterRole') {
    let result = `${indent}ALTER ROLE`;
    if (stmt.ifExists) result += ' IF EXISTS';
    result += ` ${formatAccessControlNames(stmt.names)}`;
    if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
    if (stmt.renameTo) result += ` RENAME TO ${formatAccessControlName(stmt.renameTo)}`;
    if (stmt.settings !== undefined)
      result += ` SETTINGS ${formatAccessControlSettings(stmt.settings, indent)}`;
    return result;
  }
  if (stmt.kind === 'alterQuota') {
    let result = `${indent}ALTER QUOTA`;
    if (stmt.ifExists) result += ' IF EXISTS';
    result += ` ${stmt.names.join(', ')}`;
    if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
    if (stmt.renameTo) result += ` RENAME TO ${stmt.renameTo}`;
    if (stmt.keyed) {
      result += 'notKeyed' in stmt.keyed ? ' NOT KEYED' : ` KEYED BY ${stmt.keyed.keys.join(', ')}`;
    }
    if (stmt.intervals) {
      for (const interval of stmt.intervals) {
        result += ' FOR';
        if (interval.randomized) result += ' RANDOMIZED';
        result += ` ${interval.duration} ${interval.unit}`;
        if (interval.trackingOnly) result += ' TRACKING ONLY';
        else if (interval.noLimits) result += ' NO LIMITS';
        else if (interval.limits)
          result +=
            ' ' +
            interval.limits.map((l) => `MAX ${l.name} = ${formatExpr(l.value, indent)}`).join(', ');
      }
    }
    if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
    return result;
  }
  if (stmt.kind === 'alterRowPolicy') {
    let result = `${indent}ALTER ${stmt.hasRowKeyword ? 'ROW POLICY' : 'POLICY'}`;
    if (stmt.ifExists) result += ' IF EXISTS';
    const targets = stmt.targets
      .map((t) => `${t.names.join(', ')} ON ${formatTableRef(t.table)}`)
      .join(', ');
    result += ` ${targets}`;
    if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
    if (stmt.renameTo) result += ` RENAME TO ${stmt.renameTo}`;
    if (stmt.forSelect) result += ' FOR SELECT';
    if (stmt.using) result += ` USING ${formatExpr(stmt.using, indent)}`;
    if (stmt.restrictive) result += ` AS ${stmt.restrictive}`;
    if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
    return result;
  }
  // alterSettingsProfile
  let result = `${indent}ALTER ${stmt.hasSettingsKeyword ? 'SETTINGS PROFILE' : 'PROFILE'}`;
  if (stmt.ifExists) result += ' IF EXISTS';
  result += ` ${stmt.names.join(', ')}`;
  if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
  if (stmt.renameTo) result += ` RENAME TO ${stmt.renameTo}`;
  if (stmt.settings !== undefined)
    result += ` SETTINGS ${formatAccessControlSettings(stmt.settings, indent)}`;
  if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
  return result;
}

function formatGrantQuery(node: GrantQueryNode, indent: string): string {
  const stmt = nativeGrantToStatement(node);
  const fmtPriv = (p: GrantPrivilege) =>
    p.columns && p.columns.length > 0
      ? `${p.name}(${p.columns.map(quoteIdent).join(', ')})`
      : p.name;
  const fmtTarget = (t: GrantTarget) =>
    t.database !== undefined ? `${t.database}.${t.table}` : t.table;
  let result = `${indent}${stmt.operation}`;
  if (stmt.optionFor) result += ` ${stmt.optionFor} OPTION FOR`;
  if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
  if (stmt.elements) {
    result += ` ${stmt.elements
      .map((el) => `${el.privileges.map(fmtPriv).join(', ')} ON ${fmtTarget(el.target)}`)
      .join(', ')}`;
  } else if (stmt.roles) {
    result += ` ${stmt.roles.join(', ')}`;
  }
  result += ` ${stmt.operation === 'REVOKE' ? 'FROM' : 'TO'} ${stmt.grantees.join(', ')}`;
  if (stmt.withOptions) {
    for (const opt of stmt.withOptions) result += ` WITH ${opt} OPTION`;
  }
  return result;
}

function formatBackupStatement(node: BackupQueryNode, indent: string): string {
  const fmtQualified = (database: string | undefined, table: string): string =>
    database !== undefined ? `${quoteIdent(database)}.${quoteIdent(table)}` : quoteIdent(table);
  const fmtElement = (el: BackupQueryElement): string => {
    switch (el.element_type) {
      case 'TABLE':
      case 'TEMPORARY_TABLE': {
        const keyword = el.element_type === 'TEMPORARY_TABLE' ? 'TEMPORARY TABLE' : 'TABLE';
        let s = `${keyword} ${fmtQualified(el.database, el.table!)}`;
        if (el.new_table !== undefined) s += ` AS ${fmtQualified(el.new_database, el.new_table)}`;
        if (el.partitions && el.partitions.length > 0) {
          s += ` PARTITION ${el.partitions.map((p) => formatExpr(p.value as Expression, indent)).join(', ')}`;
        }
        return s;
      }
      case 'DATABASE': {
        let s = `DATABASE ${quoteIdent(el.database!)}`;
        if (el.new_database !== undefined) s += ` AS ${quoteIdent(el.new_database)}`;
        if (el.except_tables && el.except_tables.length > 0) {
          s += ` EXCEPT TABLES ${el.except_tables.map((t) => quoteIdent(t.table)).join(', ')}`;
        }
        return s;
      }
      case 'FUNCTION':
        return `FUNCTION ${quoteIdent(el.function_name!)}`;
      case 'NAMED_COLLECTION':
        return `NAMED COLLECTION ${quoteIdent(el.collection_name!)}`;
      case 'ALL': {
        let s = 'ALL';
        if (el.except_databases && el.except_databases.length > 0) {
          s += ` EXCEPT DATABASES ${el.except_databases.map(quoteIdent).join(', ')}`;
        }
        if (el.except_tables && el.except_tables.length > 0) {
          s += ` EXCEPT TABLES ${el.except_tables
            .map((t) => fmtQualified(t.database, t.table))
            .join(', ')}`;
        }
        return s;
      }
      default:
        return '';
    }
  };
  let result = `${indent}${node.kind} ${node.elements.map(fmtElement).join(', ')}`;
  result += ` ${node.kind === 'RESTORE' ? 'FROM' : 'TO'} ${formatExpr(node.backup_name, indent)}`;
  if (node.cluster) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;
  // The `async` change (if any) is re-emitted as the trailing SYNC/ASYNC
  // keyword; the remaining changes stay in the SETTINGS clause.
  let waitKeyword: string | undefined;
  const otherPairs: string[] = [];
  if (node.settings !== undefined) {
    const changes = node.settings.changes ?? {};
    for (const name of Object.keys(changes)) {
      if (name === 'async') {
        waitKeyword = changes[name] ? 'ASYNC' : 'SYNC';
      } else {
        otherPairs.push(`${name} = ${formatSettingScalar(changes[name])}`);
      }
    }
    if (node.settings.default_settings !== undefined) {
      for (const name of node.settings.default_settings) otherPairs.push(`${name} = DEFAULT`);
    }
  }
  if (otherPairs.length > 0) result += ` SETTINGS ${otherPairs.join(', ')}`;
  if (waitKeyword !== undefined) result += ` ${waitKeyword}`;
  if (node.format) result += ` FORMAT ${node.format}`;
  return result;
}

// Reconstruct a `SYSTEM ...` command entirely from its native structured
// fields (there is no verbatim payload). Keyword casing is canonicalized.
function formatSystemQuery(node: SystemQueryNode, indent: string): string {
  let s = `${indent}SYSTEM ${node.system_type ?? ''}`;
  const onCluster = node.cluster ? ` ON CLUSTER ${quoteIdent(node.cluster)}` : '';

  // DROP REPLICA / DROP DATABASE REPLICA: quoted replica, then optional FROM
  // target, then ON CLUSTER.
  if (node.system_type === 'DROP REPLICA' || node.system_type === 'DROP DATABASE REPLICA') {
    s += ` '${escapeString(node.replica ?? '')}'`;
    if (node.table !== undefined) {
      const q = node.database !== undefined ? `${formatPlainIdent(node.database)}.` : '';
      s += ` FROM TABLE ${q}${formatPlainIdent(node.table)}`;
    } else if (node.database !== undefined) {
      s += ` FROM DATABASE ${formatPlainIdent(node.database)}`;
    } else if (node.replica_zk_path !== undefined) {
      s += ` FROM ZKPATH '${escapeString(node.replica_zk_path)}'`;
    } else if (node.shard !== undefined) {
      s += ` FROM SHARD '${escapeString(node.shard)}'`;
    }
    return s + onCluster;
  }

  s += onCluster;

  // Target database/table.
  if (node.database !== undefined && node.table !== undefined) {
    s += ` ${formatPlainIdent(node.database)}.${formatPlainIdent(node.table)}`;
  } else if (node.table !== undefined) {
    s += ` ${formatPlainIdent(node.table)}`;
  } else if (node.database !== undefined) {
    s += ` ${formatPlainIdent(node.database)}`;
  }

  // FLUSH LOGS / FLUSH ASYNC INSERT QUEUE table list.
  if (node.tables !== undefined) {
    s +=
      ' ' +
      node.tables
        .map((t) =>
          t.database !== undefined
            ? `${quoteIdent(t.database)}.${quoteIdent(t.table)}`
            : quoteIdent(t.table),
        )
        .join(', ');
  }
  // SYNC REPLICA wait mode + source replica list.
  if (node.sync_replica_mode !== undefined) s += ` ${node.sync_replica_mode}`;
  if (node.src_replicas !== undefined) {
    s += ` FROM ${node.src_replicas.map((r) => `'${escapeString(r)}'`).join(', ')}`;
  }
  // FAILPOINT name.
  if (node.fail_point_name !== undefined) s += ` ${node.fail_point_name}`;
  // CLEAR QUERY CACHE tag.
  if (node.query_result_cache_tag !== undefined) {
    s += ` TAG '${escapeString(node.query_result_cache_tag)}'`;
  }
  // SCHEMA CACHE storage / format.
  if (node.schema_cache_storage !== undefined) s += ` FOR ${node.schema_cache_storage}`;
  if (node.schema_cache_format !== undefined) s += ` FOR ${node.schema_cache_format}`;
  // FILESYSTEM CACHE name / key / offset.
  if (node.filesystem_cache_name !== undefined) {
    s += ` '${escapeString(node.filesystem_cache_name)}'`;
  }
  if (node.key_to_drop !== undefined) s += ` KEY ${node.key_to_drop}`;
  if (node.offset_to_drop !== undefined) s += ` OFFSET ${node.offset_to_drop}`;
  // SUSPEND seconds.
  if (node.seconds !== undefined) s += ` FOR ${node.seconds} SECOND`;
  // UNFREEZE backup name.
  if (node.backup_name !== undefined) s += ` WITH NAME '${escapeString(node.backup_name)}'`;
  // LISTEN server type.
  if (node.server_type !== undefined) s += ` ${formatSystemServerType(node.server_type)}`;
  // Trailing SETTINGS.
  if (node.settings !== undefined) {
    const pairs = formatSetPairs(node.settings);
    if (pairs.length > 0) s += ` SETTINGS ${pairs.join(', ')}`;
  }
  return s;
}

function formatSystemServerType(st: {
  type: string;
  custom_name?: string;
  exclude_types?: string[];
}): string {
  if (st.type === 'CUSTOM' && st.custom_name !== undefined) {
    return `CUSTOM '${escapeString(st.custom_name)}'`;
  }
  let s = st.type;
  if (st.exclude_types !== undefined && st.exclude_types.length > 0) {
    s += ` EXCEPT ${st.exclude_types.join(', ')}`;
  }
  return s;
}

// Render a `TimeInterval` node (e.g. inside REFRESH) as `<value> <UNIT>`.
function formatTimeInterval(ti: TimeIntervalNode): string {
  return (ti.interval ?? []).map((c) => `${c.value} ${c.kind.toUpperCase()}`).join(' ');
}

// Reconstruct a refreshable-MV `REFRESH ...` clause body (everything after the
// REFRESH keyword) from the native RefreshStrategy fields. `settings` may be a
// native `Settings` node (native path) or a raw setting-item list (structured
// path).
type RefreshLike = {
  schedule_kind: string;
  period?: TimeIntervalNode;
  offset?: TimeIntervalNode;
  spread?: TimeIntervalNode;
  dependencies?: ExpressionListNode;
  settings?: SettingsNode | SettingItem[];
  append?: boolean;
};

function formatRefreshStrategy(r: RefreshLike, indent: string): string {
  let s = r.schedule_kind;
  if (r.period) s += ` ${formatTimeInterval(r.period)}`;
  if (r.offset) s += ` OFFSET ${formatTimeInterval(r.offset)}`;
  if (r.spread) s += ` RANDOMIZE FOR ${formatTimeInterval(r.spread)}`;
  if (r.dependencies) {
    const deps = (r.dependencies.children ?? []).map((d) => {
      const ti = d as { name?: string; database?: string };
      return ti.database !== undefined
        ? `${quoteIdent(ti.database)}.${quoteIdent(ti.name!)}`
        : quoteIdent(ti.name!);
    });
    s += ` DEPENDS ON ${deps.join(', ')}`;
  }
  if (r.settings !== undefined) {
    const pairs = Array.isArray(r.settings)
      ? [formatSettingsList(r.settings, indent)]
      : formatSetPairs(r.settings);
    if (pairs.length > 0 && pairs[0] !== '') s += ` SETTINGS ${pairs.join(', ')}`;
  }
  if (r.append) s += ' APPEND';
  return s;
}

// A NAMED COLLECTION / WORKLOAD setting value in ClickHouse's reference AST:
// a literal keeps its native `value_type`/`value`; any other expression
// serializes to a `CustomType` whose value is the compact SQL text.
function formatTypedSettingValue(tv: TypedSettingValue): string {
  if (tv.value_type === 'CustomType') return String(tv.value);
  return formatLiteralValue(
    tv.value_type as LiteralNode['value_type'],
    tv.value as LiteralNode['value'],
    undefined,
  );
}

// Extract the plain name from a native Identifier node (`{type:'Identifier',
// name}`), as carried by WORKLOAD / RESOURCE query fields.
function nativeIdentName(node: IdentifierNode | undefined): string {
  return node?.name ?? '';
}

function formatWorkloadQuery(n: CreateWorkloadQueryNode, indent: string): string {
  let result = `${indent}CREATE`;
  if (n.or_replace) result += ' OR REPLACE';
  result += ' WORKLOAD';
  if (n.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${quoteIdent(nativeIdentName(n.workload_name))}`;
  if (n.workload_parent !== undefined) {
    result += ` IN ${quoteIdent(nativeIdentName(n.workload_parent))}`;
  }
  if (n.cluster) result += ` ON CLUSTER ${n.cluster}`;
  const changes = n.changes ?? [];
  if (changes.length > 0) {
    const items = changes.map((c) => {
      let item = `${c.name} = ${formatTypedSettingValue(c.value)}`;
      if (c.resource !== undefined) item += ` FOR ${quoteIdent(c.resource)}`;
      return item;
    });
    result += ` SETTINGS ${items.join(', ')}`;
  }
  return result;
}

function formatCreateUserQuery(node: CreateUserQueryNode, indent: string): string {
  const stmt = {
    names: nativeUserNamesToNames(node.names),
    auth: nativeAuthToAuth(node.authentication_methods),
    host: nativeHostsToItems(node.hosts),
    settings: nativeSettingsToItems(node.settings),
    defaultRole: nativeSetToTarget(node.default_roles),
    defaultDatabase: nativeDatabaseOrNone(node.default_database),
    grantees: nativeSetToTarget(node.grantees),
    validUntil: nativeValidUntil(node.authentication_methods),
    ifNotExists: node.if_not_exists,
    orReplace: node.or_replace,
    onCluster: node.cluster,
  };
  let result = `${indent}CREATE USER`;
  if (stmt.ifNotExists) result += ' IF NOT EXISTS';
  if (stmt.orReplace) result += ' OR REPLACE';
  result += ` ${formatAccessControlNames(stmt.names)}`;
  if (stmt.auth) {
    const allEmpty =
      stmt.auth.length === 1 && !stmt.auth[0].secret && stmt.auth[0].sshKeys === undefined;
    if (allEmpty) {
      result += ' NOT IDENTIFIED';
    } else {
      const auth = formatAuthMethods(stmt.auth);
      if (auth) result += ` IDENTIFIED ${auth}`;
    }
  }
  if (stmt.onCluster) result += ` ON CLUSTER ${stmt.onCluster}`;
  if (stmt.host) result += ` HOST ${formatHostItems(stmt.host)}`;
  if (stmt.settings !== undefined)
    result += ` SETTINGS ${formatAccessControlSettings(stmt.settings, indent)}`;
  if (stmt.defaultRole) result += ` DEFAULT ROLE ${formatRoleTarget(stmt.defaultRole)}`;
  if (stmt.defaultDatabase) result += ` DEFAULT DATABASE ${quoteIdent(stmt.defaultDatabase)}`;
  if (stmt.grantees) result += ` GRANTEES ${formatRoleTarget(stmt.grantees)}`;
  if (stmt.validUntil) result += ` VALID UNTIL '${stmt.validUntil}'`;
  return result;
}

function formatCreateRoleQuery(node: CreateRoleQueryNode, indent: string): string {
  const stmt = {
    names: nativeStringNamesToNames(node.names),
    settings: nativeSettingsToItems(node.settings),
    orReplace: node.or_replace,
    ifNotExists: node.if_not_exists,
  };
  let result = `${indent}CREATE`;
  if (stmt.orReplace) result += ' OR REPLACE';
  result += ' ROLE';
  if (stmt.ifNotExists) result += ' IF NOT EXISTS';
  result += ` ${formatAccessControlNames(stmt.names)}`;
  if (stmt.settings !== undefined)
    result += ` SETTINGS ${formatAccessControlSettings(stmt.settings, indent)}`;
  return result;
}

function formatCreateRowPolicyQuery(node: CreateRowPolicyQueryNode, indent: string): string {
  let using: Expression | undefined;
  if (node.filters && node.filters.length > 0) {
    using = node.filters[0].condition ?? ({ type: 'Identifier', name: 'NONE' } as IdentifierNode);
  }
  const stmt = {
    hasRowKeyword: true,
    targets: nativeRowPolicyTargets(node.names),
    using,
    restrictive:
      node.is_restrictive !== undefined
        ? node.is_restrictive
          ? ('RESTRICTIVE' as const)
          : ('PERMISSIVE' as const)
        : undefined,
    onCluster: node.cluster,
    to: nativeSetToTarget(node.roles),
    orReplace: node.or_replace,
    ifNotExists: node.if_not_exists,
  };
  let result = `${indent}CREATE`;
  if (stmt.orReplace) result += ' OR REPLACE';
  result += stmt.hasRowKeyword ? ' ROW POLICY' : ' POLICY';
  if (stmt.ifNotExists) result += ' IF NOT EXISTS';
  const targets = stmt.targets
    .map((t) => `${t.names.join(', ')} ON ${formatTableRef(t.table)}`)
    .join(', ');
  result += ` ${targets}`;
  if (stmt.onCluster) result += ` ON CLUSTER ${quoteIdent(stmt.onCluster)}`;
  if (stmt.using) result += ` USING ${formatExpr(stmt.using, indent)}`;
  if (stmt.restrictive) result += ` AS ${stmt.restrictive}`;
  if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
  return result;
}

function formatCreateQuotaQuery(node: CreateQuotaQueryNode, indent: string): string {
  const stmt = {
    names: node.names ?? [],
    keyed: nativeKeyTypeToKeyed(node.key_type),
    intervals: nativeLimitsToIntervals(node.limits),
    to: nativeSetToTarget(node.roles),
    orReplace: node.or_replace,
    ifNotExists: node.if_not_exists,
  };
  let result = `${indent}CREATE`;
  if (stmt.orReplace) result += ' OR REPLACE';
  result += ' QUOTA';
  if (stmt.ifNotExists) result += ' IF NOT EXISTS';
  result += ` ${stmt.names.join(', ')}`;
  if (stmt.keyed) {
    if ('notKeyed' in stmt.keyed) {
      result += ' NOT KEYED';
    } else {
      result += ` KEYED BY ${stmt.keyed.keys.join(', ')}`;
    }
  }
  if (stmt.intervals) {
    for (const interval of stmt.intervals) {
      result += ' FOR';
      if (interval.randomized) result += ' RANDOMIZED';
      result += ` ${interval.duration} ${interval.unit}`;
      if (interval.trackingOnly) result += ' TRACKING ONLY';
      else if (interval.noLimits) result += ' NO LIMITS';
      else if (interval.limits) {
        result +=
          ' ' +
          interval.limits.map((l) => `MAX ${l.name} = ${formatExpr(l.value, indent)}`).join(', ');
      }
    }
  }
  if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
  return result;
}

function formatCreateSettingsProfileQuery(
  node: CreateSettingsProfileQueryNode,
  indent: string,
): string {
  const stmt = {
    names: node.names ?? [],
    hasSettingsKeyword: true,
    to: nativeSetToTarget(node.to_roles),
    settings: nativeSettingsToItems(node.settings),
    orReplace: node.or_replace,
    ifNotExists: node.if_not_exists,
  };
  let result = `${indent}CREATE`;
  if (stmt.orReplace) result += ' OR REPLACE';
  result += stmt.hasSettingsKeyword ? ' SETTINGS PROFILE' : ' PROFILE';
  if (stmt.ifNotExists) result += ' IF NOT EXISTS';
  result += ` ${stmt.names.join(', ')}`;
  if (stmt.settings !== undefined)
    result += ` SETTINGS ${formatAccessControlSettings(stmt.settings, indent)}`;
  if (stmt.to) result += ` TO ${formatRoleTarget(stmt.to)}`;
  return result;
}

function formatNamedCollectionQuery(n: CreateNamedCollectionQueryNode, indent: string): string {
  let result = `${indent}CREATE NAMED COLLECTION`;
  if (n.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${quoteIdent(n.collection_name ?? '')}`;
  if (n.cluster) result += ` ON CLUSTER ${n.cluster}`;
  const changes = n.changes ?? {};
  const overridability = n.overridability;
  const items = Object.entries(changes).map(([key, tv]) => {
    let item = `${key} = ${formatTypedSettingValue(tv)}`;
    const ov = overridability?.[key];
    if (ov === true) item += ' OVERRIDABLE';
    else if (ov === false) item += ' NOT OVERRIDABLE';
    return item;
  });
  result += ` AS ${items.join(', ')}`;
  return result;
}

function formatResourceQuery(n: CreateResourceQueryNode, indent: string): string {
  let result = `${indent}CREATE`;
  if (n.or_replace) result += ' OR REPLACE';
  result += ' RESOURCE';
  if (n.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${quoteIdent(nativeIdentName(n.resource_name))}`;
  const operations = n.operations ?? [];
  const specs = operations
    .map((op) => {
      const target = op.disk !== undefined ? `disk ${quoteIdent(op.disk)}` : 'any disk';
      return `${op.mode.toLowerCase()} ${target}`;
    })
    .join(', ');
  result += ` (${specs})`;
  return result;
}

// ════════════════════════════════════════════════════════════════════════════
// Native CREATE rendering — drives `format()` solely from ClickHouse's
// reference AST fields on `CreateQueryNode` (table/database/columns_list/
// storage/select/dictionary/...) plus the minimal library-only underscore
// scalars that recover what the native serialization drops.
// ════════════════════════════════════════════════════════════════════════════

/** A CreateQueryNode or schema-form AttachQueryNode (same runtime shape). */
type CreateLikeNode = CreateQueryNode & { attach?: boolean };

/** Render a native data-type node (DataType/EnumDataType/TupleDataType/...). */
function formatTypeNode(node: ASTNode): string {
  if (isNodeType(node, 'DataType')) {
    if (node.arguments === undefined) return node.name;
    if (node.arguments.length === 0) return `${node.name}()`;
    return `${node.name}(${node.arguments.map(formatTypeArg).join(', ')})`;
  }
  if (isNodeType(node, 'EnumDataType')) {
    if (node.values && node.values.length > 0) {
      return `${node.name}(${node.values
        .map((v) => `'${escapeString(v.name)}' = ${v.value}`)
        .join(', ')})`;
    }
    return node.name;
  }
  if (isNodeType(node, 'TupleDataType')) {
    const args = (node.arguments ?? []) as ASTNode[];
    return `${node.name}(${args
      .map((a, i) => {
        const nm = node.element_names?.[i];
        return nm ? `${quoteIdent(nm)} ${formatTypeNode(a)}` : formatTypeNode(a);
      })
      .join(', ')})`;
  }
  if (isNodeType(node, 'NameTypePair')) {
    return `${quoteIdent(node.name)} ${formatTypeNode(node.data_type as ASTNode)}`;
  }
  // Literal / Function / Identifier type arguments.
  return formatExpr(node as Expression, '');
}

/** Render one argument inside a parameterized data type. */
function formatTypeArg(arg: ASTNode): string {
  if (
    isNodeType(arg, 'DataType') ||
    isNodeType(arg, 'EnumDataType') ||
    isNodeType(arg, 'TupleDataType') ||
    isNodeType(arg, 'NameTypePair')
  ) {
    return formatTypeNode(arg);
  }
  if (isNodeType(arg, 'ObjectTypeArgument')) {
    if (arg.path_with_type) {
      // `JSON(path Type)` — the path name is one quoted string (dots/spaces
      // backtick-quoted as a whole).
      const otp = arg.path_with_type;
      const inner = otp.data_type as ASTNode | undefined;
      return `${quoteIdent(otp.name ?? '')}${inner ? ` ${formatTypeNode(inner)}` : ''}`;
    }
    if (arg.skip_path) {
      // `JSON(SKIP path)` — a dotted path (per-segment quoting).
      return `SKIP ${formatPlainIdent(arg.skip_path as IdentifierNode)}`;
    }
    if (arg.skip_path_regexp) {
      // `JSON(SKIP REGEXP 'pat')`.
      return `SKIP REGEXP ${formatExpr(arg.skip_path_regexp as Expression, '')}`;
    }
    if (arg.parameter) {
      // `JSON(max_dynamic_paths = N)`.
      return formatExpr(arg.parameter as Expression, '');
    }
    return '';
  }
  // An `Identifier` in type-argument position is an aggregate-function name
  // (`AggregateFunction(any, ...)`); ClickHouse never backtick-quotes it.
  if (isNodeType(arg, 'Identifier')) {
    return (arg.name_parts ?? [arg.name]).join('.');
  }
  return formatExpr(arg as Expression, '');
}

/**
 * Render the inner items of a native `CODEC(...)`/`STATISTICS(...)` function
 * node (each argument is itself a `Function` like `ZSTD(17)` / `Delta`).
 */
function formatNativeCodecInner(fnNode: FunctionNode): string {
  return (fnNode.arguments as FunctionNode[])
    .map((c) => {
      const fmtName = /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(c.name) ? c.name : quoteIdent(c.name);
      // Canonicalize the no-argument form to empty parens (`Delta()`, not
      // `Delta`); the two are semantically identical. `no_parens` is retained
      // only so `formatExplain()` can reproduce ClickHouse's byte-exact AST.
      if (c.arguments !== undefined && c.arguments.length > 0) {
        return `${fmtName}(${c.arguments.map((a) => formatExpr(a, '')).join(', ')})`;
      }
      return `${fmtName}()`;
    })
    .join(', ');
}

/** Render a native ColumnDeclaration node. */
function formatColumnDeclNode(col: ColumnDeclarationNode, indent: string): string {
  const parts = [`${indent}${quoteIdent(col.name)}`];
  if (col.data_type) parts.push(formatTypeNode(col.data_type));
  if (col.collation) parts.push(`COLLATE ${col.collation.name}`);
  if (col.null_modifier === true) parts.push('NULL');
  else if (col.null_modifier === false) parts.push('NOT NULL');
  if (col.primary_key_specifier) parts.push('PRIMARY KEY');
  if (col.default_specifier === 'AUTO_INCREMENT') {
    parts.push('AUTO_INCREMENT');
  } else if (col.default_specifier) {
    parts.push(col.default_specifier);
    if (col.default_expression && !col.ephemeral_default) {
      parts.push(formatExpr(col.default_expression, indent));
    }
  }
  if (col.comment) parts.push(`COMMENT ${formatStringLiteral(col.comment.value as string)}`);
  if (col.codec) parts.push(`CODEC(${formatNativeCodecInner(col.codec)})`);
  if (col.statistics) parts.push(`STATISTICS(${formatNativeCodecInner(col.statistics)})`);
  if (col.ttl) parts.push(`TTL ${formatExpr(col.ttl, indent)}`);
  if (col.settings) parts.push(`SETTINGS(${formatSetPairs(col.settings).join(', ')})`);
  return parts.join(' ');
}

/** Render a native `TYPE name[(args)]` index-type function. */
function formatTypeFn(it: FunctionNode, indent: string): string {
  // Canonicalize the no-argument form to empty parens (`minmax()`, not
  // `minmax`); `no_parens` is retained only for `formatExplain()`.
  if (it.arguments.length > 0) {
    return `${it.name}(${it.arguments.map((a) => formatExpr(a, indent)).join(', ')})`;
  }
  return `${it.name}()`;
}

/**
 * Render the trailing `GRANULARITY n` clause for a native Index node.
 *
 * `granularity` is always populated (the source value or ClickHouse's
 * default — including the forced 100000000 for `text` indexes), so we
 * canonicalize by always re-emitting it. `GRANULARITY 1` is semantically
 * equivalent to omitting the clause, and a `text` index's granularity is
 * forced regardless of any source value.
 */
function formatIndexGranularityClause(idx: IndexNode): string {
  if (idx.granularity !== undefined) {
    return ` GRANULARITY ${idx.granularity}`;
  }
  return '';
}

/** Render a native data-skipping INDEX node as a table element. */
function formatNativeIndexElem(idx: IndexNode, indent: string): string {
  let result = `${indent}INDEX ${quoteIdent(idx.name ?? '')} ${formatExpr(idx.expression!, indent)}`;
  if (idx.index_type !== undefined) {
    result += ` TYPE ${formatTypeFn(idx.index_type, indent)}`;
  }
  result += formatIndexGranularityClause(idx);
  return result;
}

/** Render a native PROJECTION node as a table element. */
function formatNativeProjection(proj: ProjectionNode, indent: string): string {
  if (proj.index !== undefined) {
    let result = `${indent}PROJECTION ${quoteIdent(proj.name)} INDEX ${formatExpr(proj.index, indent)}`;
    if (proj.index_type !== undefined) {
      result += ` TYPE ${formatTypeFn(proj.index_type, indent)}`;
    }
    return result;
  }
  let result = `${indent}PROJECTION ${quoteIdent(proj.name)} (${formatProjectionSelectQuery(
    proj.query,
    indent,
  )})`;
  if (proj.settings !== undefined) {
    result += ` WITH SETTINGS(${formatSetPairs(proj.settings).join(', ')})`;
  }
  return result;
}

// Render a native `ProjectionSelectQuery` body (WITH / SELECT / GROUP BY /
// ORDER BY) from its structured fields.
function formatProjectionSelectQuery(
  psq: ProjectionSelectQueryNode | undefined,
  indent: string,
): string {
  if (psq === undefined) return 'SELECT';
  const fmtList = (xs: Expression[]) => xs.map((x) => formatExpr(x, indent)).join(', ');
  let s = '';
  if (psq.with && psq.with.length > 0) s += `WITH ${fmtList(psq.with)} `;
  s += `SELECT ${psq.select ? fmtList(psq.select) : ''}`;
  if (psq.group_by && psq.group_by.length > 0) s += ` GROUP BY ${fmtList(psq.group_by)}`;
  if (psq.order_by && psq.order_by.length > 0) s += ` ORDER BY ${fmtList(psq.order_by)}`;
  return s;
}

/** Render the element list of a native `Columns` definition block. */
function formatColumnsBlockNode(cols: ColumnsNode, indent: string, sep: string = ',\n'): string {
  const elements: string[] = [];
  for (const c of cols.columns ?? []) elements.push(formatColumnDeclNode(c, indent));
  for (const idx of cols.indices ?? []) elements.push(formatNativeIndexElem(idx, indent));
  for (const con of cols.constraints ?? []) {
    elements.push(
      `${indent}CONSTRAINT ${quoteIdent(con.name)} ${con.constraint_type} ${formatExpr(con.expression, indent)}`,
    );
  }
  for (const proj of cols.projections ?? []) elements.push(formatNativeProjection(proj, indent));
  // Schema-level `PRIMARY KEY(...)` that was written inside the column list
  // (column-level PRIMARY KEY modifiers are already rendered on each column).
  if (cols.primary_key !== undefined) {
    const inner = storagePkExprs(cols.primary_key)
      .map((e) => formatExpr(e, indent))
      .join(', ');
    elements.push(`${indent}PRIMARY KEY(${inner})`);
  }
  return elements.join(sep);
}

/** Render a native engine `Function` node (`ENGINE = name[(args)]`). */
function formatEngineNode(engine: FunctionNode, indent: string): string {
  // Canonicalize the no-argument form to empty parens (`ENGINE = Memory()`, not
  // `Memory`); `no_parens` is retained only for `formatExplain()`.
  if (engine.arguments !== undefined && engine.arguments.length > 0) {
    return `${engine.name}(${engine.arguments.map((a) => formatExpr(a, indent)).join(', ')})`;
  }
  return `${engine.name}()`;
}

/**
 * Split a native storage `primary_key` into its key expressions. A multi-key
 * list is a `tuple(...)` operator (`is_operator`); a single tuple-valued key is
 * a bare `tuple(...)` function call and must not be split.
 */
function storagePkExprs(pk: Expression): Expression[] {
  if (pk.type === 'Function' && pk.name === 'tuple' && pk.is_operator === true) {
    return pk.arguments as Expression[];
  }
  return [pk];
}

/** Render a native TTLElement node (table TTL). */
function formatNativeTTLElement(ttl: TTLElementNode, indent: string): string {
  let s = formatExpr(ttl.ttl, indent);
  if (ttl.mode === 'MOVE') {
    s += ` TO ${ttl.destination_type ?? 'DISK'}`;
    if (ttl.if_exists) s += ` IF EXISTS`;
    if (ttl.destination_name !== undefined) s += ` ${formatStringLiteral(ttl.destination_name)}`;
  } else if (ttl.mode === 'RECOMPRESS') {
    if (ttl.recompression_codec)
      s += ` RECOMPRESS CODEC(${formatNativeCodecInner(ttl.recompression_codec)})`;
  } else if (ttl.mode === 'GROUP_BY') {
    if (ttl.group_by_key && ttl.group_by_key.length > 0) {
      s += ` GROUP BY ${ttl.group_by_key.map((e) => formatExpr(e, indent)).join(', ')}`;
    }
    if (ttl.group_by_assignments && ttl.group_by_assignments.length > 0) {
      s += ` SET ${ttl.group_by_assignments
        .map((sp) => `${quoteIdent(sp.column)} = ${formatExpr(sp.expression, indent)}`)
        .join(', ')}`;
    }
  } else if (ttl.where) {
    s += ` WHERE ${formatExpr(ttl.where, indent)}`;
  }
  return s;
}

/**
 * Render the post-ENGINE storage clauses of a native `Storage` node, in the
 * source-faithful order. `columnsHavePk` suppresses the storage `PRIMARY KEY`
 * clause when the primary key belongs in the column list (schema/column PK).
 */
function formatStorageClausesNode(
  storage: StorageNode,
  columnsHavePk: boolean,
  indent: string,
): string {
  let result = '';
  const hasStoragePk = storage.primary_key !== undefined && !columnsHavePk;

  // Canonicalize to ClickHouse's clause order: `PRIMARY KEY` before `ORDER BY`
  // (source order is not preserved; it has no semantic effect).
  if (hasStoragePk) {
    result += `\n${indent}PRIMARY KEY ${formatPrimaryKeyExprs(storagePkExprs(storage.primary_key!), indent)}`;
  }
  if (storage.order_by !== undefined) {
    result += `\n${indent}ORDER BY ${formatStorageOrderBy(storage.order_by, indent)}`;
  }
  if (storage.partition_by !== undefined) {
    result += `\n${indent}PARTITION BY ${formatExpr(storage.partition_by, indent)}`;
  }
  if (storage.sample_by !== undefined) {
    result += `\n${indent}SAMPLE BY ${formatExpr(storage.sample_by, indent)}`;
  }
  if (storage.ttl_table !== undefined) {
    const ttlStr = (storage.ttl_table.children as TTLElementNode[])
      .map((item) => formatNativeTTLElement(item, indent))
      .join(',\n' + indent + '    ');
    result += `\n${indent}TTL ${ttlStr}`;
  }
  // ClickHouse requires storage `SETTINGS` to be the last clause; canonicalize
  // to that position. `settings_after_order_by` is retained only so
  // `formatExplain()` can reproduce ClickHouse's source-order `Set` child.
  if (storage.settings) {
    result += `\n${indent}SETTINGS ${formatSetPairs(storage.settings).join(', ')}`;
  }
  return result;
}

/**
 * True when a schema-level `PRIMARY KEY(...)` appears inside the column list.
 * Such a key is rendered as a column-list element, so the standalone storage
 * `PRIMARY KEY` clause is suppressed. A column-level `PRIMARY KEY` modifier
 * (`primary_key_from_columns`) does NOT suppress it: ClickHouse re-emits both
 * the per-column marker and a `PRIMARY KEY <cols>` clause for tables.
 */
function schemaPkInList(node: CreateLikeNode): boolean {
  return node.columns_list?.primary_key !== undefined;
}

/** True when the column list owns the primary key (schema or column-level). */
function columnsOwnPrimaryKey(node: CreateLikeNode): boolean {
  const cl = node.columns_list as
    | (ColumnsNode & { primary_key_from_columns?: Expression })
    | undefined;
  return !!cl && (cl.primary_key !== undefined || cl.primary_key_from_columns !== undefined);
}

/** Render `db.table` (or just `table`) from native Identifier fields. */
function formatCreateName(node: CreateLikeNode): string {
  const tbl = node.table ? formatPlainIdent(node.table) : '';
  return node.database !== undefined ? `${formatPlainIdent(node.database)}.${tbl}` : tbl;
}

/**
 * True when an `AttachQuery` node carries a full CREATE schema (built by the
 * CREATE-path grammar) rather than a bare `ATTACH TABLE name`. The bare form
 * carries none of the create-specific content fields below.
 */
function isSchemaFormAttach(node: AttachQueryNode): boolean {
  const n = node as unknown as CreateLikeNode;
  return (
    n.columns_list !== undefined ||
    n.storage !== undefined ||
    n.select !== undefined ||
    n.as_table !== undefined ||
    n.as_table_function !== undefined ||
    n.dictionary !== undefined ||
    n.dictionary_attributes !== undefined ||
    n.targets !== undefined ||
    n.aliases !== undefined ||
    n.comment !== undefined ||
    n.is_materialized_view === true ||
    n.is_ordinary_view === true ||
    n.attach_as_replicated !== undefined ||
    n.attach_from_path !== undefined
  );
}

/** Main entry: render a CreateQuery / schema-form AttachQuery from native fields. */
function formatCreateQueryNode(node: CreateLikeNode, indent: string): string {
  if (node.is_dictionary) return formatCreateDictionaryNode(node, indent);
  if (node.is_materialized_view) return formatCreateMaterializedViewNode(node, indent);
  if (node.is_ordinary_view) return formatCreateViewNode(node, indent);
  if (node.table === undefined && node.database !== undefined) {
    return formatCreateDatabaseNode(node, indent);
  }
  return formatCreateTableNode(node, indent);
}

function formatCreateTableNode(node: CreateLikeNode, indent: string): string {
  const storage = node.storage;
  const parts: string[] = [];
  // Header
  const pureReplace = node.replace_table === true && node.create_or_replace !== true;
  if (pureReplace) {
    parts.push(`${indent}REPLACE${node.temporary ? ' TEMPORARY' : ''} TABLE`);
  } else {
    let header = node.attach ? `${indent}ATTACH` : `${indent}CREATE`;
    if (node.create_or_replace) header += ' OR REPLACE';
    if (node.temporary) header += ' TEMPORARY';
    header += ' TABLE';
    if (node.if_not_exists) header += ' IF NOT EXISTS';
    parts.push(header);
  }
  parts.push(formatCreateName(node));
  if (node.uuid !== undefined) parts.push(`UUID ${formatStringLiteral(node.uuid)}`);
  if (node.attach_from_path !== undefined) {
    parts.push(`FROM '${node.attach_from_path.replace(/'/g, "\\'")}'`);
  }
  if (node.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(node.cluster)}`);
  let result = parts.join(' ');

  // Trailing clauses common to every CREATE TABLE form.
  const trailing = (s: string): string => {
    if (node.comment !== undefined) {
      s += `\n${indent}COMMENT ${formatStringLiteral(node.comment.value as string)}`;
    }
    if (node.settings !== undefined) {
      s += `\n${indent}SETTINGS ${formatSetPairs(node.settings).join(', ')}`;
    }
    if (node.format !== undefined) s += `\n${indent}FORMAT ${node.format}`;
    return s;
  };

  // ATTACH TABLE t AS [NOT] REPLICATED conversion.
  if (node.attach_as_replicated !== undefined) {
    result += ` AS ${node.attach_as_replicated ? 'REPLICATED' : 'NOT REPLICATED'}`;
    return trailing(result);
  }

  // CLONE AS form.
  if (node.is_clone_as && node.as_table !== undefined) {
    const src =
      node.as_database !== undefined
        ? `${quoteIdent(node.as_database)}.${quoteIdent(node.as_table!)}`
        : quoteIdent(node.as_table!);
    result += `\n${indent}CLONE AS ${src}`;
    if (storage?.engine)
      result += `\n${indent}ENGINE = ${formatEngineNode(storage.engine, indent)}`;
    if (storage) result += formatStorageClausesNode(storage, schemaPkInList(node), indent);
    return trailing(result);
  }

  // AS table form (no schema).
  if (node.as_table !== undefined && node.columns_list === undefined) {
    if (node.is_create_empty) result += ' EMPTY';
    const src =
      node.as_database !== undefined
        ? `${quoteIdent(node.as_database)}.${quoteIdent(node.as_table!)}`
        : quoteIdent(node.as_table!);
    result += ` AS ${src}`;
    if (storage?.engine)
      result += `\n${indent}ENGINE = ${formatEngineNode(storage.engine, indent)}`;
    if (storage) result += formatStorageClausesNode(storage, schemaPkInList(node), indent);
    return trailing(result);
  }

  // Column schema.
  if (node.columns_list !== undefined) {
    const inner = formatColumnsBlockNode(node.columns_list, indent + '    ');
    result += `\n(\n${inner}\n${indent})`;
  }
  if (storage?.engine) result += `\n${indent}ENGINE = ${formatEngineNode(storage.engine, indent)}`;
  if (storage) result += formatStorageClausesNode(storage, schemaPkInList(node), indent);
  if (node.is_create_empty) result += `\n${indent}EMPTY`;
  if (node.as_table_function !== undefined) {
    result += ` AS ${formatExpr(node.as_table_function, indent)}`;
  }
  if (node.select !== undefined) {
    result += ` AS\n${formatStatement(node.select, indent)}`;
  }
  return trailing(result);
}

function formatCreateViewNode(node: CreateLikeNode, indent: string): string {
  let result = node.attach ? `${indent}ATTACH` : `${indent}CREATE`;
  if (node.replace_view) result += ' OR REPLACE';
  if (node.temporary) result += ' TEMPORARY';
  result += ' VIEW';
  if (node.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatCreateName(node)}`;
  if (node.uuid !== undefined) result += ` UUID ${formatStringLiteral(node.uuid)}`;
  if (node.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;
  // Column list: bare aliases or a typed Columns block.
  if (node.aliases !== undefined) {
    result += ` (${node.aliases.map((a) => formatPlainIdent(a)).join(', ')})`;
  } else if (node.columns_list !== undefined) {
    result += ` (${formatColumnsBlockNode(node.columns_list, '', ', ')})`;
  }
  if (node.select !== undefined) result += `\nAS\n${formatStatement(node.select, indent)}`;
  if (node.comment !== undefined) {
    result += `\nCOMMENT ${formatStringLiteral(node.comment.value as string)}`;
  }
  return result;
}

function formatCreateMaterializedViewNode(node: CreateLikeNode, indent: string): string {
  let result = node.attach ? `${indent}ATTACH` : `${indent}CREATE`;
  if (node.replace_view) result += ' OR REPLACE';
  result += ' MATERIALIZED VIEW';
  if (node.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatCreateName(node)}`;
  if (node.uuid !== undefined) result += ` UUID ${formatStringLiteral(node.uuid)}`;
  if (node.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;
  if (node.refresh !== undefined) {
    result += `\nREFRESH ${formatRefreshStrategy(node.refresh, indent)}`;
  }
  const targets = node.targets?.targets;
  const toTarget = targets?.find((t) => t.table !== undefined);
  const innerTarget = targets?.find((t) => t.inner_engine !== undefined);
  if (toTarget !== undefined) {
    const part = (v: string | QueryParameterNode) =>
      typeof v === 'string' ? quoteIdent(v) : formatQueryParameter(v);
    const tn =
      toTarget.database !== undefined
        ? `${part(toTarget.database)}.${part(toTarget.table!)}`
        : part(toTarget.table!);
    result += `\nTO ${tn}`;
  }
  if (node.columns_list !== undefined) {
    const inner = formatColumnsBlockNode(node.columns_list, indent + '    ');
    result += `\n(\n${inner}\n${indent})`;
  }
  const innerStorage = innerTarget?.inner_engine;
  if (innerStorage?.engine) {
    result += `\n${indent}ENGINE = ${formatEngineNode(innerStorage.engine, indent)}`;
  }
  if (innerStorage) {
    result += formatStorageClausesNode(innerStorage, columnsOwnPrimaryKey(node), indent);
  }
  if (node.is_populate) result += `\nPOPULATE`;
  if (node.is_create_empty) result += `\nEMPTY`;
  if (node.select !== undefined) result += `\nAS\n${formatStatement(node.select, indent)}`;
  if (node.comment !== undefined) {
    result += `\nCOMMENT ${formatStringLiteral(node.comment.value as string)}`;
  }
  if (node.format !== undefined) result += `\nFORMAT ${node.format}`;
  return result;
}

function formatCreateDatabaseNode(node: CreateLikeNode, indent: string): string {
  let result = node.attach ? `${indent}ATTACH` : `${indent}CREATE`;
  if (node.create_or_replace) result += ' OR REPLACE';
  result += ' DATABASE';
  if (node.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatPlainIdent(node.database!)}`;
  if (node.uuid !== undefined) result += ` UUID ${formatStringLiteral(node.uuid)}`;
  if (node.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;
  const storage = node.storage;
  if (storage?.engine) result += `\n${indent}ENGINE = ${formatEngineNode(storage.engine, indent)}`;
  if (storage?.order_by !== undefined) {
    result += `\n${indent}ORDER BY ${formatStorageOrderBy(storage.order_by, indent)}`;
  }
  if (storage?.settings) {
    result += `\n${indent}SETTINGS ${formatSetPairs(storage.settings).join(', ')}`;
  }
  if (node.settings !== undefined) {
    result += `\n${indent}SETTINGS ${formatSetPairs(node.settings).join(', ')}`;
  }
  if (node.comment !== undefined) {
    result += `\n${indent}COMMENT ${formatStringLiteral(node.comment.value as string)}`;
  }
  if (node.format !== undefined) result += `\n${indent}FORMAT ${node.format}`;
  return result;
}

function formatCreateDictionaryNode(node: CreateLikeNode, indent: string): string {
  const pureReplace = node.replace_table === true && node.create_or_replace !== true;
  let result: string;
  if (pureReplace) {
    result = `${indent}REPLACE DICTIONARY`;
  } else {
    result = node.attach ? `${indent}ATTACH` : `${indent}CREATE`;
    if (node.create_or_replace) result += ' OR REPLACE';
    result += ' DICTIONARY';
  }
  if (node.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatCreateName(node)}`;
  if (node.uuid !== undefined) result += ` UUID ${formatStringLiteral(node.uuid)}`;
  if (node.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(node.cluster)}`;

  const innerIndent = indent + '    ';
  const attrs = (node.dictionary_attributes ?? []).map((a) => formatDictAttrNode(a, innerIndent));
  result += `\n(\n${attrs.join(',\n')}\n${indent})`;

  const dict = node.dictionary;
  if (dict !== undefined) result += formatDictionaryDefNode(dict, indent);
  if (node.comment !== undefined) {
    result += `\nCOMMENT ${formatStringLiteral(node.comment.value as string)}`;
  }
  return result;
}

function formatDictAttrNode(a: DictionaryAttributeDeclarationNode, indent: string): string {
  let s = `${indent}${quoteIdent(a.name)} ${formatTypeNode(a.data_type as ASTNode)}`;
  if (a.default_value !== undefined) s += ` DEFAULT ${formatExpr(a.default_value, indent)}`;
  if (a.expression !== undefined) s += ` EXPRESSION ${formatExpr(a.expression, indent)}`;
  if (a.injective) s += ` INJECTIVE`;
  if (a.is_object_id) s += ` IS_OBJECT_ID`;
  if (a.hierarchical) s += ` HIERARCHICAL`;
  if (a.bidirectional) s += ` BIDIRECTIONAL`;
  return s;
}

function formatDictionaryDefNode(dict: DictionaryNode, indent: string): string {
  let result = '';
  if (dict.primary_key !== undefined) {
    result += `\nPRIMARY KEY ${dict.primary_key.map((e) => formatExpr(e, indent)).join(', ')}`;
  }
  if (dict.source !== undefined) {
    // ClickHouse lowercases SOURCE/LAYOUT argument keys in its native AST;
    // SHOW CREATE re-uppercases them, so canonicalize to upper case here.
    const pairs = dict.source.elements
      .map((p) => {
        if ((p.value as { type?: string }).type === 'ExpressionList') {
          const inner = ((p.value as ExpressionListNode).children ?? [])
            .map((sp) => {
              const s = sp as unknown as { key: string; value: ASTNode };
              return `${s.key.toUpperCase()} ${formatExpr(s.value as Expression, '')}`;
            })
            .join(' ');
          return `${p.key.toUpperCase()} (${inner})`;
        }
        return `${p.key.toUpperCase()} ${formatExpr(p.value as Expression, indent)}`;
      })
      .join(' ');
    result += `\nSOURCE(${dict.source.name}(${pairs}))`;
  }
  if (dict.lifetime !== undefined) {
    const lt = dict.lifetime;
    const parts: string[] = [];
    if (lt.min_sec !== undefined) parts.push(`MIN ${lt.min_sec}`);
    if (lt.max_sec !== undefined) parts.push(`MAX ${lt.max_sec}`);
    result += `\nLIFETIME(${parts.join(' ')})`;
  }
  if (dict.range !== undefined) {
    const parts: string[] = [];
    if (dict.range.min_attr_name !== undefined)
      parts.push(`MIN ${quoteIdent(dict.range.min_attr_name)}`);
    if (dict.range.max_attr_name !== undefined)
      parts.push(`MAX ${quoteIdent(dict.range.max_attr_name)}`);
    result += `\nRANGE(${parts.join(' ')})`;
  }
  if (dict.layout !== undefined) {
    const pairs = (dict.layout.parameters ?? [])
      .map((p) => `${p.key.toUpperCase()} ${formatExpr(p.value as Expression, indent)}`)
      .join(' ');
    result += `\nLAYOUT(${dict.layout.layout_type.toUpperCase()}(${pairs}))`;
  }
  if (dict.settings !== undefined) {
    result += `\nSETTINGS(${formatSetPairs(dict.settings).join(', ')})`;
  }
  return result;
}

function formatTableOrderByItem(item: TableOrderByItem, indent: string): string {
  let result = formatExpr(item.expr, indent);
  if (item.dir === 'DESC') result += ' DESC';
  else if (item.dir === 'ASC') result += ' ASC';
  return result;
}

// Render a storage ORDER BY clause from the native `order_by` Expression child
// (the canonical storage representation). The native shape fully describes the
// clause: directions live in `StorageOrderByElement` wrappers (ASC explicit
// when any sibling is DESC), and `(a, b)` vs `tuple(a, b)` is distinguished by
// the `tuple` Function's `is_operator` flag. See docs/underscore-fields.md.
function formatStorageOrderBy(
  structural: Expression | StorageOrderByElementNode,
  indent: string,
): string {
  // Single unparenthesized DESC key: `a DESC`.
  if (isNodeType(structural, 'StorageOrderByElement')) {
    return formatTableOrderByItem({ expr: structural.expression, dir: 'DESC' }, indent);
  }
  if (structural.type === 'Function' && structural.name === 'tuple') {
    const args = structural.arguments as ASTNode[];
    const hasSobe = args.some((a) => isNodeType(a, 'StorageOrderByElement'));
    if (hasSobe) {
      // Parenthesized list carrying explicit directions. Each DESC key is a
      // StorageOrderByElement; ASC keys render bare (whether wrapped or not).
      const items: TableOrderByItem[] = args.map((a: ASTNode) => {
        if (isNodeType(a, 'StorageOrderByElement')) {
          return a.direction === 'DESC'
            ? { expr: a.expression, dir: 'DESC' }
            : { expr: a.expression };
        }
        return { expr: a as Expression };
      });
      return `(${items.map((e) => formatTableOrderByItem(e, indent)).join(', ')})`;
    }
    if (structural.is_operator === true) {
      // Operator-paren multi-key list: `(a, b)`.
      return `(${args.map((a) => formatExpr(a as Expression, indent)).join(', ')})`;
    }
    // Single tuple-valued key: `tuple(a, b)` — no extra wrapping parens.
    return formatExpr(structural, indent);
  }
  // Single ASC key (bare expression): `a`.
  return formatExpr(structural, indent);
}

function formatPrimaryKeyExprs(exprs: Expression[], indent: string): string {
  if (exprs.length === 1) return formatExpr(exprs[0], indent);
  return `(${exprs.map((e) => formatExpr(e, indent)).join(', ')})`;
}

function formatStringLiteral(str: string): string {
  return `'${str.replace(/'/g, "\\'")}'`;
}

function formatExplainQuery(stmt: ExplainQueryNode, indent: string): string {
  // Derive the suffix from the native `kind` phrase. `EXPLAIN PLAN`
  // collapses to bare `kind: 'EXPLAIN'`, so it canonicalizes to `EXPLAIN`.
  const kindSuffix =
    stmt.kind && stmt.kind.toUpperCase().startsWith('EXPLAIN ')
      ? stmt.kind.slice('EXPLAIN '.length)
      : undefined;
  const parts = [`${indent}EXPLAIN`];
  if (kindSuffix !== undefined) parts.push(kindSuffix);
  if (stmt.settings !== undefined) {
    parts.push(formatSetPairs(stmt.settings).join(', '));
  }
  let result = parts.join(' ');
  if (stmt.query !== undefined) {
    result += '\n' + formatStatement(stmt.query, indent);
  }
  if (stmt.format !== undefined) result += `\n${indent}FORMAT ${stmt.format}`;
  if (stmt.output_settings !== undefined) {
    const postPairs = formatSetPairs(stmt.output_settings);
    if (postPairs.length > 0) {
      result += `\n${indent}SETTINGS ${postPairs.join(', ')}`;
    }
  }
  return result;
}

type QueryMember = SelectQueryNode | SelectIntersectExceptQueryNode | SelectWithUnionQueryNode;

function formatSelectWithUnion(
  stmt: SelectWithUnionQueryNode,
  indent: string,
  // True when this SWU is a precedence-implied DISTINCT group — i.e. an
  // unmoded SelectWithUnionQuery that appears as a member of an outer
  // SelectWithUnionQuery with union_mode = UNION_ALL. The caller supplies
  // this context; we no longer mark it on the node itself.
  isImplicitDistinct = false,
): string {
  const mode =
    stmt.union_mode === 'UNION_DISTINCT' || isImplicitDistinct ? 'UNION DISTINCT' : 'UNION ALL';
  // A child member is itself a precedence-implied DISTINCT group exactly when
  // this chain is UNION_ALL and the child is an unmoded SWU wrapper. That's
  // the only shape that path can produce (see `unionAllMembers` in the
  // grammar): explicit parenthesized DISTINCT groups keep `union_mode`,
  // explicit UNION ALL children dissolve into this chain's `selects`.
  const childIsImplicitDistinct = (q: QueryMember): boolean =>
    stmt.union_mode === 'UNION_ALL' &&
    q.type === 'SelectWithUnionQuery' &&
    q.union_mode === undefined;
  const renderMember = (q: QueryMember): string => {
    const childImplicit = childIsImplicitDistinct(q);
    let body =
      q.type === 'SelectWithUnionQuery'
        ? formatSelectWithUnion(q, indent, childImplicit)
        : formatQueryMember(q, indent);
    if (q.leadingComments && q.leadingComments.length > 0) {
      body = q.leadingComments.join('\n') + '\n' + body;
    }
    // Precedence-implied DISTINCT groups print flat and regroup on reparse
    if (childImplicit) return body;
    // Nested SelectWithUnion wrappers inside a multi-member outer chain need
    // parens to preserve the chain's associativity on reparse. A nested
    // IntersectExcept member of a SelectWithUnion needs parens only when the
    // chain has more than one member (otherwise the outer SelectWithUnion is
    // just the top-level wrapper around the IntersectExcept and adding parens
    // would change the comment/structure attachment).
    if (q.type === 'SelectWithUnionQuery') return `(${body})`;
    if (q.type === 'SelectIntersectExceptQuery' && stmt.selects.length > 1) {
      return `(${body})`;
    }
    return body;
  };
  const memberStrs: string[] = [];
  let i = 0;
  while (i < stmt.selects.length) {
    const q = stmt.selects[i];
    // A precedence-implied DISTINCT group mid-chain reparses correctly only as
    // `(group <mode> rest...)`: the closing members keep the inner chain's top
    // combine non-DISTINCT so the group's mode stays implied.
    if (childIsImplicitDistinct(q) && i > 0 && i < stmt.selects.length - 1) {
      const rest = stmt.selects.slice(i).map(renderMember);
      memberStrs.push(`(${rest.join(`\n${indent}${mode}\n`)})`);
      i = stmt.selects.length;
      continue;
    }
    memberStrs.push(renderMember(q));
    i++;
  }
  let result = memberStrs.join(`\n${indent}${mode}\n`);
  result += formatQueryTrailing(stmt, indent);
  return result;
}

function formatQueryMember(q: QueryMember, indent: string): string {
  if (q.type === 'SelectQuery') return formatSelectQuery(q, indent);
  if (q.type === 'SelectIntersectExceptQuery') return formatIntersectExcept(q, indent);
  return formatStatement(q as Statement, indent);
}

function formatIntersectChild(c: QueryMember, indent: string, isExceptLeft: boolean): string {
  if (c.type === 'SelectWithUnionQuery') {
    // SelectWithUnion children of INTERSECT/EXCEPT come from one of:
    //   (a) ClickHouse's automatic wrap of EXCEPT's left child,
    //   (b) the automatic wrap of an IntersectExcept child in any position,
    //   (c) a user-written parenthesized SELECT in INTERSECT context.
    // (a) is reparseable without printing parens (the next parse will re-add
    // the wrap). (b) and (c) need parens to keep the AST shape on re-parse.
    if (c.selects.length === 1) {
      const inner = c.selects[0];
      if (inner.type === 'SelectIntersectExceptQuery') {
        return `(${formatIntersectExcept(inner, indent)})`;
      }
      // Single-SelectQuery wrapper: dissolve when this is the EXCEPT-left
      // (auto-rewrapped on reparse); preserve the parens otherwise (the wrap
      // encodes a user-written parenthesized SELECT in INTERSECT-* /
      // EXCEPT-right context). Preserve the inner's leadingComments in
      // either case (they were attached to the inner SelectQuery, not the
      // dissolved SelectWithUnion wrapper).
      let innerBody = formatQueryMember(inner, indent);
      if (inner.leadingComments !== undefined && inner.leadingComments.length > 0) {
        innerBody = inner.leadingComments.join('\n') + '\n' + innerBody;
      }
      if (isExceptLeft) {
        return innerBody;
      }
      return `(${innerBody})`;
    }
    return `(${formatSelectWithUnion(c, indent)})`;
  }
  let body = formatQueryMember(c, indent);
  if (c.leadingComments !== undefined && c.leadingComments.length > 0) {
    body = c.leadingComments.join('\n') + '\n' + body;
  }
  return body;
}

function formatIntersectExcept(stmt: SelectIntersectExceptQueryNode, indent: string): string {
  // Canonical operator: `INTERSECT`/`EXCEPT` (the ALL default) or the full
  // `INTERSECT DISTINCT`/`EXCEPT DISTINCT` form. The bare keyword is the
  // safer canonical form because `SELECT * EXCEPT ALL SELECT ...` is
  // ambiguous with the `EXCEPT col` column transformer; bare `EXCEPT` is
  // always unambiguously the query-level operator.
  const opText = stmt.operator.endsWith(' ALL') ? stmt.operator.split(' ')[0] : stmt.operator;
  const isExcept = stmt.operator.startsWith('EXCEPT');
  let result = stmt.selects
    .map((c, i) => formatIntersectChild(c, indent, isExcept && i === 0))
    .join(`\n${opText}\n`);
  result += formatQueryTrailing(stmt, indent);
  return result;
}

// Trailing INTO OUTFILE / FORMAT / SETTINGS on a query wrapper.
function formatQueryTrailing(
  stmt: SelectWithUnionQueryNode | SelectIntersectExceptQueryNode,
  indent: string,
): string {
  let result = '';
  if (stmt.out_file) {
    result += `\n${indent}INTO OUTFILE '${escapeString(String(stmt.out_file.value))}'`;
    if (stmt.outfile_truncate) result += ' TRUNCATE';
  }
  if (stmt.format) {
    result += `\n${indent}FORMAT ${stmt.format}`;
  }
  // ClickHouse allows SETTINGS on either side of FORMAT, but the position is a
  // no-op; canonicalize to ClickHouse's re-emitted order (SETTINGS after FORMAT).
  if (stmt.settings) {
    const pairs = formatSetPairs(stmt.settings);
    if (pairs.length > 0) result += `\n${indent}SETTINGS ${pairs.join(', ')}`;
  }
  return result;
}

// Format trailing INTO OUTFILE, FORMAT, and SETTINGS clauses shared by select/union/intersect/explain
function formatSettingsList(settings: SettingItem[], indent: string): string {
  return settings.map((s) => `${s.name} = ${formatExpr(s.value, indent)}`).join(', ');
}

// Operator precedence levels for operator-form Function nodes
function opPrecedence(op: string): number {
  switch (op) {
    case 'OR':
      return 1;
    case 'AND':
      return 2;
    case '=':
    case '!=':
    case '<':
    case '>':
    case '<=':
    case '>=':
    case '<=>':
    case 'IS DISTINCT FROM':
      return 3;
    case 'IN':
    case 'NOT IN':
    case 'GLOBAL IN':
    case 'GLOBAL NOT IN':
    case 'LIKE':
    case 'NOT LIKE':
    case 'ILIKE':
    case 'NOT ILIKE':
    case 'REGEXP':
      return 3.5;
    case '||':
      return 4.5;
    // Postfix IS [NOT] NULL binds looser than the comparison operators (and thus
    // looser than IN/LIKE/arithmetic too): `c0 > (0 IS NULL)` must keep its parens,
    // since `c0 > 0 IS NULL` parses as `isNull(c0 > 0)`. It still binds tighter than
    // AND/OR.
    case 'IS NULL':
    case 'IS NOT NULL':
      return 2.5;
    case '+':
    case '-':
      return 4;
    case '*':
    case '/':
    case '%':
    case 'DIV':
      return 5;
    default:
      return 100;
  }
}

// Maps a Function `name` to the canonical SQL operator token to emit when the
// node is an operator (`is_operator: true`). The grammar's OP_TO_FUNCTION
// runs the reverse direction at parse time; this map runs the forward
// direction at format time. Spelling synonyms (`==`, `<>`, `MOD`) are
// canonicalized to `=`, `!=`, `%`.
const FN_TO_OP: Record<string, string> = {
  // Comparisons
  equals: '=',
  notEquals: '!=',
  greater: '>',
  less: '<',
  greaterOrEquals: '>=',
  lessOrEquals: '<=',
  isNotDistinctFrom: '<=>',
  isDistinctFrom: 'IS DISTINCT FROM',
  // Arithmetic
  plus: '+',
  minus: '-',
  multiply: '*',
  divide: '/',
  intDiv: 'DIV',
  modulo: '%',
  // Logical
  and: 'AND',
  or: 'OR',
  // Pattern / string
  concat: '||',
  match: 'REGEXP',
  like: 'LIKE',
  notLike: 'NOT LIKE',
  ilike: 'ILIKE',
  notILike: 'NOT ILIKE',
  // IN family
  in: 'IN',
  notIn: 'NOT IN',
  globalIn: 'GLOBAL IN',
  globalNotIn: 'GLOBAL NOT IN',
  // Nullish
  isNull: 'IS NULL',
  isNotNull: 'IS NOT NULL',
};

// Names handled as binary `left op right` syntax when is_operator is true.
const BINARY_FN_NAMES = new Set([
  'equals',
  'notEquals',
  'greater',
  'less',
  'greaterOrEquals',
  'lessOrEquals',
  'isNotDistinctFrom',
  'isDistinctFrom',
  'plus',
  'minus',
  'multiply',
  'divide',
  'intDiv',
  'modulo',
]);

// Classify an operator-form Function node by its source operator token.
type OperatorForm =
  | 'binary'
  | 'nary'
  | 'not'
  | 'negate'
  | 'in'
  | 'like'
  | 'isNull'
  | 'ternary'
  | 'concat'
  | 'castKeyword'
  | 'castOperator'
  | 'subscript'
  | 'tupleElement'
  | 'arraySyntax'
  | 'tupleSyntax'
  | 'lambda'
  | null;

function operatorForm(expr: FunctionNode): OperatorForm {
  // Only the arrow-form lambda (`x -> body`) renders as `x -> body`; the
  // function-call form (`lambda(tuple(x), body)`) keeps its source syntax
  // — the latter has `is_lambda_function: true` but lacks `is_operator`
  // and `kind: 'LAMBDA_FUNCTION'`.
  if (expr.is_lambda_function && expr.is_operator === true) return 'lambda';

  const name = expr.name;

  // CAST has three source forms collapsing to (at most) two AST shapes:
  //   x :: T                      → is_operator: true             → `x::T`
  //   1::UInt8                    → pure-literal operand stringified into a
  //                                  String literal; is_operator: false (same
  //                                  shape ClickHouse stores).
  //   CAST(x AS T) / CAST(x, 'T') → is_operator: false             → `CAST(x AS T)`
  // The last two are indistinguishable in the public AST; both render as
  // `CAST(operand AS Type)` (accepted canonicalization: `1::UInt8` formats
  // back as `CAST('1' AS UInt8)`, reparsing to the same AST).
  if (name === 'CAST') {
    if (expr.is_operator === true) return 'castOperator';
    return 'castKeyword';
  }

  // Everything else only takes operator form when is_operator is set.
  if (expr.is_operator !== true) return null;

  if (name === 'not') return 'not';
  if (name === 'negate') return 'negate';
  if (name === 'in' || name === 'notIn' || name === 'globalIn' || name === 'globalNotIn') {
    return 'in';
  }
  if (
    name === 'like' ||
    name === 'notLike' ||
    name === 'ilike' ||
    name === 'notILike' ||
    name === 'match'
  ) {
    return 'like';
  }
  if (name === 'isNull' || name === 'isNotNull') return 'isNull';
  if (name === 'if') return 'ternary';
  if (name === 'concat') return 'concat';
  if (name === 'arrayElement') return 'subscript';
  if (name === 'tupleElement') return 'tupleElement';
  if (name === 'array') return 'arraySyntax';
  if (name === 'tuple') return 'tupleSyntax';
  if ((name === 'and' || name === 'or') && expr.arguments.length >= 2) return 'nary';
  if (BINARY_FN_NAMES.has(name) && expr.arguments.length === 2) return 'binary';
  return null;
}

// The canonical operator token for an operator-form Function node, or ''
// if it isn't a token-bearing operator (lambda, CAST keyword form, etc.).
function opTokenOf(expr: FunctionNode): string {
  return FN_TO_OP[expr.name] ?? '';
}

function exprPrecedence(expr: Expression): number {
  if (expr.type === 'Function') {
    const form = operatorForm(expr);
    if (
      form === 'binary' ||
      form === 'nary' ||
      form === 'in' ||
      form === 'like' ||
      form === 'isNull' ||
      form === 'concat'
    ) {
      return opPrecedence(opTokenOf(expr));
    }
    if (form === 'ternary') return 0.5;
    // Unary prefix operators bind tighter than any binary op but less tightly
    // than postfix `::` / `[` / `.field`. Used by cast / subscript /
    // tupleElement to decide when to wrap an operand in parens.
    if (form === 'negate' || form === 'not') return 6;
  }
  return 100;
}

function isNotOperator(expr: Expression): boolean {
  return expr.type === 'Function' && expr.name === 'not' && expr.is_operator === true;
}

function hasAlias(expr: Expression): boolean {
  return expr.type !== 'Settings' && (expr as { alias?: string }).alias !== undefined;
}

// Format NOT in high-precedence form: NOT(inner) parsed by PrimaryBase
function formatNotHighPrec(expr: Expression, indent: string): string {
  if (!isNotOperator(expr)) return formatExprCore(expr, indent);
  const fnExpr = expr as FunctionNode;
  const inner = formatExprCore(fnExpr.arguments[0], indent);
  return `NOT(${inner})`;
}

// Wrap a child expression with parentheses if needed for operator precedence.
// Renders trailing comments inline after the expression (leading comments handled by caller).
function wrapChildCore(
  child: Expression,
  parentOp: string,
  isRight: boolean,
  indent: string,
): string {
  let s: string;
  if (isNotOperator(child) && !hasAlias(child)) {
    const parentPrec = opPrecedence(parentOp);
    if ((!isRight && parentPrec >= 3) || (isRight && parentPrec >= 5)) {
      s = formatNotHighPrec(child, indent);
    } else {
      s = formatExprCore(child, indent);
    }
  } else {
    s = formatExprCore(child, indent);
  }
  if (hasAlias(child)) s = `(${s})`;
  else {
    const parentPrec = opPrecedence(parentOp);
    const childPrec = exprPrecedence(child);
    if (isRight ? childPrec <= parentPrec : childPrec < parentPrec) {
      s = `(${s})`;
    }
  }
  if (child.trailingComments && child.trailingComments.length > 0) {
    s += ' ' + child.trailingComments.join(' ');
  }
  return s;
}

// Wrap an AND/OR operand, rendering trailing comments inline
function wrapNaryOperandCore(operand: Expression, parentOp: string, indent: string): string {
  let s = formatExprCore(operand, indent);
  if (hasAlias(operand)) s = `(${s})`;
  // A same-op n-ary operand inside the same op (e.g. AND inside AND, from a
  // BETWEEN expansion or an explicitly grouped sub-chain) prints with parens
  // so the chain reparses to the same nested structure.
  else if (
    operand.type === 'Function' &&
    operatorForm(operand) === 'nary' &&
    opTokenOf(operand) === parentOp
  )
    s = `(${s})`;
  else {
    const childPrec = exprPrecedence(operand);
    const parentPrec = opPrecedence(parentOp);
    if (childPrec < parentPrec) s = `(${s})`;
  }
  if (operand.trailingComments && operand.trailingComments.length > 0) {
    s += ' ' + operand.trailingComments.join(' ');
  }
  return s;
}

// Format an expression with leading/trailing comments rendered.
// Leading comments appear on their own lines before the expression (indented).
// Trailing comments appear inline after the expression.
// Call sites that handle comments themselves (formatExprList, formatArgList,
// operator forms) should use formatExprCore instead.
function formatExpr(expr: Expression, indent: string): string {
  let result = formatExprCore(expr, indent);
  if (expr.leadingComments && expr.leadingComments.length > 0) {
    const comments = expr.leadingComments.map((c) => `${indent}${c}`).join('\n');
    result = comments + '\n' + indent + result;
  }
  if (expr.trailingComments && expr.trailingComments.length > 0) {
    result += ' ' + expr.trailingComments.join(' ');
  }
  return result;
}

// ── Per-type expression formatters ──────────────────────────────────────────
// Each function accepts the specific expression type and indent, and returns a
// string. Inline aliases and leading/trailing comments are handled by
// formatExprCore / formatExpr. Surrounding parens are added by the parent
// expression formatter based on operator precedence (see wrapChildCore /
// wrapNaryOperandCore).

function formatLiteral(expr: LiteralNode): string {
  return formatLiteralValue(expr.value_type, expr.value, expr.nonfinite);
}

// Shared rendering for a Literal node and for the `{value_type, value,
// nonfinite?}` elements of an `Array`/`Tuple` literal `value` list (the
// scalar cases are identical; collections recurse into their element lists).
// Inline comments are not represented in the typed-element model, so they are
// dropped (an accepted canonicalization of array/tuple literals).
function formatLiteralValue(
  valueType: LiteralNode['value_type'],
  value: LiteralNode['value'],
  nonfinite: LiteralNode['nonfinite'],
): string {
  switch (valueType) {
    case 'String':
      return `'${escapeString(String(value))}'`;
    case 'Bool':
      return value ? 'true' : 'false';
    case 'Null':
      return 'NULL';
    case 'Float64':
      // `value` cannot carry non-finite forms (`null`) or negative zero (`0`);
      // `nonfinite` supplies those. Finite values reconstruct from the double:
      // `canonicalFloatText` guarantees a `.`/`e` so the output reparses as a
      // Float and not as a UInt64.
      return value === null
        ? (nonfinite ?? 'nan')
        : nonfinite === '-0'
          ? '-0.'
          : canonicalFloatText(String(value).replace('e+', 'e'));
    case 'Array':
    case 'Tuple': {
      const open = valueType === 'Array' ? '[' : '(';
      const close = valueType === 'Array' ? ']' : ')';
      const els = Array.isArray(value) ? value : [];
      return (
        open +
        els.map((el) => formatLiteralValue(el.value_type, el.value, el.nonfinite)).join(', ') +
        close
      );
    }
    default:
      // UInt64/Int64: `value` is the canonical decimal-digit string.
      return String(value);
  }
}

// Bare-digit form of a Float64 that holds an integer value (used by
// `expr.N` tuple-element rendering, whose grammar only accepts `[0-9]+`
// after the dot). Returns `null` for non-integer / non-finite values so
// the caller can fall back to the function-call form.
function float64IntDigits(lit: LiteralNode): string | null {
  const v = lit.value;
  if (typeof v !== 'number' || !Number.isFinite(v) || !Number.isInteger(v)) return null;
  return BigInt(v).toString();
}

// Canonical Float64 spelling for a finite value's decimal string: ensures the
// emitted text reparses as a Float (not a UInt64) by appending a trailing dot
// to integral magnitudes ("1." / "100000000000000000000."). Values whose
// shortest form already carries a fraction or exponent are emitted as-is.
// (Non-finite and negative-zero forms are handled by the caller.)
function canonicalFloatText(raw: string): string {
  return /[.eE]/.test(raw) ? raw : raw + '.';
}

function formatIdentifier(expr: IdentifierNode, indent: string): string {
  void indent;
  const parts = expr.name_parts ?? [expr.name];
  return parts.map(renderIdentPart).join('.');
}

// Render an identifier path part. Two normalized JSON-subcolumn shapes are
// emitted in their idiomatic source form so the output round-trips through
// `name_parts` without a `_parts_source` side channel:
//   - `:`TypeText`` → `.:TypeText` (or `.:`TypeText`` when TypeText has
//     non-bare-identifier chars like parens/spaces) — JSON subcolumn type
//     marker (from `expr.:Type`).
//   - `^`Name``    → `.^Name` (or `.^`Name`` when Name isn't a bare
//     identifier) — JSON object subcolumn (from `json.^a`).
// Any other part runs through `quoteIdent`.
function renderIdentPart(part: Identifier): string {
  if (typeof part === 'string' && part.length >= 3 && part.charCodeAt(1) === 0x60) {
    const prefix = part[0];
    if ((prefix === ':' || prefix === '^') && part.endsWith('`')) {
      const inner = part.slice(2, -1);
      return prefix + (isBareIdent(inner) ? inner : backtickQuote(inner));
    }
  }
  return quoteIdent(part);
}

function formatTransformers(
  transformers: ColumnsTransformerListNode | ColumnsTransformerListNode['children'] | undefined,
  indent: string,
): string {
  if (transformers === undefined) return '';
  // Transformers may appear either as a `ColumnsTransformerList` node (qualified
  // matchers) or as a flat array (plain matchers / asterisks).
  const list = Array.isArray(transformers) ? transformers : transformers.children;
  return list.map((t) => ' ' + formatTransformer(t, indent)).join('');
}

function formatAsterisk(expr: AsteriskNode, indent: string): string {
  // Tuple expansion `expr.*` carries the base in `expression`
  const base = expr.expression !== undefined ? `${formatExpr(expr.expression, indent)}.*` : '*';
  return base + formatTransformers(expr.transformers, indent);
}

function formatQualifiedAsterisk(expr: QualifiedAsteriskNode, indent: string): string {
  const parts = expr.qualifier.name_parts ?? [expr.qualifier.name];
  return `${parts.map(quoteIdent).join('.')}.*` + formatTransformers(expr.transformers, indent);
}

function formatQueryParameter(expr: QueryParameterNode): string {
  return `{${expr.name}:${expr.param_type}}`;
}

type DropFamilyNodeF = DropQueryNode | DetachQueryNode | TruncateQueryNode | UndropQueryNode;

// The first `settings` node among an inner SELECT's members — the settings the
// SELECT will render itself (mirrors the grammar's findFirstSelectSettings).
function findInnerSelectSettings(sel: ASTNode | undefined): SettingsNode | undefined {
  if (isNodeType(sel, 'SelectQuery')) return sel.settings;
  if (isNodeType(sel, 'SelectWithUnionQuery') || isNodeType(sel, 'SelectIntersectExceptQuery')) {
    for (const m of sel.selects) {
      const r = findInnerSelectSettings(m);
      if (r !== undefined) return r;
    }
  }
  return undefined;
}

// INSERT-level SETTINGS pairs: the effective `settings` entries whose value is
// not already rendered identically by the inner SELECT's own settings.
function insertLevelSettingPairs(
  effective: SettingsNode,
  inner: SettingsNode | undefined,
): string[] {
  const innerChanges = inner?.changes ?? {};
  const innerDefaults = new Set(inner?.default_settings ?? []);
  const pairs: string[] = [];
  for (const name of Object.keys(effective.changes ?? {})) {
    const v = effective.changes![name];
    if (name in innerChanges && JSON.stringify(innerChanges[name]) === JSON.stringify(v)) continue;
    pairs.push(`${name} = ${formatSettingScalar(v)}`);
  }
  for (const name of effective.default_settings ?? []) {
    if (innerDefaults.has(name)) continue;
    pairs.push(`${name} = DEFAULT`);
  }
  return pairs;
}

function formatInsertQuery(stmt: InsertQueryNode, indent: string): string {
  let target: string;
  if (stmt.table_function !== undefined) {
    const f = stmt.table_function;
    const args = f.arguments.map((a) => formatExpr(a, indent)).join(', ');
    target = `FUNCTION ${f.name}(${args})`;
  } else if (stmt.database !== undefined && stmt.table !== undefined) {
    target = `${formatPlainIdent(stmt.database)}.${formatPlainIdent(stmt.table)}`;
  } else if (stmt.table !== undefined) {
    target = formatPlainIdent(stmt.table);
  } else {
    target = '';
  }
  const parts: string[] = [`${indent}INSERT INTO`, target];
  if (stmt.partition_by !== undefined) {
    parts.push(`PARTITION BY ${formatExpr(stmt.partition_by, indent)}`);
  }
  if (stmt.columns !== undefined) {
    parts.push(`(${stmt.columns.map((c) => formatExpr(c, indent)).join(', ')})`);
  }
  if (stmt.infile !== undefined) {
    parts.push(`FROM INFILE ${formatExpr(stmt.infile, indent)}`);
    if (stmt.compression !== undefined) {
      parts.push(`COMPRESSION ${formatExpr(stmt.compression, indent)}`);
    }
  }
  // INSERT-level SETTINGS = the effective (hoisted) `settings` minus the
  // (key, value) pairs the inner SELECT renders itself. ClickHouse merges both
  // onto `InsertQuery.settings` (INSERT-level value winning), and keeps the
  // SELECT's own settings on the inner SELECT node, so the placement is fully
  // recoverable without a provenance marker.
  if (stmt.settings !== undefined) {
    const pairs = insertLevelSettingPairs(stmt.settings, findInnerSelectSettings(stmt.select));
    if (pairs.length > 0) parts.push(`SETTINGS ${pairs.join(', ')}`);
  }
  if (stmt.select !== undefined) {
    parts.push(formatStatement(stmt.select, ''));
  }
  // Re-emit the explicit data `FORMAT` keyword (the trailing data payload
  // itself is not preserved). `Values` is the default, so it is omitted.
  if (stmt.format !== undefined && stmt.format !== 'Values') {
    parts.push(`FORMAT ${stmt.format}`);
  }
  return parts.join(' ');
}

// Display form of a single-part Identifier child of a children-array statement.
function formatPlainIdent(idn: IdentifierNode): string {
  const parts = (idn.name_parts ?? [idn.name]) as (string | QueryParameterNode)[];
  return parts
    .map((part) => (typeof part === 'string' ? renderIdentPart(part) : formatQueryParameter(part)))
    .join('.');
}

function formatDropFamily(stmt: DropFamilyNodeF, indent: string): string {
  let names: string;
  if (stmt.database_and_tables !== undefined) {
    names = ((stmt.database_and_tables.children ?? []) as TableIdentifierNode[])
      .map(
        (ti) =>
          (ti.database !== undefined ? `${quoteIdent(ti.database)}.` : '') + quoteIdent(ti.name),
      )
      .join(', ');
  } else if (stmt.database !== undefined && stmt.table !== undefined) {
    names = `${formatPlainIdent(stmt.database)}.${formatPlainIdent(stmt.table)}`;
  } else if (stmt.database !== undefined) {
    names = formatPlainIdent(stmt.database);
  } else if (stmt.table !== undefined) {
    names = formatPlainIdent(stmt.table);
  } else {
    names = '';
  }
  const setChild = stmt.settings;
  // Reconstruct the target keyword purely from native fields: `is_dictionary`/
  // `is_view` flags, the `has_tables` marker (`TRUNCATE [ALL] TABLES FROM db`,
  // which is otherwise database-only and indistinguishable from
  // `TRUNCATE DATABASE db`), then the database-only/table-set slot shape.
  const hasTables = stmt.type === 'TruncateQuery' && stmt.has_tables === true;
  const target = stmt.is_dictionary
    ? 'DICTIONARY'
    : stmt.is_view
      ? 'VIEW'
      : hasTables
        ? 'TABLES'
        : stmt.database !== undefined && stmt.table === undefined
          ? 'DATABASE'
          : 'TABLE';
  const parts: string[] = [];
  if (stmt.type === 'DropQuery') {
    parts.push('DROP');
    if (stmt.temporary) parts.push('TEMPORARY');
    parts.push(target);
    if (stmt.if_exists) parts.push('IF EXISTS');
    if (stmt.if_empty) parts.push('IF EMPTY');
    parts.push(names);
    if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
    if (stmt.sync) parts.push('SYNC');
    if (setChild !== undefined) {
      const pairs = formatSetPairs(setChild);
      if (pairs.length > 0) parts.push(`SETTINGS ${pairs.join(', ')}`);
    }
    if (stmt.format !== undefined) parts.push(`FORMAT ${stmt.format}`);
  } else if (stmt.type === 'DetachQuery') {
    parts.push('DETACH');
    if (stmt.temporary) parts.push('TEMPORARY');
    parts.push(target);
    if (stmt.if_exists) parts.push('IF EXISTS');
    parts.push(names);
    if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
    if (stmt.permanently) parts.push('PERMANENTLY');
    if (stmt.sync) parts.push('SYNC');
  } else if (stmt.type === 'TruncateQuery') {
    parts.push('TRUNCATE');
    if (target === 'TABLES') {
      if (stmt.has_all) parts.push('ALL');
      parts.push('TABLES FROM');
      if (stmt.if_exists) parts.push('IF EXISTS');
      parts.push(names);
      if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
      if (stmt.like !== undefined) {
        const kw = stmt.case_insensitive_like ? 'ILIKE' : 'LIKE';
        parts.push(stmt.not_like ? `NOT ${kw}` : kw);
        parts.push(`'${escapeString(stmt.like)}'`);
      }
    } else if (target === 'DATABASE') {
      parts.push('DATABASE');
      if (stmt.if_exists) parts.push('IF EXISTS');
      parts.push(names);
      if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
    } else {
      if (stmt.temporary) parts.push('TEMPORARY');
      parts.push('TABLE');
      if (stmt.if_exists) parts.push('IF EXISTS');
      parts.push(names);
      if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
      if (setChild !== undefined) {
        const pairs = formatSetPairs(setChild);
        if (pairs.length > 0) parts.push(`SETTINGS ${pairs.join(', ')}`);
      }
    }
  } else {
    parts.push('UNDROP TABLE');
    parts.push(names);
    if (stmt.uuid !== undefined) parts.push(`UUID ${formatStringLiteral(stmt.uuid)}`);
    if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
    if (stmt.format !== undefined) parts.push(`FORMAT ${stmt.format}`);
  }
  return indent + parts.join(' ');
}

// Render the qualified table name from a statement carrying the explicit
// `database`/`table` Identifier fields shared by the drop-family and
// sibling node types.
function tableTargetName(stmt: { database?: IdentifierNode; table?: IdentifierNode }): string {
  if (stmt.database !== undefined && stmt.table !== undefined) {
    return `${formatPlainIdent(stmt.database)}.${formatPlainIdent(stmt.table)}`;
  }
  if (stmt.database !== undefined) return formatPlainIdent(stmt.database);
  if (stmt.table !== undefined) return formatPlainIdent(stmt.table);
  return '';
}

// SETTINGS suffix from a statement's native `settings` trailer (empty when absent).
function settingsTrailerSuffix(stmt: { settings?: SettingsNode }): string {
  if (stmt.settings === undefined) return '';
  const pairs = formatSetPairs(stmt.settings);
  if (pairs.length === 0) return '';
  return ` SETTINGS ${pairs.join(', ')}`;
}

function formatPartitionChild(c: ASTNode, indent: string): string {
  if (isNodeType(c, 'Partition_ID')) {
    if (c.all === true || c.id === undefined) return 'ALL';
    return `ID ${formatExpr(c.id, indent)}`;
  }
  return formatExpr((c as PartitionNode).value, indent);
}

function formatOptimizeQuery(stmt: OptimizeQueryNode, indent: string): string {
  let result = `${indent}OPTIMIZE TABLE ${tableTargetName(stmt)}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  if (stmt.partition !== undefined) {
    result += ` PARTITION ${formatPartitionChild(stmt.partition, indent)}`;
  }
  if (stmt.final) result += ' FINAL';
  if (stmt.cleanup) result += ' CLEANUP';
  if (stmt.deduplicate) {
    result += ' DEDUPLICATE';
    if (stmt.deduplicate_by_columns !== undefined) {
      const cols = (stmt.deduplicate_by_columns.children ?? []) as Expression[];
      if (cols.length > 0) {
        result += ` BY ${cols.map((e) => formatExpr(e, indent)).join(', ')}`;
      }
    }
  }
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatDescribeQuery(stmt: DescribeQueryNode, indent: string): string {
  const te = stmt.table_expression;
  let target: string = '';
  if (te !== undefined) {
    if (te.database_and_table_name !== undefined) {
      const ti = te.database_and_table_name;
      target =
        (ti.database !== undefined ? `${quoteIdent(ti.database)}.` : '') + quoteIdent(ti.name);
    } else if (te.table_function !== undefined) {
      const f = te.table_function;
      target = `${f.name}(${f.arguments.map((a) => formatExpr(a, indent)).join(', ')})`;
    } else if (te.subquery !== undefined) {
      target = `(${formatStatement(te.subquery.query, '')})`;
    }
  }
  let result = `${indent}DESCRIBE TABLE ${target}`;
  if (te?.final) result += ' FINAL';
  // Canonicalize `SETTINGS ... FORMAT ...` to `FORMAT ... SETTINGS ...` (a
  // syntactic no-op). `settings_before_format` is retained only so
  // `formatExplain()` can reproduce ClickHouse's source-order child list.
  if (stmt.format !== undefined) result += ` FORMAT ${stmt.format}`;
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatShowCreateQuery(stmt: ShowCreateQueryNode, indent: string): string {
  // Both `SHOW CREATE ...` and the `SHOW TABLE|VIEW|DATABASE` shorthand parse
  // to this node; we always emit the canonical `SHOW CREATE ...` form.
  const temp = stmt.temporary === true ? 'TEMPORARY ' : '';
  // The node `type` encodes the target keyword (native AST carries no
  // `is_view`/`is_dictionary` flag for SHOW CREATE).
  const target =
    stmt.type === 'ShowCreateDictionaryQuery'
      ? 'DICTIONARY'
      : stmt.type === 'ShowCreateViewQuery'
        ? 'VIEW'
        : 'TABLE';
  let result: string;
  if (stmt.type === 'ShowCreateDatabaseQuery') {
    result = `${indent}SHOW CREATE DATABASE ${tableTargetName(stmt)}`;
  } else {
    result = `${indent}SHOW CREATE ${temp}${target} ${tableTargetName(stmt)}`;
  }
  result += settingsTrailerSuffix(stmt);
  if (stmt.format !== undefined) result += ` FORMAT ${stmt.format}`;
  return result;
}

function formatExistsQuery(stmt: ExistsQueryNode, indent: string): string {
  // The node `type` encodes the target keyword (native AST carries no
  // `is_view`/`is_dictionary` flag for EXISTS).
  const kind =
    stmt.type === 'ExistsDatabaseQuery'
      ? 'DATABASE'
      : stmt.type === 'ExistsDictionaryQuery'
        ? 'DICTIONARY'
        : stmt.type === 'ExistsViewQuery'
          ? 'VIEW'
          : 'TABLE';
  const temporary = (stmt as { temporary?: boolean }).temporary ? 'TEMPORARY ' : '';
  let result = `${indent}EXISTS ${temporary}${kind} ${tableTargetName(stmt)}`;
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatCheckQuery(stmt: CheckQueryNode, indent: string): string {
  let result: string;
  if (stmt.type === 'CheckAllQuery') {
    result = `${indent}CHECK ALL TABLES`;
  } else if (stmt.database !== undefined && stmt.table === undefined) {
    result = `${indent}CHECK DATABASE ${tableTargetName(stmt)}`;
  } else {
    result = `${indent}CHECK TABLE ${tableTargetName(stmt)}`;
    if (stmt.part_name !== undefined) {
      result += ` PART '${escapeString(stmt.part_name)}'`;
    } else if (stmt.partition !== undefined) {
      result += ` ${formatPartitionClause(stmt.partition, indent)}`;
    }
  }
  result += settingsTrailerSuffix(stmt);
  if (stmt.format !== undefined) result += ` FORMAT ${stmt.format}`;
  return result;
}

function formatCreateIndexQuery(stmt: CreateIndexQueryNode, indent: string): string {
  let result = `${indent}CREATE`;
  if (stmt.unique) result += ' UNIQUE';
  result += ' INDEX';
  if (stmt.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatPlainIdent(stmt.index_name)} ON `;
  if (stmt.database !== undefined) {
    result += `${formatPlainIdent(stmt.database)}.`;
  }
  result += formatPlainIdent(stmt.table);
  const decl = stmt.index_declaration;
  const indexExpr = decl.expression;
  if (indexExpr !== undefined) {
    // Multi-column index `CREATE INDEX i ON t (c1, c2)` is stored as a
    // `tuple` Function with `is_operator: true`; emit the bare comma-separated
    // list inside the wrapping parens (avoids the redundant `((c1, c2))` form).
    if (
      indexExpr.type === 'Function' &&
      indexExpr.name === 'tuple' &&
      indexExpr.is_operator === true
    ) {
      result += ` (${indexExpr.arguments.map((a) => formatExpr(a, indent)).join(', ')})`;
    } else {
      result += ` (${formatExpr(indexExpr, indent)})`;
    }
  }
  if (decl.index_type !== undefined) {
    const it = decl.index_type;
    const args =
      it.arguments.length > 0
        ? `(${it.arguments.map((a) => formatExpr(a, indent)).join(', ')})`
        : '';
    result += ` TYPE ${it.name}${args}`;
  }
  result += formatIndexGranularityClause(decl);
  return result;
}

function formatCreateFunctionQuery(stmt: CreateFunctionQueryNode, indent: string): string {
  let result = `${indent}CREATE`;
  if (stmt.or_replace) result += ' OR REPLACE';
  result += ' FUNCTION';
  if (stmt.if_not_exists) result += ' IF NOT EXISTS';
  result += ` ${formatPlainIdent(stmt.function_name)}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  result += ` AS ${formatExpr(stmt.function_core, indent)}`;
  return result;
}

function formatAttachQuery(stmt: AttachQueryNode, indent: string): string {
  // Reconstruct the target keyword from native fields: `is_dictionary`/
  // `is_view` flags, else `ATTACH DATABASE` is database-only, else TABLE.
  const target = stmt.is_dictionary
    ? 'DICTIONARY'
    : stmt.is_view
      ? 'VIEW'
      : stmt.database !== undefined && stmt.table === undefined
        ? 'DATABASE'
        : 'TABLE';
  const parts: string[] = [`${indent}ATTACH`];
  if (stmt.temporary) parts.push('TEMPORARY');
  parts.push(target);
  if (stmt.if_not_exists) parts.push('IF NOT EXISTS');
  parts.push(tableTargetName(stmt));
  if (stmt.uuid !== undefined) parts.push(`UUID '${escapeString(stmt.uuid)}'`);
  if (stmt.cluster !== undefined) parts.push(`ON CLUSTER ${quoteIdent(stmt.cluster)}`);
  return parts.join(' ');
}

function formatRenameQuery(stmt: RenameNode, indent: string): string {
  const keyword = stmt.exchange ? 'EXCHANGE' : 'RENAME';
  const joiner = stmt.exchange ? 'AND' : 'TO';
  // RENAME identifiers can be query parameters (`{p:Identifier}`); render
  // the appropriate spelling for each part.
  const namePart = (n: string | QueryParameterNode): string =>
    typeof n === 'string' ? quoteIdent(n) : formatQueryParameter(n);
  const pairStrs: string[] = stmt.elements.map((el) => {
    const from =
      el.from_table !== undefined
        ? el.from_database !== undefined
          ? `${namePart(el.from_database)}.${namePart(el.from_table)}`
          : namePart(el.from_table)
        : el.from_database !== undefined
          ? namePart(el.from_database)
          : '';
    const to =
      el.to_table !== undefined
        ? el.to_database !== undefined
          ? `${namePart(el.to_database)}.${namePart(el.to_table)}`
          : namePart(el.to_table)
        : el.to_database !== undefined
          ? namePart(el.to_database)
          : '';
    return `${from} ${joiner} ${to}`;
  });
  // The target keyword is derivable from the native `dictionary`/`database`
  // flags (default TABLE). `RENAME TABLES`/`DICTIONARIES` canonicalize to the
  // singular spelling.
  const targetKind = stmt.dictionary ? 'DICTIONARY' : stmt.database ? 'DATABASE' : 'TABLE';
  let result = `${indent}${keyword} ${targetKind}`;
  // `IF EXISTS` applies to the whole statement; the grammar mirrors it onto
  // every native `elements[]` entry, so derive it from the first element.
  if (stmt.elements.some((el) => el.if_exists)) result += ' IF EXISTS';
  result += ` ${pairStrs.join(', ')}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatKillQueryQuery(stmt: KillQueryQueryNode, indent: string): string {
  let result = `${indent}KILL ${stmt.kill_type}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  result += ` WHERE ${formatExpr(stmt.where, indent)}`;
  // Mode is derived from the two native flags (ASYNC is the default).
  result += ` ${stmt.test ? 'TEST' : stmt.sync ? 'SYNC' : 'ASYNC'}`;
  result += settingsTrailerSuffix(stmt);
  if (stmt.format !== undefined) result += ` FORMAT ${stmt.format}`;
  return result;
}

function formatDeleteQuery(stmt: DeleteQueryNode, indent: string): string {
  let result = `${indent}DELETE FROM ${tableTargetName(stmt)}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  if (stmt.partition !== undefined) {
    result += ` IN PARTITION ${formatPartitionChild(stmt.partition, indent)}`;
  }
  if (stmt.predicate !== undefined) result += ` WHERE ${formatExpr(stmt.predicate, indent)}`;
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatUpdateQuery(stmt: UpdateQueryNode, indent: string): string {
  let result = `${indent}UPDATE ${tableTargetName(stmt)}`;
  if (stmt.cluster !== undefined) result += ` ON CLUSTER ${quoteIdent(stmt.cluster)}`;
  const assignStrs = (stmt.assignments ?? []).map(
    (a) => `${quoteIdent(a.column)} = ${formatExpr(a.expression, indent)}`,
  );
  result += ` SET ${assignStrs.join(', ')}`;
  if (stmt.predicate !== undefined) result += ` WHERE ${formatExpr(stmt.predicate, indent)}`;
  result += settingsTrailerSuffix(stmt);
  return result;
}

function formatSubquery(expr: SubqueryNode, indent: string): string {
  const innerIndent = indent + '    ';
  return `(\n${formatStatement(expr.query, innerIndent)}\n${indent})`;
}

function formatColumnsMatcher(
  expr:
    | ColumnsRegexpMatcherNode
    | ColumnsListMatcherNode
    | QualifiedColumnsRegexpMatcherNode
    | QualifiedColumnsListMatcherNode,
  indent: string,
): string {
  if (expr.type === 'ColumnsRegexpMatcher') {
    return (
      `COLUMNS('${escapeString(expr.pattern)}')` + formatTransformers(expr.transformers, indent)
    );
  }
  if (expr.type === 'ColumnsListMatcher') {
    const argsStr = expr.columns.map((a) => formatExpr(a, indent)).join(', ');
    return `COLUMNS(${argsStr})` + formatTransformers(expr.transformers, indent);
  }
  // Qualified matchers carry qualifier as an Identifier; transformers (if any)
  // are wrapped in a ColumnsTransformerList node.
  const qParts = expr.qualifier.name_parts ?? [expr.qualifier.name];
  const qualifierStr = qParts.map(quoteIdent).join('.') + '.';
  const transformersStr = formatTransformers(expr.transformers, indent);
  if (expr.type === 'QualifiedColumnsRegexpMatcher') {
    return `${qualifierStr}COLUMNS('${escapeString(expr.pattern)}')` + transformersStr;
  }
  const argsStr = expr.columns.map((a) => formatExpr(a, indent)).join(', ');
  return `${qualifierStr}COLUMNS(${argsStr})` + transformersStr;
}

// Format an expression without rendering its leading/trailing comments.
// Used by list formatters and operator cases that handle comments with their own layout.
function formatExprCore(expr: Expression, indent: string): string {
  // Inline aliases: `core AS alias`
  const alias = (expr as { alias?: string }).alias;
  if (expr.type !== 'Settings' && alias !== undefined) {
    // MySQL global variables (@@varname) are formatted as @@varname directly
    if (alias.startsWith('@@')) return alias;
    return `${formatExprNoAlias(expr, indent)} AS ${quoteIdent(alias)}`;
  }
  return formatExprNoAlias(expr, indent);
}

function formatExprNoAlias(expr: Expression, indent: string): string {
  switch (expr.type) {
    case 'Literal':
      return formatLiteral(expr);
    case 'Identifier':
      return formatIdentifier(expr, indent);
    case 'Asterisk':
      return formatAsterisk(expr, indent);
    case 'QualifiedAsterisk':
      return formatQualifiedAsterisk(expr, indent);
    case 'QueryParameter':
      return formatQueryParameter(expr);
    case 'Subquery':
      return formatSubquery(expr, indent);
    case 'ColumnsRegexpMatcher':
    case 'ColumnsListMatcher':
    case 'QualifiedColumnsRegexpMatcher':
    case 'QualifiedColumnsListMatcher':
      return formatColumnsMatcher(expr, indent);
    case 'Settings':
    case 'DictionarySettings':
      // Set nodes are rendered by the enclosing function call's SETTINGS handling.
      return '';
    case 'SelectWithUnionQuery':
      // Bare SELECT used in expression position (e.g. view(SELECT ...))
      return formatSelectWithUnion(expr, indent);
    case 'Function':
      return formatFunction(expr, indent);
  }
}

// True when a Literal would be inlined into an Array dump by the grammar's
// `plainElem`. Used to decide whether a Function-form Array needs a paren
// wrap around its first argument so the formatter's `[...]` output stays
// Function-shaped on reparse instead of collapsing to a Literal Array.
function isDumpableArrayElem(node: Expression): boolean {
  if (hasAlias(node)) return false;
  if (node.type !== 'Literal') return false;
  return (
    node.value_type === 'String' ||
    node.value_type === 'Null' ||
    node.value_type === 'Bool' ||
    node.value_type === 'Float64' ||
    node.value_type === 'Int64' ||
    node.value_type === 'UInt64' ||
    node.value_type === 'Array'
  );
}

// Same idea for Tuple — mirrors the grammar's `plainTupleElem`. Literal
// Array elements are non-dumpable in a tuple dump.
function isDumpableTupleElem(node: Expression): boolean {
  if (hasAlias(node)) return false;
  if (node.type !== 'Literal') return false;
  if (node.value_type === 'Array') return false;
  if (node.value_type === 'Tuple') return true;
  return isDumpableArrayElem(node);
}

function formatFunctionArrayArgs(args: Expression[], indent: string): string {
  return formatBracketArgs(args, indent, isDumpableArrayElem);
}

function formatFunctionTupleArgs(args: Expression[], indent: string): string {
  return formatBracketArgs(args, indent, isDumpableTupleElem);
}

// Shared body for `[...]` / `(...)` Function-form rendering. Selects
// multi-line layout when any argument carries a leading/trailing comment
// (an inline `--` comment would otherwise swallow the rest of the list);
// optionally paren-wraps the first arg to keep the AST shape Function on
// reparse when every arg is dump-eligible.
function formatBracketArgs(
  args: Expression[],
  indent: string,
  isDumpable: (n: Expression) => boolean,
): string {
  const allDumpable = args.length > 0 && args.every(isDumpable);
  const hasComments = args.some(
    (a) =>
      (a.leadingComments && a.leadingComments.length > 0) ||
      (a.trailingComments && a.trailingComments.length > 0),
  );
  const renderArg = (a: Expression, i: number): string => {
    const text = formatExprCore(a, indent);
    return allDumpable && i === 0 ? `(${text})` : text;
  };
  if (!hasComments) {
    return args.map(renderArg).join(', ');
  }
  const parts: string[] = [];
  for (let i = 0; i < args.length; i++) {
    const item = args[i];
    const comma = i < args.length - 1 ? ',' : '';
    if (item.leadingComments && item.leadingComments.length > 0) {
      for (const c of item.leadingComments) {
        parts.push(`${indent}${c}`);
      }
    }
    if (item.trailingComments && item.trailingComments.length > 0) {
      parts.push(`${indent}${renderArg(item, i)}${comma} ${item.trailingComments.join(' ')}`);
    } else {
      parts.push(`${indent}${renderArg(item, i)}${comma}`);
    }
  }
  return '\n' + parts.join('\n') + '\n';
}

function formatFunction(expr: FunctionNode, indent: string): string {
  // `x op ANY/ALL (sub)` is lowered to a plain `IN`/`NOT IN` or to a
  // synthetic `(SELECT agg(*) FROM (sub))` wrap during parsing; the
  // canonical lowered shape is what we emit.
  const form = operatorForm(expr);
  let result: string;
  switch (form) {
    case 'lambda':
      result = formatLambda(expr, indent);
      break;
    case 'binary':
      result = formatBinaryOperator(expr, indent);
      break;
    case 'nary':
      result = formatNaryOperator(expr, indent);
      break;
    case 'not':
      result = formatNotOperator(expr, indent);
      break;
    case 'negate': {
      const operand = expr.arguments[0];
      const operandStr = formatExprCore(operand, indent);
      // Wrap operands that would re-parse differently with a bare prefix minus.
      // A numeric literal operand would fold into a signed literal (e.g. `-1`
      // → `Int64(-1)` instead of `negate(UInt64(1))`), so it needs protective
      // parens. Aliases and any expression with precedence below unary minus
      // (any binary operator: `+`, `-`, `*`, `/`, etc.) also need wrapping —
      // unary minus binds tighter than every binary operator so `-x / y`
      // would re-parse as `(-x) / y`.
      const isNumericLiteral =
        operand.type === 'Literal' &&
        (operand.value_type === 'UInt64' ||
          operand.value_type === 'Int64' ||
          operand.value_type === 'Float64');
      const needsParens = isNumericLiteral || hasAlias(operand) || exprPrecedence(operand) < 6;
      if (needsParens) result = `-(${operandStr})`;
      else if (operandStr.startsWith('-')) result = `- ${operandStr}`;
      else result = `-${operandStr}`;
      break;
    }
    case 'in':
      result = formatInOperator(expr, indent);
      break;
    case 'like': {
      const opText = opTokenOf(expr);
      const left = wrapChildCore(expr.arguments[0], opText, false, indent);
      const right = wrapChildCore(expr.arguments[1], opText, true, indent);
      result = `${left} ${opText} ${right}`;
      break;
    }
    case 'isNull': {
      const operand = expr.arguments[0];
      let operandStr = formatExprCore(operand, indent);
      // IS NULL is postfix and binds tighter than NOT, AND, OR, and the
      // comparison operators. Any lower-precedence operand (including the
      // low-prec NOT form which prints as `NOT x`) needs parens.
      const isNotForm = operand.type === 'Function' && operatorForm(operand) === 'not';
      if (hasAlias(operand) || exprPrecedence(operand) <= 3 || isNotForm) {
        operandStr = `(${operandStr})`;
      }
      result = `${operandStr} ${opTokenOf(expr)}`;
      break;
    }
    case 'concat': {
      result = expr.arguments.map((a) => wrapNaryOperandCore(a, '||', indent)).join(' || ');
      break;
    }
    case 'ternary': {
      const [cond, thenExpr, elseExpr] = expr.arguments;
      const wrap = (e: Expression) => {
        const s = formatExprCore(e, indent);
        return (e.type === 'Function' && e.name === 'if' && e.is_operator === true) || hasAlias(e)
          ? `(${s})`
          : s;
      };
      result = `${wrap(cond)} ? ${wrap(thenExpr)} : ${wrap(elseExpr)}`;
      break;
    }
    case 'castKeyword': {
      const [operand, typeArg] = expr.arguments;
      // The AS form requires arg[1] to be a bare String literal type-spec.
      // Comma form must be kept when:
      //  - arg[1] isn't a String literal (`cast(v, type_col)` where the
      //    second arg is an identifier — would parse as a type),
      //  - arg[1] has an alias (the AS form has no place for it), or
      //  - the type literal carries source-specific whitespace that AS-form
      //    re-parse would collapse (`Enum8(\n\t...)`).
      const useAsForm =
        typeArg.type === 'Literal' &&
        typeArg.value_type === 'String' &&
        typeArg.alias === undefined &&
        castTypeRoundTripsAsForm(typeArg);
      if (useAsForm) {
        result = `CAST(${formatExpr(operand, indent)} AS ${castTypeText(typeArg)})`;
      } else {
        result = `CAST(${formatExpr(operand, indent)}, ${formatExpr(typeArg, indent)})`;
      }
      break;
    }
    case 'castOperator': {
      const typeArg = expr.arguments[1];
      const operand = expr.arguments[0];
      // The `::` postfix binds tighter than any binary operator, so an
      // operator-form operand (`a + b::T` parses as `a + (b::T)`) or an
      // aliased operand needs protective parens.
      const needsParens = hasAlias(operand) || exprPrecedence(operand) < 100;
      const operandStr = needsParens
        ? `(${formatExpr(operand, indent)})`
        : formatExpr(operand, indent);
      result = `${operandStr}::${castTypeText(typeArg)}`;
      break;
    }
    case 'subscript': {
      const [base, index] = expr.arguments;
      // `[`-subscript binds tighter than any binary/unary operator, so an
      // operator-form base (`-x[3]` parses as `negate(x[3])`) or an aliased
      // base needs protective parens.
      const needsParens = hasAlias(base) || exprPrecedence(base) < 100;
      const baseStr = needsParens ? `(${formatExpr(base, indent)})` : formatExpr(base, indent);
      result = `${baseStr}[${formatExpr(index, indent)}]`;
      break;
    }
    case 'tupleElement':
      result = formatTupleElement(expr.arguments[0], expr.arguments[1], indent);
      break;
    case 'arraySyntax': {
      // Function Array reaches this case for two reasons: at least one
      // non-dumpable element (always Function on reparse), or the original
      // source had a parenthesized element (`[(NULL)]`) whose
      // `parenthesized` marker is stripped from the public AST. To keep
      // the Function shape across `parse → format → parse` in the second
      // case, wrap the first dump-eligible Literal in parens so the
      // reparsed first element carries `parenthesized` and `plainElem`
      // again returns null — forcing the Function form.
      result = `[${formatFunctionArrayArgs(expr.arguments, indent)}]`;
      break;
    }
    case 'tupleSyntax': {
      if (expr.arguments.length === 1) {
        // Single-element tuple needs the trailing comma to re-parse as a tuple
        result = `(${formatExpr(expr.arguments[0], indent)},)`;
      } else {
        // Same rationale as arraySyntax: protect against a fully-dumpable
        // Function Tuple round-tripping into a Literal Tuple.
        result = `(${formatFunctionTupleArgs(expr.arguments, indent)})`;
      }
      break;
    }
    default:
      result = formatFunctionCall(expr, indent);
      break;
  }
  return result;
}

// The display text for a CAST target type (a String literal holding the type).
function castTypeText(typeArg: Expression): string {
  if (typeArg.type === 'Literal') {
    return String(typeArg.value);
  }
  return '';
}

// Mirrors the grammar's normalizeTypeNamePlain. Used to decide whether the
// AS-form parse would round-trip the type string unchanged; if not, we emit
// the comma form to preserve the source whitespace.
function normalizeTypeNameForRoundTrip(type: string): string {
  let result = '';
  let inString = false;
  const s = type.replace(/\s+/g, ' ').trim();
  for (let i = 0; i < s.length; i++) {
    const ch = s[i];
    if (inString) {
      result += ch;
      if (ch === "'") inString = false;
    } else if (ch === "'") {
      result += ch;
      inString = true;
    } else if (ch === '(' || ch === ')') {
      result = result.trimEnd();
      if (ch === ')' && result.endsWith(',')) result = result.slice(0, -1).trimEnd();
      result += ch;
      if (i + 1 < s.length && s[i + 1] === ' ') i++;
    } else if (ch === ',') {
      result = result.trimEnd();
      result += ', ';
      if (i + 1 < s.length && s[i + 1] === ' ') i++;
    } else if (ch === '=' && result.length > 0 && /[\w']/.test(result[result.length - 1])) {
      result = result.trimEnd() + ' = ';
      if (i + 1 < s.length && s[i + 1] === ' ') i++;
    } else {
      result += ch;
    }
  }
  return result.replace(/\bTuple\(\)/g, 'Tuple');
}

// True when the CAST target type can be re-emitted as `CAST(x AS T)` without
// losing source-text whitespace. Returns false when the literal's value
// contains formatting (newlines, extra spaces, etc.) that the AS-form
// re-parse would collapse, in which case the comma form must be kept.
function castTypeRoundTripsAsForm(typeArg: Expression): boolean {
  if (typeArg.type !== 'Literal' || typeof typeArg.value !== 'string') return true;
  return normalizeTypeNameForRoundTrip(typeArg.value) === typeArg.value;
}

function formatLambda(expr: FunctionNode, indent: string): string {
  const paramsTuple = expr.arguments[0];
  const body = expr.arguments[1];
  const params =
    paramsTuple.type === 'Function'
      ? paramsTuple.arguments.map((p) => (p.type === 'Identifier' ? p.name : ''))
      : [];
  const bodyStr = formatExpr(body, indent);
  if (params.length === 1) {
    return `${params[0]} -> ${bodyStr}`;
  }
  return `(${params.join(', ')}) -> ${bodyStr}`;
}

function formatNotOperator(expr: FunctionNode, indent: string): string {
  const operand = expr.arguments[0];
  // NOT (a, b, c) — NOT applied to a tuple uses the NOT(...) form without inner parens doubling
  if (operand.type === 'Function' && operand.name === 'tuple' && operand.is_operator === true) {
    if (operand.arguments.length === 1) {
      // Single-element tuple keeps its trailing comma inside the NOT parens
      return `NOT((${formatExpr(operand.arguments[0], indent)},))`;
    }
    return `NOT(${operand.arguments.map((e) => formatExpr(e, indent)).join(', ')})`;
  }
  if (operand.type === 'Literal' && operand.value_type === 'Tuple') {
    // A tuple dump came from NOT ((a, b)). `formatLiteral` renders the tuple
    // with its own parens (e.g. "(1, 2)"), so wrapping it once yields
    // NOT((1, 2)), which re-parses as a parenthesized tuple (not the NOT-tuple
    // form).
    return `NOT(${formatLiteral(operand)})`;
  }
  const inner = formatExpr(operand, indent);
  // Simple operands use the space form; complex ones (AND/OR, aliases,
  // subqueries) need the high-precedence NOT(...) form.
  const innerPrec = exprPrecedence(operand);
  if (innerPrec <= 2 || hasAlias(operand) || operand.type === 'Subquery') {
    return `NOT(${inner})`;
  }
  return `NOT ${inner}`;
}

function formatBinaryOperator(expr: FunctionNode, indent: string): string {
  const op = opTokenOf(expr);
  const left = expr.arguments[0];
  const right = expr.arguments[1];
  let leftStr = wrapChildCore(left, op, false, indent);
  const rightStr = wrapChildCore(right, op, true, indent);
  // Render leading comments on the left operand
  if (left.leadingComments && left.leadingComments.length > 0) {
    const lc = left.leadingComments.map((c) => `${indent}${c}`).join('\n');
    leftStr = lc + '\n' + indent + leftStr;
  }
  if (right.leadingComments && right.leadingComments.length > 0) {
    const bParts: string[] = [leftStr];
    for (const c of right.leadingComments) {
      bParts.push(`${indent}${c}`);
    }
    bParts.push(`${indent}${op} ${rightStr}`);
    return bParts.join('\n');
  }
  return `${leftStr} ${op} ${rightStr}`;
}

function formatNaryOperator(expr: FunctionNode, indent: string): string {
  const op = opTokenOf(expr);
  const parts: string[] = [];
  const first = expr.arguments[0];
  if (first.leadingComments && first.leadingComments.length > 0) {
    for (const c of first.leadingComments) {
      parts.push(`${indent}${c}`);
    }
  }
  parts.push(wrapNaryOperandCore(first, op, indent));
  for (let i = 1; i < expr.arguments.length; i++) {
    const operand = expr.arguments[i];
    if (operand.leadingComments && operand.leadingComments.length > 0) {
      for (const c of operand.leadingComments) {
        parts.push(`${indent}${c}`);
      }
    }
    parts.push(`${indent}${op} ${wrapNaryOperandCore(operand, op, indent)}`);
  }
  return parts.join('\n');
}

function formatInOperator(expr: FunctionNode, indent: string): string {
  const opByName: Record<string, string> = {
    in: 'IN',
    notIn: 'NOT IN',
    globalIn: 'GLOBAL IN',
    globalNotIn: 'GLOBAL NOT IN',
  };
  const op = opByName[expr.name] ?? 'IN';
  const left = expr.arguments[0];
  const rhs = expr.arguments[1];
  // Wrap the IN's expr if it's an alias, lambda, nested IN, or any lower-
  // precedence expression (e.g. ternary `a ? b : c`) to preserve parse structure.
  const inPrec = opPrecedence(op);
  const leftNeedsParens =
    hasAlias(left) ||
    (left.type === 'Function' &&
      (left.is_lambda_function === true || operatorForm(left) === 'in')) ||
    exprPrecedence(left) < inPrec;
  const leftStr = leftNeedsParens ? `(${formatExpr(left, indent)})` : formatExpr(left, indent);
  let rhsStr: string;
  if (rhs.type === 'Subquery' && !hasAlias(rhs)) {
    const innerIndent = indent + '    ';
    rhsStr = `(\n${formatStatement(rhs.query, innerIndent)}\n${indent})`;
  } else if (rhs.type === 'Literal' && rhs.value_type === 'Tuple') {
    // IN value list folded to a Literal tuple; `formatLiteral` renders the
    // canonical "(...)" form from the typed element list.
    rhsStr = formatLiteral(rhs);
  } else if (rhs.type === 'Function' && rhs.name === 'tuple' && rhs.is_operator === true) {
    // IN value list in Function tuple form (non-dumpable elements) — the
    // tuple's own parens are the IN list parens. A single element keeps its
    // trailing comma so it re-parses as a tuple. For multi-element tuples
    // we delegate to `formatFunctionTupleArgs` so an all-dumpable Function
    // tuple gets its first arg paren-wrapped to keep the Function shape
    // through reparse (otherwise `IN (1, 2)` would collapse to a Literal
    // Tuple on the next parse).
    if (rhs.arguments.length === 1) {
      rhsStr = `(${formatExpr(rhs.arguments[0], indent)},)`;
    } else {
      rhsStr = `(${formatFunctionTupleArgs(rhs.arguments, indent)})`;
    }
  } else {
    rhsStr = `(${formatExpr(rhs, indent)})`;
  }
  return `${leftStr} ${op} ${rhsStr}`;
}

function formatFunctionCall(expr: FunctionNode, indent: string): string {
  // Quote function name if it contains special characters (allow dots for qualified names like lambda.nested)
  const funcName = /^[a-zA-Z_][a-zA-Z0-9_.]*$/.test(expr.name)
    ? expr.name
    : `\`${expr.name.replace(/`/g, '``')}\``;
  // A trailing Set node in the arguments is the function-level SETTINGS clause
  let args = expr.arguments;
  let settingsStr = '';
  if (args.length > 0 && args[args.length - 1].type === 'Settings') {
    const setNode = args[args.length - 1] as SettingsNode;
    args = args.slice(0, -1);
    const pairs = formatSetPairs(setNode);
    if (pairs.length > 0) {
      settingsStr = ` SETTINGS ${pairs.join(', ')}`;
    }
  }
  let call: string;
  if (expr.parameters) {
    call = `${funcName}(${formatArgList(expr.parameters, indent)})(${formatArgList(args, indent)}${settingsStr})`;
  } else {
    call = `${funcName}(${formatArgList(args, indent)}${settingsStr})`;
  }
  if (expr.nulls_action !== undefined) {
    call += ` ${expr.nulls_action}`;
  }
  if (expr.window_definition) {
    call += ` OVER (${formatWindowDefinition(expr.window_definition, indent)})`;
  } else if (expr.window_name !== undefined) {
    call += ` OVER ${quoteIdent(expr.window_name)}`;
  }
  return call;
}

// Format tupleElement(expr, index) as expr.N, expr.-N, or tupleElement(expr, arg)
// Named field access (expr.name) is NOT used because the parser re-parses it as an identifier
function formatTupleElement(base: Expression, index: Expression, indent: string): string {
  // Wrap the base in parens when:
  //  - it has an alias (the alias has to live inside the parens: `(x AS a).1`),
  //  - it is a bare Identifier (`id.name` would re-parse as a compound
  //    Identifier rather than `tupleElement(id, 'name')`), or
  //  - it is an operator-form expression (parens are needed for it to bind
  //    tightly enough that the `.field` access applies to the whole thing).
  const baseNeedsParens =
    hasAlias(base) || base.type === 'Identifier' || exprPrecedence(base) < 100;
  // A numeric-literal base also can't take the dot form even with parens for
  // a UInt64 index: `(255).100` would re-parse as `tupleElement(255, 100)`,
  // which is fine — but `255.100` without parens parses as a Float64 literal.
  // The parens are already added by `baseNeedsParens` covering operator forms
  // and identifiers, but a bare unaliased numeric literal base has precedence
  // 100 and is not an Identifier, so we fall through to the call form here.
  if (
    !baseNeedsParens &&
    base.type === 'Literal' &&
    (base.value_type === 'UInt64' || base.value_type === 'Int64' || base.value_type === 'Float64')
  ) {
    return `tupleElement(${formatExpr(base, indent)}, ${formatExpr(index, indent)})`;
  }
  const baseStr = baseNeedsParens ? `(${formatExpr(base, indent)})` : formatExpr(base, indent);
  if (index.type === 'Literal' && index.value_type === 'UInt64') {
    // expr.N (numeric index)
    return `${baseStr}.${String(index.value)}`;
  }
  if (index.type === 'Literal' && index.value_type === 'Float64') {
    // Oversized integer indices are stored as Float64 (whose double renders
    // in exponential form). Re-render via BigInt to recover bare digits —
    // the tuple-element grammar accepts only `[0-9]+` after `.`. Falls
    // through to the call form if the value isn't a finite integer.
    const digits = float64IntDigits(index);
    if (digits !== null) return `${baseStr}.${digits}`;
  }
  if (
    index.type === 'Function' &&
    index.name === 'negate' &&
    index.arguments.length === 1 &&
    index.arguments[0].type === 'Literal'
  ) {
    const inner = index.arguments[0] as LiteralNode;
    if (inner.value_type === 'UInt64') {
      // expr.-N (negative index)
      return `${baseStr}.-${String(inner.value)}`;
    }
    if (inner.value_type === 'Float64') {
      const digits = float64IntDigits(inner);
      if (digits !== null) return `${baseStr}.-${digits}`;
    }
  }
  if (index.type === 'Literal' && index.value_type === 'String') {
    const name = String(index.value);
    const canDotForm = !/^[0-9]/.test(name) && name !== '';
    if (canDotForm) {
      const nameStr = /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(name)
        ? name
        : '`' + name.replace(/\\/g, '\\\\').replace(/`/g, '``') + '`';
      return `${baseStr}.${nameStr}`;
    }
  }
  // Fallback: function call form (for digit-leading names and complex expressions)
  return `tupleElement(${formatExpr(base, indent)}, ${formatExpr(index, indent)})`;
}

function formatWindowDefinition(spec: WindowSpec, indent: string): string {
  const parts: string[] = [];
  if (spec.parent_window_name) {
    parts.push(quoteIdent(spec.parent_window_name));
  }
  if (spec.partition_by && spec.partition_by.length > 0) {
    parts.push(`PARTITION BY ${spec.partition_by.map((e) => formatExpr(e, indent)).join(', ')}`);
  }
  if (spec.order_by && spec.order_by.length > 0) {
    parts.push(
      `ORDER BY ${spec.order_by.map((item) => formatOrderByItemInline(item, indent)).join(', ')}`,
    );
  }
  if (spec.frame_type !== undefined) {
    const start = formatFrameBound(spec.frame_begin, indent);
    const end = formatFrameBound(spec.frame_end, indent);
    parts.push(`${spec.frame_type} BETWEEN ${start} AND ${end}`);
  }
  return parts.join(' ');
}

function formatFrameBound(
  bound:
    | { type: 'Unbounded'; preceding?: boolean }
    | { type: 'Current' }
    | { type: 'Offset'; offset: Expression; preceding?: boolean }
    | undefined,
  indent: string,
): string {
  if (bound === undefined) return '';
  if (bound.type === 'Current') return 'CURRENT ROW';
  const direction = bound.preceding === true ? 'PRECEDING' : 'FOLLOWING';
  if (bound.type === 'Unbounded') return `UNBOUNDED ${direction}`;
  if (bound.type === 'Offset') {
    let offsetStr = formatExpr(bound.offset, indent);
    // Aliased offset expressions need protective parens — `1 + 1 AS x
    // PRECEDING` would otherwise re-parse with PRECEDING attached to the
    // alias scope.
    if (hasAlias(bound.offset)) offsetStr = `(${offsetStr})`;
    return `${offsetStr} ${direction}`;
  }
  return '';
}

function formatTransformer(t: ColumnsTransformerNode, indent: string): string {
  if (t.type === 'ColumnsExceptTransformer') {
    const strict = t.is_strict ? 'STRICT ' : '';
    if (t.pattern !== undefined) {
      return `EXCEPT('${escapeString(t.pattern)}')`;
    }
    const cols = (t.columns ?? []).map((c) => quoteIdent(c.name)).join(', ');
    return `EXCEPT ${strict}(${cols})`;
  }
  if (t.type === 'ColumnsApplyTransformer') {
    if (t.lambda !== undefined) {
      return `APPLY(${formatExpr(t.lambda, indent)})`;
    }
    if (t.parameters !== undefined) {
      const params = ((t.parameters.children ?? []) as Expression[])
        .map((p) => formatExpr(p, indent))
        .join(', ');
      return `APPLY(${t.func_name ?? ''}(${params}))`;
    }
    return `APPLY(${t.func_name ?? ''})`;
  }
  // replace
  const strict = t.is_strict ? 'STRICT ' : '';
  const items = t.replacements
    .map((item) => `${formatExpr(item.expression, indent)} AS ${quoteIdent(item.name)}`)
    .join(', ');
  return `REPLACE ${strict}(${items})`;
}

function formatSampleRatioValue(ratio: SampleRatioValue): string {
  return ratio.den !== undefined ? `${ratio.num}/${ratio.den}` : ratio.num;
}

function formatSampleClause(sample: SampleClause): string {
  let s = `SAMPLE ${formatSampleRatioValue(sample.ratio)}`;
  if (sample.offset !== undefined) {
    s += ` OFFSET ${formatSampleRatioValue(sample.offset)}`;
  }
  return s;
}

function formatTableRef(ref: TableRef): string {
  const db = ref.database ? quoteIdent(ref.database) : undefined;
  const tbl = quoteIdent(ref.table);
  const id = db ? `${db}.${tbl}` : tbl;
  let result = id;
  if (ref.alias) result += ` AS ${quoteIdent(ref.alias)}`;
  if (ref.final) result += ' FINAL';
  if (ref.sample) result += ` ${formatSampleClause(ref.sample)}`;
  if (ref.trailingComments && ref.trailingComments.length > 0) {
    result += ' ' + ref.trailingComments.join(' ');
  }
  return result;
}

function formatOrderByItemInline(item: OrderByElementNode, indent: string): string {
  return formatOrderByCore(item, indent, '');
}

function formatOrderByItem(item: OrderByElementNode, indent: string): string {
  return formatOrderByCore(item, indent, indent);
}

function formatOrderByCore(item: OrderByElementNode, indent: string, prefix: string): string {
  let result = `${prefix}${formatExpr(item.expression, indent)} ${item.direction}`;
  if (item.nulls_first !== undefined) {
    result += item.nulls_first ? ' NULLS FIRST' : ' NULLS LAST';
  }
  if (item.collation !== undefined) {
    result += ` COLLATE '${escapeString(String(item.collation.value))}'`;
  }
  if (
    item.with_fill ||
    item.fill_from !== undefined ||
    item.fill_to !== undefined ||
    item.fill_step !== undefined ||
    item.fill_staleness !== undefined
  ) {
    // Aliased fill expressions need protective parens — `... AS x TO ...`
    // would otherwise re-parse with TO inside the alias scope.
    const fillExpr = (e: Expression): string => {
      const s = formatExpr(e, indent);
      return hasAlias(e) ? `(${s})` : s;
    };
    result += ' WITH FILL';
    if (item.fill_from !== undefined) result += ` FROM ${fillExpr(item.fill_from)}`;
    if (item.fill_to !== undefined) result += ` TO ${fillExpr(item.fill_to)}`;
    if (item.fill_step !== undefined) result += ` STEP ${fillExpr(item.fill_step)}`;
    if (item.fill_staleness !== undefined) result += ` STALENESS ${fillExpr(item.fill_staleness)}`;
  }
  return result;
}

function formatInterpolateItem(item: InterpolateElementNode, indent: string): string {
  return `${item.column} AS ${formatExpr(item.expr, indent)}`;
}

function formatCTEBlock(items: WithItem[], indent: string, recursive?: boolean): string {
  const cteIndent = indent + '  ';
  const innerIndent = indent + '    ';
  const hasComments = items.some(
    (c) =>
      (c.leadingComments && c.leadingComments.length > 0) ||
      (c.trailingComments && c.trailingComments.length > 0),
  );

  // Non-comment path: preserve original formatting behavior
  if (!hasComments) {
    const parts: string[] = [];
    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      const withKw = recursive ? 'WITH RECURSIVE ' : 'WITH ';
      const prefix = i === 0 ? `${indent}${withKw}` : `${indent}`;
      if (item.type === 'WithElement') {
        const suffix = i < items.length - 1 ? '),' : ')';
        const colAliases = item.aliases
          ? ` (${((item.aliases.children ?? []) as IdentifierNode[]).map((a) => quoteIdent(a.name)).join(', ')})`
          : '';
        const query = item.subquery.query;
        // Include leading comments on the CTE body query
        let bodyComments = '';
        if (query.leadingComments && query.leadingComments.length > 0) {
          bodyComments =
            query.leadingComments.map((c: string) => `${innerIndent}${c}`).join('\n') + '\n';
        }
        parts.push(
          `${prefix}${quoteIdent(item.name)}${colAliases} AS (\n` +
            bodyComments +
            formatStatement(query, innerIndent) +
            `\n${indent}${suffix}`,
        );
      } else if (
        item.type === 'Function' &&
        item.name === 'tuple' &&
        item.is_operator === true &&
        item.alias === undefined
      ) {
        // Tuple CTE: WITH ((expr) AS a, (expr) AS b)
        const suffix = i < items.length - 1 ? ',' : '';
        const inner = item.arguments
          .map((e: Expression) => `${innerIndent}${formatExpr(e, innerIndent)}`)
          .join(',\n');
        parts.push(`${prefix}(\n${inner})${suffix}`);
      } else {
        // Aliased expression CTE (alias is inline on the node)
        const suffix = i < items.length - 1 ? ',' : '';
        parts.push(`${prefix}${formatExprCore(item, innerIndent)}${suffix}`);
      }
    }
    return parts.join('\n\n');
  }

  // Comment path: structured layout with CTE items at cteIndent
  const parts: string[] = [];
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    const itemLines: string[] = [];
    const isFirst = i === 0;
    const isLast = i === items.length - 1;
    const withKw = recursive ? 'WITH RECURSIVE ' : 'WITH ';

    const trailingStr =
      item.trailingComments && item.trailingComments.length > 0
        ? ' ' + item.trailingComments.join(' ')
        : '';

    if (item.type === 'WithElement') {
      // Item leading comments
      if (item.leadingComments && item.leadingComments.length > 0) {
        for (const c of item.leadingComments) {
          itemLines.push(`${indent}${c}`);
        }
      }
      const suffix = isLast ? ')' : '),';
      const namePrefix = isFirst ? `${indent}${withKw}` : `${cteIndent}`;
      const colAliases = item.aliases
        ? ` (${((item.aliases.children ?? []) as IdentifierNode[]).map((a) => quoteIdent(a.name)).join(', ')})`
        : '';
      itemLines.push(`${namePrefix}${quoteIdent(item.name)}${colAliases} AS (`);
      const query = item.subquery.query;
      if (query.leadingComments && query.leadingComments.length > 0) {
        for (const c of query.leadingComments) {
          itemLines.push(`${innerIndent}${c}`);
        }
      }
      let queryStr = formatStatement(query, innerIndent);
      if (_endComments.length > 0) {
        queryStr += ' ' + _endComments.join(' ');
        _endComments = [];
      }
      if (query.trailingComments && query.trailingComments.length > 0) {
        queryStr += ' ' + query.trailingComments.join(' ');
      }
      itemLines.push(queryStr);
      itemLines.push(`${indent}${suffix}${trailingStr}`);
    } else if (
      item.type === 'Function' &&
      item.name === 'tuple' &&
      item.is_operator === true &&
      item.alias === undefined
    ) {
      if (item.leadingComments && item.leadingComments.length > 0) {
        for (const c of item.leadingComments) {
          itemLines.push(`${indent}${c}`);
        }
      }
      const suffix = isLast ? '' : ',';
      const tuplePrefix = isFirst ? `${indent}${withKw}` : `${cteIndent}`;
      const inner = item.arguments
        .map((e: Expression) => `${innerIndent}${formatExpr(e, innerIndent)}`)
        .join(',\n');
      itemLines.push(`${tuplePrefix}(\n${inner})${suffix}${trailingStr}`);
    } else {
      // Aliased expression CTE
      const suffix = isLast ? '' : ',';
      if (item.leadingComments && item.leadingComments.length > 0) {
        for (const c of item.leadingComments) {
          itemLines.push(`${cteIndent}${c}`);
        }
      }
      const exprPrefix = isFirst ? `${indent}${withKw}` : `${cteIndent}`;
      // Strip comments handled here so formatExprCore doesn't re-render them
      const bare = {
        ...item,
        leadingComments: undefined,
        trailingComments: undefined,
      } as Expression;
      const exprStr = formatExprCore(bare, cteIndent);
      itemLines.push(`${exprPrefix}${exprStr}${suffix}${trailingStr}`);
    }

    parts.push(itemLines.join('\n'));
  }

  return parts.join('\n\n');
}

function formatTablesClause(tables: TablesInSelectQueryNode, outerIndent: string): string[] {
  const innerIndent = outerIndent + '    ';
  const result: string[] = [];
  for (let i = 0; i < tables.children.length; i++) {
    const el = tables.children[i];
    if (el.array_join !== undefined) {
      const kw = el.array_join.kind === 'LEFT' ? 'LEFT ARRAY JOIN' : 'ARRAY JOIN';
      const exprsStr = el.array_join.expressions.map((e) => formatExpr(e, innerIndent)).join(', ');
      result.push(`${outerIndent}${kw} ${exprsStr}`);
      continue;
    }
    const te = el.table_expression!;
    const teStr = formatTableExpression(te, innerIndent);
    if (el.table_join !== undefined) {
      const j = el.table_join;
      let kw = '';
      if (j.kind === 'COMMA') {
        // Comma joins render attached to the previous line
        const prev = result.pop() ?? '';
        result.push(`${prev},`);
        result.push(`${innerIndent}${teStr}`);
        continue;
      }
      if (j.locality === 'GLOBAL') kw += 'GLOBAL ';
      if (j.strictness !== undefined) kw += `${j.strictness} `;
      kw += j.kind === 'INNER' ? 'INNER JOIN' : `${j.kind} JOIN`;
      result.push(`${outerIndent}${kw} ${teStr}`);
      if (j.on !== undefined) {
        result.push(`${innerIndent}ON ${formatExpr(j.on, innerIndent)}`);
      } else if (j.using !== undefined) {
        if (j.using.length === 1 && j.using[0].type === 'Asterisk') {
          result.push(`${innerIndent}USING *`);
        } else {
          const cols = j.using.map((u) => formatExpr(u, innerIndent)).join(', ');
          result.push(`${innerIndent}USING (${cols})`);
        }
      }
      continue;
    }
    // Base table expression
    const leading: string[] = [];
    if (te.leadingComments && te.leadingComments.length > 0) {
      for (const c of te.leadingComments) leading.push(`${innerIndent}${c}`);
    }
    result.push(...leading, `${innerIndent}${teStr}`);
  }
  return result;
}

// Format a SampleRatio as `n` (when denominator is 1) or `n/d`. The source
// spelling (e.g. `0.1` for `1/10`) is not preserved — canonical fraction
// form is semantically equivalent and reformats cleanly.
function formatSampleRatio(ratio: SampleRatioNode): string {
  if (ratio.denominator === '1') return ratio.numerator;
  return `${ratio.numerator}/${ratio.denominator}`;
}

function formatTableExpression(te: TableExpressionNode, indent: string): string {
  let result: string;
  if (te.database_and_table_name !== undefined) {
    const ti = te.database_and_table_name;
    // `quoteIdent` handles both a plain string name and an identifier-position
    // query parameter (`{db:Identifier}.t`).
    const namePart = quoteIdent(ti.name);
    const dbPart = ti.database !== undefined ? quoteIdent(ti.database) + '.' : '';
    result = dbPart + namePart;
    if (ti.alias !== undefined) result += ` AS ${quoteIdent(ti.alias)}`;
  } else if (te.table_function !== undefined) {
    const f = te.table_function;
    const noAlias = { ...f, alias: undefined } as FunctionNode;
    result = formatFunction(noAlias, indent);
    if (f.alias !== undefined) result += ` AS ${quoteIdent(f.alias)}`;
  } else {
    const sq = te.subquery!;
    const innerIndent = indent + '    ';
    const query = sq.query;
    let queryStr = formatStatement(query, innerIndent);
    if (_endComments.length > 0) {
      queryStr += ' ' + _endComments.join(' ');
      _endComments = [];
    }
    if (query.trailingComments && query.trailingComments.length > 0) {
      queryStr += ' ' + query.trailingComments.join(' ');
    }
    let leadingStr = '';
    if (query.leadingComments && query.leadingComments.length > 0) {
      leadingStr = query.leadingComments.map((c) => `${innerIndent}${c}`).join('\n') + '\n';
    }
    result = `(\n${leadingStr}${queryStr}\n${indent})`;
    if (sq.alias !== undefined) result += ` AS ${quoteIdent(sq.alias)}`;
    if (te.column_aliases !== undefined) {
      result += ` (${((te.column_aliases.children ?? []) as IdentifierNode[]).map((a) => quoteIdent(a.name)).join(', ')})`;
    }
  }
  if (te.final) result += ' FINAL';
  if (te.sample_size !== undefined) {
    result += ` SAMPLE ${formatSampleRatio(te.sample_size)}`;
    if (te.sample_offset !== undefined) {
      result += ` OFFSET ${formatSampleRatio(te.sample_offset)}`;
    }
  }
  if (te.trailingComments && te.trailingComments.length > 0) {
    result += ' ' + te.trailingComments.join(' ');
  }
  return result;
}

function formatSelectQuery(stmt: SelectQueryNode, indent: string): string {
  const innerIndent = indent + '    ';
  const lines: string[] = [];

  if (stmt.with && stmt.with.length > 0) {
    lines.push(formatCTEBlock(stmt.with, indent, stmt.recursive_with));
    lines.push('');
  }

  const distinctStr = stmt.distinct ? ' DISTINCT' : '';
  const firstItemHasLeadingComments =
    stmt.select[0]?.leadingComments && stmt.select[0].leadingComments.length > 0;
  if (stmt.select.length === 1 && !firstItemHasLeadingComments) {
    const item = stmt.select[0];
    const selectLine = `${indent}SELECT${distinctStr} ${formatExprCore(item, innerIndent)}`;
    lines.push(selectLine);
    _endComments = item.trailingComments ? [...item.trailingComments] : [];
  } else {
    lines.push(`${indent}SELECT${distinctStr}`);
    const [text, endComments] = formatExprList(stmt.select, innerIndent);
    lines.push(text);
    _endComments = endComments;
  }

  if (stmt.from) {
    flushEndComments(lines);
    if (stmt.from.leadingComments && stmt.from.leadingComments.length > 0) {
      for (const c of stmt.from.leadingComments) {
        lines.push(`${indent}${c}`);
      }
    }
    const fromLines = formatTablesClause(stmt.from, indent);
    if (fromLines.length === 1) {
      lines.push(`${indent}FROM ${fromLines[0].trimStart()}`);
    } else {
      lines.push(`${indent}FROM`);
      for (const line of fromLines) lines.push(line);
    }
  }

  if (stmt.prewhere) {
    flushEndComments(lines);
    lines.push(`${indent}PREWHERE ${formatExpr(stmt.prewhere, innerIndent)}`);
  }

  if (stmt.where) {
    flushEndComments(lines);
    const whereTrailing =
      stmt.where.trailingComments && stmt.where.trailingComments.length > 0
        ? ' ' + stmt.where.trailingComments.join(' ')
        : '';
    if (stmt.where.leadingComments && stmt.where.leadingComments.length > 0) {
      lines.push(`${indent}WHERE`);
      for (const c of stmt.where.leadingComments) {
        lines.push(`${innerIndent}${c}`);
      }
      lines.push(`${innerIndent}${formatExprCore(stmt.where, innerIndent)}${whereTrailing}`);
    } else {
      lines.push(`${indent}WHERE ${formatExprCore(stmt.where, innerIndent)}${whereTrailing}`);
    }
  }

  if (stmt.group_by_all) {
    flushEndComments(lines);
    lines.push(`${indent}GROUP BY ALL`);
  } else if (stmt.group_by) {
    flushEndComments(lines);
    if (stmt.group_by_with_grouping_sets) {
      const setsStr = stmt.group_by
        .map(
          (set) =>
            `(${(((set as ExpressionListNode).children ?? []) as Expression[])
              .map((e) => formatExpr(e, innerIndent))
              .join(', ')})`,
        )
        .join(', ');
      lines.push(`${indent}GROUP BY GROUPING SETS (${setsStr})`);
    } else {
      const items = stmt.group_by as Expression[];
      if (
        items.length === 1 &&
        !(items[0].leadingComments && items[0].leadingComments.length > 0)
      ) {
        const item = items[0];
        lines.push(`${indent}GROUP BY ${formatExprCore(item, innerIndent)}`);
        _endComments = item.trailingComments ? [...item.trailingComments] : [];
      } else {
        lines.push(`${indent}GROUP BY`);
        const [text, endComments] = formatExprList(items, innerIndent);
        lines.push(text);
        _endComments = endComments;
      }
    }
  }
  // `GROUP BY ROLLUP(...)`/`CUBE(...)` function syntax canonicalizes to the
  // equivalent trailing `WITH ROLLUP`/`WITH CUBE` form on format.
  if (stmt.group_by_with_cube) {
    flushEndComments(lines);
    lines.push(`${indent}WITH CUBE`);
  }
  if (stmt.group_by_with_rollup) {
    flushEndComments(lines);
    lines.push(`${indent}WITH ROLLUP`);
  }
  if (stmt.group_by_with_totals) {
    flushEndComments(lines);
    lines.push(`${indent}WITH TOTALS`);
  }

  if (stmt.having) {
    flushEndComments(lines);
    lines.push(`${indent}HAVING ${formatExpr(stmt.having, innerIndent)}`);
  }

  // WINDOW and QUALIFY canonicalize to the pre-LIMIT slot regardless of
  // where they appeared in the source.
  if (stmt.window !== undefined && stmt.window.length > 0) {
    flushEndComments(lines);
    if (stmt.window.length === 1) {
      const w = stmt.window[0];
      lines.push(
        `${indent}WINDOW ${quoteIdent(w.name)} AS (${formatWindowDefinition(w.definition, indent)})`,
      );
    } else {
      lines.push(`${indent}WINDOW`);
      lines.push(
        stmt.window
          .map(
            (w) =>
              `${innerIndent}${quoteIdent(w.name)} AS (${formatWindowDefinition(w.definition, innerIndent)})`,
          )
          .join(',\n'),
      );
    }
  }
  if (stmt.qualify) {
    flushEndComments(lines);
    lines.push(`${indent}QUALIFY ${formatExpr(stmt.qualify, innerIndent)}`);
  }

  if (stmt.order_by && stmt.order_by.length > 0) {
    flushEndComments(lines);
    const interpolateStr = formatInterpolateClause(stmt.interpolate, innerIndent);
    if (stmt.order_by.length === 1) {
      lines.push(
        `${indent}ORDER BY ${formatOrderByItem(stmt.order_by[0], innerIndent).trimStart()}${interpolateStr}`,
      );
    } else {
      lines.push(`${indent}ORDER BY`);
      lines.push(
        stmt.order_by.map((item) => formatOrderByItem(item, innerIndent)).join(',\n') +
          interpolateStr,
      );
    }
  }

  if (stmt.limit_by !== undefined) {
    flushEndComments(lines);
    const limitByOffset =
      stmt.limit_by.offset !== undefined ? `${formatExpr(stmt.limit_by.offset, indent)}, ` : '';
    const byClause =
      stmt.limit_by.by.length === 0
        ? 'ALL'
        : stmt.limit_by.by.map((e) => formatExpr(e, indent)).join(', ');
    lines.push(
      `${indent}LIMIT ${limitByOffset}${formatExpr(stmt.limit_by.length, indent)} BY ${byClause}`,
    );
  }

  // LIMIT/OFFSET canonicalize to `LIMIT length [OFFSET offset] [WITH TIES]`
  // regardless of the source spelling (comma form, SQL-standard FETCH, or
  // `SELECT TOP n`).
  if (stmt.limit !== undefined) {
    flushEndComments(lines);
    const tiesStr = stmt.limit_with_ties ? ' WITH TIES' : '';
    lines.push(`${indent}LIMIT ${formatExpr(stmt.limit, indent)}${tiesStr}`);
    if (stmt.offset !== undefined) lines.push(`${indent}OFFSET ${formatExpr(stmt.offset, indent)}`);
  } else if (stmt.offset !== undefined) {
    flushEndComments(lines);
    lines.push(`${indent}OFFSET ${formatExpr(stmt.offset, indent)}`);
  }

  if (stmt.settings) {
    const pairs = formatSetPairs(stmt.settings);
    if (pairs.length > 0) {
      flushEndComments(lines);
      if (pairs.length === 1) {
        lines.push(`${indent}SETTINGS ${pairs[0]}`);
      } else {
        lines.push(`${indent}SETTINGS`);
        lines.push(pairs.map((p) => `${innerIndent}${p}`).join(',\n'));
      }
    }
  }

  return lines.join('\n');
}

function formatInterpolateClause(
  interpolate: InterpolateElementNode[] | undefined,
  indent: string,
): string {
  if (interpolate === undefined) return '';
  return ` INTERPOLATE (${interpolate.map((i) => formatInterpolateItem(i, indent)).join(', ')})`;
}
