SELECT
    bitNot(-inf) != 0,
    bitNot(inf) != 0,
    bitNot(3.40282e38) != 0,
    bitNot(nan) != 0;

SELECT
    bitCount(-inf),
    bitCount(inf),
    bitCount(3.40282e38),
    bitCount(nan);

SELECT bitAnd(1., 1.); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT bitOr(1., 1.); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT bitRotateLeft(1., 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT bitShiftLeft(1., 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT bitTest(1., 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }