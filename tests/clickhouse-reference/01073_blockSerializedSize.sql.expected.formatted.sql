SELECT
    'UInt8',
    blockSerializedSize(0);

SELECT
    'Nullable(UInt8)',
    blockSerializedSize(toNullable(0));

SELECT
    'UInt32',
    blockSerializedSize(3735928495);

SELECT
    'UInt64',
    blockSerializedSize(244837809905325);

SELECT
    'Nullable(UInt64)',
    blockSerializedSize(toNullable(244837809905325));

SELECT
    'String',
    blockSerializedSize('foo');

SELECT
    'FixedString(32)',
    blockSerializedSize(CAST('foo' AS FixedString(32)));

SELECT
    'Enum8',
    blockSerializedSize(CAST('a' AS Enum8('a' = 1, 'b' = 2)));

SELECT
    'Array',
    blockSerializedSize(['foo']);

SELECT
    'uniqCombinedState(100)',
    blockSerializedSize(uniqCombinedState(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 100
    );

SELECT
    'uniqCombinedState(10000)',
    blockSerializedSize(uniqCombinedState(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10000
    );

SELECT
    'uniqCombinedState(100000)',
    blockSerializedSize(uniqCombinedState(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 100000
    );

SELECT
    'uniqCombinedState(1000000)',
    blockSerializedSize(uniqCombinedState(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 1000000
    );

SELECT
    'uniqCombinedState(10000000)',
    blockSerializedSize(uniqCombinedState(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10000000
    );

SELECT
    'uniqCombined64State(10000000)',
    blockSerializedSize(uniqCombined64State(number))
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10000000
    );

SELECT
    'String,UInt8',
    blockSerializedSize('foo', 1);

SELECT
    'Block(UInt32)',
    blockSerializedSize(number)
FROM numbers(2);