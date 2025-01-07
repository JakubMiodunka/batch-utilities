@echo off

set "VERSION=1"

if "%1" == "-h"        (call :print_help_prompt & goto :end)
if "%1" == "--help"    (call :print_help_prompt & goto :end)
if "%1" == "-v"        (echo Version: %VERSION% & goto :end)
if "%1" == "--version" (echo Version: %VERSION% & goto :end)

call :get_iso_timestamp TIMESTAMP
echo %TIMESTAMP%

goto :end

:get_iso_timestamp
for /f "tokens=2 delims==" %%i in ('wmic OS get localdatetime /value') do set DATETIME=%%i

set "YEAR=%DATETIME:~0,4%"
set "MONTH=%DATETIME:~4,2%"
set "DAY=%DATETIME:~6,2%"
set "HOUR=%DATETIME:~8,2%"
set "MINUTE=%DATETIME:~10,2%"
set "SECOND=%DATETIME:~12,2%"
set "UTC_OFFSET_SIGN=%DATETIME:~21,1%"
set "RAW_UTC_OFFSET=%DATETIME:~22,3%"

rem UTC offset is provided by wmic in minutes - conversion to HH:mm format is required.
set /a UTC_OFFSET_HOURS=(1000%RAW_UTC_OFFSET% %% 1000) / 60
set "UTC_OFFSET_HOURS=0%UTC_OFFSET_HOURS%"
set "UTC_OFFSET_HOURS=%UTC_OFFSET_HOURS:~-2%"

set /a UTC_OFFSET_MINUTES=(1000%RAW_UTC_OFFSET% %% 1000) %% 60
set "UTC_OFFSET_MINUTES=0%UTC_OFFSET_MINUTES%"
set "UTC_OFFSET_MINUTES=%UTC_OFFSET_MINUTES:~-2%"

set "ISO_TIMESTAMP=%YEAR%-%MONTH%-%DAY%T%HOUR%:%MINUTE%:%SECOND%%UTC_OFFSET_SIGN%%UTC_OFFSET_HOURS%:%UTC_OFFSET_MINUTES%"
set %1=%ISO_TIMESTAMP%
goto :eof

:print_help_prompt
echo USAGE:
echo     iso8601_timestamp_provider.bat
echo.
echo DESCRIPTION:
echo     Generates timestamp of a current moment formatted accordingly to ISO 8601 and prints int to std-out.
echo.
echo AUTHOR: Jakub Miodunka
goto :eof

:print_script_version
echo Version: %VERSION%
goto :eof

:end
exit
