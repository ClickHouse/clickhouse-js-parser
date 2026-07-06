SELECT *
FROM fuzzQuery('SELECT 1', 500, 8956)
LIMIT 0
FORMAT TSVWithNamesAndTypes;

SELECT *
FROM fuzzQuery('SELECT *\nFROM (\n  SELECT\n    ([toString(number % 2)] :: Array(LowCardinality(String))) AS item_id,\n    count()\n  FROM numbers(3)\n  GROUP BY item_id WITH TOTALS\n) AS l FULL JOIN (\n  SELECT\n    ([toString((number % 2) * 2)] :: Array(String)) AS item_id\n  FROM numbers(3)\n) AS r\nON l.item_id = r.item_id\nORDER BY 1,2,3;\n', 500, 8956)
LIMIT 10
FORMAT NULL;