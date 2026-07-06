SELECT 'aяb' LIKE 'a_b';

SELECT 'a\0b' LIKE 'a_b';

SELECT 'a\0b' LIKE 'a\0b';

SELECT 'a\0b' LIKE 'a%\0b';

SELECT 'a�b' LIKE 'a%�b';

SELECT 'a�b' LIKE 'a%��b';

SELECT 'a�b' LIKE '%a��b';

SELECT 'a��b' LIKE '%a��b';

SELECT materialize('aяb') LIKE 'a_b';

SELECT materialize('a\0b') LIKE 'a_b';

SELECT materialize('a\0b') LIKE 'a\0b';

SELECT materialize('a\0b') LIKE 'a%\0b';

SELECT materialize('a�b') LIKE 'a%�b';

SELECT materialize('a�b') LIKE 'a%��b';

SELECT materialize('a�b') LIKE '%a��b';

SELECT materialize('a��b') LIKE '%a��b';

SELECT materialize('aяb') LIKE materialize('a_b');

SELECT materialize('a\0b') LIKE materialize('a_b');

SELECT materialize('a\0b') LIKE materialize('a\0b');

SELECT materialize('a\0b') LIKE materialize('a%\0b');

SELECT materialize('a�b') LIKE materialize('a%�b');

SELECT materialize('a�b') LIKE materialize('a%��b');

SELECT materialize('a�b') LIKE materialize('%a��b');

SELECT materialize('a��b') LIKE materialize('%a��b');