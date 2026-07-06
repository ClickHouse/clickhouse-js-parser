SET count_matches_stop_at_empty_match = '0';

SELECT countMatches('', 'foo');

SELECT countMatches('foo', '');

-- simply stop if zero bytes was processed
SELECT countMatches('foo', '[f]{0}');

-- but this is ok
SELECT countMatches('foo', '[f]{0}foo');

SELECT countMatches('foobarfoo', 'foo');

SELECT countMatches('foobarfoo', 'foo.*');

SELECT countMatches('oooo', 'oo');

SELECT countMatches(concat(toString(number), 'foofoo'), 'foo')
FROM numbers(2);

SELECT countMatches('foobarbazfoobarbaz', 'foo(bar)(?:baz|)');

SELECT countMatches('foo.com bar.com baz.com bam.com', '([^. ]+)\\.([^. ]+)');

SELECT countMatches('foo.com@foo.com bar.com@foo.com baz.com@foo.com bam.com@foo.com', '([^. ]+)\\.([^. ]+)@([^. ]+)\\.([^. ]+)');

SELECT countMatches(materialize('foobarfoo'), 'foo');

SELECT countMatchesCaseInsensitive('foobarfoo', 'FOo');

SELECT countMatchesCaseInsensitive('foobarfoo', 'FOo.*');

SELECT countMatchesCaseInsensitive('oooo', 'Oo');

SELECT countMatchesCaseInsensitive(concat(toString(number), 'Foofoo'), 'foo')
FROM numbers(2);

SELECT countMatchesCaseInsensitive('foOBarBAZfoobarbaz', 'foo(bar)(?:baz|)');

SELECT countMatchesCaseInsensitive('foo.com BAR.COM baz.com bam.com', '([^. ]+)\\.([^. ]+)');

SELECT countMatchesCaseInsensitive('foo.com@foo.com bar.com@foo.com BAZ.com@foo.com bam.com@foo.com', '([^. ]+)\\.([^. ]+)@([^. ]+)\\.([^. ]+)');

SELECT countMatchesCaseInsensitive(materialize('foobarfoo'), 'FOo');

SELECT countMatches(1, 'foo')
FROM numbers(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT countMatches('foobarfoo', toString(number))
FROM numbers(1); -- { serverError ILLEGAL_COLUMN }

SELECT countMatches('foo', materialize('foo')); -- { serverError ILLEGAL_COLUMN }

SELECT countMatches(toFixedString('foobarfoo', 9), 'foo');

SELECT countMatches(materialize(toFixedString('foobarfoo', 9)), 'foo');

SELECT countMatches('  foo bar   ', '[a-zA-Z]*');

SELECT countMatches(toFixedString('  foo bar   ', 12), '[a-zA-Z]*');

SELECT countMatches(materialize(toFixedString('  foo bar   ', 12)), '[a-zA-Z]*');

SET count_matches_stop_at_empty_match = '1';

SELECT countMatches('foo bar   ', '[a-zA-Z]*');

SELECT countMatches(toFixedString('foo bar   ', 12), '[a-zA-Z]*');

SELECT countMatches(materialize(toFixedString('foo bar   ', 12)), '[a-zA-Z]*');