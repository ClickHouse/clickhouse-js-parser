DROP TABLE IF EXISTS part_info;

CREATE TABLE part_info
(
    t DateTime
)
ENGINE = MergeTree()
ORDER BY t
PARTITION BY toDate(t);

INSERT INTO part_info;

SELECT
    name,
    is_frozen
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'part_info';

ALTER TABLE part_info FREEZE PARTITION '1970-10-02';

ALTER TABLE part_info FREEZE;

INSERT INTO part_info;

SELECT *
FROM part_info
ORDER BY t ASC;

DROP TABLE part_info;