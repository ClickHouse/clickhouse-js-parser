WITH (
        SELECT count() > 0
        FROM remote('127.2', `system`.`settings`)
    ) AS s

SELECT s;

-- nested
WITH (
        SELECT count() > 0
        FROM remote('127.2', remote('127.2', `system`.`settings`))
    ) AS s

SELECT s;

-- nested via view()
WITH (
        SELECT count() > 0
        FROM remote('127.2', view(            SELECT count()
            FROM remote('127.2', `system`.`settings`)))
    ) AS s

SELECT s;