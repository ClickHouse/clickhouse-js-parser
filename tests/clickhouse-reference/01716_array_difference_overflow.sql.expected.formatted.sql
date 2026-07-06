-- Overflow is Ok and behaves as the CPU does it.
SELECT arrayDifference([65536, -9223372036854775808]);

-- Diff of unsigned int -> int
SELECT arrayDifference(CAST([10, 1] AS Array(UInt8)));

SELECT arrayDifference(CAST([10, 1] AS Array(UInt16)));

SELECT arrayDifference(CAST([10, 1] AS Array(UInt32)));

SELECT arrayDifference(CAST([10, 1] AS Array(UInt64)));