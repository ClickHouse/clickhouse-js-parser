DROP TABLE IF EXISTS A1;

DROP TABLE IF EXISTS A_M;

CREATE TABLE A1
(
    a DateTime
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE A_M AS A1
ENGINE = Merge(currentDatabase(), '^A1$');

INSERT INTO A1 (a) SELECT now();

SET optimize_move_to_prewhere = '0';

SELECT tupleElement(arrayJoin([(1, 1)]), 1)
FROM A_M
PREWHERE tupleElement((1, 1), 1) = 1;

SELECT tupleElement(arrayJoin([(1, 1)]), 1)
FROM A_M
WHERE tupleElement((1, 1), 1) = 1;

SELECT tupleElement(arrayJoin([(1, 1)]), 1)
FROM A1
PREWHERE tupleElement((1, 1), 1) = 1;

DROP TABLE A1;

DROP TABLE A_M;