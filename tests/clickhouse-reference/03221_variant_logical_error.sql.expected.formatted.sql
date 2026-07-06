SET allow_experimental_variant_type = '1';

SET allow_suspicious_types_in_order_by = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    key String,
    val Map(String, Variant(String, Int32, DateTime64(3, 'UTC')))
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/table', '1')
ORDER BY key;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

SELECT variantElement(arrayJoin(mapValues(val)), 'String')
FROM test
ORDER BY `ALL` ASC;

SELECT '---';

SELECT
    key,
    arrayJoin(mapValues(val))
FROM test
ORDER BY `ALL` ASC;

DROP TABLE test;