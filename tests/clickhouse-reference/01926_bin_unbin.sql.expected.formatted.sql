SELECT bin('');

SELECT bin(0);

SELECT bin(1);

SELECT bin(10);

SELECT bin(127);

SELECT bin(255);

SELECT bin(256);

SELECT bin(511);

SELECT bin(512);

SELECT bin('0');

SELECT bin('10');

SELECT bin('测试');

SELECT bin(toFixedString('测试', 10));

SELECT bin(toFloat32(1.2));

SELECT bin(toFloat64(1.2));

SELECT bin(toDecimal32(1.2, 8));

SELECT bin(toDecimal64(1.2, 17));

SELECT bin('12332424');

SELECT bin(materialize('12332424'));

SELECT bin(toNullable(materialize('12332424')));

SELECT bin(toLowCardinality(materialize('12332424')));

SELECT unbin('');

SELECT unbin('0') = '\0';

SELECT unbin('00110000'); -- 0

SELECT unbin('0011000100110000'); -- 10

SELECT unbin('111001101011010110001011111010001010111110010101'); -- 测试

SELECT unbin(materialize('00110000'));

SELECT unbin(toNullable(materialize('00110000')));

SELECT unbin(toLowCardinality(materialize('00110000')));

SELECT unbin(bin('')) = '';

SELECT bin(unbin('')) = '';

SELECT bin(unbin('0')) = '00000000';

-- hex and bin consistent for corner cases
SELECT hex('') = bin('');

SELECT unhex('') = unbin('');

SELECT unhex('0') = unbin('0');

-- hex and bin support AggregateFunction
SELECT hex(sumState(number)) = hex(toString(sumState(number)))
FROM numbers(10);

SELECT hex(avgState(number)) = hex(toString(avgState(number)))
FROM numbers(99);

SELECT hex(avgState(number))
FROM numbers(10);

SELECT bin(avgState(number))
FROM numbers(10);