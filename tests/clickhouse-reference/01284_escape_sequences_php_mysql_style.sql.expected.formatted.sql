-- Tags: no-fasttest
SELECT
    'a\\_\\c\\l\\i\\c\\k\\h\\o\\u\\s',
    'a\\_\\c\\l\\i\\c\\k\\h\\o\\u\\s\\e';

SELECT
    'aXb' LIKE 'a_b',
    'aXb' LIKE 'a\\_b',
    'a_b' LIKE 'a\\_b',
    'a_b' LIKE 'a\\_b';

SELECT
    match('Hello', '\\w+'),
    match('Hello', '\\w+'),
    match('Hello', '\\\\w+'),
    match('Hello', '\\w\\+'),
    match('Hello', 'w+');

SELECT match('Hello', '\\He\\l\\l\\o'); -- { serverError CANNOT_COMPILE_REGEXP }

SELECT match('Hello', '\\H\\l\\l\\o'); -- { serverError CANNOT_COMPILE_REGEXP }