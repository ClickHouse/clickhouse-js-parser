SET readonly = '2';

CREATE TEMPORARY TABLE readonly00542
(
    ID Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO readonly00542 (ID);

SELECT ID
FROM readonly00542
ORDER BY ID ASC;

INSERT INTO readonly00542 (ID) SELECT CAST(number * 10 AS Int)
FROM `system`.numbers
LIMIT 10;

SELECT '---';

DROP TEMPORARY TABLE readonly00542;