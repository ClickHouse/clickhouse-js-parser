-- Tags: no-fasttest
-- no-fasttest because aklomp-base64 library is required
SELECT base64Encode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT base64Decode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT tryBase64Decode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT base64Encode('foo', 'excess argument'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT base64Decode('foo', 'excess argument'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT tryBase64Decode('foo', 'excess argument'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- test with valid inputs
SELECT base64Encode(val)
FROM (
        SELECT arrayJoin(['', 'f', 'fo', 'foo', 'foob', 'fooba', 'foobar']) AS val
    );

SELECT base64Decode(val)
FROM (
        SELECT arrayJoin(['', 'Zg==', 'Zm8=', 'Zm9v', 'Zm9vYg==', 'Zm9vYmE=', 'Zm9vYmFy']) AS val
    );

SELECT tryBase64Decode(val)
FROM (
        SELECT arrayJoin(['', 'Zg==', 'Zm8=', 'Zm9v', 'Zm9vYg==', 'Zm9vYmE=', 'Zm9vYmFy']) AS val
    );

SELECT
    base64Decode(base64Encode('foo')) = 'foo',
    base64Encode(base64Decode('Zm9v')) = 'Zm9v';

SELECT
    tryBase64Decode(base64Encode('foo')) = 'foo',
    base64Encode(tryBase64Decode('Zm9v')) = 'Zm9v';

-- test with invalid inputs
SELECT base64Decode('Zm9vYmF=Zm9v'); -- { serverError INCORRECT_DATA }

SELECT tryBase64Decode('Zm9vYmF=Zm9v');

SELECT base64Decode('foo'); -- { serverError INCORRECT_DATA }

SELECT tryBase64Decode('foo');

SELECT base64Decode('aoeo054640eu='); -- { serverError INCORRECT_DATA }

SELECT tryBase64Decode('aoeo054640eu=');

-- test FixedString arguments
SELECT base64Encode(toFixedString('foo', 3));

SELECT base64Decode(toFixedString('Zm9v', 4));

SELECT tryBase64Decode(toFixedString('Zm9v', 4));