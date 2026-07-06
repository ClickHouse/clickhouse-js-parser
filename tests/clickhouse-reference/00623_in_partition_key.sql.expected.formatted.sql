DROP TABLE IF EXISTS test54378;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test54378
(
    part_date Date,
    pk_date Date,
    date Date
)
ENGINE = MergeTree(part_date, pk_date, 8192);

INSERT INTO test54378;

SELECT 111
FROM test54378
WHERE part_date = '2018-04-19';

SELECT 112
FROM test54378
WHERE part_date IN ('2018-04-19');

SELECT 113
FROM test54378
WHERE pk_date IN ('2018-04-19');

SELECT 114
FROM test54378
WHERE date IN ('2018-04-19');

SELECT 121
FROM test54378
WHERE part_date = toDate('2018-04-19');

SELECT 122
FROM test54378
WHERE part_date IN (toDate('2018-04-19'));

SELECT 123
FROM test54378
WHERE pk_date IN (toDate('2018-04-19'));

SELECT 124
FROM test54378
WHERE date IN (toDate('2018-04-19'));

SELECT 131
FROM test54378
WHERE part_date = (
        SELECT toDate('2018-04-19')
    );

SELECT 132
FROM test54378
WHERE part_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 133
FROM test54378
WHERE pk_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 134
FROM test54378
WHERE date IN (
        SELECT toDate('2018-04-19')
    );

SELECT '---';

SELECT 211
FROM test54378
PREWHERE part_date = '2018-04-19';

SELECT 212
FROM test54378
PREWHERE part_date IN ('2018-04-19');

SELECT 213
FROM test54378
PREWHERE pk_date IN ('2018-04-19');

SELECT 214
FROM test54378
PREWHERE date IN ('2018-04-19');

SELECT 221
FROM test54378
PREWHERE part_date = toDate('2018-04-19');

SELECT 222
FROM test54378
PREWHERE part_date IN (toDate('2018-04-19'));

SELECT 223
FROM test54378
PREWHERE pk_date IN (toDate('2018-04-19'));

SELECT 224
FROM test54378
PREWHERE date IN (toDate('2018-04-19'));

SELECT 231
FROM test54378
PREWHERE part_date = (
        SELECT toDate('2018-04-19')
    );

SELECT 232
FROM test54378
PREWHERE part_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 233
FROM test54378
PREWHERE pk_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 234
FROM test54378
PREWHERE date IN (
        SELECT toDate('2018-04-19')
    );

SET optimize_move_to_prewhere = '0';

SELECT 311
FROM test54378
WHERE part_date = '2018-04-19';

SELECT 312
FROM test54378
WHERE part_date IN ('2018-04-19');

SELECT 313
FROM test54378
WHERE pk_date IN ('2018-04-19');

SELECT 314
FROM test54378
WHERE date IN ('2018-04-19');

SELECT 321
FROM test54378
WHERE part_date = toDate('2018-04-19');

SELECT 322
FROM test54378
WHERE part_date IN (toDate('2018-04-19'));

SELECT 323
FROM test54378
WHERE pk_date IN (toDate('2018-04-19'));

SELECT 324
FROM test54378
WHERE date IN (toDate('2018-04-19'));

SELECT 331
FROM test54378
WHERE part_date = (
        SELECT toDate('2018-04-19')
    );

SELECT 332
FROM test54378
WHERE part_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 333
FROM test54378
WHERE pk_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 334
FROM test54378
WHERE date IN (
        SELECT toDate('2018-04-19')
    );

SET optimize_move_to_prewhere = '1';

SELECT 411
FROM test54378
WHERE part_date = '2018-04-19';

SELECT 412
FROM test54378
WHERE part_date IN ('2018-04-19');

SELECT 413
FROM test54378
WHERE pk_date IN ('2018-04-19');

SELECT 414
FROM test54378
WHERE date IN ('2018-04-19');

SELECT 421
FROM test54378
WHERE part_date = toDate('2018-04-19');

SELECT 422
FROM test54378
WHERE part_date IN (toDate('2018-04-19'));

SELECT 423
FROM test54378
WHERE pk_date IN (toDate('2018-04-19'));

SELECT 424
FROM test54378
WHERE date IN (toDate('2018-04-19'));

SELECT 431
FROM test54378
WHERE part_date = (
        SELECT toDate('2018-04-19')
    );

SELECT 432
FROM test54378
WHERE part_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 433
FROM test54378
WHERE pk_date IN (
        SELECT toDate('2018-04-19')
    );

SELECT 434
FROM test54378
WHERE date IN (
        SELECT toDate('2018-04-19')
    );

DROP TABLE test54378;