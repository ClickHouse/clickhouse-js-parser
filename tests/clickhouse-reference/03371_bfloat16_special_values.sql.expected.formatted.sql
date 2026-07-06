-- Check that Float32 and BFloat16 return the same values for calculations with special values
SELECT
    toFloat32(0.) = toFloat32(-0.),
    toBFloat16(0.) = toBFloat16(-0.);

SELECT
    toFloat32(0.) != toFloat32(-0.),
    toBFloat16(0.) != toBFloat16(-0.);

SELECT
    toFloat32(0.) > toFloat32(-0.),
    toBFloat16(0.) > toBFloat16(-0.);

SELECT
    toFloat32(0.) < toFloat32(-0.),
    toBFloat16(0.) < toBFloat16(-0.);

SELECT
    toFloat32(0.) + toFloat32(-0.),
    toBFloat16(0.) + toBFloat16(-0.);

SELECT
    toFloat32(-0.) + toFloat32(-0.),
    toBFloat16(-0.) + toBFloat16(-0.);

SELECT
    toFloat32(nan) = toFloat32(nan),
    toBFloat16(nan) = toBFloat16(nan);

SELECT
    toFloat32(nan) + toFloat32(nan),
    toBFloat16(nan) + toBFloat16(nan);

SELECT
    toFloat32(nan) - toFloat32(nan),
    toBFloat16(nan) - toBFloat16(nan);

SELECT
    toFloat32(nan) * toFloat32(nan),
    toBFloat16(nan) * toBFloat16(nan);

SELECT
    toFloat32(nan) / toFloat32(nan),
    toBFloat16(nan) / toBFloat16(nan);

SELECT
    toFloat32(nan) % toFloat32(nan),
    toBFloat16(nan) % toBFloat16(nan);

SELECT
    toFloat32(5.5) + toFloat32(nan),
    toBFloat16(5.5) + toBFloat16(nan);

SELECT
    toFloat32(5.5) - toFloat32(nan),
    toBFloat16(5.5) - toBFloat16(nan);

SELECT
    toFloat32(5.5) * toFloat32(nan),
    toBFloat16(5.5) * toBFloat16(nan);

SELECT
    toFloat32(5.5) / toFloat32(nan),
    toBFloat16(5.5) / toBFloat16(nan);

SELECT
    toFloat32(5.5) % toFloat32(nan),
    toBFloat16(5.5) % toBFloat16(nan);

SELECT
    toFloat32(inf) = toFloat32(inf),
    toBFloat16(inf) = toBFloat16(inf);

SELECT
    toFloat32(inf) + toFloat32(inf),
    toBFloat16(inf) + toBFloat16(inf);

SELECT
    toFloat32(inf) - toFloat32(inf),
    toBFloat16(inf) - toBFloat16(inf);

SELECT
    toFloat32(inf) * toFloat32(inf),
    toBFloat16(inf) * toBFloat16(inf);

SELECT
    toFloat32(inf) / toFloat32(inf),
    toBFloat16(inf) / toBFloat16(inf);

SELECT
    toFloat32(inf) % toFloat32(inf),
    toBFloat16(inf) % toBFloat16(inf);

SELECT
    toFloat32(-inf) = toFloat32(-inf),
    toBFloat16(-inf) = toBFloat16(-inf);

SELECT
    toFloat32(5.5) + toFloat32(inf),
    toBFloat16(5.5) + toBFloat16(inf);

SELECT
    toFloat32(5.5) - toFloat32(inf),
    toBFloat16(5.5) - toBFloat16(inf);

SELECT
    toFloat32(5.5) * toFloat32(inf),
    toBFloat16(5.5) * toBFloat16(inf);

SELECT
    toFloat32(5.5) / toFloat32(inf),
    toBFloat16(5.5) / toBFloat16(inf);

SELECT
    toFloat32(5.5) % toFloat32(inf),
    toBFloat16(5.5) % toBFloat16(inf);

-- Test for Bug 77087
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    c0 Tuple(BFloat16)
)
ENGINE = SummingMergeTree()
ORDER BY c0
SETTINGS ratio_of_defaults_for_sparse_serialization = 1.; -- Disable sparse serialization, otherwise the test becomes flaky

INSERT INTO tab (c0);

SELECT c0
FROM tab FINAL;

DROP TABLE tab;

-- Test for Bug 77224
CREATE TABLE tab
(
    c0 BFloat16 PRIMARY KEY
)
ENGINE = SummingMergeTree()
PRIMARY KEY c0
SETTINGS ratio_of_defaults_for_sparse_serialization = 1.; -- Disable sparse serialization, otherwise the test becomes flaky

INSERT INTO tab (c0);

INSERT INTO tab (c0);