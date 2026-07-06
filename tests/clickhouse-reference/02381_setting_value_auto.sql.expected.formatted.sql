SELECT
    value,
    changed,
    type
FROM `system`.`settings`
WHERE name = 'insert_quorum';

SET insert_quorum = 'auto';

SET insert_quorum = '0';

SET insert_quorum = '1';