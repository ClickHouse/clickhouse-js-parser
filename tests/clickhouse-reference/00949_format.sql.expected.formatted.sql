SET send_logs_level = 'fatal';

SELECT format('Hello {1} World {0}', materialize('first'), materialize('second'))
FROM `system`.numbers
LIMIT 1;

SELECT format('Hello {0} World {1}', materialize('first'), materialize('second'))
FROM `system`.numbers
LIMIT 2;

SELECT format('Hello {1} World {1}', materialize('first'), materialize('second'))
FROM `system`.numbers
LIMIT 3;

SELECT format('Hello {0} World {0}', materialize('first'), 'second')
FROM `system`.numbers
LIMIT 2;

SELECT format('Hellooooooooooooooooooooooooooooooooooo {0} Wooooooooooooooooooooooorld {0} {2}{2}', materialize('fiiiiiiiiiiirst'), 'second', materialize('third'))
FROM `system`.numbers
LIMIT 2;

SELECT format('{}', 'first');

SELECT format('{}{}', 'first', toFixedString('second', 6));

SELECT format('{{}}', materialize('first'), 'second');

SELECT 50 = length(format((
        SELECT arrayStringConcat(arrayMap((x -> '{'), range(100)))
    ), ''));

SELECT 100 = length(format(concat((
        SELECT arrayStringConcat(arrayMap((x -> '}'), range(100)))
    ), (
        SELECT arrayStringConcat(arrayMap((x -> '{'), range(100)))
    )), ''));

SELECT format('', 'first');

SELECT concat('third', 'first', 'second') = format('{2}{0}{1}', 'first', 'second', 'third');

SELECT format('{', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{{}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{ {}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{{', '');

SELECT format('{}}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('}}', '');

SELECT format('{2 }', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{}{}{}{}{}{} }{}', '', '', '', '', '', '', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{sometext}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{\0sometext}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{1023}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{10000000000000000000000000000000000000000000000000}', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{} {0}', '', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('{0} {}', '', ''); -- { serverError BAD_ARGUMENTS }

SELECT format('Hello {} World {} {}{}', 'first', 'second', 'third')
FROM `system`.numbers
LIMIT 2; -- { serverError BAD_ARGUMENTS }

SELECT format('Hello {0} World {1} {2}{3}', 'first', 'second', 'third')
FROM `system`.numbers
LIMIT 2; -- { serverError BAD_ARGUMENTS }

SELECT 50 = length(format((
        SELECT arrayStringConcat(arrayMap((x -> '{'), range(101)))
    ), '')); -- { serverError BAD_ARGUMENTS }

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT '{{}' = format('{{{}', '{}');

SELECT '{ key: fn, value: concat }' = format('{}{}{}{}{}', '{ key: ', toFixedString('fn', 2), ', value: ', 'concat', ' }');

SELECT format('{}{}', 'a', 'b') = 'ab';

SELECT format('{}{}', 'a', materialize('b')) = 'ab';

SELECT format('{}{}', materialize('a'), 'b') = 'ab';

SELECT format('{}{}', materialize('a'), materialize('b')) = 'ab';

SELECT format('{}{}', 'a', toFixedString('b', 1)) = 'ab';

SELECT format('{}{}', 'a', materialize(toFixedString('b', 1))) = 'ab';

SELECT format('{}{}', materialize('a'), toFixedString('b', 1)) = 'ab';

SELECT format('{}{}', materialize('a'), materialize(toFixedString('b', 1))) = 'ab';

SELECT format('{}{}', toFixedString('a', 1), 'b') = 'ab';

SELECT format('{}{}', toFixedString('a', 1), materialize('b')) = 'ab';

SELECT format('{}{}', materialize(toFixedString('a', 1)), 'b') = 'ab';

SELECT format('{}{}', materialize(toFixedString('a', 1)), materialize('b')) = 'ab';

SELECT format('{}{}', toFixedString('a', 1), toFixedString('b', 1)) = 'ab';

SELECT format('{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1))) = 'ab';

SELECT format('{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1)) = 'ab';

SELECT format('{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1))) = 'ab';

SELECT format('{}{}', 'a', 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', 'a', materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize('a'), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize('a'), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', 'a', toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', 'a', materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize('a'), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize('a'), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', toFixedString('a', 1), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', toFixedString('a', 1), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize(toFixedString('a', 1)), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize(toFixedString('a', 1)), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', toFixedString('a', 1), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', 'b', 'c') = 'abc';

SELECT format('{}{}{}', 'a', 'b', materialize('c')) = 'abc';

SELECT format('{}{}{}', 'a', materialize('b'), 'c') = 'abc';

SELECT format('{}{}{}', 'a', materialize('b'), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize('a'), 'b', 'c') = 'abc';

SELECT format('{}{}{}', materialize('a'), 'b', materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize('b'), 'c') = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize('b'), materialize('c')) = 'abc';

SELECT format('{}{}{}', 'a', 'b', toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', 'a', 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', 'a', materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', 'a', materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize('a'), 'b', toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize('a'), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', 'a', toFixedString('b', 1), 'c') = 'abc';

SELECT format('{}{}{}', 'a', toFixedString('b', 1), materialize('c')) = 'abc';

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), 'c') = 'abc';

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT format('{}{}{}', 'a', toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', 'a', toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), 'b', 'c') = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), 'b', materialize('c')) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), 'c') = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', 'c') = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), 'c') = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), materialize('c')) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), 'b', toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), 'c') = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), 'c') = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT format('{}{}{}', 'a', 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', 'a', materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize('a'), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT format('{}{}{}', materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;