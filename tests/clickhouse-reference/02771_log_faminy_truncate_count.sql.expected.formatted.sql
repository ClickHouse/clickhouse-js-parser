DROP TABLE IF EXISTS test_log;

CREATE TABLE test_log
(
    crypto_name String,
    trade_date Date
)
ENGINE = Log();

INSERT INTO test_log (crypto_name, trade_date);

TRUNCATE TABLE test_log;

SELECT count()
FROM test_log;

CREATE TABLE test_log
(
    crypto_name String,
    trade_date Date
)
ENGINE = StripeLog();

DROP TABLE test_log;