CREATE TABLE `03756_capn_proto_message_size_limit`
(
    c0 Decimal32(8)
)
ENGINE = Memory();

INSERT INTO FUNCTION url('http://localhost:8123/?query=INSERT+INTO+' || currentDatabase() || '.03756_capn_proto_message_size_limit+(c0)+FORMAT+CapnProto', 'BSONEachRow', 'c0 Decimal32(8)'); -- { serverError 86 }