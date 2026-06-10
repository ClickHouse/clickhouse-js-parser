import * as fs from 'fs';
import * as path from 'path';
import { formatExplain, parse } from '../src/index';
import { CLICKHOUSE_DIR, discoverCases, readReferenceSql } from './helpers';

const QUERY_PARAMS = '<Query Parameters>';
const EXPLAIN_ERROR = '<Explain Error>';

describe('clickhouse reference - explain', () => {
  for (const fileName of discoverCases()) {
    const filePath = path.join(CLICKHOUSE_DIR, fileName);
    const explainPath = `${filePath}.expected.explain.txt`;

    it(fileName, () => {
      if (!fs.existsSync(explainPath)) return;

      const sql = readReferenceSql(filePath);
      const statements = parse(sql);

      const expectedEntries = fs.readFileSync(explainPath, 'utf-8').trimEnd().split('\n\n');
      for (let i = 0; i < expectedEntries.length; i++) {
        const expected = expectedEntries[i].trimEnd();
        if (expected === QUERY_PARAMS) continue;
        if (expected === EXPLAIN_ERROR) continue;
        const actual = formatExplain([statements[i]]).trimEnd();
        expect(actual).toBe(expected);
      }
    });
  }
});
