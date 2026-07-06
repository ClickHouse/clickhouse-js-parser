-- Tags: no-parallel
-- Do not run this test in parallel because `all` workload might affect other queries execution process
-- Test simple resource and workload hierarchy creation
CREATE RESOURCE `03232_write` (write disk `03232_fake_disk`);

CREATE RESOURCE `03232_read` (read disk `03232_fake_disk`);

CREATE WORKLOAD `all` SETTINGS max_io_requests = 100 FOR `03232_write`, max_io_requests = 200 FOR `03232_read`;

CREATE WORKLOAD admin IN `all` SETTINGS priority = 0;

CREATE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9;

CREATE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1;

-- Test that illegal actions are not allowed
CREATE WORKLOAD another_root; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD self_ref IN self_ref; -- {serverError BAD_ARGUMENTS}

DROP WORKLOAD `all`; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `03232_write`; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS priority = 0 FOR `all`; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS priority = 'invalid_value'; -- {serverError BAD_GET}

CREATE WORKLOAD invalid IN `all` SETTINGS weight = 0; -- {serverError INVALID_SCHEDULER_NODE}

CREATE WORKLOAD invalid IN `all` SETTINGS weight = -1; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS max_speed = -1; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS max_bytes_inflight = -1; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS unknown_setting = 42; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS max_io_requests = -1; -- {serverError BAD_ARGUMENTS}

CREATE WORKLOAD invalid IN `all` SETTINGS max_io_requests = 1.5; -- {serverError BAD_GET}

CREATE OR REPLACE WORKLOAD `all` IN production; -- {serverError BAD_ARGUMENTS}

-- Test CREATE OR REPLACE WORKLOAD
CREATE OR REPLACE WORKLOAD `all` SETTINGS max_io_requests = 200 FOR `03232_write`, max_io_requests = 100 FOR `03232_read`, max_concurrent_threads = 16, max_concurrent_threads_ratio_to_cores = 2.5;

CREATE OR REPLACE WORKLOAD admin IN `all` SETTINGS priority = 1;

CREATE OR REPLACE WORKLOAD admin IN `all` SETTINGS priority = 2;

CREATE OR REPLACE WORKLOAD admin IN `all` SETTINGS priority = 0;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 90;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 0, weight = 9;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 2, weight = 9;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 0;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 2;

-- Test CREATE OR REPLACE RESOURCE
CREATE OR REPLACE RESOURCE `03232_write` (write disk `03232_fake_disk_2`);

CREATE OR REPLACE RESOURCE `03232_read` (read disk `03232_fake_disk_2`);

-- Test update settings with CREATE OR REPLACE WORKLOAD
CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9, max_io_requests = 100;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1, max_io_requests = 10;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9, max_bytes_inflight = 100000;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1, max_bytes_inflight = 10000;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9, max_speed = 1000000;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1, max_speed = 100000;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9, max_speed = 1000000, max_burst = 10000000;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1, max_speed = 100000, max_burst = 1000000;

CREATE OR REPLACE WORKLOAD `all` SETTINGS max_bytes_inflight = 1000000, max_speed = 100000 FOR `03232_write`, max_speed = 200000 FOR `03232_read`;

CREATE OR REPLACE WORKLOAD `all` SETTINGS max_io_requests = 100 FOR `03232_write`, max_io_requests = 200 FOR `03232_read`;

CREATE OR REPLACE WORKLOAD production IN `all` SETTINGS priority = 1, weight = 9;

CREATE OR REPLACE WORKLOAD development IN `all` SETTINGS priority = 1, weight = 1;

-- Test change parent with CREATE OR REPLACE WORKLOAD
CREATE OR REPLACE WORKLOAD development IN production SETTINGS priority = 1, weight = 1;

CREATE OR REPLACE WORKLOAD development IN admin SETTINGS priority = 1, weight = 1;

-- Clean up
DROP WORKLOAD IF EXISTS production;

DROP WORKLOAD IF EXISTS development;

DROP WORKLOAD IF EXISTS admin;

DROP WORKLOAD IF EXISTS `all`;

DROP RESOURCE IF EXISTS `03232_write`;

DROP RESOURCE IF EXISTS `03232_read`;