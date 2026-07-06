-- The following queries use very weird block structure:
-- __table3.b UInt8 UInt8(size = 1), __table3.b UInt8 Const(size = 1, UInt8(size = 1)), __table3.c UInt8 Const(size = 1, UInt8(size = 1))
-- That leads to a pretty legit error in ConcurrentHashJoin within a call to Block::cloneEmpty():
-- Code: 352. DB::Exception: Block structure mismatch in (columns with identical name must have identical structure) stream: different columns:
-- __table3.b UInt8 UInt8(size = 0)
-- __table3.b UInt8 Const(size = 0, UInt8(size = 1))
-- So let's disable parallel_hash.
SET join_algorithm = 'hash,grace_hash,partial_merge,full_sorting_merge';

SELECT b
FROM
    (
        SELECT
            1 AS a,
            42 AS c
    ) AS js1
ANY LEFT JOIN (
        SELECT
            2 AS b,
            2 AS b,
            41 AS c
    ) AS js2
    USING (c);

SELECT b
FROM
    (
        SELECT
            1 AS a,
            42 AS c
    ) AS js1
ANY LEFT JOIN (
        SELECT
            2 AS b,
            2 AS b,
            42 AS c
    ) AS js2
    USING (c);

SELECT
    c,
    a,
    a,
    b,
    b
FROM
    (
        SELECT
            1 AS a,
            1 AS a,
            42 AS c
        GROUP BY c
        ORDER BY
            a ASC,
            c ASC
    ) AS js1
ANY LEFT JOIN (
        SELECT
            2 AS b,
            2 AS b,
            41 AS c
        GROUP BY c
        ORDER BY
            b ASC,
            c ASC
    ) AS js2
    USING (c)
ORDER BY b ASC;