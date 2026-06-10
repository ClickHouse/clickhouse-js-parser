DROP TABLE IF EXISTS foo;

DROP TABLE IF EXISTS bar;

CREATE TABLE foo
(
    server_date Date,
    server_time Datetime('Asia/Istanbul'),
    dimension_1 String
)
ENGINE = MergeTree()
ORDER BY server_date
PARTITION BY toYYYYMM(server_date);

CREATE TABLE bar
(
    server_date Date,
    dimension_1 String
)
ENGINE = MergeTree()
ORDER BY server_date
PARTITION BY toYYYYMM(server_date);

INSERT INTO foo;

INSERT INTO bar;

SET optimize_move_to_prewhere = '1';

SET any_join_distinct_right_table_keys = '0';

SELECT count()
FROM
    foo
ANY INNER JOIN bar
    USING (dimension_1)
WHERE foo.server_date <= '2020-11-07'
    AND toDate(foo.server_time, 'Asia/Yekaterinburg') <= '2020-11-07';

SELECT toDateTime(foo.server_time, 'UTC')
FROM
    foo
ANY INNER JOIN bar
    USING (dimension_1)
WHERE toDate(foo.server_time, 'UTC') <= toDate('2020-04-30');

SELECT toDateTime(foo.server_time, 'UTC')
FROM
    foo
SEMI LEFT JOIN bar
    USING (dimension_1)
WHERE toDate(foo.server_time, 'UTC') <= toDate('2020-04-30');

SET any_join_distinct_right_table_keys = '1';

DROP TABLE foo;

DROP TABLE bar;