DROP TABLE IF EXISTS moving_sum_num;

DROP TABLE IF EXISTS moving_sum_dec;

CREATE TABLE moving_sum_num
(
    k String,
    dt DateTime,
    v UInt64
)
ENGINE = MergeTree()
ORDER BY (k, dt);

INSERT INTO moving_sum_num SELECT
    'b' AS k,
    toDateTime('2001-02-03 00:00:00') + number AS dt,
    number AS v
FROM `system`.numbers
LIMIT 5
UNION ALL
SELECT
    'a' AS k,
    toDateTime('2001-02-03 00:00:00') + number AS dt,
    number AS v
FROM `system`.numbers
LIMIT 5;

INSERT INTO moving_sum_num SELECT
    'b' AS k,
    toDateTime('2001-02-03 01:00:00') + number AS dt,
    5 + number AS v
FROM `system`.numbers
LIMIT 5;

SELECT *
FROM moving_sum_num
ORDER BY
    k ASC,
    dt ASC
FORMAT TabSeparatedWithNames;

-- Result of function 'groupArrayMovingSum' depends on the order of merging
-- aggregate states which is implementation defined in external aggregation.
SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

SELECT
    k,
    groupArrayMovingSum(v)
FROM (
        SELECT *
        FROM moving_sum_num
        ORDER BY
            k ASC,
            dt ASC
    )
GROUP BY k
ORDER BY k ASC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT
    k,
    groupArrayMovingSum(3)(v)
FROM (
        SELECT *
        FROM moving_sum_num
        ORDER BY
            k ASC,
            dt ASC
    )
GROUP BY k
ORDER BY k ASC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT
    k,
    groupArrayMovingAvg(v)
FROM (
        SELECT *
        FROM moving_sum_num
        ORDER BY
            k ASC,
            dt ASC
    )
GROUP BY k
ORDER BY k ASC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT
    k,
    groupArrayMovingAvg(3)(v)
FROM (
        SELECT *
        FROM moving_sum_num
        ORDER BY
            k ASC,
            dt ASC
    )
GROUP BY k
ORDER BY k ASC
FORMAT TabSeparatedWithNamesAndTypes;

CREATE TABLE moving_sum_dec
ENGINE = Memory() AS
SELECT
    k,
    dt,
    toDecimal64(v, 2) AS v
FROM moving_sum_num;

DROP TABLE moving_sum_dec;

DROP TABLE moving_sum_num;