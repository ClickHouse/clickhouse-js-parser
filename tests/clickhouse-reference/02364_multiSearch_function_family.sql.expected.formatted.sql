SET send_logs_level = 'fatal';

SELECT 0 = multiSearchAny('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchAnyCaseInsensitive('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchAnyCaseInsensitiveUTF8('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchAnyUTF8('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstIndex('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstIndexCaseInsensitive('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstIndexCaseInsensitiveUTF8('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstIndexUTF8('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstPosition('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstPositionCaseInsensitive('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstPositionCaseInsensitiveUTF8('\0', CAST([] AS Array(String)));

SELECT 0 = multiSearchFirstPositionUTF8('\0', CAST([] AS Array(String)));

SELECT [] = multiSearchAllPositions('\0', CAST([] AS Array(String)));

SELECT [] = multiSearchAllPositionsCaseInsensitive('\0', CAST([] AS Array(String)));

SELECT [] = multiSearchAllPositionsCaseInsensitiveUTF8('\0', CAST([] AS Array(String)));

SELECT [] = multiSearchAllPositionsUTF8('\0', CAST([] AS Array(String)));

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['b']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bc']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcd']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcde']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdef']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefg']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefgh']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefgh']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefg']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdef']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcde']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcd']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abc']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['ab']);

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['a']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['c']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cd']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cde']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdef']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefg']);

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefgh']);

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defgh']);

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defg']);

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['def']);

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['de']);

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['d']);

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['e']);

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['ef']);

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efg']);

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efgh']);

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fgh']);

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fg']);

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['f']);

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['g']);

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['gh']);

SELECT [8] = multiSearchAllPositions(materialize('abcdefgh'), ['h']);

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['b'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bc'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcd'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcde'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcde'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcd'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abc'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['ab'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['a'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['c'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cd'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cde'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defg'])
FROM `system`.numbers
LIMIT 10;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['def'])
FROM `system`.numbers
LIMIT 10;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['de'])
FROM `system`.numbers
LIMIT 10;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['d'])
FROM `system`.numbers
LIMIT 10;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['e'])
FROM `system`.numbers
LIMIT 10;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['ef'])
FROM `system`.numbers
LIMIT 10;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efg'])
FROM `system`.numbers
LIMIT 10;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fg'])
FROM `system`.numbers
LIMIT 10;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['f'])
FROM `system`.numbers
LIMIT 10;

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['g'])
FROM `system`.numbers
LIMIT 10;

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['gh'])
FROM `system`.numbers
LIMIT 10;

SELECT [8] = multiSearchAllPositions(materialize('abcdefgh'), ['h'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['b'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bc'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcde'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdef'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abcdefgh'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcdef'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcde'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abcd'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['abc'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['ab'])
FROM `system`.numbers
LIMIT 129;

SELECT [1] = multiSearchAllPositions(materialize('abcdefgh'), ['a'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['c'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cd'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cde'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdef'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT [3] = multiSearchAllPositions(materialize('abcdefgh'), ['cdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['defg'])
FROM `system`.numbers
LIMIT 129;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['def'])
FROM `system`.numbers
LIMIT 129;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['de'])
FROM `system`.numbers
LIMIT 129;

SELECT [4] = multiSearchAllPositions(materialize('abcdefgh'), ['d'])
FROM `system`.numbers
LIMIT 129;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['e'])
FROM `system`.numbers
LIMIT 129;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['ef'])
FROM `system`.numbers
LIMIT 129;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efg'])
FROM `system`.numbers
LIMIT 129;

SELECT [5] = multiSearchAllPositions(materialize('abcdefgh'), ['efgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fgh'])
FROM `system`.numbers
LIMIT 129;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['fg'])
FROM `system`.numbers
LIMIT 129;

SELECT [6] = multiSearchAllPositions(materialize('abcdefgh'), ['f'])
FROM `system`.numbers
LIMIT 129;

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['g'])
FROM `system`.numbers
LIMIT 129;

SELECT [7] = multiSearchAllPositions(materialize('abcdefgh'), ['gh'])
FROM `system`.numbers
LIMIT 129;

SELECT [8] = multiSearchAllPositions(materialize('abcdefgh'), ['h'])
FROM `system`.numbers
LIMIT 129;

SELECT [2] = multiSearchAllPositions(materialize('abc'), ['b']);

SELECT [2] = multiSearchAllPositions(materialize('abc'), ['bc']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcde']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdef']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdefg']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdefgh']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcdefg']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcdef']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcde']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcd']);

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['abc']);

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['ab']);

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['a']);

SELECT [3] = multiSearchAllPositions(materialize('abcd'), ['c']);

SELECT [3] = multiSearchAllPositions(materialize('abcd'), ['cd']);

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cde']);

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdef']);

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdefg']);

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdefgh']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['defgh']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['defg']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['def']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['de']);

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['d']);

SELECT [2] = multiSearchAllPositions(materialize('abc'), ['b'])
FROM `system`.numbers
LIMIT 10;

SELECT [2] = multiSearchAllPositions(materialize('abc'), ['bc'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcde'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcde'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['abcd'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['abc'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['ab'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['a'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcd'), ['c'])
FROM `system`.numbers
LIMIT 10;

SELECT [3] = multiSearchAllPositions(materialize('abcd'), ['cd'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cde'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdef'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abcd'), ['cdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['defgh'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['defg'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['def'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['de'])
FROM `system`.numbers
LIMIT 10;

SELECT [0] = multiSearchAllPositions(materialize('abc'), ['d'])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abc'), ['']);

SELECT [1] = multiSearchAllPositions(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 100;

SELECT [1] = multiSearchAllPositions(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 1000;

SELECT [1] = multiSearchAllPositions(materialize('abab'), ['ab']);

SELECT [1] = multiSearchAllPositions(materialize('abababababababababababab'), ['abab']);

SELECT [1] = multiSearchAllPositions(materialize('abababababababababababab'), ['abababababababababa']);

SELECT [1] = multiSearchAllPositions(materialize('abc'), materialize(['']));

SELECT [1] = multiSearchAllPositions(materialize('abc'), materialize(['']))
FROM `system`.numbers
LIMIT 10;

SELECT [1] = multiSearchAllPositions(materialize('abab'), materialize(['ab']));

SELECT [2] = multiSearchAllPositions(materialize('abab'), materialize(['ba']));

SELECT [1] = multiSearchAllPositionsCaseInsensitive(materialize('aBaB'), materialize(['abab']));

SELECT [3] = multiSearchAllPositionsUTF8(materialize('ab€ab'), materialize(['€']));

SELECT [3] = multiSearchAllPositionsCaseInsensitiveUTF8(materialize('ab€AB'), materialize(['€ab']));

-- checks the correct handling of broken utf-8 sequence
SELECT [0] = multiSearchAllPositionsCaseInsensitiveUTF8(materialize(''), materialize(['a������']));

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['b']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bc']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcd']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcde']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdef']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdef']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcde']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcd']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abc']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ab']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['a']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['c']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cd']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cde']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdef']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['def']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['de']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['d']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['e']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ef']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fgh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fg']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['f']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['g']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['gh']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['h']);

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['b'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bc'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcde'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcde'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abc'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ab'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['a'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['c'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cde'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['def'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['de'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['d'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['e'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ef'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fg'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['f'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['g'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['gh'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['h'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['b'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bc'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcde'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdef'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcdef'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcde'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abcd'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['abc'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ab'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['a'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['c'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cd'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cde'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdef'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['cdefgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['defg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['def'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['de'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['d'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['e'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['ef'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['efgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fgh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['fg'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['f'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['g'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['gh'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abcdefgh'), ['h'])
FROM `system`.numbers
LIMIT 129;

SELECT 1 = multiSearchAny(materialize('abc'), ['b']);

SELECT 1 = multiSearchAny(materialize('abc'), ['bc']);

SELECT 0 = multiSearchAny(materialize('abc'), ['bcde']);

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdef']);

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdefg']);

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdefgh']);

SELECT 0 = multiSearchAny(materialize('abc'), ['abcdefg']);

SELECT 0 = multiSearchAny(materialize('abc'), ['abcdef']);

SELECT 0 = multiSearchAny(materialize('abc'), ['abcde']);

SELECT 0 = multiSearchAny(materialize('abc'), ['abcd']);

SELECT 1 = multiSearchAny(materialize('abc'), ['abc']);

SELECT 1 = multiSearchAny(materialize('abc'), ['ab']);

SELECT 1 = multiSearchAny(materialize('abc'), ['a']);

SELECT 1 = multiSearchAny(materialize('abcd'), ['c']);

SELECT 1 = multiSearchAny(materialize('abcd'), ['cd']);

SELECT 0 = multiSearchAny(materialize('abcd'), ['cde']);

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdef']);

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdefg']);

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdefgh']);

SELECT 0 = multiSearchAny(materialize('abc'), ['defgh']);

SELECT 0 = multiSearchAny(materialize('abc'), ['defg']);

SELECT 0 = multiSearchAny(materialize('abc'), ['def']);

SELECT 0 = multiSearchAny(materialize('abc'), ['de']);

SELECT 0 = multiSearchAny(materialize('abc'), ['d']);

SELECT 1 = multiSearchAny(materialize('abc'), ['b'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), ['bc'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['bcde'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['bcdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['abcdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['abcdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['abcde'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['abcd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), ['abc'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), ['ab'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), ['a'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcd'), ['c'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abcd'), ['cd'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abcd'), ['cde'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdef'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdefg'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abcd'), ['cdefgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['defgh'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['defg'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['def'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['de'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchAny(materialize('abc'), ['d'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), ['']);

SELECT 1 = multiSearchAny(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchAny(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 100;

SELECT 1 = multiSearchAny(materialize('abc'), [''])
FROM `system`.numbers
LIMIT 1000;

SELECT 1 = multiSearchAny(materialize('abab'), ['ab']);

SELECT 1 = multiSearchAny(materialize('abababababababababababab'), ['abab']);

SELECT 1 = multiSearchAny(materialize('abababababababababababab'), ['abababababababababa']);

SELECT 0 = multiSearchFirstPosition(materialize('abcdefgh'), ['z', 'pq'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPosition(materialize('abcdefgh'), ['a', 'b', 'c', 'd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPosition(materialize('abcdefgh'), ['defgh', 'bcd', 'abcd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPosition(materialize('abcdefgh'), ['', 'bcd', 'bcd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 2 = multiSearchFirstPosition(materialize('abcdefgh'), ['something', 'bcd', 'bcd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 6 = multiSearchFirstPosition(materialize('abcdefgh'), ['something', 'bcdz', 'fgh', 'f'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchFirstPositionCaseInsensitive(materialize('abcdefgh'), ['z', 'pq'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitive(materialize('aBcdefgh'), ['A', 'b', 'c', 'd'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitive(materialize('abCDefgh'), ['defgh', 'bcd', 'aBCd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitive(materialize('abCdeFgH'), ['', 'bcd', 'bcd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 2 = multiSearchFirstPositionCaseInsensitive(materialize('ABCDEFGH'), ['something', 'bcd', 'bcd', 'c'])
FROM `system`.numbers
LIMIT 10;

SELECT 6 = multiSearchFirstPositionCaseInsensitive(materialize('abcdefgh'), ['sOmEthIng', 'bcdZ', 'fGh', 'F'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['л', 'ъ'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['а', 'б', 'в', 'г'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['гдежз', 'бвг', 'абвг', 'вг'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['', 'бвг', 'бвг', 'в'])
FROM `system`.numbers
LIMIT 10;

SELECT 2 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['что', 'в', 'гдз', 'бвг'])
FROM `system`.numbers
LIMIT 10;

SELECT 6 = multiSearchFirstPositionUTF8(materialize('абвгдежз'), ['з', 'бвгя', 'ежз', 'з'])
FROM `system`.numbers
LIMIT 10;

SELECT 0 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежз'), ['Л', 'Ъ'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежз'), ['А', 'б', 'в', 'г'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежз'), ['гДеЖз', 'бВг', 'АБВг', 'вг'])
FROM `system`.numbers
LIMIT 10;

SELECT 1 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежз'), ['', 'бвг', 'Бвг', 'в'])
FROM `system`.numbers
LIMIT 10;

SELECT 2 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежз'), ['что', 'в', 'гдз', 'бвг'])
FROM `system`.numbers
LIMIT 10;

SELECT 6 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('аБвгДежЗ'), ['З', 'бвгЯ', 'ЕЖз', 'з'])
FROM `system`.numbers
LIMIT 10;

SELECT [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] = multiSearchAllPositions(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']);

SELECT 254 = multiSearchFirstIndex(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']);

SELECT [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] = multiSearchAllPositions(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']);

SELECT 255 = multiSearchFirstIndex(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']);

SELECT multiSearchAllPositions(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT multiSearchFirstIndex(materialize('string'), ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'str']); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }