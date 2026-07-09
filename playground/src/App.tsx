import { useCallback, useMemo, useRef, useState } from 'react';
import { parse, format, formatExplain, formatExplainJson } from '@clickhouse/parser';
import type { AstNode, SourceLocation } from './ast-utils';
import { SqlInput } from './SqlInput';
import { AstJson } from './AstJson';
import { AstViz } from './AstViz';
import { NodeDetail } from './NodeDetail';
import { TextOutput } from './TextOutput';
import { JsonExplain } from './JsonExplain';

const DEFAULT_SQL = `SELECT
    user_id,
    count() AS events,
    max(ts) AS last_seen
FROM events
WHERE ts > now() - INTERVAL 7 DAY
    AND status IN ('active', 'trial')
GROUP BY user_id
HAVING events > {min_events:UInt32}
ORDER BY events DESC
LIMIT 100;`;

type Tab = 'json' | 'viz' | 'formatted' | 'jsonExplain' | 'explain';

const TABS: { id: Tab; label: string }[] = [
  { id: 'json', label: 'AST (JSON)' },
  { id: 'viz', label: 'AST (Visual)' },
  { id: 'formatted', label: 'Formatted SQL' },
  { id: 'explain', label: 'Explain AST' },
  { id: 'jsonExplain', label: 'Explain AST JSON (v2)' },
];

type ParseResult = { ok: true; statements: AstNode[] } | { ok: false; error: string };

function tryRun<T>(fn: () => T): { ok: true; value: T } | { ok: false; error: string } {
  try {
    return { ok: true, value: fn() };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : String(e) };
  }
}

export function App() {
  const [sql, setSql] = useState(DEFAULT_SQL);
  const [tab, setTab] = useState<Tab>('viz');
  const [selected, setSelected] = useState<AstNode | null>(null);
  const [hoverLocation, setHoverLocation] = useState<SourceLocation | null>(null);
  // Left column width as a percentage of the columns container.
  const [leftPct, setLeftPct] = useState(42);
  const columnsRef = useRef<HTMLDivElement>(null);
  // Visualization pane height as a percentage of the output column.
  const [vizPct, setVizPct] = useState(60);
  const outputRef = useRef<HTMLDivElement>(null);

  // Generic split-pane drag: computes the cursor position as a percentage of
  // the container along the given axis, clamps it, and reports it to `onPct`.
  const startDrag = useCallback(
    (
      e: React.MouseEvent,
      axis: 'x' | 'y',
      container: HTMLElement | null,
      onPct: (pct: number) => void,
    ) => {
      e.preventDefault();
      if (!container) return;

      const onMove = (ev: MouseEvent) => {
        const rect = container.getBoundingClientRect();
        const pct =
          axis === 'x'
            ? ((ev.clientX - rect.left) / rect.width) * 100
            : ((ev.clientY - rect.top) / rect.height) * 100;
        onPct(Math.min(80, Math.max(20, pct)));
      };
      const onUp = () => {
        window.removeEventListener('mousemove', onMove);
        window.removeEventListener('mouseup', onUp);
        document.body.classList.remove('dragging-col', 'dragging-row');
      };
      document.body.classList.add(axis === 'x' ? 'dragging-col' : 'dragging-row');
      window.addEventListener('mousemove', onMove);
      window.addEventListener('mouseup', onUp);
    },
    [],
  );

  const parsed = useMemo<ParseResult>(() => {
    const r = tryRun(() => parse(sql) as unknown as AstNode[]);
    return r.ok ? { ok: true, statements: r.value } : { ok: false, error: r.error };
  }, [sql]);

  const formatted = useMemo(
    () => (parsed.ok ? tryRun(() => format(parsed.statements as never)) : null),
    [parsed],
  );
  const explained = useMemo(
    () => (parsed.ok ? tryRun(() => formatExplain(parsed.statements as never)) : null),
    [parsed],
  );
  const jsonExplained = useMemo(
    () =>
      parsed.ok
        ? tryRun(() => JSON.stringify(formatExplainJson(parsed.statements as never, 2), null, 2))
        : null,
    [parsed],
  );

  return (
    <div className="app">
      <header className="app-header">
        <h1>ClickHouse SQL Parser Playground</h1>
        <a
          href="https://github.com/ClickHouse/clickhouse-js-parser"
          target="_blank"
          rel="noreferrer"
        >
          GitHub
        </a>
      </header>

      <div className="columns" ref={columnsRef}>
        <div className="col col-input" style={{ width: `${leftPct}%` }}>
          <SqlInput
            value={sql}
            onChange={setSql}
            highlight={hoverLocation}
            selection={tab === 'viz' ? (selected?.location ?? null) : null}
          />
        </div>

        <div
          className="col-divider"
          role="separator"
          aria-orientation="vertical"
          onMouseDown={(e) => startDrag(e, 'x', columnsRef.current, setLeftPct)}
          title="Drag to resize"
        />

        <div className="col col-output">
          <div className="tabs" role="tablist">
            {TABS.map((t) => (
              <button
                key={t.id}
                role="tab"
                aria-selected={tab === t.id}
                className={tab === t.id ? 'tab tab-active' : 'tab'}
                onClick={() => setTab(t.id)}
              >
                {t.label}
              </button>
            ))}
          </div>

          <div className="output-body" ref={outputRef}>
            <div
              className="tab-panel"
              style={tab === 'viz' && parsed.ok ? { flex: `0 0 ${vizPct}%` } : undefined}
            >
              {!parsed.ok ? (
                <pre className="error">{`Parse error:\n${parsed.error}`}</pre>
              ) : tab === 'json' ? (
                <AstJson statements={parsed.statements} />
              ) : tab === 'viz' ? (
                <AstViz
                  statements={parsed.statements}
                  selected={selected}
                  onSelect={setSelected}
                  onHover={setHoverLocation}
                />
              ) : tab === 'formatted' ? (
                <TextOutput result={formatted} />
              ) : tab === 'jsonExplain' ? (
                <JsonExplain result={jsonExplained} />
              ) : (
                <TextOutput result={explained} />
              )}
            </div>

            {tab === 'viz' && parsed.ok && (
              <>
                <div
                  className="row-divider"
                  role="separator"
                  aria-orientation="horizontal"
                  onMouseDown={(e) => startDrag(e, 'y', outputRef.current, setVizPct)}
                  title="Drag to resize"
                />
                <div className="detail-panel">
                  <NodeDetail node={selected} />
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
