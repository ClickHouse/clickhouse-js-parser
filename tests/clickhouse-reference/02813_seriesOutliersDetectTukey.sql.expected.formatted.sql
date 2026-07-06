-- Tags: no-cpu-aarch64
-- Tag no-cpu-aarch64: values generated are slighly different on aarch64
DROP TABLE IF EXISTS tb1;

CREATE TABLE tb1
(
    n UInt32,
    a Array(Float64)
)
ENGINE = Memory();

INSERT INTO tb1;

-- non-const inputs
SELECT seriesOutliersDetectTukey(a)
FROM tb1
ORDER BY n ASC;

SELECT seriesOutliersDetectTukey(a, 0.1, 0.9, 1.5)
FROM tb1
ORDER BY n ASC;

-- const inputs
SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4.5, 5, 12, 45, 12, 3.4, 3, 4, 5, 6]);

SELECT seriesOutliersDetectTukey([-3, 2.4, 15, 3.9, 5, 6, 4.5, 5.2, 12, 60, 12, 3.4, 3, 4, 5, 6, 3.4, 2.7]);

-- const inputs with optional arguments
SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4.5, 5, 12, 45, 12, 3.4, 3, 4, 5, 6], 0.25, 0.75, 1.5);

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4.5, 5, 12, 45, 12, 3.4, 3, 4, 5, 6], 0.1, 0.9, 1.5);

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4.5, 5, 12, 45, 12, 3.4, 3, 4, 5, 6], 0.02, 0.98, 1.5);

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3], 0.02, 0.98, 1.5);

SELECT seriesOutliersDetectTukey(arrayMap((x -> sin(x / 10)), range(30)));

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4, 5, 12, 45, 12, 3, 3, 4, 5, 6], 0.25, 0.75, 3);

-- negative tests
SELECT seriesOutliersDetectTukey([-3, 2, 15, 3, 5, 6, 4, 5, 12, 45, 12, 3, 3, 4, 5, 6], 0.25, 0.75, -1); -- { serverError BAD_ARGUMENTS}

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3], 0.33, 0.53); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT seriesOutliersDetectTukey([-3, 2, 15, 3], 0.33); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT seriesOutliersDetectTukey([-3, 2.4, 15, NULL]); -- { serverError ILLEGAL_COLUMN}

SELECT seriesOutliersDetectTukey([]); -- { serverError ILLEGAL_COLUMN}

SELECT seriesOutliersDetectTukey([-3, 2.4, 15]); -- { serverError BAD_ARGUMENTS}