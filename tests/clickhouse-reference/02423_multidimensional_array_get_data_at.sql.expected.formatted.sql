SELECT formatRow('RawBLOB', [[[33]], []]); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', [[[]], []]); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', [[[[[[[72, 101, 108, 108, 111]]]]]], []]); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', CAST('[]' AS Array(Array(Nothing)))); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', [[], [['Hello']]]); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', [[['World']], []]); -- { serverError NOT_IMPLEMENTED }

SELECT formatRow('RawBLOB', CAST('[]' AS Array(String))); -- { serverError NOT_IMPLEMENTED }