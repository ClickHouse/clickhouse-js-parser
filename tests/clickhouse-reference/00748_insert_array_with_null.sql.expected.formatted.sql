DROP TABLE IF EXISTS arraytest;

SET allow_deprecated_syntax_for_merge_tree = '1';

SET input_format_null_as_default = '0';

CREATE TABLE arraytest
(
    created_date Date DEFAULT toDate(created_at),
    created_at DateTime DEFAULT now(),
    strings Array(String) DEFAULT emptyArrayString()
)
ENGINE = MergeTree(created_date, cityHash64(created_at), (created_date, cityHash64(created_at)), 8192);

INSERT INTO arraytest (created_at, strings);

INSERT INTO arraytest (created_at, strings); -- { error CANNOT_INSERT_NULL_IN_ORDINARY_COLUMN }

SELECT strings
FROM arraytest;