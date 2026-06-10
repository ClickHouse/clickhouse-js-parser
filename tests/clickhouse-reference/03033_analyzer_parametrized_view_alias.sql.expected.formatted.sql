CREATE TABLE raw_data
(
    id UInt8,
    data String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO raw_data SELECT
    number,
    number
FROM numbers(10);

CREATE VIEW raw_data_parameterized
AS
SELECT *
FROM raw_data
WHERE id >= 0
    AND id <= 0;

SELECT t1.id
FROM raw_data_parameterized(id_from = 0, id_to = 50000) AS t1
ORDER BY t1.id ASC;