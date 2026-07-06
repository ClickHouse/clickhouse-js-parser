import { format, parse } from '../src/index';

describe('formatting comments', () => {
  it('should preserve and correctly format comments', () => {
    const input = `
-- leading comment
SELECT -- comment 1
  1, -- comment 3
  -- comment 2
  2, 3; -- comment 4
`;
    const formatted = format(parse(input));
    expect(formatted).toBe(
      `
-- leading comment
SELECT
    -- comment 1
    1, -- comment 3
    -- comment 2
    2,
    3; -- comment 4
`.trim(),
    );
  });

  it('should preserve and correctly format comments', () => {
    const input = `
SELECT
  toStartOfInterval(TimestampTime, INTERVAL {intervalSeconds:Int64} second) AS ts, -- (Timestamp column)
  ServiceName,                                                                     -- (Group name column)
  count()                                                                          -- (Series value column)
FROM otel_logs
WHERE TimestampTime >= fromUnixTimestamp64Milli ({startDateMilliseconds:Int64})
  AND TimestampTime < fromUnixTimestamp64Milli ({endDateMilliseconds:Int64})
GROUP BY ServiceName, ts
`;
    const formatted = format(parse(input));
    expect(formatted).toBe(
      `
SELECT
    toStartOfInterval(TimestampTime, toIntervalSecond({intervalSeconds:Int64})) AS ts, -- (Timestamp column)
    ServiceName, -- (Group name column)
    count() -- (Series value column)
FROM otel_logs
WHERE TimestampTime >= fromUnixTimestamp64Milli({startDateMilliseconds:Int64})
    AND TimestampTime < fromUnixTimestamp64Milli({endDateMilliseconds:Int64})
GROUP BY
    ServiceName,
    ts;
`.trim(),
    );
  });

  it('should preserve and correctly format comments', () => {
    const input = `
SELECT *
FROM otel_logs
WHERE
  -- This is a comment about the first timestamp filter
  TimestampTime >= fromUnixTimestamp64Milli ({startDateMilliseconds:Int64})
  -- This is a comment about the second timestamp filter
  AND TimestampTime < fromUnixTimestamp64Milli ({endDateMilliseconds:Int64})
GROUP BY 
  -- Comment 1
  ServiceName,
  -- Comment 2
  ts; -- Comment 3
`;
    const formatted = format(parse(input));
    expect(formatted).toBe(
      `
SELECT *
FROM otel_logs
WHERE
    -- This is a comment about the first timestamp filter
    TimestampTime >= fromUnixTimestamp64Milli({startDateMilliseconds:Int64})
    -- This is a comment about the second timestamp filter
    AND TimestampTime < fromUnixTimestamp64Milli({endDateMilliseconds:Int64})
GROUP BY
    -- Comment 1
    ServiceName,
    -- Comment 2
    ts; -- Comment 3
`.trim(),
    );
  });

  it('should preserve and correctly format comments', () => {
    const input = `
-- 1
WITH 
  -- 2
  sub AS (
    -- 3
    SELECT 1 -- 4
  ), -- 5
  
  -- 7
  42 
  -- 6
  * 2 
  -- 8
  AS magic_number -- 9

SELECT
    -- 10
    *, --11
    -- 12
    -- 13
    otel_logs.TimestampTime -- 14
-- 15
FROM otel_logs
-- 16
; -- 17

`;
    const formatted = format(parse(input));
    expect(formatted).toBe(
      `
-- 1
-- 2
WITH sub AS (
    -- 3
    SELECT 1
), -- 5

  -- 7
  42
  -- 6
  * 2 AS magic_number -- 8 -- 9

SELECT
    -- 10
    *, --11
    -- 12
    -- 13
    otel_logs.TimestampTime -- 14
-- 15
FROM otel_logs; -- 16
-- 17`.trim(),
    );
  });

  it('should preserve and correctly format comments', () => {
    const input = `
SELECT *
FROM otel_logs
WHERE TimestampTime >= fromUnixTimestamp64Milli (
    -- 1
    {startDateMilliseconds:Int64},
    -- 2
    {endDateMilliseconds:Int64}
)
`;
    const formatted = format(parse(input));
    expect(formatted).toBe(
      `
SELECT *
FROM otel_logs
WHERE TimestampTime >= fromUnixTimestamp64Milli(
    -- 1
    {startDateMilliseconds:Int64},
    -- 2
    {endDateMilliseconds:Int64}
);
`.trim(),
    );
  });
});
