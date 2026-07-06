-- Tags: no-parallel-replicas
SELECT '--------';

SELECT
    arrayJoin([0, 1, 3, NULL]) AS x,
    x = 0,
    if(x = 0, 'x=0', 'x<>0')
ORDER BY x ASC;

DROP TABLE IF EXISTS mutation_delete_null_rows;

CREATE TABLE mutation_delete_null_rows
(
    EventDate Date,
    CounterID Nullable(String),
    UserID Nullable(UInt32)
)
ENGINE = MergeTree()
ORDER BY EventDate;

INSERT INTO mutation_delete_null_rows;

INSERT INTO mutation_delete_null_rows;

SELECT
    *,
    UserID = 0 AS UserIDEquals0,
    if(UserID = 0, 'delete', 'leave') AS verdict
FROM mutation_delete_null_rows
ORDER BY EventDate ASC;

ALTER TABLE mutation_delete_null_rows DELETE WHERE UserID = 0 SETTINGS mutations_sync = '1';

SELECT *
FROM mutation_delete_null_rows
ORDER BY EventDate ASC;

DROP TABLE mutation_delete_null_rows;