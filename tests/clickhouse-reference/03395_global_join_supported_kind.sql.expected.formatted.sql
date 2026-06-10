SELECT t1.*
FROM
    remote('127.1') AS t1
GLOBAL FULL JOIN remote('127.1') AS t2
    ON t1.dummy = t2.dummy
SETTINGS allow_experimental_analyzer = '1';