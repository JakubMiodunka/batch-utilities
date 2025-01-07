@echo off

set "VERSION=1"
set "TIMESTAMP_PROVIDER=iso8601_timestamp_provider.bat"

if "%1" == ""          (call :print_help_prompt & goto :end)
if "%1" == "-h"        (call :print_help_prompt & goto :end)
if "%1" == "--help"    (call :print_help_prompt & goto :end)
if "%1" == "-v"        (echo Version: %VERSION% & goto :end)
if "%1" == "--version" (echo Version: %VERSION% & goto :end)
if "%2" == ""          (call :print_help_prompt & goto :end)

call :main "%1" "%2"

goto :end

:pick_message_label
if "%1" == "failure" (set "%2=FAILURE" & goto :eof)
if "%1" == "error"   (set "%2=ERROR"   & goto :eof)
if "%1" == "warning" (set "%2=WARNING" & goto :eof)
if "%1" == "info"    (set "%2=INFO"    & goto :eof)
if "%1" == "debug"   (set "%2=DEBUG"   & goto :eof)
echo Specified logging level invalid: %1
goto :end

:get_current_timestamp
if exist %TIMESTAMP_PROVIDER% (
    for /f %%i in ('call %TIMESTAMP_PROVIDER%') do (set "%1=%%i" & goto :eof)
)
echo File not found: %TIMESTAMP_PROVIDER%
goto :end

:main
set "LOGGING_LEVEL=%1"
set "MESSAGE_CONTENT=%2"

call :pick_message_label %LOGGING_LEVEL% MESSAGE_LABEL
call :get_current_timestamp TIMESTAMP

set "MESSAGE=[%MESSAGE_LABEL%][%TIMESTAMP%] %MESSAGE_CONTENT%"
echo %MESSAGE%

goto :eof

:print_help_prompt
echo USAGE:
echo     logger.bat [LOGGING_LEVEL] [MESSAGE_CONTENT]
echo.
echo DESCRIPTION:
echo     Formulates log messages according to specified parameters and prints in to std-out.
echo     Format of generated log messages: [LOGGING_LEVEL_LABEL][TIMESTAMP] MESSAGE_CONTENT
echo.
echo ARGUMENTS:
echo     LOGGING_LEVEL
echo         Logging level, on which given message should be logged.
echo         Available logging levels: failure, error, warning, info, debug
echo.
echo     MESSAGE_CONTENT
echo         Message content to be logged.
echo     -v, --version
echo         Prints version of the script.
echo     -h, --help
echo         Prints this help prompt.
echo.
echo AUTHOR: Jakub Miodunka
goto :eof

:end
exit
