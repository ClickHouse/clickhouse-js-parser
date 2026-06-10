DROP TABLE IF EXISTS type_names;

DROP TABLE IF EXISTS values_template;

DROP TABLE IF EXISTS values_template_nullable;

DROP TABLE IF EXISTS values_template_fallback;

SET input_format_null_as_default = '0';

CREATE TABLE type_names
(
    n UInt8,
    s1 String,
    s2 String,
    s3 String
)
ENGINE = Memory();

CREATE TABLE values_template
(
    d Date,
    s String,
    u UInt8,
    i Int64,
    f Float64,
    a Array(UInt8)
)
ENGINE = Memory();

CREATE TABLE values_template_nullable
(
    d Date,
    s Nullable(String),
    u Nullable(UInt8),
    a Array(Nullable(Float32))
)
ENGINE = Memory();

CREATE TABLE values_template_fallback
(
    n UInt8
)
ENGINE = Memory();

SET input_format_values_interpret_expressions = '0';

-- checks type deduction
INSERT INTO type_names;

--(1, lower(replaceAll(_STR_1, 'o', 'a')), _NUM_1 + _NUM_2 + _NUM_3, round(_NUM_4 / _NUM_5), _NUM_6 * CAST(_STR_7, 'Int8'), _ARR_8);
-- _NUM_1: UInt64 -> Int64 -> UInt64
-- _NUM_4: Int64 -> UInt64
-- _NUM_5: Float64 -> Int64
INSERT INTO values_template;

INSERT INTO values_template_nullable;

INSERT INTO values_template_fallback; -- { error SYNTAX_ERROR }

INSERT INTO values_template_fallback; -- { error UNKNOWN_FUNCTION }

INSERT INTO values_template_fallback; -- { error ILLEGAL_TYPE_OF_ARGUMENT }

INSERT INTO values_template_fallback;

SET input_format_values_accurate_types_of_literals = '0';

INSERT INTO type_names;

SET input_format_values_interpret_expressions = '1';

INSERT INTO values_template_fallback;

INSERT INTO values_template_fallback;

SELECT *
FROM type_names
ORDER BY n ASC;

SELECT *
FROM values_template
ORDER BY d ASC;

SELECT *
FROM values_template_nullable
ORDER BY d ASC;

SELECT *
FROM values_template_fallback
ORDER BY n ASC;

DROP TABLE type_names;

DROP TABLE values_template;

DROP TABLE values_template_nullable;

DROP TABLE values_template_fallback;