DROP TABLE IF EXISTS table;

CREATE TABLE table
(
    uid UUID,
    date DateTime('Asia/Kamchatka')
)
ENGINE = MergeTree()
ORDER BY date;

INSERT INTO table;

SELECT
    uid,
    date,
    toDate(date) = toDate('2021-03-24') AS res
FROM table
WHERE res = 1
ORDER BY
    uid ASC,
    date ASC;

SELECT '---';

SELECT
    uid,
    date,
    toDate(date) = toDate('2021-03-24') AS res
FROM table
WHERE toDate(date) = toDate('2021-03-24')
ORDER BY
    uid ASC,
    date ASC;

DROP TABLE table;