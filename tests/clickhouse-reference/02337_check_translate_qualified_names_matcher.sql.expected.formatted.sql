CREATE TABLE nested_name_tuples
(
    a Tuple(x String, y Tuple(i Int32, j String))
)
ENGINE = Memory();

INSERT INTO nested_name_tuples;

SELECT t.a.y.i
FROM nested_name_tuples AS t;

SELECT nested_name_tuples.a.y.i
FROM nested_name_tuples AS t;