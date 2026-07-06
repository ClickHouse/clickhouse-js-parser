-- { echoOn }
DROP TABLE IF EXISTS funnel_test;

CREATE TABLE funnel_test
(
    timestamp UInt32,
    event UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test;

SELECT 1 = windowFunnel(10000)(timestamp, event = 1000)
FROM funnel_test;

SELECT 2 = windowFunnel(10000)(timestamp, event = 1000, event = 1001)
FROM funnel_test;

SELECT 3 = windowFunnel(10000)(timestamp, event = 1000, event = 1001, event = 1002)
FROM funnel_test;

SELECT 4 = windowFunnel(10000)(timestamp, event = 1000, event = 1001, event = 1002, event = 1008)
FROM funnel_test;

SELECT 1 = windowFunnel(1)(timestamp, event = 1000)
FROM funnel_test;

SELECT 3 = windowFunnel(2)(timestamp, event = 1003, event = 1004, event = 1005, event = 1006, event = 1007)
FROM funnel_test;

SELECT 4 = windowFunnel(3)(timestamp, event = 1003, event = 1004, event = 1005, event = 1006, event = 1007)
FROM funnel_test;

SELECT 5 = windowFunnel(4)(timestamp, event = 1003, event = 1004, event = 1005, event = 1006, event = 1007)
FROM funnel_test;

DROP TABLE IF EXISTS funnel_test2;

CREATE TABLE funnel_test2
(
    uid UInt32 DEFAULT 1,
    timestamp DateTime,
    event UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test2 (timestamp, event);

SELECT 5 = windowFunnel(4)(timestamp, event = 1003, event = 1004, event = 1005, event = 1006, event = 1007)
FROM funnel_test2;

SELECT 2 = windowFunnel(10000)(timestamp, event = 1001, event = 1008)
FROM funnel_test2;

SELECT 1 = windowFunnel(10000)(timestamp, event = 1008, event = 1001)
FROM funnel_test2;

SELECT 4 = windowFunnel(4)(timestamp, event <= 1007, event >= 1002, event <= 1006, event >= 1004)
FROM funnel_test2;

DROP TABLE IF EXISTS funnel_test_u64;

CREATE TABLE funnel_test_u64
(
    uid UInt32 DEFAULT 1,
    timestamp UInt64,
    event UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test_u64 (timestamp, event);

SELECT 5 = windowFunnel(4)(timestamp, event = 1003, event = 1004, event = 1005, event = 1006, event = 1007)
FROM funnel_test_u64;

SELECT 2 = windowFunnel(10000)(timestamp, event = 1001, event = 1008)
FROM funnel_test_u64;

SELECT 1 = windowFunnel(10000)(timestamp, event = 1008, event = 1001)
FROM funnel_test_u64;

SELECT 4 = windowFunnel(4)(timestamp, event <= 1007, event >= 1002, event <= 1006, event >= 1004)
FROM funnel_test_u64;

DROP TABLE IF EXISTS funnel_test_strict;

CREATE TABLE funnel_test_strict
(
    timestamp UInt32,
    event UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test_strict;

SELECT 6 = windowFunnel(10000, 'strict_deduplication')(timestamp, event = 1000, event = 1001, event = 1002, event = 1003, event = 1004, event = 1005, event = 1006)
FROM funnel_test_strict;

SELECT 7 = windowFunnel(10000)(timestamp, event = 1000, event = 1001, event = 1002, event = 1003, event = 1004, event = 1005, event = 1006)
FROM funnel_test_strict;

DROP TABLE funnel_test;

DROP TABLE funnel_test2;

DROP TABLE funnel_test_u64;

DROP TABLE funnel_test_strict;

DROP TABLE IF EXISTS funnel_test_strict_order;

CREATE TABLE funnel_test_strict_order
(
    dt DateTime,
    user int,
    event String
)
ENGINE = MergeTree()
ORDER BY user
PARTITION BY dt;

INSERT INTO funnel_test_strict_order;

INSERT INTO funnel_test_strict_order;

INSERT INTO funnel_test_strict_order;

INSERT INTO funnel_test_strict_order;

INSERT INTO funnel_test_strict_order;

INSERT INTO funnel_test_strict_order;

SELECT
    user,
    windowFunnel(86400)(dt, event = 'a', event = 'b', event = 'c') AS s
FROM funnel_test_strict_order
GROUP BY user
ORDER BY user ASC
FORMAT JSONCompactEachRow;

SELECT
    user,
    windowFunnel(86400, 'strict_order')(dt, event = 'a', event = 'b', event = 'c') AS s
FROM funnel_test_strict_order
GROUP BY user
ORDER BY user ASC
FORMAT JSONCompactEachRow;

SELECT
    user,
    windowFunnel(86400, 'strict_deduplication', 'strict_order')(dt, event = 'a', event = 'b', event = 'c') AS s
FROM funnel_test_strict_order
GROUP BY user
ORDER BY user ASC
FORMAT JSONCompactEachRow;

INSERT INTO funnel_test_strict_order;

SELECT
    user,
    windowFunnel(10, 'strict_order')(dt, event = 'a', event = 'b', event = 'c') AS s
FROM funnel_test_strict_order
WHERE user = 7
GROUP BY user
FORMAT JSONCompactEachRow;

DROP TABLE funnel_test_strict_order;

--https://github.com/ClickHouse/ClickHouse/issues/27469
DROP TABLE IF EXISTS strict_BiteTheDDDD;

CREATE TABLE strict_BiteTheDDDD
(
    ts UInt64,
    event String
)
ENGINE = Log();

INSERT INTO strict_BiteTheDDDD;

SELECT 3 = windowFunnel(86400, 'strict_deduplication')(ts, event = 'a', event = 'b', event = 'c', event = 'd')
FROM strict_BiteTheDDDD
FORMAT JSONCompactEachRow;

DROP TABLE strict_BiteTheDDDD;

DROP TABLE IF EXISTS funnel_test_non_null;

CREATE TABLE funnel_test_non_null
(
    dt DateTime,
    u int,
    a Nullable(String),
    b Nullable(String)
)
ENGINE = MergeTree()
ORDER BY u
PARTITION BY dt;

INSERT INTO funnel_test_non_null;

INSERT INTO funnel_test_non_null;

INSERT INTO funnel_test_non_null;

INSERT INTO funnel_test_non_null;

SELECT
    u,
    windowFunnel(86400)(dt, COALESCE(a, '') = 'a1', COALESCE(a, '') = 'a2') AS s
FROM funnel_test_non_null
GROUP BY u
ORDER BY u ASC
FORMAT JSONCompactEachRow;

SELECT
    u,
    windowFunnel(86400)(dt, COALESCE(a, '') = 'a1', COALESCE(b, '') = 'b2') AS s
FROM funnel_test_non_null
GROUP BY u
ORDER BY u ASC
FORMAT JSONCompactEachRow;

SELECT
    u,
    windowFunnel(86400)(dt, a IS NULL
    AND b IS NULL) AS s
FROM funnel_test_non_null
GROUP BY u
ORDER BY u ASC
FORMAT JSONCompactEachRow;

SELECT
    u,
    windowFunnel(86400)(dt, a IS NULL, COALESCE(b, '') = 'b3') AS s
FROM funnel_test_non_null
GROUP BY u
ORDER BY u ASC
FORMAT JSONCompactEachRow;

SELECT
    u,
    windowFunnel(86400, 'strict_order')(dt, a IS NULL, COALESCE(b, '') = 'b3') AS s
FROM funnel_test_non_null
GROUP BY u
ORDER BY u ASC
FORMAT JSONCompactEachRow;

DROP TABLE funnel_test_non_null;

CREATE TABLE funnel_test_strict_increase
(
    timestamp UInt32,
    event UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test_strict_increase;

SELECT 5 = windowFunnel(10000)(timestamp, event = 1000, event = 1001, event = 1002, event = 1003, event = 1004)
FROM funnel_test_strict_increase;

SELECT 2 = windowFunnel(10000, 'strict_increase')(timestamp, event = 1000, event = 1001, event = 1002, event = 1003, event = 1004)
FROM funnel_test_strict_increase;

SELECT 3 = windowFunnel(10000)(timestamp, event = 1004, event = 1004, event = 1004)
FROM funnel_test_strict_increase;

SELECT 1 = windowFunnel(10000, 'strict_once')(timestamp, event = 1004, event = 1004, event = 1004)
FROM funnel_test_strict_increase;

SELECT 1 = windowFunnel(10000, 'strict_increase')(timestamp, event = 1004, event = 1004, event = 1004)
FROM funnel_test_strict_increase;

CREATE TABLE funnel_test2
(
    event_ts UInt32,
    result String,
    uid UInt32
)
ENGINE = Memory();

INSERT INTO funnel_test2 SELECT
    (data).1,
    (data).2,
    (data).3
FROM (
        SELECT arrayJoin([(100, 'failure', 234), (200, 'success', 345), (210, 'failure', 345), (230, 'success', 345), (250, 'failure', 234), (180, 'failure', 123), (220, 'failure', 123), (250, 'success', 123)]) AS data
    );

SELECT
    uid,
    windowFunnel(200, 'strict_once', 'strict_increase')(toUInt32(event_ts), result = 'failure', result = 'failure', result = 'success')
FROM funnel_test2
WHERE event_ts >= 0
    AND event_ts <= 300
GROUP BY uid
ORDER BY uid ASC;

SELECT
    uid,
    windowFunnel(200, 'strict_once')(toUInt32(event_ts), result = 'failure', result = 'failure', result = 'success')
FROM funnel_test2
WHERE event_ts >= 0
    AND event_ts <= 300
GROUP BY uid
ORDER BY uid ASC;

SELECT
    uid,
    windowFunnel(200, 'strict_once', 'strict_deduplication')(toUInt32(event_ts), result = 'failure', result = 'failure', result = 'success')
FROM funnel_test2
WHERE event_ts >= 0
    AND event_ts <= 300
GROUP BY uid
ORDER BY uid ASC;

DROP TABLE funnel_test_strict_increase;

DROP TABLE IF EXISTS funnel_test_reentry;

CREATE TABLE funnel_test_reentry
(
    uid Int32,
    dt UInt32,
    event String
)
ENGINE = Memory();

INSERT INTO funnel_test_reentry;

INSERT INTO funnel_test_reentry;

INSERT INTO funnel_test_reentry;

SELECT
    uid,
    windowFunnel(100, 'strict_order')(dt, event = 'a', event = 'b', event = 'a', event = 'c') AS res
FROM funnel_test_reentry
WHERE uid = 1
GROUP BY uid
FORMAT JSONCompactEachRow;

SELECT
    uid,
    windowFunnel(100, 'strict_order', 'allow_reentry')(dt, event = 'a', event = 'b', event = 'a', event = 'c') AS res
FROM funnel_test_reentry
WHERE uid = 1
GROUP BY uid
FORMAT JSONCompactEachRow;

SELECT
    uid,
    windowFunnel(100, 'strict_order')(dt, event = 'a', event = 'b', event = 'c') AS res
FROM funnel_test_reentry
WHERE uid = 2
GROUP BY uid
FORMAT JSONCompactEachRow;

SELECT
    uid,
    windowFunnel(100, 'strict_order', 'allow_reentry')(dt, event = 'a', event = 'b', event = 'c') AS res
FROM funnel_test_reentry
WHERE uid = 2
GROUP BY uid
FORMAT JSONCompactEachRow;

SELECT
    uid,
    windowFunnel(100, 'strict_order', 'allow_reentry')(dt, event = 'a', event = 'b', event = 'c') AS res
FROM funnel_test_reentry
WHERE uid = 3
GROUP BY uid
FORMAT JSONCompactEachRow;

DROP TABLE funnel_test_reentry;