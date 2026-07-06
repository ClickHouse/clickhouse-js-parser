// Generic, library-internals-free helpers for walking a parsed ClickHouse AST.
//
// Every AST node the parser emits is a plain object carrying a string `type`
// discriminator plus a `location` range. Children are nested nodes (or arrays
// of nodes) reachable from a node's own fields; everything else (primitives,
// and arrays/objects that contain no nodes) is "data". This mirrors the walk
// logic used by the library's own find-nodes.ts, but stays decoupled from it.

export type SourceLocation = {
  start: { offset: number; line: number; column: number };
  end: { offset: number; line: number; column: number };
};

export type AstNode = {
  type: string;
  location?: SourceLocation;
  [key: string]: unknown;
};

// Metadata keys that are never treated as children or shown as data fields.
const META_KEYS = new Set(['location', 'parent']);

/** True for a plain object carrying a string `type` discriminator. */
export function isNode(value: unknown): value is AstNode {
  return (
    typeof value === 'object' &&
    value !== null &&
    !Array.isArray(value) &&
    typeof (value as { type?: unknown }).type === 'string'
  );
}

/** True for an object shaped like a {@link SourceLocation}. */
function isLocation(value: unknown): boolean {
  if (typeof value !== 'object' || value === null) return false;
  const v = value as Record<string, unknown>;
  const start = v.start as Record<string, unknown> | undefined;
  const end = v.end as Record<string, unknown> | undefined;
  return !!start && !!end && typeof start.offset === 'number' && typeof end.offset === 'number';
}

/** True if `value` is a node, or an array/object that (recursively) contains a node. */
function containsNode(value: unknown): boolean {
  if (isNode(value)) return true;
  if (Array.isArray(value)) return value.some(containsNode);
  if (typeof value === 'object' && value !== null && !isLocation(value)) {
    return Object.values(value as Record<string, unknown>).some(containsNode);
  }
  return false;
}

export type NamedChild = {
  /** The field name the child was found under (arrays get `field[i]`). */
  label: string;
  node: AstNode;
};

/**
 * Returns the direct child nodes of `node`, in declaration order, each labelled
 * by the field (and index, for arrays) it was reached through. Descends through
 * intermediate arrays/objects that are not themselves nodes so structural
 * wrappers don't hide the real children.
 */
export function getChildren(node: AstNode): NamedChild[] {
  const children: NamedChild[] = [];

  const visit = (value: unknown, label: string): void => {
    if (isNode(value)) {
      children.push({ label, node: value });
      return;
    }
    if (Array.isArray(value)) {
      value.forEach((item, i) => visit(item, `${label}[${i}]`));
      return;
    }
    if (typeof value === 'object' && value !== null && !isLocation(value)) {
      for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
        if (containsNode(v)) visit(v, `${label}.${k}`);
      }
    }
  };

  for (const [key, value] of Object.entries(node)) {
    if (META_KEYS.has(key)) continue;
    if (key === 'type') continue;
    if (containsNode(value)) visit(value, key);
  }

  return children;
}

/**
 * Returns the "data" fields of a node: everything that is not `type`, not
 * metadata (`location`/`parent`), and does not (recursively) contain a child
 * node. These are the primitive values plus node-free arrays/objects — e.g. a
 * Literal's `value`, an Identifier's `name`.
 */
export function getDataFields(node: AstNode): Record<string, unknown> {
  const data: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(node)) {
    if (key === 'type' || META_KEYS.has(key)) continue;
    if (containsNode(value)) continue;
    data[key] = value;
  }
  return data;
}

// ── Deterministic per-type colors ────────────────────────────────────────────

// A fixed palette of visually distinct, readable colors. A node type always
// maps to the same color across renders (hash of the type string).
const PALETTE = [
  '#4e79a7',
  '#f28e2b',
  '#e15759',
  '#76b7b2',
  '#59a14f',
  '#edc948',
  '#b07aa1',
  '#ff9da7',
  '#9c755f',
  '#bab0ac',
  '#86bcb6',
  '#d37295',
  '#8cd17d',
  '#b6992d',
  '#499894',
  '#79706e',
];

function hashString(s: string): number {
  let h = 2166136261;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}

/** Deterministic palette color for a node type. */
export function colorForType(type: string): string {
  return PALETTE[hashString(type) % PALETTE.length];
}
