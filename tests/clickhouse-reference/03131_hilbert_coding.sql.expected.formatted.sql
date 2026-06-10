SELECT '----- START -----';

DROP TABLE IF EXISTS hilbert_numbers_03131;

CREATE TABLE hilbert_numbers_03131
(
    n1 UInt32,
    n2 UInt32
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SELECT hilbertEncode(133);

SELECT hilbertEncode(3, 4);

SELECT hilbertDecode(2, 31);

INSERT INTO hilbert_numbers_03131 SELECT
    n1.number,
    n2.number
FROM
    numbers(pow(2, 32) - 8, 8) AS n1
CROSS JOIN numbers(pow(2, 32) - 8, 8) AS n2;

DROP TABLE IF EXISTS hilbert_numbers_1_03131;

CREATE TABLE hilbert_numbers_1_03131
(
    n1 UInt64,
    n2 UInt64
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO hilbert_numbers_1_03131 SELECT untuple(hilbertDecode(2, hilbertEncode(n1, n2)))
FROM hilbert_numbers_03131;

(SELECT
    n1,
    n2
FROM hilbert_numbers_03131
UNION DISTINCT
SELECT
    n1,
    n2
FROM hilbert_numbers_1_03131)
EXCEPT
(SELECT
    n1,
    n2
FROM hilbert_numbers_03131
INTERSECT
SELECT
    n1,
    n2
FROM hilbert_numbers_1_03131);

SELECT hilbertEncode(); -- { serverError TOO_FEW_ARGUMENTS_FOR_FUNCTION }

SELECT hilbertEncode(1, 2, 3); -- { serverError TOO_MANY_ARGUMENTS_FOR_FUNCTION }

SELECT hilbertDecode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT hilbertEncode('text'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT hilbertDecode('text', 'text'); -- { serverError ILLEGAL_COLUMN }

SELECT hilbertEncode((1, 2), 3); -- { serverError ARGUMENT_OUT_OF_BOUND }