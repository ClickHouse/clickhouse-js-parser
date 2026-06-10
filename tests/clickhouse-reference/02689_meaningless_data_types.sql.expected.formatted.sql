SELECT CAST('0' AS Bool(Upyachka)); -- { serverError DATA_TYPE_CANNOT_HAVE_ARGUMENTS }

SELECT CAST('[(1, 2), (3, 4)]' AS Ring(Upyachka)); -- { serverError DATA_TYPE_CANNOT_HAVE_ARGUMENTS }

SELECT '1.1.1.1'::IPv4('Hello, world!'); -- { serverError DATA_TYPE_CANNOT_HAVE_ARGUMENTS }