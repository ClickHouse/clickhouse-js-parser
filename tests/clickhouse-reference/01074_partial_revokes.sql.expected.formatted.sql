-- Tags: no-parallel
DROP USER IF EXISTS test_user_01074;

CREATE USER test_user_01074;

SELECT '--simple 1';

GRANT SELECT ON *.* TO test_user_01074;

REVOKE SELECT ON db.* FROM test_user_01074;

SHOW GRANTS FOR test_user_01074;

REVOKE SELECT ON *.* FROM test_user_01074;

GRANT SELECT ON db.* TO test_user_01074;

REVOKE SELECT ON db.table FROM test_user_01074;

GRANT SELECT ON db.table TO test_user_01074;

REVOKE SELECT(col1) ON db.table FROM test_user_01074;

REVOKE SELECT(col1, col2) ON db.table FROM test_user_01074;

SELECT *
FROM `system`.grants
WHERE user_name = 'test_user_01074'
SETTINGS output_format_pretty_color = '1'
FORMAT Pretty;

GRANT SELECT ON *.* TO test_user_01074 WITH GRANT OPTION;

REVOKE GRANT OPTION FOR SELECT(col1) ON db.table FROM test_user_01074;

GRANT SELECT ON db.* TO test_user_01074 WITH GRANT OPTION;

DROP USER test_user_01074;