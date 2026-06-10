SELECT base32Encode('This is a test string');

SELECT base32Encode('This is a test string', 'Second arg'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

DROP TABLE IF EXISTS t3447;

CREATE TABLE t3447
(
    id Int32,
    str String,
    b32 String
)
ENGINE = Memory();

INSERT INTO t3447;

SELECT
    id,
    str AS input,
    hex(str) AS input_hex,
    base32Encode(str) AS result,
    b32,
    result = b32
FROM t3447;

SELECT
    id,
    b32 AS input,
    base32Decode(input) AS result,
    hex(result) AS result_hex,
    hex(str) AS expected_hex,
    result = str
FROM t3447;

SELECT
    id,
    lower(b32) AS input,
    base32Decode(input) AS result,
    hex(result) AS result_hex,
    hex(str) AS expected_hex,
    result = str
FROM t3447;

SELECT
    id,
    str AS input,
    hex(str) AS input_hex,
    base32Decode(base32Encode(str)) AS result,
    result = str
FROM t3447;

SELECT base32Decode('========'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YT!'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6Y=B'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6Y=!'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6Y==='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ=Q'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ======'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('12345678'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ'); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ=='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ==='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ===='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ====='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ======='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ====!=='); -- { serverError INCORRECT_DATA }

SELECT base32Decode('MZXW6YQ====A=='); -- { serverError INCORRECT_DATA }

SELECT tryBase32Decode('========');

SELECT tryBase32Decode('MZXW6YT!');

SELECT tryBase32Decode('MZXW6Y=B');

SELECT tryBase32Decode('MZXW6Y=!');

SELECT tryBase32Decode('MZXW6Y===');

SELECT tryBase32Decode('MZXW6YQ=Q');

SELECT tryBase32Decode('MZXW6YQ======');

SELECT tryBase32Decode('12345678');

SELECT tryBase32Decode('MZXW6YQ');

SELECT tryBase32Decode('MZXW6YQ==');

SELECT tryBase32Decode('MZXW6YQ===');

SELECT tryBase32Decode('MZXW6YQ====');

SELECT tryBase32Decode('MZXW6YQ=====');

SELECT tryBase32Decode('MZXW6YQ=======');

SELECT tryBase32Decode('MZXW6YQ====!==');

SELECT tryBase32Decode('MZXW6YQ====A==');

SELECT
    val,
    hex(val),
    base32Encode(val) AS enc_res,
    hex(base32Decode(enc_res)) AS dec_res,
    dec_res = hex(val)
FROM (
        SELECT arrayJoin([toFixedString('', 1), toFixedString('f', 1), toFixedString('fo', 2), toFixedString('foo', 3), toFixedString('foob', 4), toFixedString('fooba', 5), toFixedString('foobar', 6), toFixedString('\0', 1), toFixedString('\0\0', 2), toFixedString('\0\0\0', 3), toFixedString('\0\0\0\0', 4), toFixedString('\0\0\0\0\0', 5), toFixedString('�', 1), toFixedString('��', 2), toFixedString('���', 3), toFixedString('����', 4), toFixedString('�����', 5), toFixedString('#Eg�', 5), toFixedString('���#', 5), toFixedString('1234567890', 10), toFixedString('The quick brown fox jumps over the lazy dog', 43), toFixedString('a', 1), toFixedString('ab', 2), toFixedString('abc', 3), toFixedString('abcd', 4), toFixedString('abcde', 5), toFixedString('abcdef', 6), toFixedString('foo', 3), toFixedString('foobar', 6), toFixedString('Hello world!', 12), toFixedString('Hold my beer', 12), toFixedString('Hold another beer', 18), toFixedString('And a wine', 10), toFixedString('And another wine', 17), toFixedString('And a lemonade', 14), toFixedString('t1Zv2yaZ', 8), toFixedString('And another wine', 17)]) AS val
    );

SELECT
    val,
    base32Decode(val) AS dec_res,
    hex(dec_res),
    base32Encode(dec_res) AS enc_res,
    enc_res = val
FROM (
        SELECT arrayJoin([toFixedString('AAAAA===', 8), toFixedString('MY======', 8), toFixedString('MZXQ====', 8), toFixedString('MZXW6===', 8), toFixedString('MZXW6YQ=', 8), toFixedString('MZXW6YTB', 8), toFixedString('MZXW6YTBOI======', 16), toFixedString('AA======', 8), toFixedString('AAAA====', 8), toFixedString('AAAAA===', 8), toFixedString('AAAAAAA=', 8), toFixedString('AAAAAAAA', 8), toFixedString('74======', 8), toFixedString('777Q====', 8), toFixedString('77776===', 8), toFixedString('777777Y=', 8), toFixedString('77777777', 8), toFixedString('AERUKZ4J', 8), toFixedString('VPG66AJD', 8), toFixedString('GEZDGNBVGY3TQOJQ', 16), toFixedString('KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===', 96), toFixedString('ME======', 8), toFixedString('MFRA====', 8), toFixedString('MFRGG===', 8), toFixedString('MFRGGZA=', 8), toFixedString('MFRGGZDF', 8), toFixedString('MFRGGZDFMY======', 16), toFixedString('MZXW6===', 8), toFixedString('MZXW6YTBOI======', 16), toFixedString('JBSWY3DPEB3W64TMMQQQ====', 24), toFixedString('JBXWYZBANV4SAYTFMVZA====', 24), toFixedString('JBXWYZBAMFXG65DIMVZCAYTFMVZA====', 32), toFixedString('IFXGIIDBEB3WS3TF', 16), toFixedString('IFXGIIDBNZXXI2DFOIQHO2LOMU======', 32), toFixedString('IFXGIIDBEBWGK3LPNZQWIZI=', 24), toFixedString('OQYVU5RSPFQVU===', 16), toFixedString('IFXGIIDBNZXXI2DFOIQHO2LOMU======', 32)]) AS val
    );

SELECT base32Decode(encoded)
FROM (
        SELECT base32Encode(val) AS encoded
        FROM (
                SELECT arrayJoin(['', 'f', 'fo', 'foo', 'foob', 'fooba', 'foobar', 'Hello world!']) AS val
            )
    );

SELECT tryBase32Decode(encoded)
FROM (
        SELECT base32Encode(val) AS encoded
        FROM (
                SELECT arrayJoin(['', 'f', 'fo', 'foo', 'foob', 'fooba', 'foobar', 'Hello world!']) AS val
            )
    );

SELECT tryBase32Decode(val)
FROM (
        SELECT arrayJoin(['Hold my beer', 'Hold another beer', '3csAg9', 'And a wine', 'And another wine', 'And a lemonade', 't1Zv2yaZ', 'And another wine']) AS val
    );

SELECT base32Encode(val)
FROM (
        SELECT arrayJoin(['', 'f', 'fo', 'foo', 'foob', 'fooba', 'foobar']) AS val
    );

SELECT base32Decode(val)
FROM (
        SELECT arrayJoin(['', 'MY======', 'MZXQ====', 'MZXW6===', 'MZXW6YQ=', 'MZXW6YTB', 'MZXW6YTBOI======']) AS val
    );

SELECT base32Encode(base32Decode('KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===')) = 'KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===';

SELECT base32Encode('���#') = 'VPG66AJD';

SELECT base32Encode(toFixedString('Hold my beer...', 15));

SELECT base32Decode(toFixedString('t1Zv2yaZ', 8)); -- { serverError INCORRECT_DATA }

SELECT tryBase32Decode(toFixedString('t1Zv2yaZ', 8));

SELECT base32Encode(val)
FROM (
        SELECT arrayJoin([toFixedString('', 3), toFixedString('f', 3), toFixedString('fo', 3), toFixedString('foo', 3)]) AS val
    );

SELECT base32Decode(val)
FROM (
        SELECT arrayJoin([toFixedString('AAAAA===', 8), toFixedString('MYAAA===', 8), toFixedString('MZXQA===', 8), toFixedString('MZXW6===', 8)]) AS val
    );

SELECT base32Encode(reinterpretAsFixedString(byteSwap(toUInt256('256')))) = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAA====';

SELECT base32Encode(reinterpretAsString(byteSwap(toUInt256('256')))) = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE======'; -- { reinterpretAsString drops the last null byte hence, encoded value is different than the FixedString version above }

SELECT base32Encode('Testing') = 'KRSXG5DJNZTQ====';

SELECT base32Decode('KRSXG5DJNZTQ====') = 'Testing';

SELECT base32Encode(val)
FROM (
        SELECT arrayJoin(['test1', 'test2', 'test3', 'test123', 'test456']) AS val
    );

SELECT base32Decode(val)
FROM (
        SELECT arrayJoin(['KRSXG5A=', 'ORSXG5BA', 'ORSXG5BB']) AS val
    );