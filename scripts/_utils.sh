#!/bin/sh

_check_value () {
    # Check if environment variables have a valid value. If not do
    # any of the actions and possibly reset the environment variable to
    # the specified default value.
    # Run as:
    # _check_value <VAR_NAME> <PATTERN> <DEFAULT_VALUE> [<ACTION>]
    #
    # Args:
    #  VAR_NAME:      The variable name of the variable holding the value to
    #                 check.
    #  PATTERN:       The basic regular expression against which to check the
    #                 value of the variable VAR_NAME.
    #  DEFAULT_VALUE: The default value that shall be assigned to the variable
    #                 VAR_NAME if the value does not match PATTERN. If ACTION
    #                 is not provided and DEFAULT_VALUE = exit, it will be
    #                 assumed the ACTION = exit.
    #  ACTION:        The action to do, if the variable value does not match
    #                 the PATTERN. The following actions are supported:
    #                    - <no_action>: Print a warning text, but only if the
    #                                   variable is not empty. Set the variable
    #                                   to DEFAULT_VALUE afterwards.
    #                    - warn:        Print a warning text and set the
    #                                   variable to DEFAULT_VALUE.
    #                    - exit:        Print a warning text and exit the
    #                                   program.
    local VAR_NAME="${1}";
    local PATTERN="${2}";
    local DEFAULT_VALUE="${3}";
    local ACTION="${4}";
    eval "local VAR_VALUE=\"\${${VAR_NAME}}\"";
    local STR_VAR_VALUE=" ${VAR_VALUE}";

    # If pattern does not match expr returns 0 matched characters
    if [ "$(expr match "${STR_VAR_VALUE}" " ${PATTERN}")" -eq 0 ]; then
        if [ "${ACTION}" = "warn" ] ||
           [ -z "${ACTION}" -a "$(expr length "${VAR_VALUE}")" -gt 0 ]; then
            echo 'You have supplied an invalid value for ' \
                 "${VAR_NAME} (${VAR_VALUE:-none})." \
                 "Setting it to default value: ${DEFAULT_VALUE}" 1>&2;

        elif [ "${ACTION}" = "exit" ] || \
             [ -z "${ACTION}" -a "${DEFAULT_VALUE}" = "exit" ]; then
            echo "You have to supply a valid value for ${VAR_NAME}." \
                 "See the documentation for more information." \
                 "Shutting down...";
            exit 1;
        fi

        export ${VAR_NAME}="${DEFAULT_VALUE}";
    fi
}