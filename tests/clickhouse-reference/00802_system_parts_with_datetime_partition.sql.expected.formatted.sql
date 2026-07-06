DROP TABLE IF EXISTS datetime_table;

-- Create a table with DateTime column, but not used in partition key
CREATE TABLE datetime_table
(
    t DateTime('UTC'),
    name String,
    value UInt32
)
ENGINE = MergeTree()
ORDER BY (t, name)
PARTITION BY value;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

-- min_time and max_time are not filled
SELECT
    `partition`,
    toTimeZone(MIN(min_time), 'UTC') AS min_time,
    toTimeZone(MAX(max_time), 'UTC') AS max_time
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'datetime_table'
    AND active = 1
GROUP BY `partition`
ORDER BY `partition` ASC
FORMAT CSV;

-- Create a table with DateTime column, this time used in partition key
CREATE TABLE datetime_table
(
    t DateTime('UTC'),
    name String,
    value UInt32
)
ENGINE = MergeTree()
ORDER BY (t, name)
PARTITION BY toStartOfDay(t);

INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

-- Create a table with DateTime column, this time used in partition key, but not at the first level
CREATE TABLE datetime_table
(
    t DateTime('UTC'),
    name String,
    value UInt32
)
ENGINE = MergeTree()
ORDER BY (t, name)
PARTITION BY (name, toUInt32(toUnixTimestamp(t) / (60 * 60 * 24)));

-- We are using a daily aggregation that is independant of the timezone, add data also
INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

INSERT INTO datetime_table;

-- min_time and max_time are now filled
SELECT
    `partition`,
    toUnixTimestamp(MIN(min_time)) AS min_unix_time,
    toUnixTimestamp(MAX(max_time)) AS max_unix_time
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'datetime_table'
    AND active = 1
GROUP BY `partition`
ORDER BY `partition` ASC
FORMAT CSV;