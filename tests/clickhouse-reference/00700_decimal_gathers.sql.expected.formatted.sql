SELECT if(1, [CAST(materialize(2.), 'Decimal(9,3)')], [CAST(materialize(1.), 'Decimal(9,3)')]);

SELECT if(1, [CAST(materialize(2.), 'Decimal(18,10)')], [CAST(materialize(1.), 'Decimal(18,10)')]);

SELECT if(1, [CAST(materialize(2.), 'Decimal(38,18)')], [CAST(materialize(1.), 'Decimal(38,18)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(9,3)')], [CAST(materialize(1.), 'Decimal(9,3)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(18,10)')], [CAST(materialize(1.), 'Decimal(18,10)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(38,18)')], [CAST(materialize(1.), 'Decimal(38,18)')]);

SELECT if(1, [CAST(materialize(2.), 'Decimal(9,3)')], [CAST(materialize(1.), 'Decimal(9,0)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(18,10)')], [CAST(materialize(1.), 'Decimal(18,0)')]);

SELECT if(1, [CAST(materialize(2.), 'Decimal(38,18)')], [CAST(materialize(1.), 'Decimal(38,8)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(9,0)')], [CAST(materialize(1.), 'Decimal(9,3)')]);

SELECT if(1, [CAST(materialize(2.), 'Decimal(18,0)')], [CAST(materialize(1.), 'Decimal(18,10)')]);

SELECT if(0, [CAST(materialize(2.), 'Decimal(38,0)')], [CAST(materialize(1.), 'Decimal(38,18)')]);