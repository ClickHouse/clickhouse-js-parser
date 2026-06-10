DROP TABLE IF EXISTS null_in_subquery;

CREATE TABLE null_in_subquery
(
    dt DateTime,
    idx int,
    i Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY idx
PARTITION BY dt
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO null_in_subquery SELECT
    number % 3,
    number,
    number
FROM `system`.numbers
LIMIT 99999;

SET transform_null_in = '1';

SELECT count() = 33333
FROM null_in_subquery
WHERE i IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 0
    );

SELECT count() = 66666
FROM null_in_subquery
WHERE i NOT IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 1
    );

SELECT count() = 33333
FROM null_in_subquery
WHERE i GLOBAL IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 2
    );

SELECT count() = 66666
FROM null_in_subquery
WHERE i GLOBAL NOT IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 0
    );

-- For index column
SELECT count() = 33333
FROM null_in_subquery
WHERE idx IN (
        SELECT idx
        FROM null_in_subquery
        WHERE dt = 0
    );

SELECT count() = 66666
FROM null_in_subquery
WHERE idx NOT IN (
        SELECT idx
        FROM null_in_subquery
        WHERE dt = 1
    );

SELECT count() = 33333
FROM null_in_subquery
WHERE idx GLOBAL IN (
        SELECT idx
        FROM null_in_subquery
        WHERE dt = 2
    );

SELECT count() = 66666
FROM null_in_subquery
WHERE idx GLOBAL NOT IN (
        SELECT idx
        FROM null_in_subquery
        WHERE dt = 0
    );

INSERT INTO null_in_subquery;

INSERT INTO null_in_subquery;

SELECT count() = 33335
FROM null_in_subquery
WHERE i IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 0
    );

SELECT count() = 33333
FROM null_in_subquery
WHERE i IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 2
    );

SELECT count() = 66668
FROM null_in_subquery
WHERE i NOT IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 2
    );

SELECT count() = 33335
FROM null_in_subquery
WHERE i GLOBAL IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 0
    );

SELECT count() = 66666
FROM null_in_subquery
WHERE i GLOBAL NOT IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 1
    );

SELECT count() = 66668
FROM null_in_subquery
WHERE i GLOBAL NOT IN (
        SELECT i
        FROM null_in_subquery
        WHERE dt = 2
    );

DROP TABLE IF EXISTS null_in_tuple;

CREATE TABLE null_in_tuple
(
    dt DateTime,
    idx int,
    t Tuple(Nullable(UInt64), Nullable(String))
)
ENGINE = MergeTree()
ORDER BY idx
PARTITION BY dt
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO null_in_tuple;

SET transform_null_in = '0';

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1')]
FROM null_in_tuple
WHERE t IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1')]
FROM null_in_tuple
WHERE t GLOBAL IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t GLOBAL NOT IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1'), (NULL, NULL)]
FROM null_in_tuple
WHERE t IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3')]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1'), (NULL, NULL)]
FROM null_in_tuple
WHERE t GLOBAL IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3')]
FROM null_in_tuple
WHERE t GLOBAL NOT IN ((1, '1'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1')]
FROM null_in_tuple
WHERE t IN ((1, '1'), (1, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1')]
FROM null_in_tuple
WHERE t IN ((1, '1'), (NULL, '1'));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1'), (2, NULL)]
FROM null_in_tuple
WHERE t IN ((1, '1'), (NULL, '1'), (2, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1'), (NULL, '3')]
FROM null_in_tuple
WHERE t IN ((1, '1'), (1, NULL), (NULL, '3'));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(1, '1'), (2, NULL), (NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t IN ((1, '1'), (1, NULL), (2, NULL), (NULL, '3'), (NULL, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (1, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (NULL, '1'));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(NULL, '3'), (NULL, NULL)]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (NULL, '1'), (2, NULL));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = [(2, NULL), (NULL, NULL)]
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (1, NULL), (NULL, '3'));

SELECT arraySort((x -> ((x).1, (x).2)), groupArray(t)) = []
FROM null_in_tuple
WHERE t NOT IN ((1, '1'), (1, NULL), (2, NULL), (NULL, '3'), (NULL, NULL));