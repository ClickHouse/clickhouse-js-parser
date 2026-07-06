DROP TABLE IF EXISTS x_1;

DROP TABLE IF EXISTS x_2;

DROP TABLE IF EXISTS x;

CREATE TABLE x_1
ENGINE = Log() AS
SELECT *
FROM numbers(10);

CREATE TABLE x_2
ENGINE = Log() AS
SELECT *
FROM numbers(10);

CREATE TABLE x AS x_1
ENGINE = Merge(currentDatabase(), '^x_(1|2)$');

SELECT
    _table,
    count()
FROM x
GROUP BY _table
ORDER BY _table ASC;

DROP TABLE x_1;

DROP TABLE x_2;

DROP TABLE x;