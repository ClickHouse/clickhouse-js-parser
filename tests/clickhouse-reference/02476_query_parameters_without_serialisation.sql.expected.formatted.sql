SET param_num = '42';

SET param_str = 'hello';

SET param_date = '2022-08-04 18:30:53';

SET param_map = [('2b95a497-3a5d-49af-bf85-15763318cde7', [1.2, 3.4])];

SELECT
    0,
    'placeholder',
    '2020-01-01 00:00:00',
    map();

SELECT
    toTypeName(0),
    toTypeName('placeholder'),
    toTypeName('2020-01-01 00:00:00'),
    toTypeName(map());

SET param_id = '42';

SET param_arr = [1, 2, 3];

SET param_map_2 = [('abc', 22), ('def', 33)];

SET param_mul_arr = [[4, 5, 6], [7], [8, 9]];

SET param_map_arr = [('10', [11, 12]), ('13', [14, 15])];

SET param_map_map_arr = [('ghj', [('klm', [16, 17])]), ('nop', [('rst', [18])])];

SELECT
    0,
    [],
    map(),
    [],
    map(),
    map();

SELECT
    toTypeName(0),
    toTypeName([]),
    toTypeName(map()),
    toTypeName([]),
    toTypeName(map()),
    toTypeName(map());

SET param_tbl = 'numbers';

SET param_db = 'system';

SET param_col = 'number';

SELECT col
FROM db.tbl
LIMIT 1
OFFSET 5;

SET param_arr_arr_arr = [[['a', 'b', 'c'], ['d', 'e', 'f']], [['g', 'h', 'i'], ['j', 'k', 'l']]];

SET param_tuple_tuple_tuple = [1, 'a', '2b95a497-3a5d-49af-bf85-15763318cde7', 3.14];

SET param_arr_map_tuple = [[(1, (2, '2022-08-04 18:30:53', 's')), (3, (4, '2020-08-04 18:30:53', 't'))]];

SET param_map_arr_tuple_map = [('a', [(1, [(10, 1), (20, 2)]), (2, [(30, 3), (40, 4)])]), ('b', [(3, [(50, 5), (60, 6)]), (4, [(70, 7), (80, 8)])])];

SELECT
    [],
    toTypeName([]);

SELECT
    tuple(),
    toTypeName(tuple());

SELECT
    [],
    toTypeName([]);

SELECT
    map(),
    toTypeName(map());