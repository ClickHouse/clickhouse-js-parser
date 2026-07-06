DROP TABLE IF EXISTS badFixedStringSort;

CREATE TABLE IF NOT EXISTS badFixedStringSort
(
    uuid5_old FixedString(16),
    subitem String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO badFixedStringSort;

INSERT INTO badFixedStringSort;

INSERT INTO badFixedStringSort;

INSERT INTO badFixedStringSort;

OPTIMIZE TABLE badFixedStringSort FINAL;

SELECT
    hex(uuid5_old),
    subitem
FROM badFixedStringSort
ORDER BY
    uuid5_old ASC,
    subitem ASC;