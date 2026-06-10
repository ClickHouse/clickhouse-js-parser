CREATE TABLE datetime64_issue
(
    id int,
    dt DateTime64(3),
    dtn Nullable(DateTime64(3))
)
ENGINE = MergeTree()
PRIMARY KEY id
ORDER BY id;

INSERT INTO datetime64_issue (id, dt, dtn);

SELECT *
FROM datetime64_issue
WHERE dt IN (toDateTime64('2001-01-11 01:11:21.100', 3));

SELECT *
FROM datetime64_issue
WHERE dtn IN (toDateTime64('2001-01-11 01:11:21.100', 3));

DROP TABLE datetime64_issue;