SELECT [true, false]::Array(FixedString(5));

SELECT arrayMap((x -> x::FixedString(5)), [true, false]);

SELECT [false, true]::Array(FixedString(5));