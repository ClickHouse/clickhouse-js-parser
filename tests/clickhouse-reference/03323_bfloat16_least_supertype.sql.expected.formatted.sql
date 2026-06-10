SELECT if(d = 4, d, 1)
FROM (
        SELECT materialize(CAST('1' AS BFloat16)) AS d
    );