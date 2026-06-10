DROP TABLE IF EXISTS data2013;

DROP TABLE IF EXISTS data2015;

CREATE TABLE data2013
(
    name String,
    value UInt32
)
ENGINE = Memory();

CREATE TABLE data2015
(
    data_name String,
    data_value UInt32
)
ENGINE = Memory();

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2015 (data_name, data_value);

INSERT INTO data2015 (data_name, data_value);

SELECT X
FROM (
        SELECT name AS X
        FROM data2013
        UNION ALL
        SELECT data_name
        FROM data2015
    )
ORDER BY X ASC;

DROP TABLE data2013;

DROP TABLE data2015;