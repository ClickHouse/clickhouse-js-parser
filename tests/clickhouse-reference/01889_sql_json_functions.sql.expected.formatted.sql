-- Tags: no-fasttest
-- { echo }
SELECT '--JSON_VALUE--';

SELECT JSON_VALUE('{"hello":1}', '$'); -- root is a complex object => default value (empty string)

SELECT JSON_VALUE('{"hello":1}', '$.hello');

SELECT JSON_VALUE('{"hello":1.2}', '$.hello');

SELECT JSON_VALUE('{"hello":true}', '$.hello');

SELECT JSON_VALUE('{"hello":"world"}', '$.hello');

SELECT JSON_VALUE('{"hello":null}', '$.hello');

SELECT JSON_VALUE('{"hello":["world","world2"]}', '$.hello');

SELECT JSON_VALUE('{"hello":{"world":"!"}}', '$.hello');

SELECT JSON_VALUE('{hello:world}', '$.hello'); -- invalid json => default value (empty string)

SELECT JSON_VALUE('', '$.hello');

SELECT JSON_VALUE('{"foo foo":"bar"}', '$."foo foo"');

SELECT JSON_VALUE('{"hello":"\\uD83C\\uDF3A \\uD83C\\uDF38 \\uD83C\\uDF37 Hello, World \\uD83C\\uDF37 \\uD83C\\uDF38 \\uD83C\\uDF3A"}', '$.hello');

SELECT JSON_VALUE('{"a":"Hello \\"World\\" \\\\"}', '$.a');

SELECT JSON_VALUE('{"a":"\\n\\u0000"}', '$.a');

SELECT JSON_VALUE('{"a":"\\u263a"}', '$.a');

SELECT JSON_VALUE('{"hello":"world"}', '$.b')
SETTINGS function_json_value_return_type_allow_nullable = true;

SELECT JSON_VALUE('{"hello":{"world":"!"}}', '$.hello')
SETTINGS function_json_value_return_type_allow_complex = true;

SELECT JSON_VALUE('{"hello":["world","world2"]}', '$.hello')
SETTINGS function_json_value_return_type_allow_complex = true;

SELECT JSON_VALUE('{"1key":1}', '$.1key');

SELECT JSON_VALUE('{"hello":1}', '$[hello]');

SELECT JSON_VALUE('{"hello":1}', '$["hello"]');

SELECT JSON_VALUE('{"hello":1}', '$[''hello'']');

SELECT JSON_VALUE('{"hello 1":1}', '$["hello 1"]');

SELECT JSON_VALUE('{"1key":1}', '$..1key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_VALUE('{"1key":1}', '$1key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_VALUE('{"1key":1}', '$key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_VALUE('{"1key":1}', '$.[key]'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_QUERY('{"hello":1}', '$');

SELECT JSON_QUERY('{"hello":1}', '$.hello');

SELECT JSON_QUERY('{"hello":1.2}', '$.hello');

SELECT JSON_QUERY('{"hello":true}', '$.hello');

SELECT JSON_QUERY('{"hello":"world"}', '$.hello');

SELECT JSON_QUERY('{"hello":null}', '$.hello');

SELECT JSON_QUERY('{"hello":["world","world2"]}', '$.hello');

SELECT JSON_QUERY('{"hello":{"world":"!"}}', '$.hello');

SELECT JSON_QUERY('{hello:{"world":"!"}}}', '$.hello'); -- invalid json => default value (empty string)

SELECT JSON_QUERY('', '$.hello');

SELECT JSON_QUERY('{"array":[[0, 1, 2, 3, 4, 5], [0, -1, -2, -3, -4, -5]]}', '$.array[*][0 to 2, 4]');

SELECT JSON_QUERY('{"1key":1}', '$.1key');

SELECT JSON_QUERY('{"123":1}', '$.123');

SELECT JSON_QUERY('{"123":{"123":1}}', '$.123.123');

SELECT JSON_QUERY('{"123":{"abc":1}}', '$.123.abc');

SELECT JSON_QUERY('{"abc":{"123":1}}', '$.abc.123');

SELECT JSON_QUERY('{"123abc":{"123":1}}', '$.123abc.123');

SELECT JSON_QUERY('{"abc123":{"123":1}}', '$.abc123.123');

SELECT JSON_QUERY('{"123":1}', '$[123]');

SELECT JSON_QUERY('{"123":["1"]}', '$.123[0]');

SELECT JSON_QUERY('{"123abc":["1"]}', '$.123abc[0]');

SELECT JSON_QUERY('{"123abc":[{"123":"1"}]}', '$.123abc[0].123');

SELECT JSON_QUERY('{"hello":1}', '$[hello]');

SELECT JSON_QUERY('{"hello":1}', '$["hello"]');

SELECT JSON_QUERY('{"hello":1}', '$[''hello'']');

SELECT JSON_QUERY('{"hello 1":1}', '$["hello 1"]');

SELECT JSON_QUERY('{"1key":1}', '$..1key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_QUERY('{"1key":1}', '$1key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_QUERY('{"1key":1}', '$key'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_QUERY('{"1key":1}', '$.[key]'); -- { serverError BAD_ARGUMENTS }

SELECT JSON_EXISTS('{"hello":1}', '$');

SELECT JSON_EXISTS('', '$');

SELECT JSON_EXISTS('{}', '$');

SELECT JSON_EXISTS('{"hello":1}', '$.hello');

SELECT JSON_EXISTS('{"hello":1,"world":2}', '$.world');

SELECT JSON_EXISTS('{"hello":{"world":1}}', '$.world');

SELECT JSON_EXISTS('{"hello":{"world":1}}', '$.hello.world');

SELECT JSON_EXISTS('{hello:world}', '$.hello'); -- invalid json => default value (zero integer)

SELECT JSON_EXISTS('', '$.hello');

SELECT JSON_EXISTS('{"hello":["world"]}', '$.hello[*]');

SELECT JSON_EXISTS('{"hello":["world"]}', '$.hello[0]');

SELECT JSON_EXISTS('{"hello":["world"]}', '$.hello[1]');

SELECT JSON_EXISTS('{"a":[{"b":1},{"c":2}]}', '$.a[*].b');

SELECT JSON_EXISTS('{"a":[{"b":1},{"c":2}]}', '$.a[*].f');

SELECT JSON_EXISTS('{"a":[[{"b":1}, {"g":1}],[{"h":1},{"y":1}]]}', '$.a[*][0].h');

DROP TABLE IF EXISTS `01889_sql_json`;

CREATE TABLE `01889_sql_json`
(
    id UInt8,
    json String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `01889_sql_json` (id, json);

INSERT INTO `01889_sql_json` (id, json);

INSERT INTO `01889_sql_json` (id, json);

SELECT
    id,
    JSON_QUERY(json, '$.friends[0 to 2]')
FROM `01889_sql_json`
ORDER BY id ASC;

SELECT
    id,
    JSON_VALUE(json, '$.friends[0]')
FROM `01889_sql_json`
ORDER BY id ASC;

DROP TABLE `01889_sql_json`;