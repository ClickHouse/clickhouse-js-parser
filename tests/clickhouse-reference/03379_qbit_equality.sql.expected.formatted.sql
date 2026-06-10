SELECT CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6)) = CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6));

SELECT CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6)) != CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6));

SELECT CAST('[0, 0, 0, 0, 0, 0]' AS QBit(Float32, 6)) = CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT CAST('[0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 6)) = CAST('[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]' AS QBit(BFloat16, 14)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }