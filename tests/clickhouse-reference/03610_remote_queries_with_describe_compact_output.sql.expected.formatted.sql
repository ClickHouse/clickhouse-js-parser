SELECT *
FROM remote('127.2', `system`.one)
SETTINGS describe_compact_output = '1';