DROP TABLE IF EXISTS tp_1;

-- In this test, we are going to create an old part with written projection which does not exist in table metadata
CREATE TABLE tp_1
(
    x Int32,
    y Int32,
    PROJECTION p (SELECT x, y ORDER BY x)
)
ENGINE = MergeTree()
ORDER BY y
PARTITION BY intDiv(y, 100)
SETTINGS old_parts_lifetime = '1';

INSERT INTO tp_1 SELECT
    number,
    number
FROM numbers(3);

SET mutations_sync = '2';

ALTER TABLE tp_1 ADD PROJECTION pp (SELECT x, count() GROUP BY x);

INSERT INTO tp_1 SELECT
    number,
    number
FROM numbers(4);

-- Here we have a part with written projection pp
ALTER TABLE tp_1 DETACH PARTITION '0';

-- Move part to detached
ALTER TABLE tp_1 CLEAR PROJECTION pp;

-- Remove projection from table metadata
ALTER TABLE tp_1 DROP PROJECTION pp;

-- Now, we don't load projection pp for attached part, but it is written on disk
ALTER TABLE tp_1 ATTACH PARTITION '0';

-- Make this part obsolete
OPTIMIZE TABLE tp_1 FINAL;

-- Now, DROP TABLE triggers part removal
DROP TABLE tp_1;