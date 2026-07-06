SELECT CAST([('a', 1), ('b', 2)] AS Map(String, UInt8));

SELECT CAST([('abc', 22), ('def', 33)] AS Map(String, UInt8));

SELECT CAST([(10, [11, 12]), (13, [14, 15])] AS Map(UInt8, Array(UInt8)));

SELECT CAST([('ghj', [('klm', [16, 17])]), ('nop', [('rst', [18])])] AS Map(String, Map(String, Array(UInt8))));

SELECT CAST((('a', 1), ('b', 2)) AS Map(String, UInt8)); -- { serverError TYPE_MISMATCH }

SELECT CAST((('abc', 22), ('def', 33)) AS Map(String, UInt8)); -- { serverError TYPE_MISMATCH }

SELECT CAST(((10, [11, 12]), (13, [14, 15])) AS Map(UInt8, Array(UInt8))); -- { serverError TYPE_MISMATCH }

SELECT CAST((('ghj', ('klm', [16, 17])), ('nop', ('rst', [18]))) AS Map(String, Map(String, Array(UInt8)))); -- { serverError TYPE_MISMATCH }