SET output_format_pretty_color = '1';

SELECT CAST('True' AS Bool);

SELECT CAST('On' AS Bool);

SELECT CAST('Yes' AS Bool);

SELECT CAST('T' AS Bool);

SELECT CAST('Y' AS Bool);

SELECT CAST('1' AS Bool);

SELECT CAST('enabled' AS Bool);

SELECT CAST('enable' AS Bool);

SELECT CAST('False' AS Bool);

SELECT CAST('Off' AS Bool);

SELECT CAST('No' AS Bool);

SELECT CAST('N' AS Bool);

SELECT CAST('F' AS Bool);

SELECT CAST('0' AS Bool);

SELECT CAST('disabled' AS Bool);

SELECT CAST('disable' AS Bool);

SET bool_true_representation = 'Custom true';

SET bool_false_representation = 'Custom false';

SELECT CAST('true' AS Bool)
FORMAT CSV;

SELECT CAST('true' AS Bool)
FORMAT TSV;

SELECT CAST('true' AS Bool)
FORMAT Values;

SELECT CAST('true' AS Bool)
FORMAT Vertical;

SELECT CAST('true' AS Bool)
FORMAT Pretty;

SELECT CAST('true' AS Bool)
FORMAT JSONEachRow;

SELECT CAST(CAST(2 AS Bool) AS UInt8);

SELECT CAST(CAST(toUInt32(2) AS Bool) AS UInt8);

SELECT CAST(CAST(toInt8(2) AS Bool) AS UInt8);

SELECT CAST(CAST(toFloat32(2) AS Bool) AS UInt8);

SELECT CAST(CAST(toDecimal32(2, 2) AS Bool) AS UInt8);

SELECT CAST(CAST(materialize(2) AS Bool) AS UInt8);