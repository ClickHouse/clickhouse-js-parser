DROP TABLE IF EXISTS dict_table;

DROP TABLE IF EXISTS data_table;

DROP DICTIONARY IF EXISTS dict;

CREATE TABLE dict_table
(
    strField String,
    dateField Date,
    float64Field Float64
)
ENGINE = Log();

INSERT INTO dict_table;

CREATE DICTIONARY dict
(
    strField String,
    dateField Date,
    float64Field Float64
)
PRIMARY KEY strField, dateField
SOURCE(clickhouse(TABLE 'dict_table'))
LIFETIME(MIN 300 MAX 360)
LAYOUT(COMPLEX_KEY_HASHED());

CREATE TABLE data_table
(
    float64Field1 Float64,
    float64Field2 Float64,
    strField1 String,
    strField2 String
)
ENGINE = Log();

INSERT INTO data_table;

SELECT round(float64Field1 * if(strField1 != '', 1., dictGetFloat64('dict', 'float64Field', (strField1, toDate('2021-01-01')))) + if(strField2 != '', 1., dictGetFloat64('dict', 'float64Field', (strField2, toDate('2021-01-01')))) * if(isFinite(float64Field2), float64Field2, 0), 2)
FROM data_table;

DROP DICTIONARY dict;

DROP TABLE dict_table;

DROP TABLE data_table;