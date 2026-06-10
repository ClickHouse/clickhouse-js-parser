DROP TABLE IF EXISTS mutation_table;

SET enable_lightweight_update = '1';

CREATE TABLE mutation_table
(
    id int,
    price Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY id
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

INSERT INTO mutation_table (id, price);

UPDATE mutation_table SET price = 150 WHERE id = 1;

SELECT *
FROM mutation_table;

CREATE TABLE mutation_table
(
    dt Nullable(Date),
    name Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

INSERT INTO mutation_table (name, dt);

INSERT INTO mutation_table (name, dt);

SELECT *
FROM mutation_table
ORDER BY
    dt ASC,
    name ASC;

UPDATE mutation_table SET dt = toDateOrNull('2020-08-02') WHERE name = 'car';

INSERT INTO mutation_table (name, dt);

INSERT INTO mutation_table (name, dt);

UPDATE mutation_table SET dt = toDateOrNull('2020-08-03') WHERE name = 'car'
AND dt IS NULL;

UPDATE mutation_table SET dt = toDateOrNull('2020-08-04') WHERE name = 'car'
OR dt IS NULL;

INSERT INTO mutation_table (name, dt);

UPDATE mutation_table SET dt = NULL WHERE name IS NOT NULL;