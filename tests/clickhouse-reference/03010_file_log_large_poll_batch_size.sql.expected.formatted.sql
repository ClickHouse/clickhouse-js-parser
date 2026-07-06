CREATE TABLE test
(
    number UInt64
)
ENGINE = FileLog('./user_files/data.jsonl', 'JSONEachRow')
SETTINGS poll_max_batch_size = '18446744073709'; -- {serverError INVALID_SETTING_VALUE}