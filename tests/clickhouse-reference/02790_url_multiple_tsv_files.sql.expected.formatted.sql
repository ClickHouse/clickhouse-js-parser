SELECT sum(*)
FROM (
        SELECT *
        FROM url('http://127.0.0.1:8123?query=select+{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}+as+x+format+TSV', 'TSV')
        SETTINGS
            max_threads = '1',
            max_download_threads = '1'
    );

SELECT sum(*)
FROM (
        SELECT *
        FROM url('http://127.0.0.1:8123?query=select+{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}+as+x+format+CSV', 'CSV')
        SETTINGS
            max_threads = '1',
            max_download_threads = '1'
    );

SELECT sum(*)
FROM (
        SELECT *
        FROM url('http://127.0.0.1:8123?query=select+{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}+as+x+format+JSONEachRow', 'JSONEachRow')
        SETTINGS
            max_threads = '1',
            max_download_threads = '1'
    );

SELECT sum(*)
FROM (
        SELECT *
        FROM url('http://127.0.0.1:8123?query=select+{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}+as+x+format+TSKV', 'TSKV')
        SETTINGS
            max_threads = '1',
            max_download_threads = '1'
    );

SELECT sum(*)
FROM (
        SELECT *
        FROM url('http://127.0.0.1:8123?query=select+{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}+as+x+format+Native', 'Native')
        SETTINGS
            max_threads = '1',
            max_download_threads = '1'
    );