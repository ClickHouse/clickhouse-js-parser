SELECT now() + CAST('1' AS Int128); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() + CAST('1' AS Int256); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() + CAST('1' AS UInt128); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() + CAST('1' AS UInt256); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() - CAST('1' AS Int128); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() - CAST('1' AS Int256); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() - CAST('1' AS UInt128); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() - CAST('1' AS UInt256); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT now() + toIntervalSecond(CAST('1' AS Int128)) - now();

SELECT now() + toIntervalSecond(CAST('1' AS Int256)) - now();

SELECT now() + toIntervalSecond(CAST('1' AS UInt128)) - now();

SELECT now() + toIntervalSecond(CAST('1' AS UInt256)) - now();

SELECT today() + toIntervalDay(CAST('1' AS Int128)) - today();

SELECT today() + toIntervalDay(CAST('1' AS Int256)) - today();

SELECT today() + toIntervalDay(CAST('1' AS UInt128)) - today();

SELECT today() + toIntervalDay(CAST('1' AS UInt256)) - today();