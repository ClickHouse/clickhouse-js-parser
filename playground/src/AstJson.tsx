import { useMemo, useState } from 'react';
import type { AstNode } from './ast-utils';

type Props = {
  statements: AstNode[];
};

/** JSON.stringify replacer that drops `location` (and any circular `parent`). */
function stripLocations(_key: string, value: unknown): unknown {
  if (_key === 'location' || _key === 'parent') return undefined;
  return value;
}

export function AstJson({ statements }: Props) {
  const [includeLocations, setIncludeLocations] = useState(false);

  const json = useMemo(
    () => JSON.stringify(statements, includeLocations ? undefined : stripLocations, 2),
    [statements, includeLocations],
  );

  return (
    <div className="json-view">
      <label className="json-toggle">
        <input
          type="checkbox"
          checked={includeLocations}
          onChange={(e) => setIncludeLocations(e.target.checked)}
        />
        Include source locations
      </label>
      <pre className="json-pre">{json}</pre>
    </div>
  );
}
