SELECT 'aaaabb ' = trimLeft('b aaaabb ', 'b ') AS x;

SELECT 'b aaaa' = trimRight('b aaaabb ', 'b ') AS x;

SELECT 'aaaa' = trimBoth('b aaaabb ', 'b ') AS x;

SELECT '1' = replaceRegexpAll(',,1,,', '^[,]*|[,]*$', '') AS x;

SELECT '1' = replaceRegexpAll(',,1', '^[,]*|[,]*$', '') AS x;

SELECT '1' = replaceRegexpAll('1,,', '^[,]*|[,]*$', '') AS x;

SELECT '1,,' = replaceRegexpOne(',,1,,', '^[,]*|[,]*$', '') AS x;

SELECT '1' = replaceRegexpOne(',,1', '^[,]*|[,]*$', '') AS x;

SELECT '1,,' = replaceRegexpOne('1,,', '^[,]*|[,]*$', '') AS x;

SELECT '5935,5998,6014' = trimBoth('5935,5998,6014, ', ', ') AS x;

SELECT '5935,5998,6014' = replaceRegexpAll('5935,5998,6014, ', concat('^[', regexpQuoteMeta(', '), ']*|[', regexpQuoteMeta(', '), ']*$'), '') AS x;

SELECT trimBoth('2', '"') = '2';