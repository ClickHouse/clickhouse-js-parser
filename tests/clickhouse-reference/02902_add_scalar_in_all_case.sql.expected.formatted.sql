SELECT count()
FROM format(TSVRaw, (
        SELECT CAST(arrayStringConcat(groupArray('some long string'), '\n') AS LowCardinality(String))
        FROM numbers(10000)
    ))
FORMAT TSVRaw;