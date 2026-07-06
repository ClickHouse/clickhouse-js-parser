DROP TABLE IF EXISTS dep;

DROP TABLE IF EXISTS dep2;

DROP TABLE IF EXISTS id_join;

CREATE TABLE id_join
(
    country String,
    location Array(Int32)
)
ENGINE = Join(`ANY`, `LEFT`, country);

INSERT INTO id_join;

CREATE TABLE dep
(
    id Int32,
    country LowCardinality(String),
    purchase_location UInt16 MATERIALIZED if(id IN (joinGet(concat(currentDatabase(), '.id_join'), 'location', 'CLICK')), 123, 456)
)
ENGINE = ReplicatedMergeTree('/test/02433/{database}/dep', '1')
ORDER BY tuple();

SHOW CREATE TABLE dep;

TRUNCATE TABLE id_join;

CREATE TABLE dep2
(
    id Int32,
    country LowCardinality(String),
    purchase_location UInt16 MATERIALIZED if(id IN (joinGet(concat(currentDatabase(), '.id_join'), 'location', 'CLICK')), 123, 456)
)
ENGINE = ReplicatedMergeTree('/test/02433/{database}/dep', '2')
ORDER BY tuple();

SHOW CREATE TABLE dep2;

-- Ensure that a table name cannot be passed to IN as string literal
CREATE TABLE test
(
    n int,
    m DEFAULT n IN ('default.table_name')
)
ENGINE = Memory(); -- { serverError TYPE_MISMATCH }

CREATE TABLE test
(
    n int,
    m DEFAULT in(n, 'default.table_name')
)
ENGINE = Memory(); -- { serverError TYPE_MISMATCH }

DROP TABLE dep;

DROP TABLE dep2;

DROP TABLE id_join;