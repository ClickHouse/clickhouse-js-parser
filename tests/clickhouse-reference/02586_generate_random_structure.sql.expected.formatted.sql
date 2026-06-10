SELECT generateRandomStructure(5, 42);

SELECT toTypeName(generateRandomStructure(5, 42));

SELECT toColumnTypeName(generateRandomStructure(5, 42));

SELECT *
FROM generateRandom(generateRandomStructure(5, 42), 42)
LIMIT 1;

SELECT generateRandomStructure(5, 42, 42); -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT generateRandomStructure('5'); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT generateRandomStructure(5, '42'); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT generateRandomStructure(materialize(5), 42); -- {serverError ILLEGAL_COLUMN}

SELECT generateRandomStructure(5, materialize(42)); -- {serverError ILLEGAL_COLUMN}

DESCRIBE TABLE generateRandom(10000000);

SELECT *
FROM generateRandom(10000000)
LIMIT 1;

SELECT *
FROM generateRandom(10000000, 2)
LIMIT 1;

SELECT *
FROM generateRandom(10000000, 2, 2)
LIMIT 1;

SELECT *
FROM generateRandom(10000000, 2, 2, 2)
LIMIT 1; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SET allow_suspicious_low_cardinality_types = '1';

SELECT generateRandomStructure(5, 4);