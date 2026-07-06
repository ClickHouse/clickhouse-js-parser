SELECT char(208, 191, 209, 128, 208, 184, 208, 178, 208, 181, 209, 130) AS hello;

SELECT char(-48, -65, -47, -128, -48, -72, -48, -78, -48, -75, -47, -126) AS hello;

SELECT char(-48, 176 + number, -47, -128, -48, -72, -48, -78, -48, -75, -47, -126) AS hello
FROM numbers(16);

SELECT char(228, 189, 160, 229, 165, 189) AS hello;