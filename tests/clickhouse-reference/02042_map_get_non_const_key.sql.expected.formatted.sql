SELECT map[key]
FROM (
        SELECT
            materialize('key') AS key,
            CAST((['key'], ['value']) AS Map(String, String)) AS map
    );