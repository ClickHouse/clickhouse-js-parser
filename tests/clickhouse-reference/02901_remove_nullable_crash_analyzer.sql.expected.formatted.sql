SELECT 1 % multiIf(1, (1 IS NOT NULL) + *, NULL);

SELECT caseWithExpression(1, false, 1, multiIf(1, 1 - caseWithExpression(1, 1, 1, 1), NULL) % 1);

SELECT 1 % if(1, dummy, NULL); -- { serverError ILLEGAL_DIVISION }

SELECT sum(multiIf(1, dummy, NULL));

SELECT sum(multiIf(1, dummy, NULL)) OVER ();