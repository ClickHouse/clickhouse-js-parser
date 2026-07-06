import { colorForType, getDataFields, type AstNode } from './ast-utils';

type Props = {
  node: AstNode | null;
};

/**
 * Bottom panel showing the selected node's non-child, non-location fields
 * (primitives plus node-free arrays/objects) as pretty JSON.
 */
export function NodeDetail({ node }: Props) {
  if (!node) {
    return (
      <div className="detail-empty">Click a node in the visualization to inspect its fields.</div>
    );
  }

  const data = getDataFields(node);
  const color = colorForType(node.type);
  const loc = node.location;

  return (
    <div className="detail">
      <div className="detail-title">
        <span className="detail-type" style={{ color }}>
          {node.type}
        </span>
        {loc && (
          <span className="detail-loc">
            offset {loc.start.offset}–{loc.end.offset} (line {loc.start.line}:{loc.start.column})
          </span>
        )}
      </div>
      {Object.keys(data).length === 0 ? (
        <div className="detail-empty">No data fields (this node only has children).</div>
      ) : (
        <pre className="detail-json">{JSON.stringify(data, null, 2)}</pre>
      )}
    </div>
  );
}
