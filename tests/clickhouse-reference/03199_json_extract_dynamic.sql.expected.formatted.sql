SET input_format_json_try_infer_numbers_from_strings = '1';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

SELECT
    JSONExtract(materialize('{"d" : true}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : 42}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : -42}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : 18446744073709551615}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : 42.42}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "42"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "-42"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "18446744073709551615"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "Hello"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "2020-01-01"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : "2020-01-01 00:00:00.000"}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [1, 2, 3]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["str1", "str2", "str3"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [[[1], [2, 3, 4]], [[5, 6], [7]]]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["2020-01-01", "2020-01-01 00:00:00"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["2020-01-01", "2020-01-01 date"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["2020-01-01", "2020-01-01 00:00:00", "str"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["2020-01-01", "2020-01-01 00:00:00", "42"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["str", "42"]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [42, 42.42]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [42, 18446744073709551615, 42.42]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [null, null]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [null, 42]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [[null], [], [42]]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"a" : [[], [null, null], ["1", null, "3"], [null, "2", null]]}'), 'a', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"a" : [[], [null, null], ["1", null, "3"], [null, "2", null], ["2020-01-01"]]}'), 'a', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : ["str", 42, [42]]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [42, 18446744073709551615]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);

SELECT
    JSONExtract(materialize('{"d" : [-42, 18446744073709551615]}'), 'd', 'Dynamic') AS d,
    dynamicType(d);