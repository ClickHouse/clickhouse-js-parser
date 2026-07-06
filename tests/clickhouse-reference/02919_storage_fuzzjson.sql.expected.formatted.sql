DROP TABLE IF EXISTS `02919_test_table_noarg`;

CREATE TABLE `02919_test_table_noarg`
(
    str String
)
ENGINE = FuzzJSON('{}');

SELECT count()
FROM (
        SELECT *
        FROM `02919_test_table_noarg`
        LIMIT 100
    );

--
DROP TABLE IF EXISTS `02919_test_table_valid_args`;

CREATE TABLE `02919_test_table_valid_args`
(
    str String
)
ENGINE = FuzzJSON('{"pet":"rat"}', NULL);

SELECT count()
FROM (
        SELECT *
        FROM `02919_test_table_valid_args`
        LIMIT 100
    );

--
DROP TABLE IF EXISTS `02919_test_table_reuse_args`;

CREATE TABLE `02919_test_table_reuse_args`
(
    str String
)
ENGINE = FuzzJSON('{\n      "name": "Jane Doe",\n      "age": 30,\n      "city": "New York",\n      "contacts": {\n        "email": "jane@example.com",\n        "phone": "+1234567890"\n      },\n      "skills": [\n        "JavaScript",\n        "Python",\n        {\n          "frameworks": ["React", "Django"]\n        }\n      ],\n      "projects": [\n        {"name": "Project A", "status": "completed"},\n        {"name": "Project B", "status": "in-progress"}\n      ]\n    }', 12345);

SELECT count()
FROM (
        SELECT *
        FROM `02919_test_table_reuse_args`
        LIMIT 100
    );

--
DROP TABLE IF EXISTS `02919_test_table_invalid_col_type`;

CREATE TABLE `02919_test_table_invalid_col_type`
(
    str Nullable(Int64)
)
ENGINE = FuzzJSON('{"pet":"rat"}', NULL); -- { serverError BAD_ARGUMENTS }

--
DROP TABLE IF EXISTS `02919_test_multi_col`;

CREATE TABLE `02919_test_multi_col`
(
    str1 String,
    str2 String
)
ENGINE = FuzzJSON('{"pet":"rat"}', 999);

SELECT
    count(str1),
    count(str2)
FROM (
        SELECT
            str1,
            str2
        FROM `02919_test_multi_col`
        LIMIT 100
    );