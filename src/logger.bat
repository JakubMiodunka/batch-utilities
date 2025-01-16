@echo off

rem Defining constants.
set "VERSION=4"
set "TIMESTAMP_PROVIDER=iso8601_timestamp_provider.bat"
set "TIMESTAMP_FORMAT=--long"   & rem Provided directly to timestamp provider as option/argument.

rem Script entry point.
call :main "%~1" "%~2" "%~3"
goto :end

rem Defining subroutines.
:pick_message_label
setlocal

set "LOGGING_LEVEL=%~1"

if "%LOGGING_LEVEL%" == "1" (set "MESSAGE_LABEL=FAILURE")
if "%LOGGING_LEVEL%" == "2" (set "MESSAGE_LABEL=ERROR")
if "%LOGGING_LEVEL%" == "3" (set "MESSAGE_LABEL=WARNING")
if "%LOGGING_LEVEL%" == "4" (set "MESSAGE_LABEL=INFO")
if "%LOGGING_LEVEL%" == "5" (set "MESSAGE_LABEL=DEBUG")

if "%MESSAGE_LABEL%" == "" ( echo Invalid logging level specified: %LOGGING_LEVEL% & endlocal & exit -1)

endlocal && set "%~2=%MESSAGE_LABEL%"
goto :eof

:get_current_timestamp
setlocal

if not exist "%TIMESTAMP_PROVIDER%" ( echo File not found: %TIMESTAMP_PROVIDER% & endlocal & exit -1)

for /f %%i in ('call "%TIMESTAMP_PROVIDER%" "%TIMESTAMP_FORMAT%"') do (set "TIMESTAMP=%%i")

endlocal && set "%~1=%TIMESTAMP%"
goto :eof

:print_help_prompt
setlocal

echo USAGE:
echo     logger.bat [LOGGING_LEVEL] [MESSAGE_CONTENT] [OPTION]
echo.
echo DESCRIPTION:
echo     Formulates log messages according to specified parameters and prints in to std-out.
echo     Format of generated log messages: [LOGGING_LEVEL_LABEL][TIMESTAMP] MESSAGE_CONTENT
echo.
echo ARGUMENTS:
echo     LOGGING_LEVEL
echo         Numeric representation of logging level, on which given message should be logged.
echo         Available logging levels: 1 (FAILURE), 2 (ERROR), 3 (WARNING), 4 (INFO), 5 (DEBUG)
echo.
echo     MESSAGE_CONTENT
echo         Message content to be logged.
echo.
echo OPTIONS:
echo     -v, --version
echo         Prints version of the script.
echo     -h, --help
echo         Prints this help prompt.
echo.
echo AUTHOR: Jakub Miodunka
echo VERSION: %VERSION%

endlocal
goto :eof

:main
setlocal

set "ARG1=%~1"
set "ARG2=%~2"
set "ARG3=%~3"

rem Argument 3 is used only for detecting, if too many arguments were passed to the script.
if "%ARG3%" NEQ ""         (call :print_help_prompt & endlocal & goto :eof)

if "%ARG1%" == ""          (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "-h"        (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "--help"    (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "-v"        (echo Version: %VERSION% & endlocal & goto :eof)
if "%ARG1%" == "--version" (echo Version: %VERSION% & endlocal & goto :eof)
if "%ARG2%" == ""          (call :print_help_prompt & endlocal & goto :eof)

call :pick_message_label "%ARG1%" MESSAGE_LABEL
call :get_current_timestamp TIMESTAMP

set "MESSAGE=[%MESSAGE_LABEL%][%TIMESTAMP%] %ARG2%"
echo %MESSAGE%

endlocal
goto :eof

:end
exit /b
