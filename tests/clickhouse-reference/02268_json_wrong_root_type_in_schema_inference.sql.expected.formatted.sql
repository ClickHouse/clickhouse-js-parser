INSERT INTO FUNCTION file(currentDatabase() || '_02268_data.jsonl', 'TSV') SELECT 1;

SELECT *
FROM file(currentDatabase() || '_02268_data.jsonl'); --{serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO FUNCTION file(currentDatabase() || '_02268_data.jsonCompactEachRow', 'TSV') SELECT 1;

SELECT *
FROM file(currentDatabase() || '_02268_data.jsonCompactEachRow'); --{serverError CANNOT_EXTRACT_TABLE_STRUCTURE}