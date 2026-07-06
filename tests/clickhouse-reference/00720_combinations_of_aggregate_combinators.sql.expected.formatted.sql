SELECT sumForEachArray([[1], [2]]);

SELECT sumForEachArrayIf([[number], [number % 2]], number < 5)
FROM numbers(10);

SELECT groupUniqArrayMerge(x)
FROM (
        SELECT groupUniqArrayStateArray([]) AS x
    );

SELECT groupUniqArrayArrayMerge(x)
FROM (
        SELECT groupUniqArrayArrayState([]) AS x
    );

SELECT groupUniqArrayForEachMerge(x)
FROM (
        SELECT groupUniqArrayForEachStateArray([[1], [1], [1]]) AS x
    );