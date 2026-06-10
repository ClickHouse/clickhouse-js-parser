SELECT number >= 0
    AND if(number != 0, intDiv(1, number), 1)
FROM numbers(5);

SELECT if(number >= 0, if(number != 0, intDiv(1, number), 1), 1)
FROM numbers(5);

SELECT number >= 0
    AND if(number = 0, 0, if(number = 1, intDiv(1, number), if(number = 2, intDiv(1, number - 1), if(number = 3, intDiv(1, number - 2), intDiv(1, number - 3)))))
FROM numbers(10);