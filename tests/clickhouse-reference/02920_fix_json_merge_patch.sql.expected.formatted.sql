-- Tags: no-fasttest
SELECT
    '{"id":1,"foo":["bar"]}' AS a,
    jsonMergePatch(a, toJSONString(map('foo', arrayPushBack(arrayMap((x -> JSONExtractString(x)), JSONExtractArrayRaw(a, 'foo')), 'baz')))) AS b;