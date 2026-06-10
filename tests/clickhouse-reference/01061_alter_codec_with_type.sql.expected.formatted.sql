DROP TABLE IF EXISTS alter_bug;

CREATE TABLE alter_bug
(
    epoch UInt64 CODEC(Delta(), LZ4()),
    _time_dec Float64
)
ENGINE = MergeTree()
ORDER BY epoch;

SELECT
    name,
    type,
    compression_codec
FROM `system`.`columns`
WHERE table = 'alter_bug'
    AND database = currentDatabase();

ALTER TABLE alter_bug MODIFY COLUMN epoch DEFAULT toUInt64(_time_dec) CODEC(Delta(), LZ4());

SELECT
    name,
    type,
    default_expression,
    compression_codec
FROM `system`.`columns`
WHERE table = 'alter_bug'
    AND database = currentDatabase();

INSERT INTO alter_bug (_time_dec);

SELECT *
FROM alter_bug;