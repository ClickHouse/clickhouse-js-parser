type Result = { ok: true; value: string } | { ok: false; error: string } | null;

type Props = {
  result: Result;
};

/**
 * Renders the `formatJsonExplain` output (the ClickHouse-native `EXPLAIN AST
 * json = 2` view, `{ version, ast }` per statement) as formatted JSON, or its
 * error.
 */
export function JsonExplain({ result }: Props) {
  if (!result) return <div className="viz-empty">No output.</div>;
  if (!result.ok) {
    return <pre className="error">{`Error:\n${result.error}`}</pre>;
  }
  return (
    <div className="json-view">
      <pre className="json-pre">{result.value}</pre>
    </div>
  );
}
