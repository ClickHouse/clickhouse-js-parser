SELECT 'r\\a1bbb' LIKE '%r\\\\a1%bbb%' AS res;

WITH lower('\\RealVNC\\WinVNC4 /v password') AS CommandLine

SELECT
    CommandLine LIKE '%\\\\realvnc\\\\winvnc4%password%' AS t1,
    CommandLine LIKE '%\\\\realvnc\\\\winvnc4 %password%' AS t2,
    CommandLine LIKE '%\\\\realvnc\\\\winvnc4%password' AS t3,
    CommandLine LIKE '%\\\\realvnc\\\\winvnc4 %password' AS t4,
    CommandLine LIKE '%realvnc%winvnc4%password%' AS t5,
    CommandLine LIKE '%\\\\winvnc4%password%' AS t6;