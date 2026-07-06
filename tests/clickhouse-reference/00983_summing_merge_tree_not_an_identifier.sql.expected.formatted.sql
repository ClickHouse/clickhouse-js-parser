CREATE TABLE xx
(
    date Date,
    id Int64,
    clicks Int64,
    price Float64,
    spend Float64
)
ENGINE = SummingMergeTree([price, spend])
ORDER BY id
PARTITION BY toYYYYMM(date)
SAMPLE BY id
SETTINGS index_granularity = '8192'; -- { serverError UNEXPECTED_AST_STRUCTURE }