import * as fs from 'fs';
import * as path from 'path';
import { parse } from '../src/index';
import {
  CLICKHOUSE_DIR,
  discoverCases,
  formatExplainJson,
  pruneFilteredStorageSettings,
  pruneLibraryOnlyParamSettings,
  readReferenceSql,
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
      const actual = formatExplainJson(statements, 2) as unknown[];

      // Each entry in the reference JSON is either a sentinel string
      // (`<AST Error>`, `<Query Parameters>`) or a `{ version, ast }` envelope.
      const expected = JSON.parse(fs.readFileSync(astPath, 'utf-8')) as unknown[];
      // Tolerate ClickHouse's per-engine filtering of `Storage > Set` settings
      // (extra keys in actual only); see pruneFilteredStorageSettings.
      pruneFilteredStorageSettings(actual, expected);
      // Tolerate `param_*` SET entries that this library keeps in changes
      // but the native AST drops (see pruneLibraryOnlyParamSettings).
      pruneLibraryOnlyParamSettings(actual, expected);
      for (let i = 0; i < expected.length; i++) {
        if (expected[i] === AST_ERROR) continue;
        if (expected[i] === QUERY_PARAMS) continue;
        expect(actual[i]).toEqual(expected[i]);
      }
    });
  }
});
