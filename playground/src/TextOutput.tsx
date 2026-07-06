type Result = { ok: true; value: string } | { ok: false; error: string } | null;

type Props = {
  result: Result;
};

/** Renders a string result (formatted SQL / explain) or its error. */
export function TextOutput({ result }: Props) {
  if (!result) return <div className="viz-empty">No output.</div>;
  if (!result.ok) {
    return <pre className="error">{`Error:\n${result.error}`}</pre>;
  }
  return <pre className="text-output">{result.value}</pre>;
}
