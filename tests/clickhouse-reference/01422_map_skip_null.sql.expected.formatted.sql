SELECT minMap(arrayJoin([([1], [NULL]), ([1], [NULL])])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT maxMap(arrayJoin([([1], [NULL]), ([1], [NULL])])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT sumMap(arrayJoin([([1], [NULL]), ([1], [NULL])])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT sumMapWithOverflow(arrayJoin([([1], [NULL]), ([1], [NULL])])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap(arrayJoin([([1, 2], [NULL, 11]), ([1, 2], [NULL, 22])]));

SELECT maxMap(arrayJoin([([1, 2], [NULL, 11]), ([1, 2], [NULL, 22])]));

SELECT sumMap(arrayJoin([([1, 2], [NULL, 11]), ([1, 2], [NULL, 22])]));

SELECT sumMapWithOverflow(arrayJoin([([1, 2], [NULL, 11]), ([1, 2], [NULL, 22])]));