-- Tags: no-parallel
DROP USER IF EXISTS `       `;

DROP USER IF EXISTS `   spaces`;

DROP USER IF EXISTS `spaces    `;

DROP USER IF EXISTS ` spaces `;

DROP USER IF EXISTS `test 01119`;

DROP USER IF EXISTS `Вася Пупкин`;

DROP USER IF EXISTS `无名氏 `;

DROP USER IF EXISTS `🙈 🙉 🙊`;

CREATE USER `       `;

CREATE USER `   spaces`;

CREATE USER `spaces    `;

CREATE USER ` INTERSERVER SECRET `; -- { serverError BAD_ARGUMENTS }

CREATE USER `test 01119`;

ALTER USER `test 01119` RENAME TO ` spaces `;

ALTER USER ` spaces ` RENAME TO ` INTERSERVER SECRET `; -- { serverError BAD_ARGUMENTS }

CREATE USER `Вася Пупкин`;

CREATE USER `无名氏 `;

CREATE USER `🙈 🙉 🙊`;

SELECT
    length(name),
    name,
    '.'
FROM `system`.users
WHERE position(name, ' ') != 0
ORDER BY name ASC;

DROP USER `       `;

DROP USER `   spaces`;

DROP USER `spaces    `;

DROP USER ` spaces `;

DROP USER `Вася Пупкин`;

DROP USER `无名氏 `;

DROP USER `🙈 🙉 🙊`;