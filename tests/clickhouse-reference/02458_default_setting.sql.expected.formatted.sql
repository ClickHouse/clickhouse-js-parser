SELECT value
FROM `system`.`settings`
WHERE name = 'max_insert_block_size';

SET max_insert_block_size = '100000';

SELECT changed
FROM `system`.`settings`
WHERE name = 'max_insert_block_size';

SET max_insert_block_size = DEFAULT;