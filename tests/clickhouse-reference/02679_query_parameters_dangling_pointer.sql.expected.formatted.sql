-- There is no use-after-free in the following query:
SET param_o = 'a';

CREATE TABLE test.xxx
(
    a Int64
)
ENGINE = MergeTree()
ORDER BY 'placeholder'; -- { serverError ILLEGAL_COLUMN }