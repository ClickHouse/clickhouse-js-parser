SET allow_suspicious_primary_key = '0';

DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int,
    value AggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
ORDER BY (key, value); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE data
(
    key Int,
    value SimpleAggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
ORDER BY (key, value); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE data
(
    key Int,
    value AggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PRIMARY KEY value; -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE data
(
    key Int,
    value SimpleAggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PRIMARY KEY value; -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE data
(
    key Int,
    value AggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PRIMARY KEY value
ORDER BY (value, key); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

CREATE TABLE data
(
    key Int,
    value SimpleAggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PRIMARY KEY value
ORDER BY (value, key); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

SET allow_suspicious_primary_key = '1';

DETACH TABLE data;

ATTACH TABLE data;

DROP TABLE data;

-- ALTER AggregatingMergeTree
CREATE TABLE data
(
    key Int
)
ENGINE = AggregatingMergeTree()
ORDER BY key;

ALTER TABLE data ADD COLUMN value SimpleAggregateFunction(sum, UInt64), MODIFY ORDER BY (key, value); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

ALTER TABLE data ADD COLUMN value SimpleAggregateFunction(sum, UInt64), MODIFY ORDER BY (key, value) SETTINGS allow_suspicious_primary_key = '1';

-- ALTER ReplicatedAggregatingMergeTree
CREATE TABLE data_rep
(
    key Int
)
ENGINE = ReplicatedAggregatingMergeTree('/tables/{database}', 'r1')
ORDER BY key;

ALTER TABLE data_rep ADD COLUMN value SimpleAggregateFunction(sum, UInt64), MODIFY ORDER BY (key, value); -- { serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY }

ALTER TABLE data_rep ADD COLUMN value SimpleAggregateFunction(sum, UInt64), MODIFY ORDER BY (key, value) SETTINGS allow_suspicious_primary_key = '1';

DROP TABLE data_rep;