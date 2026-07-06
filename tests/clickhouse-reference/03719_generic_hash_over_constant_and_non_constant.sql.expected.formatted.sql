SELECT sipHash64(number, CAST('42' AS Variant(UInt64, String)))
FROM numbers(2);