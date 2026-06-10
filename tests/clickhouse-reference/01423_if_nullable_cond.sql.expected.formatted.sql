SELECT
    CAST(NULL AS Nullable(UInt8)) = 1 ? CAST(NULL AS Nullable(UInt8)) : -1 AS x,
    toTypeName(x),
    dumpColumnStructure(x);