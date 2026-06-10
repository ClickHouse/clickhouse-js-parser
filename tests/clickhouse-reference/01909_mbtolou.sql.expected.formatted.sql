-- BIGMDM.DATE_INFO_DICT definition
DROP TABLE IF EXISTS DATE_INFO_DICT;

CREATE TABLE DATE_INFO_DICT
(
    TV Date,
    SHAMSI String,
    HIJRI String,
    MILADI String,
    S_DAY UInt8,
    H_DAY UInt8,
    S_MONTH UInt8,
    H_MONTH UInt8,
    WEEK_DAY_NAME String,
    DAY_NUMBER UInt8,
    HOLIDAY UInt8,
    WEEK_NAME String
)
ENGINE = Join(`ANY`, `LEFT`, TV);

TRUNCATE TABLE DATE_INFO_DICT;

INSERT INTO DATE_INFO_DICT (TV, SHAMSI, HIJRI, MILADI, S_DAY, H_DAY, S_MONTH, H_MONTH, WEEK_DAY_NAME, DAY_NUMBER, HOLIDAY, WEEK_NAME);

WITH A AS (
    SELECT
        rowNumberInAllBlocks() AS R,
        addDays(toDate('2021-05-18'), R) AS TVV
    FROM numbers(5)
),

B AS (
    SELECT
        rowNumberInAllBlocks() AS R,
        toDateTime(NULL) AS TVV
    FROM numbers(1)
)

SELECT
    joinGet('DATE_INFO_DICT', 'SHAMSI', toDate(A.TVV)) AS TV1,
    substr(TV1, 3, 8) || ' : ' || toString(1) AS TV_CHAR_1
FROM
    A
LEFT JOIN B
    USING (R)
ORDER BY TV1 ASC;

--query run success in 215ms
WITH A AS (
    SELECT
        rowNumberInAllBlocks() AS R,
        addDays(toDate('2021-05-18'), R) AS TVV
    FROM numbers(5)
),

B AS (
    SELECT
        rowNumberInAllBlocks() AS R,
        toDateTime(NULL) AS TVV
    FROM numbers(1)
)

SELECT
    joinGetOrNull('DATE_INFO_DICT', 'SHAMSI', toDate(A.TVV)) AS TV1,
    substr(TV1, 3, 8) || ' : ' || toString(1) AS TV_CHAR_1
FROM
    A
LEFT JOIN B
    USING (R)
ORDER BY TV1 ASC;

--query not run success !!!!
DROP TABLE DATE_INFO_DICT;