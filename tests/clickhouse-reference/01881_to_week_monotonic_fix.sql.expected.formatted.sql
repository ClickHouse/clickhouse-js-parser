DROP TABLE IF EXISTS test_tbl;

CREATE TABLE test_tbl
(
    vend_nm String,
    ship_dt Date
)
ENGINE = MergeTree()
ORDER BY vend_nm
PARTITION BY toWeek(ship_dt);

INSERT INTO test_tbl;

SELECT *
FROM test_tbl
WHERE ship_dt >= toDate('2020-11-01')
    AND ship_dt <= toDate('2021-05-05')
ORDER BY ship_dt ASC;

SELECT *
FROM test_tbl
WHERE ship_dt >= toDate('2020-01-01')
    AND ship_dt <= toDate('2021-05-05')
ORDER BY ship_dt ASC;

DROP TABLE test_tbl;