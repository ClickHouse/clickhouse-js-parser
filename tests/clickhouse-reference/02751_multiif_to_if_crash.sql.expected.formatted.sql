SELECT sum(A)
FROM (
        SELECT multiIf(1, 1, NULL) AS A
    );

SELECT sum(multiIf(number = NULL, 65536, 3))
FROM numbers(3);

SELECT multiIf(NULL, CAST('65536' AS UInt32), CAST('3' AS Int32));