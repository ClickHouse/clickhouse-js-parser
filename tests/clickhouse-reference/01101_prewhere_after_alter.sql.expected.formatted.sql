DROP TABLE IF EXISTS test_a;

DROP TABLE IF EXISTS test_b;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test_a
(
    OldColumn String DEFAULT '',
    EventDate Date DEFAULT toDate(EventTime),
    EventTime DateTime
)
ENGINE = MergeTree(EventDate, EventTime, 8192);

CREATE TABLE test_b
(
    OldColumn String DEFAULT '',
    NewColumn String DEFAULT '',
    EventDate Date DEFAULT toDate(EventTime),
    EventTime DateTime
)
ENGINE = MergeTree(EventDate, EventTime, 8192);

INSERT INTO test_a (OldColumn, EventTime);

INSERT INTO test_b (OldColumn, NewColumn, EventTime);

INSERT INTO test_b (OldColumn, NewColumn, EventTime);

ALTER TABLE test_a ADD COLUMN NewColumn String DEFAULT '' AFTER OldColumn;

INSERT INTO test_a (OldColumn, NewColumn, EventTime);

SELECT NewColumn
FROM
    test_a
INNER JOIN (
        SELECT
            OldColumn,
            NewColumn
        FROM test_b
    ) AS s
    USING (OldColumn)
PREWHERE NewColumn != '';

DROP TABLE test_a;

DROP TABLE test_b;