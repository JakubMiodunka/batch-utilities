@echo off

rem Defining constants.
set "VERSION=2"

rem Script entry point.
call :main "%~1" "%~2"
goto :end

rem Defining subroutines.
:print_help_prompt
setlocal

echo USAGE:
echo     file_sorter.bat [DIRECTORY_PATH] [OPTION]
echo.
echo DESCRIPTION:
echo     Sorts files contained by specified directory into sub-directories.
echo     Each created sub-directory contains files with particular extension and is named after it.
echo.     
echo     Files without any extensions, hidden files, system files and directories placed in specified directory will be omitted during the process.
echo.
echo ARGUMENTS:
echo     DIRECTORY_PATH
echo         Path to directory, which content (contained files) shall be sorted.
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
setlocal enabledelayedexpansion

set "ARG1=%~1"
set "ARG2=%~2"

rem Argument 2 is used only for detecting, if too many arguments were passed to the script.
if "%ARG2%" NEQ ""         (call :print_help_prompt & endlocal & goto :eof)

if "%ARG1%" == ""          (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "-h"        (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "--help"    (call :print_help_prompt & endlocal & goto :eof)
if "%ARG1%" == "-v"        (echo Version: %VERSION% & endlocal & goto :eof)
if "%ARG1%" == "--version" (echo Version: %VERSION% & endlocal & goto :eof)

set "DIRECTORY_PATH=%ARG1%"
if not exist "%DIRECTORY_PATH%" ( echo Directory not found: %DIRECTORY_PATH% & endlocal & exit -1)

set "CURRENT_WORKING_DIRECTORY_PATH=%CD%"
cd /d "%DIRECTORY_PATH%"

for /f %%i in ('dir /b /a:-d-h-s "." ^| findstr "\."') do (
    set "FILE_NAME=%%~fi"
    for %%j in ("!FILE_NAME!") do set "FILE_EXTENSION=%%~xj"

    set "SUB_DIRECTORY_PATH=!DIRECTORY_PATH!\!FILE_EXTENSION:~1!"
    if not exist "!SUB_DIRECTORY_PATH!" (mkdir "!SUB_DIRECTORY_PATH!")

    move  /-Y "!FILE_NAME!" "!SUB_DIRECTORY_PATH!"
)

cd /d "%CURRENT_WORKING_DIRECTORY_PATH%"

endlocal
goto :eof

:end
exit /b
