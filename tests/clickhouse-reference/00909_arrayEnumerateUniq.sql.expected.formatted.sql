-- env SQL_FUZZY_FUNCTIONS=arrayEnumerateUniqRanked,arrayEnumerateDenseRanked SQL_FUZZY_RUNS=1000 clickhouse-test fuzzy
SELECT arrayEnumerateUniq([1, 1, 2, 2, 1, 1], [1, 2, 1, 2, 2, 2]);

SELECT arrayEnumerateUniqRanked(1, [1, 1, 2, 2, 1, 1], 1, [1, 2, 1, 2, 2, 2], 1);

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1); -- f(1, x,1)     =[1,1,2] -- 1 2 1

SELECT arrayEnumerateUniq([1, 2, 1]);

SELECT arrayEnumerateUniqRanked(1, ['a', 'b', 'c'], 1); -- f(1, x2,1)    =[1,1,1] -- a b c

SELECT arrayEnumerateUniq(['a', 'b', 'c']);

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, ['a', 'b', 'c'], 1); -- f(1, x,1,x2,1)=[1,1,1] -- (1,a) (2,b) (1,c)

SELECT arrayEnumerateUniq([1, 2, 1], ['a', 'b', 'c']);

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, [[1, 2, 3], [2, 2, 1], [3]], 1); -- f(1, x,1,y,1) =[1,1,1] -- (1,[1,2,3]) (2,[2,2,1]) (1,[3])

SELECT arrayEnumerateUniq([1, 2, 1], [[1, 2, 3], [2, 2, 1], [3]]);

SELECT arrayEnumerateUniqRanked(1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 1); -- f(1, y2,1)    =[1,2,1] -- [a,b,a] [a,b,a] [c]

SELECT arrayEnumerateUniq([['a', 'b', 'a'], ['a', 'b', 'a'], ['c']]);

SELECT arrayEnumerateUniqRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 1); -- f(1, z,1)     =[1,2,1] -- [[1,2,3],[1,2,3],[1,2,3]] [[1,2,3],[1,2,3],[1,2,3]] [[1,2]]

SELECT arrayEnumerateUniq([[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]]);

SELECT arrayEnumerateUniqRanked(1, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(1, y,2)     =[[1,1,1],[2,3,2],[2]] -- 1 2 3 2 2 1 3

SELECT arrayEnumerateUniqRanked(1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, y2,2)    =[[1,1,2],[3,2,4],[1]] -- a b a a b a c

SELECT arrayEnumerateUniqRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(1, z,2)     =[[1,2,3],[4,5,6],[1]] -- [1,2,3] [1,2,3] [1,2,3] [1,2,3] [1,2,3] [1,2,3] [1,2]

SELECT arrayEnumerateUniqRanked(1, [[1, 2, 3], [2, 2, 1], [3]], 2, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, y,2,y2,2)=[[1,1,1],[1,2,2],[1]] -- (1,a) (2,b) (3,a) (2,a) (2,b) (1,a) (3,c)

SELECT arrayEnumerateUniqRanked(1, [[1, 2, 3], [2, 2, 1], [3]], 2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(1, y,2,z, 2)=[[1,1,1],[2,3,2],[1]] -- (1,[1,2,3]) (2,[1,2,3]) (3,[1,2,3]) (2,[1,2,3]) (2,[1,2,3]) (1,[1,2,3]) (3,[1,2])

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(1, x,1,y,2)=[[1,1,1],[1,2,1],[2]] -- (1,1) (1,2) (1,3) (2,2) (2,2) (2,1) (1,3)

SELECT arrayEnumerateUniqRanked(1, ['a', 'b', 'c'], 1, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(1, x2,1,y,2)=[[1,1,1],[1,2,1],[1]] -- (a,1) (a,2) (a,3) (b,2) (b,2) (b,1) (c,3)

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, x,1,y2,2)=[[1,1,2],[1,1,2],[1]] -- (1,a) (1,b) (1,a) (2,a) (2,b) (2,a) (1,c)

SELECT arrayEnumerateUniqRanked(1, ['a', 'b', 'c'], 1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, x2,1,y2,2)=[[1,1,2],[1,1,2],[1]] -- (a,a) (a,b) (a,a) (b,a) (b,b) (b,a) (c,c)

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(1, x,1,z,2)=[[1,2,3],[1,2,3],[1]] --  (1,[1,2,3]) (1,[1,2,3]) (1,[1,2,3]) (2,[1,2,3]) (2,[1,2,3]) (2,[1,2,3]) (1,[1,2])

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, ['a', 'b', 'c'], 1, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(1, x,1,x2,1,y,2)=[[1,1,1],[1,2,1],[1]] -- (1,a,1) (1,a,2) (1,a,3) (2,b,2) (2,b,2) (2,b,1) (1,c,3)

SELECT arrayEnumerateUniqRanked(1, [1, 2, 1], 1, [[1, 2, 3], [2, 2, 1], [3]], 2, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, x,1,y,2,y2,2)=[[1,1,1],[1,1,1],[1]] -- (1,1,a) (1,2,b) (1,3,a) (2,2,a) (2,2,b) (2,1,a) (1,3,c)

SELECT arrayEnumerateUniqRanked(1, [[1, 2, 3], [2, 2, 1], [3]], 1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(1, y,1,y2,2)=[[1,1,2],[1,1,2],[1]] -- ([1,2,3],a) ([1,2,3],b) ([1,2,3],a) ([2,2,1],a) ([2,2,1],b) ([2,2,1],a) ([3],c)

SELECT arrayEnumerateUniqRanked(1, [[1, 2, 3], [2, 2, 1], [3]], 2, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 1); -- f(1, y,2,y2,1)=[[1,1,1],[2,3,2],[1]] -- (1,[a,b,a]) (2,[a,b,a]) (3,[a,b,a]) (2,[a,b,a]) (2,[a,b,a]) (1,[a,b,a]) (3,[c])

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(2, y,2)=[[1,1,1],[1,2,1],[1]]  -- 1 2 3, 2 2 1, 3

SELECT arrayEnumerateUniqRanked(2, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(2, y2,2)=[[1,1,2],[1,1,2],[1]] -- a b a, a b a, c

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], 2, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(2, y,2,y2,2)=[[1,1,1],[1,1,1],[1]] -- (1,a) (2,b) (3,a), (2,a) (2,b) (1,a), (3,c)

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], 2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(2, y,2,z,2)=[[1,1,1],[1,2,1],[1]] -- (1,[1,2,3]) (2,[1,2,3]) (3,[1,2,3]), (2,[1,2,3]) (2,[1,2,3]) (1,[1,2,3]), (3,[1,2])

SELECT arrayEnumerateUniqRanked(2, [1, 2, 1], 1, [[1, 2, 3], [2, 2, 1], [3]], 2); -- f(2, x,1,y,2)=[[1,1,1],[1,2,1],[1]] -- (1,1) (1,2) (1,3), (2,2) (2,2) (2,1), (1,3)

SELECT arrayEnumerateUniqRanked(2, [1, 2, 1], 1, [['a', 'b', 'a'], ['a', 'b', 'a'], ['c']], 2); -- f(2, x,1,y2,2)=[[1,1,2],[1,1,2],[1]] -- (1,a) (1,b) (1,a), (2,a) (2,b) (2,a), (1,c)

SELECT arrayEnumerateUniqRanked(2, [1, 2, 1], 1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(2, x,1,z,2)=[[1,2,3],[1,2,3],[1]] -- (1,[1,2,3]) (1,[1,2,3]) (1,[1,2,3]), (2,[1,2,3]) (2,[1,2,3]) (2,[1,2,3]), (1,[1,2])

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], 1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2); -- f(2, y,1,z,2)=[[1,2,3],[1,2,3],[1]] -- ([1,2,3],[1,2,3]) ([1,2,3],[1,2,3]) ([1,2,3],[1,2,3]), ([2,2,1],[1,2,3]) ([2,2,1],[1,2,3]) ([2,2,1],[1,2,3]), ([3],[1,2])

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], 2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3], [2, 2, 1], [3]], [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]]); -- same

SELECT arrayEnumerateUniqRanked(3, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateUniqRanked(2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateUniqRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateUniqRanked([[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]]); --same

SELECT '---------Dense';

SELECT arrayEnumerateDenseRanked(1, [10, 20, 10, 30], 1);

SELECT arrayEnumerateDense([10, 20, 10, 30]);

SELECT arrayEnumerateDenseRanked(3, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateDenseRanked(2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateDenseRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 3);

SELECT arrayEnumerateDenseRanked(2, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2);

SELECT arrayEnumerateDenseRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 2);

SELECT arrayEnumerateDenseRanked(1, [[[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2, 3], [1, 2, 3], [1, 2, 3]], [[1, 2]]], 1);

DROP TABLE IF EXISTS arrays_test;

CREATE TABLE arrays_test
(
    a1 Array(UInt16),
    a2 Array(UInt16),
    a3 Array(Array(UInt16)),
    a4 Array(Array(UInt16))
)
ENGINE = Memory();

--INSERT INTO arrays_test VALUES ([1,2,3], [2,2,1], [[1,2,3,4],[2,2,1],[3]], [[1,2,4,4],[2,2,1],[3]]), ([1,2,4], [2,2,1], [[1,2,3,4],[2,2,1],[3]], [[1,2,5,4],[2,2,1],[3]]), ([1,2,3], [2,2,1], [[1,2,3,4],[2,2,1],[3]], [[1,2,4,4],[2,2,1],[3]]), ([1,2,3], [2,2,1], [[1,2,3,4],[2,2,1],[3]], [[1,2,4,4],[2,2,1],[3]]);
INSERT INTO arrays_test;

--INSERT INTO arrays_test VALUES ([1,2,3], [1,2,1], [[1,2,3,4],[2,2,1],[3]], [[1,2,4,4],[2,2,1],[3]]), ([21,22,24], [21,22,21], [[21,22,23,24],[22,22,21],[23]], [[21,22,25,24],[22,22,21],[23]]);
INSERT INTO arrays_test;

INSERT INTO arrays_test;

SELECT *
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a1,1',
    arrayEnumerateUniqRanked(1, a1, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a2,1',
    arrayEnumerateUniqRanked(1, a2, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a3,1',
    arrayEnumerateUniqRanked(1, a3, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a4,1',
    arrayEnumerateUniqRanked(1, a4, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a1,1,a2,1',
    arrayEnumerateUniqRanked(1, a1, 1, a2, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT arrayEnumerateUniq(a1, a2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a3,1,a4,1',
    arrayEnumerateUniqRanked(1, a3, 1, a4, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a3,2,a4,1',
    arrayEnumerateUniqRanked(1, a3, 2, a4, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a3,1,a4,2',
    arrayEnumerateUniqRanked(1, a3, 1, a4, 2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '1,a3,2,a4,2',
    arrayEnumerateUniqRanked(1, a3, 2, a4, 2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '2,a3,2,a4,2',
    arrayEnumerateUniqRanked(2, a3, 2, a4, 2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '2,a3,2,a4,1',
    arrayEnumerateUniqRanked(2, a3, 2, a4, 1)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

SELECT
    '2,a3,1,a4,2',
    arrayEnumerateUniqRanked(2, a3, 1, a4, 2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

DROP TABLE arrays_test;

CREATE TABLE arrays_test
(
    a3 Array(Array(UInt8)),
    a4 Array(Array(UInt32))
)
ENGINE = Memory();

INSERT INTO arrays_test;

SELECT
    'a3,a4 1..n',
    arrayEnumerateUniqRanked(a3, a4)
FROM arrays_test
ORDER BY
    a3 ASC,
    a4 ASC;

TRUNCATE TABLE arrays_test;

INSERT INTO arrays_test;

SELECT
    'a3,a4 1..1',
    arrayEnumerateUniqRanked(a3, a4)
FROM arrays_test
ORDER BY
    a3 ASC,
    a4 ASC;

SELECT arrayEnumerateUniqRanked(); -- { serverError TOO_FEW_ARGUMENTS_FOR_FUNCTION }

SELECT arrayEnumerateUniqRanked([]);

SELECT arrayEnumerateUniqRanked(1); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(2, []); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(2, [], 2); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(2, [], []); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(2, [], [], 3); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked([], 2); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked([], 2, []); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(0, [], 0); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(0, 0, 0); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(1, 1, 1); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(1, [10, 20, 10, 30], 0); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(1, [[7, 8, 9, 10], [10, 11, 12]], 2, [[14, 15, 16], [17, 18, 19], [20], [21]], 2); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateUniqRanked(1, [1, 2], 1, ['a', 'b', 'c', 'd'], 1); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateUniqRanked(1, [1, 2], 1, [14, 15, 16, 17, 18, 19], 1); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateUniqRanked(1, [14, 15, 16, 17, 18, 19], 1, [1, 2], 1); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateUniqRanked(1, [1, 1, 1, 1, 1, 1], 1, [1, 1], 1); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateUniqRanked(1, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 1, [1, 1], 1); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT arrayEnumerateDenseRanked([], [], []);

SELECT arrayEnumerateDenseRanked([], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []);

SELECT arrayEnumerateDenseRanked([1, 2], [1, 2], [1, 2]);

SELECT arrayEnumerateUniqRanked([1, 2], [1, 2], [1, 2]);

SELECT arrayEnumerateUniqRanked([1, 2], 3, 4, 5); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked([1, 2], 1, 2); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked([1, 2], 1, 3, 4, 5); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked([1, 2], 1, 3, [4], 5); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked([[[[[[[[[[42]]]]]]]]]]);

SELECT arrayEnumerateUniqRanked('wat', [1, 2]); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(1, [1, 2], 'boom'); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(['\0'], -8363126); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(-10, ['\0'], -8363126); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(1, ['\0'], -8363126); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(-101, ['\0']); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked(1.1, [10, 20, 10, 30]); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked([10, 20, 10, 30], 0.4); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateDenseRanked([10, 20, 10, 30], 1.8); -- { serverError BAD_ARGUMENTS }

SELECT arrayEnumerateUniqRanked(1, [], 1000000000); -- { serverError BAD_ARGUMENTS }

-- skipping empty arrays
SELECT arrayEnumerateUniqRanked(2, [[3], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[], [3], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[], [], [], [3], [], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[], [], [], [], [3], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[3], [], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[3], [], [], [3]]);

SELECT arrayEnumerateUniqRanked(2, [[3], [], [], [3], [3]]);

SELECT *
FROM (
        SELECT
            a,
            arrayEnumerateUniqRanked(a)
        FROM (
                SELECT *
                FROM (
                        SELECT [[], [1, 2, 3, 4]] AS a
                        UNION ALL
                        SELECT [[3, 4, 5]] AS a
                    )
            )
    )
ORDER BY a ASC;

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[], [3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[6], [1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3, 4], [3, 4, 5, 6]]);

SELECT arrayEnumerateUniqRanked(2, [[], [1, 2, 3, 4], [3, 4, 5, 6]]);

SELECT arrayEnumerateUniqRanked(2, [[], [1, 2, 3, 4], [], [], [3, 4, 5, 6]]);

SELECT arrayEnumerateUniqRanked(2, [[1, 2, 3, 4], [], [], [3, 4, 5, 6]]);

SELECT arrayEnumerateUniqRanked(2, [[1], [1]]);

SELECT arrayEnumerateUniqRanked(2, [[], [1], [1]]);

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [4]] AS a
                UNION ALL
                SELECT [[4]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [], [1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [], [1, 2, 3, 4]] AS a
                UNION ALL
                SELECT [[], [], [3, 4, 5]] AS a
            )
        ORDER BY a ASC
    );

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [], [1, 2, 1, 4]] AS a
                UNION ALL
                SELECT [[], [], [3, 4, 5, 4]] AS a
            )
        ORDER BY a ASC
    );

CREATE TABLE arrays_test
(
    a1 Array(UInt8),
    a2 Array(UInt32)
)
ENGINE = Memory();

INSERT INTO arrays_test;

SELECT
    'a1,a2 n',
    arrayEnumerateUniqRanked(a1, a2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

INSERT INTO arrays_test;

SELECT
    'a1,a2 1',
    arrayEnumerateUniqRanked(a1, a2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

INSERT INTO arrays_test;

SELECT
    'a1,a2 n2',
    arrayEnumerateUniqRanked(a1, a2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

INSERT INTO arrays_test;

SELECT
    'a1,a2 12',
    arrayEnumerateUniqRanked(a1, a2)
FROM arrays_test
ORDER BY
    a1 ASC,
    a2 ASC;

DROP TABLE IF EXISTS arr_tests_visits;

CREATE TABLE arr_tests_visits
(
    CounterID UInt32,
    StartDate Date,
    Sign Int8,
    VisitID UInt64,
    UserID UInt64,
    VisitVersion UInt16,
    `Test.BannerID` Array(UInt64),
    `Test.Load` Array(UInt8),
    `Test.PuidKey` Array(Array(UInt8)),
    `Test.PuidVal` Array(Array(UInt32))
)
ENGINE = MergeTree()
ORDER BY (CounterID, StartDate, intHash32(UserID), VisitID)
PARTITION BY toMonday(StartDate)
SAMPLE BY intHash32(UserID)
SETTINGS index_granularity = '8192';

TRUNCATE TABLE arr_tests_visits;

INSERT INTO arr_tests_visits (CounterID, StartDate, Sign, VisitID, UserID, VisitVersion, `Test.BannerID`, `Test.Load`, `Test.PuidKey`, `Test.PuidVal`);

SELECT
    CounterID,
    StartDate,
    Sign,
    VisitID,
    UserID,
    VisitVersion,
    BannerID,
    Load,
    PuidKeyArr,
    PuidValArr,
    arrayEnumerateUniqRanked(PuidKeyArr, PuidValArr) AS uniqTestPuid
FROM
    arr_tests_visits
ARRAY JOIN Test.BannerID AS BannerID, Test.Load AS Load, Test.PuidKey AS PuidKeyArr, Test.PuidVal AS PuidValArr;

DROP TABLE arr_tests_visits;

SELECT arrayEnumerateUniqRanked([['a'], [], ['a']]);

SELECT arrayEnumerateUniqRanked([[1], [], [1]]);

SELECT arrayEnumerateUniqRanked([[1], [], [1], [], [1], [], [1], [], [1], [], [1], [], [1], [], [1], [], [1]]);

SELECT arrayEnumerateUniqRanked([[], [1], [], [1], [], [1], [], [1], [], [1], [], [1], [], [1], [], [1]]);

SELECT arrayEnumerateUniqRanked([[1], [1], [], [1]]);

SELECT
    a,
    arrayEnumerateUniqRanked(a)
FROM (
        SELECT *
        FROM (
                SELECT [[], [1], []] AS a
                UNION ALL
                SELECT [[1]] AS a
            )
        ORDER BY a ASC
    );