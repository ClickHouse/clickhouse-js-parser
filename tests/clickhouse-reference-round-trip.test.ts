import * as path from 'path';
import { format, parse } from '../src/index';
import { CLICKHOUSE_DIR, discoverCases, readReferenceSql, stripVolatile } from './helpers';

describe('clickhouse reference - round-trip', () => {
  for (const fileName of discoverCases()) {
    const filePath = path.join(CLICKHOUSE_DIR, fileName);

    it(fileName, () => {
      const sql = readReferenceSql(filePath);
      const statements = parse(sql);

      const sqlFormatted = format(statements);
      const reparsed = parse(sqlFormatted);
      expect(stripVolatile(reparsed)).toEqual(stripVolatile(statements));
    });
  }
});
