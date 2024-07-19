{% macro encode_json_string(column) %}
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(
                                                    REPLACE(
                                                        REPLACE(
                                                            REPLACE(
                                                                REPLACE(
                                                                    REPLACE(
                                                                        REPLACE(
                                                                            REPLACE(
                                                                                REPLACE(
                                                                                    CAST({{ column }} AS STRING),
                                                                                    "'", '\"' -- Handle single quotes
                                                                                ),
                                                                                'None', 'null'
                                                                            ),
                                                                            'none', 'null' -- Handle lowercase 'none'
                                                                        ),
                                                                        'NULL', 'null' -- Handle uppercase 'NULL'
                                                                    ),
                                                                    '\\"', '\\\"' -- Handle escaped double quotes
                                                                ),
                                                                '"', '\"' -- Escape double quotes inside the string
                                                            ),
                                                            '\n', '\\n' -- Handle newline characters
                                                        ),
                                                        '\r', '\\r' -- Handle carriage return characters
                                                    ),
                                                    '\b', '\\b' -- Handle backspace characters
                                                ),
                                                '\f', '\\f' -- Handle form feed characters
                                            ),
                                            '\\', '\\\\' -- Handle backslashes
                                        ),
                                        '\t', '\\t' -- Handle tab characters
                                    ),
                                    '\\u', '\\\\u' -- Handle unicode escape sequences if any
                                ),
                                "\\'", "\\\\'" -- Handle single quotes within the string
                            ),
                            '\\"', '\\\\\\"' -- Handle double quotes within the string
                        ),
                        '\\', '\\\\\\\\' -- Handle double backslashes within the string
                    ),
                    "\n", "\\n" -- Handle escaped newlines
                ),
                "\r", "\\r" -- Handle escaped carriage returns
            ),
            "\t", "\\t" -- Handle escaped tabs
        )
    )
{% endmacro %}
