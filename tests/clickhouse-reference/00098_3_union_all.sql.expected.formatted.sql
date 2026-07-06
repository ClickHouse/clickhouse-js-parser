DROP TABLE IF EXISTS data2013;

DROP TABLE IF EXISTS data2014;

CREATE TABLE data2013
(
    name String,
    value UInt32
)
ENGINE = Memory();

CREATE TABLE data2014
(
    name String,
    value UInt32
)
ENGINE = Memory();

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2014 (name, value);

INSERT INTO data2014 (name, value);

INSERT INTO data2014 (name, value);

SELECT val
FROM (
        SELECT value AS val
        FROM data2013
        WHERE name = 'Alice'
        UNION ALL
        SELECT value AS val
        FROM data2014
        WHERE name = 'Alice'
    )
ORDER BY val ASC;

DROP TABLE data2013;

DROP TABLE data2014;