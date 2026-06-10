SELECT CAST((
        SELECT groupArray(number + 0.1)
        FROM numbers(2)
    ) AS QBit(Float64, 2));

SELECT *
FROM format('Values', 'qbit QBit(Float64, 2)', '(array(0.1,1.1))');

SELECT CAST((
        SELECT groupArray(number + 0.1)
        FROM numbers(2)
    ) AS QBit(Float32, 2));

SELECT *
FROM format('Values', 'qbit QBit(Float32, 2)', '(array(0.1,1.1))');

SELECT CAST((
        SELECT groupArray(number + 0.1)
        FROM numbers(2)
    ) AS QBit(BFloat16, 2));

SELECT *
FROM format('Values', 'qbit QBit(BFloat16, 2)', '(array(0.1,1.1))');

SELECT *
FROM format('Values', 'qbit QBit(BFloat16, 3)', '(tuple([1,2,3]::QBit(BFloat16, 3).1,\n                                                                 [1,2,3]::QBit(BFloat16, 3).2,\n                                                                 [1,2,3]::QBit(BFloat16, 3).3,\n                                                                 [1,2,3]::QBit(BFloat16, 3).4,\n                                                                 [1,2,3]::QBit(BFloat16, 3).5,\n                                                                 [1,2,3]::QBit(BFloat16, 3).6,\n                                                                 [1,2,3]::QBit(BFloat16, 3).7,\n                                                                 [1,2,3]::QBit(BFloat16, 3).8,\n                                                                 [1,2,3]::QBit(BFloat16, 3).9,\n                                                                 [1,2,3]::QBit(BFloat16, 3).10,\n                                                                 [1,2,3]::QBit(BFloat16, 3).11,\n                                                                 [1,2,3]::QBit(BFloat16, 3).12,\n                                                                 [1,2,3]::QBit(BFloat16, 3).13,\n                                                                 [1,2,3]::QBit(BFloat16, 3).14,\n                                                                 [1,2,3]::QBit(BFloat16, 3).15,\n                                                                 [1,2,3]::QBit(BFloat16, 3).16))');

SELECT *
FROM format('Values', 'qbit QBit(BFloat16, 3)', '(tuple([1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).1,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).2,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).3,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).4,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).5,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).6,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).7,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).8,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).9,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).10,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).11,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).12,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).13,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).14,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).15,\n                                                                 [1,2,3,4,5,6,7,8,9]::QBit(BFloat16, 9).16))'); -- { serverError TYPE_MISMATCH }

SELECT *
FROM format('Values', 'qbit QBit(BFloat16, 9)', '(tuple([1,2,3]::QBit(BFloat16, 3).1))'); -- { serverError TYPE_MISMATCH }

SELECT L2DistanceTransposed(CAST('[1,2,3]' AS QBit(Float64, 3)), CAST('[1,2,3]' AS Array(Float64)), 3)
SETTINGS enable_analyzer = '0';

SELECT L2DistanceTransposed(CAST('[1,2,3]' AS QBit(Float64, 3)), CAST('[1,2,3]' AS Array(Float64)), 3)
SETTINGS enable_analyzer = '1';

SELECT L2DistanceTransposed(materialize(CAST('[1,2,3]' AS QBit(Float64, 3))), CAST('[1,2,3]' AS Array(Float64)), 3)
SETTINGS enable_analyzer = '0';

SELECT L2DistanceTransposed(materialize(CAST('[1,2,3]' AS QBit(Float64, 3))), CAST('[1,2,3]' AS Array(Float64)), 3)
SETTINGS enable_analyzer = '1';

SELECT bin(CAST([0.1, 0.2] AS QBit(Float64, 2)).1) AS tuple_result;

SELECT bin(CAST([0.1, 0.2] AS QBit(Float64, 2)).2) AS tuple_result;

SELECT bin(CAST([0.1, 0.2] AS QBit(Float64, 2)).3) AS tuple_result;