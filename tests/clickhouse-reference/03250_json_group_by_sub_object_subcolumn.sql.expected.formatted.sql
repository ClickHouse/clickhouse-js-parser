SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 20, `a.b.c` UInt32)
)
ENGINE = Memory();

INSERT INTO test SELECT toJSONString(map('a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number)))
FROM numbers(2);

SELECT json.^a
FROM test
GROUP BY json.^a
ORDER BY toString(json.^a) ASC;

DROP TABLE test;