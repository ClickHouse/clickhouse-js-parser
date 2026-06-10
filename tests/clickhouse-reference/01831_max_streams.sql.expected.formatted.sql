SELECT *
FROM remote('127.1', `system`.one)
SETTINGS max_distributed_connections = '0';