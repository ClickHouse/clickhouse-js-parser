DROP TABLE IF EXISTS joinbug;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE joinbug
(
    event_date Date MATERIALIZED toDate(created, 'Asia/Istanbul'),
    id UInt64,
    id2 UInt64,
    val UInt64,
    val2 Int32,
    created UInt64
)
ENGINE = MergeTree(event_date, (id, id2), 8192);

INSERT INTO joinbug (id, id2, val, val2, created);

DROP TABLE IF EXISTS joinbug_join;

CREATE TABLE joinbug_join
(
    id UInt64,
    id2 UInt64,
    val UInt64,
    val2 Int32,
    created UInt64
)
ENGINE = Join(SEMI, `LEFT`, id2);

INSERT INTO joinbug_join (id, id2, val, val2, created) SELECT
    id,
    id2,
    val,
    val2,
    created
FROM joinbug;

SELECT *
FROM joinbug;

SELECT
    id,
    id2,
    val,
    val2,
    created
FROM
    (
        SELECT toUInt64(arrayJoin(range(50))) AS id2
    ) AS js1
SEMI LEFT JOIN joinbug_join
    USING (id2);

-- type conversion
SELECT *
FROM
    (
        SELECT toUInt32(11) AS id2
    ) AS js1
SEMI LEFT JOIN joinbug_join
    USING (id2);

-- can't convert right side in case on storage join
SELECT *
FROM
    (
        SELECT toInt64(11) AS id2
    ) AS js1
SEMI LEFT JOIN joinbug_join
    USING (id2); -- { serverError TYPE_MISMATCH, 386 }

DROP TABLE joinbug;

DROP TABLE joinbug_join;