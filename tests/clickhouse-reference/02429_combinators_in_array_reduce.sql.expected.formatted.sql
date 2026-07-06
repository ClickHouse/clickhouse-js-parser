SELECT arrayReduce('uniqStateMap', [map(1, 2)]);

SELECT arrayReduce('uniqStateForEach', [[1], [2]]);

SELECT arrayReduce('uniqStateForEachMapForEach', [[map(1, [2])]]);

SELECT arrayReduceInRanges('uniqStateMap', [(1, 3), (2, 3), (3, 3)], [map(1, 'a'), map(1, 'b'), map(1, 'c'), map(1, 'd'), map(1, 'e')]);

SELECT arrayReduceInRanges('uniqStateForEach', [(1, 3), (2, 3), (3, 3)], [['a'], ['b'], ['c'], ['d'], ['e']]);

SELECT arrayReduceInRanges('uniqStateForEachMapForEach', [(1, 3), (2, 3), (3, 3)], [[map(1, ['a'])], [map(1, ['b'])], [map(1, ['c'])], [map(1, ['d'])], [map(1, ['e'])]]);