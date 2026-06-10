SET allow_suspicious_low_cardinality_types = '0';

SET allow_suspicious_fixed_string_types = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

ALTER TABLE test ADD COLUMN bad LowCardinality(UInt8); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

ALTER TABLE test ADD COLUMN bad FixedString(10000); -- {serverError ILLEGAL_COLUMN}

ALTER TABLE test MODIFY COLUMN id LowCardinality(UInt8); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

ALTER TABLE test MODIFY COLUMN id FixedString(10000); -- {serverError ILLEGAL_COLUMN}

DROP TABLE test;