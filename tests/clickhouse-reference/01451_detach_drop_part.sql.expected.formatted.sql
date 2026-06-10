DROP TABLE IF EXISTS mt_01451;

CREATE TABLE mt_01451
(
    v UInt8
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS old_parts_lifetime = '0';

SYSTEM STOP MERGES mt_01451;

INSERT INTO mt_01451;

INSERT INTO mt_01451;

INSERT INTO mt_01451;

SELECT v
FROM mt_01451
ORDER BY v ASC;

ALTER TABLE mt_01451 DETACH PART 'all_100_100_0'; -- { serverError NO_SUCH_DATA_PART }

ALTER TABLE mt_01451 DETACH PART 'all_2_2_0';

SELECT name
FROM `system`.detached_parts
WHERE table = 'mt_01451'
    AND database = currentDatabase();

ALTER TABLE mt_01451 ATTACH PART 'all_2_2_0';

SELECT '-- drop part --';

ALTER TABLE mt_01451 DROP PART 'all_4_4_0';

ALTER TABLE mt_01451 ATTACH PART 'all_4_4_0'; -- { serverError BAD_DATA_PART_NAME }

SELECT name
FROM `system`.parts
WHERE table = 'mt_01451'
    AND active
    AND database = currentDatabase();

SYSTEM START MERGES mt_01451;

OPTIMIZE TABLE mt_01451 FINAL;

DROP TABLE mt_01451;