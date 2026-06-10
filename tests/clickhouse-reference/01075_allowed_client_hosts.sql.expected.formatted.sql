-- Tags: no-fasttest, no-parallel
DROP USER IF EXISTS test_user_01075, test_user_01075_x, `test_user_01075_x@localhost`, `test_user_01075_x@192.168.23.15`;

CREATE USER test_user_01075;

SHOW CREATE USER test_user_01075;

ALTER USER test_user_01075 HOST ANY;

ALTER USER test_user_01075 HOST NONE;

ALTER USER test_user_01075 HOST LOCAL;

ALTER USER test_user_01075 HOST IP '192.168.23.15';

ALTER USER test_user_01075 HOST IP '2001:db8:11a3:9d7:1f34:8a2e:7a0:765d';

ALTER USER test_user_01075 ADD HOST LOCAL;

ALTER USER test_user_01075 DROP HOST IP '2001:db8:11a3:9d7:1f34:8a2e:7a0:765d';

ALTER USER test_user_01075 DROP HOST LOCAL;

ALTER USER test_user_01075 HOST LIKE '@.somesite.com';

ALTER USER test_user_01075 HOST REGEXP '.*\.anothersite\.com';

ALTER USER test_user_01075 HOST REGEXP '.*\.anothersite\.com', REGEXP '.*\.anothersite\.org';

ALTER USER test_user_01075 HOST REGEXP '.*\.anothersite2\.com', REGEXP '.*\.anothersite2\.org';

ALTER USER test_user_01075 HOST REGEXP '.*\.anothersite3\.com', REGEXP '.*\.anothersite3\.org';

DROP USER test_user_01075;

CREATE USER test_user_01075_x@'localhost' HOST LOCAL;

SHOW CREATE USER `test_user_01075_x@localhost`;

ALTER USER test_user_01075_x@'localhost' RENAME TO test_user_01075_x;

SHOW CREATE USER test_user_01075_x;

ALTER USER test_user_01075_x RENAME TO `test_user_01075_x@192.168.23.15`;

SHOW CREATE USER `test_user_01075_x@192.168.23.15`;

DROP USER `test_user_01075_x@192.168.23.15`;