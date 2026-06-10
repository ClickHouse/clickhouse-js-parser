SELECT toTypeName(true);

SELECT toTypeName(false);

SELECT NOT false;

SELECT NOT 1;

SELECT NOT 0;

SELECT NOT 100000000;

SELECT toTypeName(NOT false);

SELECT toTypeName(NOT 1);

SELECT toTypeName(NOT 0);

SELECT toTypeName(NOT 100000000);

SELECT false
    AND true;

SELECT 1
    AND 10;

SELECT 0
    AND 100000000;

SELECT 1
    AND true;

SELECT toTypeName(false
    AND true);

SELECT toTypeName(1
    AND 10);

SELECT toTypeName(0
    AND 10000000);

SELECT toTypeName(1
    AND true);

SELECT xor(false, true);

SELECT xor(1, 10);

SELECT xor(0, 100000000);

SELECT xor(1, true);

SELECT toTypeName(xor(false, true));

SELECT toTypeName(xor(1, 10));

SELECT toTypeName(xor(0, 10000000));

SELECT toTypeName(xor(1, true));

SELECT false
    OR true;

SELECT 1
    OR 10;

SELECT 0
    OR 100000000;

SELECT 1
    OR true;

SELECT toTypeName(false
    OR true);

SELECT toTypeName(1
    OR 10);

SELECT toTypeName(0
    OR 10000000);

SELECT toTypeName(1
    OR true);

SELECT toBool(100000000000);

SELECT toBool(0);

SELECT toBool(-10000000000);

SELECT toBool(100000000000.);

SELECT toBool(toDecimal32(10.1, 2));

SELECT toBool(toDecimal64(100000000000.1, 2));

SELECT toBool(toDecimal32(0, 2));

SELECT toBool('true');

SELECT toBool('yes');

SELECT toBool('enabled');

SELECT toBool('enable');

SELECT toBool('on');

SELECT toBool('y');

SELECT toBool('t');

SELECT toBool('false');

SELECT toBool('no');

SELECT toBool('disabled');

SELECT toBool('disable');

SELECT toBool('off');

SELECT toBool('n');

SELECT toBool('f');