DROP TABLE IF EXISTS unhex_in_fix_string_table;

CREATE TABLE unhex_in_fix_string_table
(
    dt Date,
    s1 FixedString(20),
    s2 String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY dt;

INSERT INTO unhex_in_fix_string_table;

SELECT
    unhex(s1),
    unhex(s2)
FROM unhex_in_fix_string_table;