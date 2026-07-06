import { useEffect, useRef } from 'react';
import type { SourceLocation } from './ast-utils';

type Props = {
  value: string;
  onChange: (value: string) => void;
  /** Transient hover highlight range (from hovering a viz node). */
  highlight: SourceLocation | null;
  /** Persistent selection highlight range (from clicking a viz node). */
  selection: SourceLocation | null;
};

type Segment = { text: string; hover: boolean; selected: boolean };

/**
 * Splits `text` into contiguous segments at the boundaries of the hover and
 * selection ranges, tagging each segment with whether it falls inside either.
 * Handles the two ranges overlapping in any way.
 */
function buildSegments(
  text: string,
  hover: SourceLocation | null,
  selection: SourceLocation | null,
): Segment[] {
  const ranges: { start: number; end: number; kind: 'hover' | 'selected' }[] = [];
  if (hover && hover.end.offset > hover.start.offset) {
    ranges.push({ start: hover.start.offset, end: hover.end.offset, kind: 'hover' });
  }
  if (selection && selection.end.offset > selection.start.offset) {
    ranges.push({ start: selection.start.offset, end: selection.end.offset, kind: 'selected' });
  }
  if (ranges.length === 0) return [{ text, hover: false, selected: false }];

  // Collect and sort unique boundary offsets.
  const bounds = new Set<number>([0, text.length]);
  for (const r of ranges) {
    bounds.add(Math.max(0, Math.min(text.length, r.start)));
    bounds.add(Math.max(0, Math.min(text.length, r.end)));
  }
  const points = [...bounds].sort((a, b) => a - b);

  const segments: Segment[] = [];
  for (let i = 0; i < points.length - 1; i++) {
    const s = points[i];
    const e = points[i + 1];
    if (e <= s) continue;
    const hoverOn = ranges.some((r) => r.kind === 'hover' && r.start <= s && r.end >= e);
    const selOn = ranges.some((r) => r.kind === 'selected' && r.start <= s && r.end >= e);
    segments.push({ text: text.slice(s, e), hover: hoverOn, selected: selOn });
  }
  return segments;
}

/**
 * SQL text input. A native <textarea> cannot style substrings, so we render a
 * pixel-aligned mirror <div> behind it that reproduces the text with the
 * hovered node's range wrapped in a highlight <span>. The textarea sits on top
 * with a transparent background, so the user edits normally while the backdrop
 * shows the highlight. Both elements must share identical typography, padding,
 * and box metrics for the overlay to line up.
 */
export function SqlInput({ value, onChange, highlight, selection }: Props) {
  const backdropRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // Keep the backdrop scrolled in sync with the textarea.
  useEffect(() => {
    const ta = textareaRef.current;
    const bd = backdropRef.current;
    if (!ta || !bd) return;
    const sync = () => {
      bd.scrollTop = ta.scrollTop;
      bd.scrollLeft = ta.scrollLeft;
    };
    ta.addEventListener('scroll', sync);
    sync();
    return () => ta.removeEventListener('scroll', sync);
  }, []);

  const segments = buildSegments(value, highlight, selection);

  return (
    <div className="sql-input">
      <label className="sql-input-label">SQL input</label>
      <div className="sql-input-wrap">
        <div className="sql-backdrop" ref={backdropRef} aria-hidden="true">
          <div className="sql-mirror">
            {segments.map((seg, i) => {
              if (!seg.hover && !seg.selected) return <span key={i}>{seg.text}</span>;
              const cls = seg.hover
                ? seg.selected
                  ? 'sql-highlight sql-highlight-both'
                  : 'sql-highlight'
                : 'sql-highlight sql-highlight-selected';
              return (
                <mark key={i} className={cls}>
                  {seg.text}
                </mark>
              );
            })}
            {/* trailing newline keeps mirror height in sync with textarea */}
            {'\n'}
          </div>
        </div>
        <textarea
          ref={textareaRef}
          className="sql-textarea"
          value={value}
          spellCheck={false}
          onChange={(e) => onChange(e.target.value)}
          placeholder="Enter ClickHouse SQL…"
        />
      </div>
    </div>
  );
}
