SELECT materialize('{"" : {"" : {"" : 42}}}')::JSON
SETTINGS enable_json_type = '1';