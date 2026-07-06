DROP TABLE IF EXISTS mutation_table;

CREATE TABLE mutation_table
(
    id int,
    price Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY id;

INSERT INTO mutation_table (id, price);

ALTER TABLE mutation_table UPDATE price = 150 WHERE id = 1 SETTINGS mutations_sync = '2';

SELECT *
FROM mutation_table;

CREATE TABLE mutation_table
(
    dt Nullable(Date),
    name Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO mutation_table (name, dt);

INSERT INTO mutation_table (name, dt);

SELECT *
FROM mutation_table
ORDER BY
    dt ASC,
    name ASC;

ALTER TABLE mutation_table UPDATE dt = toDateOrNull('2020-08-02') WHERE name = 'car' SETTINGS mutations_sync = '2';

INSERT INTO mutation_table (name, dt);

INSERT INTO mutation_table (name, dt);

ALTER TABLE mutation_table UPDATE dt = toDateOrNull('2020-08-03') WHERE name = 'car'
AND dt IS NULL SETTINGS mutations_sync = '2';

ALTER TABLE mutation_table UPDATE dt = toDateOrNull('2020-08-04') WHERE name = 'car'
OR dt IS NULL SETTINGS mutations_sync = '2';

INSERT INTO mutation_table (name, dt);

ALTER TABLE mutation_table UPDATE dt = NULL WHERE name IS NOT NULL SETTINGS mutations_sync = '2';