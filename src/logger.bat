@echo off

set "VERSION=3"
set "TIMESTAMP_PROVIDER=iso8601_timestamp_provider.bat"

call :main "%~1" "%~2" "%~3"
goto :end

:pick_message_label
setlocal

set "arg1=%~1"
set "MESSAGE_LABEL="

if "%arg1%" == "1" (set "MESSAGE_LABEL=FAILURE")
if "%arg1%" == "2" (set "MESSAGE_LABEL=ERROR")
if "%arg1%" == "3" (set "MESSAGE_LABEL=WARNING")
if "%arg1%" == "4" (set "MESSAGE_LABEL=INFO")
if "%arg1%" == "5" (set "MESSAGE_LABEL=DEBUG")

if "%MESSAGE_LABEL%" == "" (
    echo Specified logging level invalid: %arg1%
    endlocal
    goto :end
)

endlocal & set "%~2=%MESSAGE_LABEL%"
goto :eof

:get_current_timestamp
setlocal

if not exist "%TIMESTAMP_PROVIDER%" (
    echo File not found: %TIMESTAMP_PROVIDER%
    endlocal
    goto :end
)

set "TIMESTAMP="
for /f %%i in ('call "%TIMESTAMP_PROVIDER%"') do (set "TIMESTAMP=%%i")

endlocal & set "%~1=%TIMESTAMP%"
goto :eof

:main
setlocal

rem Argument 3 is used only for detecting, if too many arguments were passed to the script.
set "arg1=%~1"
set "arg2=%~2"
set "arg3=%~3"

if "%arg1%" == ""          (call :print_help_prompt & endlocal & goto :eof)
if "%arg1%" == "-h"        (call :print_help_prompt & endlocal & goto :eof)
if "%arg1%" == "--help"    (call :print_help_prompt & endlocal & goto :eof)
if "%arg1%" == "-v"        (echo Version: %VERSION% & endlocal & goto :eof)
if "%arg1%" == "--version" (echo Version: %VERSION% & endlocal & goto :eof)
if "%arg2%" == ""          (call :print_help_prompt & endlocal & goto :eof)
if "%arg3%" NEQ ""         (call :print_help_prompt & endlocal & goto :eof)

call :pick_message_label "%arg1%" MESSAGE_LABEL
call :get_current_timestamp TIMESTAMP

set "MESSAGE=[%MESSAGE_LABEL%][%TIMESTAMP%] %arg2%"
echo %MESSAGE%

endlocal
goto :eof

:print_help_prompt
setlocal

echo USAGE:
echo     logger.bat [LOGGING_LEVEL] [MESSAGE_CONTENT]
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
echo     -v, --version
echo         Prints version of the script.
echo     -h, --help
echo         Prints this help prompt.
echo.
echo AUTHOR: Jakub Miodunka

endlocal
goto :eof

:end
exit /b
