SET allow_experimental_dynamic_type = '1';

SELECT max(number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT min(number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT argMax(number, number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT argMin(number, number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT anyArgMax(number, number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT anyArgMin(number, number::Dynamic)
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

CREATE TABLE test
(
    d Dynamic,
    INDEX idx d TYPE minmax() GRANULARITY 1
); -- {serverError BAD_ARGUMENTS}

SET allow_experimental_variant_type = '1';

SELECT max(number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT min(number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT argMax(number, number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT argMin(number, number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT anyArgMax(number, number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT anyArgMin(number, number::Variant(UInt64))
FROM numbers(10); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

CREATE TABLE test
(
    d Variant(UInt64),
    INDEX idx d TYPE minmax() GRANULARITY 1
); -- {serverError BAD_ARGUMENTS}