import { useMemo, useState } from 'react';
import {
  colorForType,
  getChildren,
  getDataFields,
  type AstNode,
  type SourceLocation,
} from './ast-utils';

type Props = {
  statements: AstNode[];
  selected: AstNode | null;
  onSelect: (node: AstNode | null) => void;
  onHover: (location: SourceLocation | null) => void;
};

type Row = {
  node: AstNode;
  depth: number;
  label: string;
  key: string;
  hasChildren: boolean;
  collapsed: boolean;
};

/**
 * Depth-first flatten of the AST forest into ordered rows for the waterfall.
 * Descendants of a collapsed node are omitted; the node itself is still emitted
 * (flagged `collapsed`) so its toggle stays visible.
 */
function flatten(statements: AstNode[], collapsed: Set<string>): Row[] {
  const rows: Row[] = [];
  const walk = (node: AstNode, depth: number, label: string, key: string): void => {
    const children = getChildren(node);
    const isCollapsed = collapsed.has(key);
    rows.push({
      node,
      depth,
      label,
      key,
      hasChildren: children.length > 0,
      collapsed: isCollapsed,
    });
    if (isCollapsed) return;
    for (const child of children) {
      walk(child.node, depth + 1, child.label, `${key}/${child.label}`);
    }
  };
  statements.forEach((s, i) => walk(s, 0, `statement[${i}]`, `s${i}`));
  return rows;
}

/** Short one-line summary of a node's data fields, e.g. `value: 100`. */
function summarize(node: AstNode): string {
  const data = getDataFields(node);
  const parts: string[] = [];
  for (const [k, v] of Object.entries(data)) {
    if (v == null) continue;
    if (typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean') {
      parts.push(`${k}: ${JSON.stringify(v)}`);
    }
    if (parts.length >= 3) break;
  }
  return parts.join('  ');
}

export function AstViz({ statements, selected, onSelect, onHover }: Props) {
  const [collapsed, setCollapsed] = useState<Set<string>>(new Set());

  const rows = useMemo(() => flatten(statements, collapsed), [statements, collapsed]);

  const toggle = (key: string) =>
    setCollapsed((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });

  if (rows.length === 0) {
    return <div className="viz-empty">No statements parsed.</div>;
  }

  return (
    <div className="viz">
      <div className="viz-toolbar">
        <button className="viz-btn" onClick={() => setCollapsed(new Set())}>
          Expand all
        </button>
        <button
          className="viz-btn"
          onClick={() =>
            setCollapsed(
              new Set(
                flatten(statements, new Set())
                  .filter((r) => r.hasChildren)
                  .map((r) => r.key),
              ),
            )
          }
        >
          Collapse all
        </button>
      </div>
      <div className="viz-rows" onMouseLeave={() => onHover(null)}>
        {rows.map((row) => {
          const color = colorForType(row.node.type);
          const isSelected = row.node === selected;
          return (
            <div
              key={row.key}
              className={isSelected ? 'viz-row viz-row-selected' : 'viz-row'}
              style={{ paddingLeft: row.depth * 16 }}
              onMouseEnter={() => onHover(row.node.location ?? null)}
              onClick={() => onSelect(isSelected ? null : row.node)}
              title={row.label}
            >
              {row.hasChildren ? (
                <button
                  className="viz-toggle"
                  onClick={(e) => {
                    e.stopPropagation();
                    toggle(row.key);
                  }}
                  aria-label={row.collapsed ? 'Expand' : 'Collapse'}
                >
                  {row.collapsed ? '▸' : '▾'}
                </button>
              ) : (
                <span className="viz-toggle viz-toggle-empty" />
              )}
              <span className="viz-bar" style={{ borderLeftColor: color }}>
                <span className="viz-type" style={{ color }}>
                  {row.node.type}
                </span>
                {row.depth > 0 && <span className="viz-label">{row.label}</span>}
                <span className="viz-summary">{summarize(row.node)}</span>
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
