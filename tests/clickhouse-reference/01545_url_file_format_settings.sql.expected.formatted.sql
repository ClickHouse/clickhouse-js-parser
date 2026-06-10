-- Tags: no-parallel
SET use_hive_partitioning = '0'; -- required because of "?query=select"

CREATE TABLE file_delim
(
    a int,
    b int
)
ENGINE = File(CSV, '01545_url_file_format_settings.csv')
SETTINGS format_csv_delimiter = '|';

TRUNCATE TABLE file_delim;

INSERT INTO file_delim SELECT
    1,
    2;

-- select 1, 2 format CSV settings format_csv_delimiter='/';
CREATE TABLE url_delim
(
    a int,
    b int
)
ENGINE = URL('http://127.0.0.1:8123/?query=select%201%2C%202%20format%20CSV%20settings%20format_csv_delimiter%3D%27/%27%3B%0A', CSV)
SETTINGS format_csv_delimiter = '/';

SELECT *
FROM file_delim;

SELECT *
FROM url_delim;

SELECT *
FROM file('01545_url_file_format_settings.csv', CSV, 'a int, b int')
SETTINGS format_csv_delimiter = '|';

SELECT *
FROM url('http://127.0.0.1:8123/?query=select%201%2C%202%20format%20CSV%20settings%20format_csv_delimiter%3D%27/%27%3B%0A', CSV, 'a int, b int')
SETTINGS format_csv_delimiter = '/';

DROP TABLE file_delim;

DROP TABLE url_delim;