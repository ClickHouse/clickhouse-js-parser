SET enable_analyzer = '1';

DESCRIBE TABLE (SELECT 1);

SELECT 1;

SELECT '--';

DESCRIBE TABLE (SELECT 'test');

DESCRIBE TABLE (SELECT
    1,
    'test');

SELECT
    1,
    'test';

DESCRIBE TABLE (SELECT
    1,
    'test',
    [1, 2, 3]);

SELECT
    1,
    'test',
    [1, 2, 3];

DESCRIBE TABLE (SELECT
    1,
    'test',
    [1, 2, 3],
    ['1', '2', '3']);

SELECT
    1,
    'test',
    [1, 2, 3],
    ['1', '2', '3'];

DESCRIBE TABLE (SELECT NULL);

SELECT NULL;

DESCRIBE TABLE (SELECT (1, 1));

SELECT (1, 1);

DESCRIBE TABLE (SELECT [(1, 1)]);

SELECT [(1, 1)];

DESCRIBE TABLE (SELECT
    NULL,
    1,
    'test',
    [1, 2, 3],
    [(1, 1), (1, 1)]);

SELECT
    NULL,
    1,
    'test',
    [1, 2, 3],
    [(1, 1), (1, 1)];