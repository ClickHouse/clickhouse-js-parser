SELECT if(materialize(0), extract(materialize(CAST('aaaaaa' AS LowCardinality(String))), '\\w'), extract(materialize(CAST('bbbbb' AS LowCardinality(String))), '\\w*')) AS res
FROM numbers(2);