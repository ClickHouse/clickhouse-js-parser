DROP TABLE IF EXISTS TESTTABLE;

CREATE TABLE TESTTABLE
(
    _id UInt64,
    pt String,
    attr_list Array(String)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY pt;

INSERT INTO TESTTABLE;

SET max_threads = '1';

-- There is a bug which is fixed in new analyzer.
SET max_bytes_before_external_sort = '0';

SET max_bytes_ratio_before_external_sort = '0';

SELECT
    attr,
    _id,
    arrayFilter((x -> x IN (
        SELECT '1'
    )), attr_list) AS z
FROM
    TESTTABLE
ARRAY JOIN z AS attr
ORDER BY _id ASC
LIMIT 3 BY attr;

DROP TABLE TESTTABLE;