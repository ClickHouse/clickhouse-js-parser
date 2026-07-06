SET cast_keep_nullable = '0';

SELECT
    CAST(toNullable(toInt32(0)) AS Int32) AS x,
    toTypeName(x);

SELECT
    CAST(toNullable(toInt8(0)) AS Int32) AS x,
    toTypeName(x);

SET cast_keep_nullable = '1';

SELECT
    CAST(toNullable(toInt32(1)) AS Int32) AS x,
    toTypeName(x);

SELECT
    CAST(toNullable(toInt8(1)) AS Int32) AS x,
    toTypeName(x);

SELECT
    CAST(toNullable(toFloat32(2)) AS Float32) AS x,
    toTypeName(x);

SELECT
    CAST(toNullable(toFloat32(2)) AS UInt8) AS x,
    toTypeName(x);

SELECT
    CAST(if(1 = 1, toNullable(toInt8(3)), NULL) AS Int32) AS x,
    toTypeName(x);

SELECT
    CAST(if(1 = 0, toNullable(toInt8(3)), NULL) AS Int32) AS x,
    toTypeName(x);

SELECT
    CAST(a AS Int32) AS x,
    toTypeName(x)
FROM (
        SELECT materialize(CAST(42 AS Nullable(UInt8))) AS a
    );

SELECT
    CAST(a AS Int32) AS x,
    toTypeName(x)
FROM (
        SELECT materialize(CAST(NULL AS Nullable(UInt8))) AS a
    );