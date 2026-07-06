DROP TABLE IF EXISTS nested_smt;

CREATE TABLE nested_smt
(
    date date,
    val UInt64,
    counters_Map Nested(id UInt8, count Int32)
)
ENGINE = SummingMergeTree()
ORDER BY date;

SYSTEM STOP MERGES nested_smt;

INSERT INTO nested_smt;

INSERT INTO nested_smt;

-- { echo }
SELECT *
FROM nested_smt
ORDER BY val ASC;

SELECT *
FROM nested_smt FINAL;

SYSTEM START MERGES nested_smt;

OPTIMIZE TABLE nested_smt FINAL;

SELECT *
FROM nested_smt;

DROP TABLE nested_smt;