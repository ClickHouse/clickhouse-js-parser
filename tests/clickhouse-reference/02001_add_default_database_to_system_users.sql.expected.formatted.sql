-- Tags: no-parallel
-- Tag no-parallel: create user
CREATE USER IF NOT EXISTS u_02001 DEFAULT DATABASE `system`;

SELECT default_database
FROM `system`.users
WHERE name = 'u_02001';

DROP USER IF EXISTS u_02001;