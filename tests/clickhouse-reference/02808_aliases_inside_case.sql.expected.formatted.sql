# We support specifying aliases in any place in the query, including CASE expression:
WITH arrayJoin([1, 2]) AS arg

SELECT
    arg,
    multiIf(arg = 1, 1 AS one, arg = 2, one / 2, NULL) AS imposible;