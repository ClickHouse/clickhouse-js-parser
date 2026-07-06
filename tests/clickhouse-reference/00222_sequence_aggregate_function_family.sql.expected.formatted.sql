DROP TABLE IF EXISTS sequence_test;

CREATE TABLE sequence_test
(
    time UInt32,
    data UInt8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO sequence_test;

SELECT 1 = sequenceMatch('')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('.')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('.*')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?4)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?1)(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?1)(?1)(?1)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?t>10)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?1)(?t>11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?t<11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?t<3)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?t<=2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?1)(?t<2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?2)(?t>=7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?2)(?t>7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?2)(?3)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceMatch('(?1)(?t==2)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

SELECT 1 = sequenceMatch('(?1)(?t==1)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

SELECT count() = sequenceCount('')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT count() = sequenceCount('.')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT count() = sequenceCount('.*')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 8 = sequenceCount('(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 3 = sequenceCount('(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?4)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 4 = sequenceCount('(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 2 = sequenceCount('(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 2 = sequenceCount('(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?1)(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 2 = sequenceCount('(?1)(?1)(?1)(?1)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?1)(?t>10)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?1)(?t>11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 2 = sequenceCount('(?1)(?t<11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?1)(?t<3)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?1)(?t<=2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?1)(?t<2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?2)(?t>=7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?2)(?t>7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 1 = sequenceCount('(?2)(?3)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT 0 = sequenceCount('(?1)(?t==2)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

SELECT 1 = sequenceCount('(?1)(?t==1)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

SELECT [] = sequenceMatchEvents('')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [] = sequenceMatchEvents('.')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [] = sequenceMatchEvents('.*')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0] = sequenceMatchEvents('(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [4] = sequenceMatchEvents('(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [5] = sequenceMatchEvents('(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [] = sequenceMatchEvents('(?4)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 1] = sequenceMatchEvents('(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 1, 2] = sequenceMatchEvents('(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 1, 2, 3] = sequenceMatchEvents('(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 1, 2, 3] = sequenceMatchEvents('(?1)(?1)(?1)(?1)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 1, 2, 3, 4] = sequenceMatchEvents('(?1)(?1)(?1)(?1)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 11] = sequenceMatchEvents('(?1)(?t>10)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0] = sequenceMatchEvents('(?1)(?t>11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0, 4] = sequenceMatchEvents('(?1)(?t<11)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [3, 5] = sequenceMatchEvents('(?1)(?t<3)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [3, 5] = sequenceMatchEvents('(?1)(?t<=2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [0] = sequenceMatchEvents('(?1)(?t<2)(?3)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [4, 11] = sequenceMatchEvents('(?2)(?t>=7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [4] = sequenceMatchEvents('(?2)(?t>7)(?2)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [4, 5, 6] = sequenceMatchEvents('(?2)(?3)(?1)')(time, data = 0, data = 1, data = 2, data = 3)
FROM sequence_test;

SELECT [4] = sequenceMatchEvents('(?1)(?t==2)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

SELECT [4, 5] = sequenceMatchEvents('(?1)(?t==1)(?2)')(time, data = 1, data = 2)
FROM sequence_test;

DROP TABLE sequence_test;