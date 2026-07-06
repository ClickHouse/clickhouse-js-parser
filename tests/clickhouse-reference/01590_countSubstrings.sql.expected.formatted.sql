SELECT countSubstrings('', '.');

SELECT countSubstrings('', '');

SELECT countSubstrings('.', '');

SELECT countSubstrings(toString(number), '')
FROM numbers(1);

SELECT countSubstrings('', toString(number))
FROM numbers(1);

SELECT countSubstrings('aaa', materialize(''));

SELECT countSubstrings(materialize('aaa'), '');

SELECT countSubstrings(materialize('aaa'), materialize(''));

SELECT countSubstrings('foobar.com', '.');

SELECT countSubstrings('www.foobar.com', '.');

SELECT countSubstrings('.foobar.com.', '.');

SELECT countSubstrings('foobar.com', 'com');

SELECT countSubstrings('com.foobar', 'com');

SELECT countSubstrings('foo.com.bar', 'com');

SELECT countSubstrings('com.foobar.com', 'com');

SELECT countSubstrings('com.foo.com.bar.com', 'com');

SELECT countSubstrings('aaaa', 'aa');

SELECT countSubstrings(toString(number), toString(number))
FROM numbers(1);

SELECT countSubstrings(concat(toString(number), '000111'), toString(number))
FROM numbers(1);

SELECT countSubstrings(concat(toString(number), '000111001'), toString(number))
FROM numbers(1);

SELECT
    'intersect',
    countSubstrings(concat(toString(number), '0000000'), '00')
FROM numbers(1)
FORMAT CSV;

SELECT countSubstrings('100', toString(number))
FROM numbers(3);

SELECT countSubstrings('0100', toString(number))
FROM numbers(1);

SELECT countSubstrings('010000', toString(number))
FROM numbers(1);

SELECT
    'intersect',
    countSubstrings('00000000', repeat(toString(number), 2))
FROM numbers(1)
FORMAT CSV;

SELECT countSubstrings(toString(number), '1')
FROM `system`.numbers
LIMIT 3
OFFSET 9;

SELECT countSubstrings(concat(toString(number), '000111'), '1')
FROM numbers(1);

SELECT countSubstrings(concat(toString(number), '000111001'), '1')
FROM numbers(1);

SELECT
    'intersect',
    countSubstrings(repeat(toString(number), 8), '00')
FROM numbers(1)
FORMAT CSV;

SELECT countSubstringsCaseInsensitive('aba', 'B');

SELECT countSubstringsCaseInsensitive('bab', 'B');

SELECT countSubstringsCaseInsensitive('BaBaB', 'b');

SELECT countSubstringsCaseInsensitive('foobar.com', 'COM');

SELECT countSubstringsCaseInsensitive('com.foobar', 'COM');

SELECT countSubstringsCaseInsensitive('foo.com.bar', 'COM');

SELECT countSubstringsCaseInsensitive('com.foobar.com', 'COM');

SELECT countSubstringsCaseInsensitive('com.foo.com.bar.com', 'COM');

SELECT countSubstringsCaseInsensitive('aaaa', 'AA');

SELECT countSubstringsCaseInsensitive(upper(char(number)), lower(char(number)))
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitive(concat(toString(number), 'aaa111'), char(number))
FROM numbers(100)
WHERE number = 65;

SELECT countSubstringsCaseInsensitive(concat(toString(number), 'aaa111aa1'), char(number))
FROM numbers(100)
WHERE number = 65;

SELECT countSubstringsCaseInsensitive('aab', char(number))
FROM numbers(100)
WHERE number >= 65
    AND number <= 67; -- A..C

SELECT countSubstringsCaseInsensitive('abaa', char(number))
FROM numbers(100)
WHERE number = 65;

SELECT countSubstringsCaseInsensitive('abaaaa', char(number))
FROM numbers(100)
WHERE number = 65;

SELECT countSubstringsCaseInsensitive(char(number), 'a')
FROM numbers(100)
WHERE number >= 65
    AND number <= 67;

SELECT countSubstringsCaseInsensitiveUTF8('фуу', 'Ф');

SELECT countSubstringsCaseInsensitiveUTF8('ФуФ', 'ф');

SELECT countSubstringsCaseInsensitiveUTF8('ФуФуФ', 'ф');

SELECT countSubstringsCaseInsensitiveUTF8('подстрока.рф', 'РФ');

SELECT countSubstringsCaseInsensitiveUTF8('рф.подстрока', 'рф');

SELECT countSubstringsCaseInsensitiveUTF8('подстрока.рф.подстрока', 'РФ');

SELECT countSubstringsCaseInsensitiveUTF8('рф.подстрока.рф', 'рф');

SELECT countSubstringsCaseInsensitiveUTF8('рф.подстрока.рф.подстрока.рф', 'РФ');

SELECT countSubstringsCaseInsensitiveUTF8('яяяя', 'ЯЯ');

-- can't use any char, since this will not make valid UTF8
-- for the haystack we use number as-is, for needle we just add dependency from number to go to vectorVector code
SELECT countSubstringsCaseInsensitiveUTF8(upperUTF8(concat(char(number), 'я')), lowerUTF8(concat(substringUTF8(char(number), 2), 'Я')))
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitiveUTF8(concat(toString(number), 'ЯЯЯ111'), concat(substringUTF8(char(number), 2), 'я'))
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitiveUTF8(concat(toString(number), 'яяя111яя1'), concat(substringUTF8(char(number), 2), 'Я'))
FROM numbers(100)
WHERE number = 65; -- A

SELECT
    'intersect',
    countSubstringsCaseInsensitiveUTF8(concat(toString(number), 'яяяяяяяя'), concat(substringUTF8(char(number), 2), 'Яя'))
FROM numbers(100)
WHERE number = 65
FORMAT CSV; -- A

SELECT countSubstringsCaseInsensitiveUTF8('ЯЯb', concat(substringUTF8(char(number), 2), 'я'))
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitiveUTF8('ЯbЯЯ', concat(substringUTF8(char(number), 2), 'я'))
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitiveUTF8('ЯbЯЯЯЯ', concat(substringUTF8(char(number), 2), 'я'))
FROM numbers(100)
WHERE number = 65; -- A

SELECT
    'intersect',
    countSubstringsCaseInsensitiveUTF8('ЯЯЯЯЯЯЯЯ', concat(substringUTF8(char(number), 2), 'Яя'))
FROM numbers(100)
WHERE number = 65
FORMAT CSV; -- A

SELECT countSubstringsCaseInsensitiveUTF8(concat(char(number), 'я'), 'Я')
FROM numbers(100)
WHERE number = 65; -- A

SELECT countSubstringsCaseInsensitiveUTF8(concat(char(number), 'б'), 'Я')
FROM numbers(100)
WHERE number = 65; -- A

SELECT
    'intersect',
    countSubstringsCaseInsensitiveUTF8(concat(char(number), repeat('я', 8)), 'яЯ')
FROM numbers(100)
WHERE number = 65
FORMAT CSV; -- A