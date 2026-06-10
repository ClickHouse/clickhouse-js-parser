SELECT arrayStringConcat(['Hello', 'World']);

SELECT arrayStringConcat(materialize(['Hello', 'World']));

SELECT arrayStringConcat(['Hello', 'World'], ', ');

SELECT arrayStringConcat(materialize(['Hello', 'World']), ', ');

SELECT arrayStringConcat(emptyArrayString());

SELECT arrayStringConcat(arrayMap((x -> toString(x)), range(number)))
FROM `system`.numbers
LIMIT 10;

SELECT arrayStringConcat(arrayMap((x -> toString(x)), range(number)), '')
FROM `system`.numbers
LIMIT 10;

SELECT arrayStringConcat(arrayMap((x -> toString(x)), range(number)), ',')
FROM `system`.numbers
LIMIT 10;

SELECT arrayStringConcat(arrayMap((x -> transform(x, [0, 1, 2, 3, 4, 5, 6, 7, 8], ['meta.ua', 'google', 'test', '123', '', 'hello', 'world', 'goodbye', 'xyz'], '')), arrayMap((x -> x % 9), range(number))), ' ')
FROM `system`.numbers
LIMIT 20;

SELECT arrayStringConcat(arrayMap((x -> toString(x)), range(number % 4)))
FROM `system`.numbers
LIMIT 10;

SELECT arrayStringConcat([NULL, 'hello', NULL, 'world', NULL, 'xyz', 'def', NULL], ';');

SELECT arrayStringConcat([NULL::Nullable(String), NULL::Nullable(String)], ';');

SELECT arrayStringConcat(arr, ';')
FROM (
        SELECT [1, 23, 456] AS arr
    );

SELECT arrayStringConcat(materialize([NULL, 'hello', NULL, 'world', NULL, 'xyz', 'def', NULL]), ';');

SELECT arrayStringConcat(materialize([NULL::Nullable(String), NULL::Nullable(String)]), ';');