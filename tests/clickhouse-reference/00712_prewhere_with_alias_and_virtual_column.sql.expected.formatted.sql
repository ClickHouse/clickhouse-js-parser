DROP TABLE IF EXISTS tab_00712_1;

CREATE TABLE tab_00712_1
(
    a UInt32,
    b UInt32 ALIAS a + 1,
    c UInt32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab_00712_1;

SELECT ignore(_part)
FROM tab_00712_1
PREWHERE b = 2;

DROP TABLE tab_00712_1;