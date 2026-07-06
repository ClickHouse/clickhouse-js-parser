DROP TABLE IF EXISTS issue_46128;

CREATE TABLE issue_46128
(
    id Int64,
    a LowCardinality(Nullable(String)),
    b LowCardinality(Nullable(String))
)
ENGINE = MergeTree()
ORDER BY id AS
SELECT
    number % 100,
    'xxxx',
    'yyyy'
FROM numbers(10);

ALTER TABLE issue_46128 UPDATE a = b WHERE id = 1 SETTINGS mutations_sync = '2';

SELECT *
FROM issue_46128
WHERE id <= 2
ORDER BY id ASC;

DROP TABLE issue_46128;