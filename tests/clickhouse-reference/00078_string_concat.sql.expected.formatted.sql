SELECT '{ key: fn, value: concat }' = concat('{ key: ', toFixedString('fn', 2), ', value: ', 'concat', ' }');

SELECT concat('a', 'b') = 'ab';

SELECT concat('a', materialize('b')) = 'ab';

SELECT concat(materialize('a'), 'b') = 'ab';

SELECT concat(materialize('a'), materialize('b')) = 'ab';

SELECT concat('a', toFixedString('b', 1)) = 'ab';

SELECT concat('a', materialize(toFixedString('b', 1))) = 'ab';

SELECT concat(materialize('a'), toFixedString('b', 1)) = 'ab';

SELECT concat(materialize('a'), materialize(toFixedString('b', 1))) = 'ab';

SELECT concat(toFixedString('a', 1), 'b') = 'ab';

SELECT concat(toFixedString('a', 1), materialize('b')) = 'ab';

SELECT concat(materialize(toFixedString('a', 1)), 'b') = 'ab';

SELECT concat(materialize(toFixedString('a', 1)), materialize('b')) = 'ab';

SELECT concat(toFixedString('a', 1), toFixedString('b', 1)) = 'ab';

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1))) = 'ab';

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1)) = 'ab';

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1))) = 'ab';

SELECT concat('a', 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), 'b') = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize('b')) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1)) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1))) = 'ab'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', 'b', 'c') = 'abc';

SELECT concat('a', 'b', materialize('c')) = 'abc';

SELECT concat('a', materialize('b'), 'c') = 'abc';

SELECT concat('a', materialize('b'), materialize('c')) = 'abc';

SELECT concat(materialize('a'), 'b', 'c') = 'abc';

SELECT concat(materialize('a'), 'b', materialize('c')) = 'abc';

SELECT concat(materialize('a'), materialize('b'), 'c') = 'abc';

SELECT concat(materialize('a'), materialize('b'), materialize('c')) = 'abc';

SELECT concat('a', 'b', toFixedString('c', 1)) = 'abc';

SELECT concat('a', 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT concat('a', materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT concat('a', materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize('a'), 'b', toFixedString('c', 1)) = 'abc';

SELECT concat(materialize('a'), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize('a'), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize('a'), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat('a', toFixedString('b', 1), 'c') = 'abc';

SELECT concat('a', toFixedString('b', 1), materialize('c')) = 'abc';

SELECT concat('a', materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT concat('a', materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT concat(materialize('a'), toFixedString('b', 1), 'c') = 'abc';

SELECT concat(materialize('a'), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT concat('a', toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT concat('a', toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat('a', materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT concat('a', materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize('a'), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize('a'), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(toFixedString('a', 1), 'b', 'c') = 'abc';

SELECT concat(toFixedString('a', 1), 'b', materialize('c')) = 'abc';

SELECT concat(toFixedString('a', 1), materialize('b'), 'c') = 'abc';

SELECT concat(toFixedString('a', 1), materialize('b'), materialize('c')) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), 'b', 'c') = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), 'b', materialize('c')) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), 'c') = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), materialize('c')) = 'abc';

SELECT concat(toFixedString('a', 1), 'b', toFixedString('c', 1)) = 'abc';

SELECT concat(toFixedString('a', 1), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(toFixedString('a', 1), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT concat(toFixedString('a', 1), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), 'b', toFixedString('c', 1)) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), 'b', materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), 'c') = 'abc';

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), 'c') = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize('c')) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), 'c') = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize('c')) = 'abc';

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc';

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc';

SELECT concat('a', 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat('a', materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize('a'), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), 'b', 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), 'b', materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), 'b', toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), 'b', materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize('b'), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), 'c') = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize('c')) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(toFixedString('a', 1), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), toFixedString('b', 1), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), toFixedString('c', 1)) = 'abc'
FROM `system`.numbers
LIMIT 5;

SELECT concat(materialize(toFixedString('a', 1)), materialize(toFixedString('b', 1)), materialize(toFixedString('c', 1))) = 'abc'
FROM `system`.numbers
LIMIT 5;