SELECT (
        SELECT dictGet()
    )
SETTINGS enable_analyzer = '0'; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}