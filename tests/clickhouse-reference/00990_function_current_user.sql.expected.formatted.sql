-- Since the actual user name is unknown, have to perform just smoke tests
SELECT currentUser() IS NOT NULL;

SELECT length(currentUser()) > 0;

SELECT
    currentUser() = user(),
    currentUser() = USER(),
    current_user() = currentUser();

SELECT currentUser() = initial_user
FROM `system`.processes
WHERE query LIKE '%$!@#%'
    AND current_database = currentDatabase();