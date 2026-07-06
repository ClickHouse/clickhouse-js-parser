-- When left and right element types are compatible, but the particular value
-- on the right is not in the range of the left type, it should be ignored.
SELECT toUInt8(1) IN (-1);

SELECT toUInt8(0) IN (-1);

SELECT toUInt8(255) IN (-1);

SELECT [toUInt8(1)] IN ([-1]);

SELECT [toUInt8(0)] IN ([-1]);

SELECT [toUInt8(255)] IN ([-1]);

-- When left and right element types are not compatible, we should get an error.
SELECT toUInt8(1) IN ('a'); -- { serverError TYPE_MISMATCH }

SELECT [toUInt8(1)] IN (['a']); -- { serverError TYPE_MISMATCH }