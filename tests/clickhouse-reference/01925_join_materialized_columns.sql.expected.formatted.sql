DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    time DateTime,
    foo String,
    dimension_1 String,
    dt Date MATERIALIZED toDate(time),
    dt1 Date MATERIALIZED toDayOfYear(time),
    aliascol1 ALIAS foo || dimension_1,
    time_alias DateTime ALIAS time
)
ENGINE = MergeTree()
ORDER BY (dt, foo)
PARTITION BY toYYYYMM(dt);

CREATE TABLE t2
(
    time DateTime,
    bar String,
    dimension_2 String,
    dt Date MATERIALIZED toDate(time),
    dt2 Date MATERIALIZED toDayOfYear(time),
    aliascol2 ALIAS bar || dimension_2,
    time_alias DateTime ALIAS time
)
ENGINE = MergeTree()
ORDER BY (dt, bar)
PARTITION BY toYYYYMM(dt);

INSERT INTO t1;

INSERT INTO t2;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.foo = t2.bar
WHERE t2.dt >= '2020-02-01';

SELECT
    t1.*,
    t1.dt,
    t2.*,
    t2.dt
FROM
    t1
INNER JOIN t2
    ON t1.foo = t2.bar
WHERE t2.dt >= '2020-02-01';

SELECT
    t1.dt,
    t2.dt
FROM
    t1
INNER JOIN t2
    ON t1.foo = t2.bar
ORDER BY t1.dt ASC;

SELECT *
FROM
    t1
ALL INNER JOIN t2
    ON t1.dt = t2.dt
ORDER BY
    t1.time ASC,
    t2.time ASC;

SELECT *
FROM
    t1
ALL INNER JOIN t2
    USING (dt)
ORDER BY
    t1.time ASC,
    t2.time ASC
SETTINGS enable_analyzer = '0';

SELECT *
FROM
    t1
ALL INNER JOIN t2
    USING (dt)
ORDER BY
    t1.time ASC,
    t2.time ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.dt1 = t2.dt2
ORDER BY
    t1.time ASC,
    t1.dimension_1 ASC,
    t2.time ASC,
    t2.dimension_2 ASC;

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.foo = t2.bar
WHERE t2.aliascol2 = 'fact2t1_val2';

SELECT
    t1.aliascol1,
    t2.aliascol2
FROM
    t1
INNER JOIN t2
    ON t1.foo = t2.bar
ORDER BY
    t1.time ASC,
    t2.time ASC;

SELECT
    t1.time,
    t2.time
FROM
    t1
INNER JOIN t2
    ON t1.aliascol1 = t2.aliascol2
ORDER BY
    t1.time ASC,
    t2.time ASC;

SELECT count()
FROM
    t1
INNER JOIN t2
    ON t1.time_alias = t2.time;

SELECT count()
FROM
    t1
INNER JOIN t2
    ON t1.time = t2.time_alias;

SELECT count()
FROM
    t1
INNER JOIN t2
    ON t1.time_alias = t2.time_alias;

SELECT count()
FROM
    t1
INNER JOIN t2
    USING (time_alias);

SELECT t1.time AS talias
FROM
    t1
INNER JOIN t2
    ON talias = t2.time;

SELECT t1.time AS talias
FROM
    t1
INNER JOIN t2
    ON talias = t2.time_alias;

SELECT t2.time AS talias
FROM
    t1
INNER JOIN t2
    ON t1.time = talias;

SELECT t2.time AS talias
FROM
    t1
INNER JOIN t2
    ON t1.time_alias = talias;

SELECT time AS talias
FROM
    t1
INNER JOIN t2
    ON talias = t2.time
SETTINGS enable_analyzer = '0'; -- { serverError AMBIGUOUS_COLUMN_NAME }

SELECT time AS talias
FROM
    t1
INNER JOIN t2
    ON talias = t2.time
SETTINGS enable_analyzer = '1';

SELECT time AS talias
FROM
    t1
INNER JOIN t2
    ON t1.time = talias
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.time = t2.time
    AND NULL
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';