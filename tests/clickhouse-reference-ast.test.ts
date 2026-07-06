import * as fs from 'fs';
import * as path from 'path';
import { parse } from '../src/index';
import {
  CLICKHOUSE_DIR,
  discoverCases,
  pruneFilteredStorageSettings,
  pruneLibraryOnlyParamSettings,
  readReferenceSql,
  stripAstMeta,
} from './helpers';

const AST_ERROR = '<AST Error>';
const QUERY_PARAMS = '<Query Parameters>';

describe('clickhouse reference - ast', () => {
  for (const fileName of discoverCases()) {
    const filePath = path.join(CLICKHOUSE_DIR, fileName);
    const astPath = `${filePath}.expected.ast.json`;

    it(fileName, () => {
      if (!fs.existsSync(astPath)) return;

      const sql = readReferenceSql(filePath);
      const statements = parse(sql);
      const actual = stripAstMeta(statements) as unknown[];

      // Each entry in the reference JSON is either a sentinel string
      // (`<AST Error>`, `<Query Parameters>`) or a `{ version, ast }`
      // envelope wrapping the actual AST. Unwrap envelopes so the rest of
      // the comparison can treat them like raw AST nodes.
      const rawExpected = JSON.parse(fs.readFileSync(astPath, 'utf-8')) as unknown[];
      const expectedAst = rawExpected.map((entry) => {
        if (entry && typeof entry === 'object' && !Array.isArray(entry) && 'ast' in entry) {
          return (entry as { ast: unknown }).ast;
        }
        return entry;
      });
      // Tolerate ClickHouse's per-engine filtering of `Storage > Set` settings
      // (extra keys in actual only); see pruneFilteredStorageSettings.
      pruneFilteredStorageSettings(actual, expectedAst);
      // Tolerate `param_*` SET entries that this library keeps in changes
      // but the native AST drops (see pruneLibraryOnlyParamSettings).
      pruneLibraryOnlyParamSettings(actual, expectedAst);
      for (let i = 0; i < expectedAst.length; i++) {
        const expected = expectedAst[i];
        if (expected === AST_ERROR) continue;
        if (expected === QUERY_PARAMS) continue;
        expect(actual[i]).toEqual(expected);
      }
    });
  }
});
