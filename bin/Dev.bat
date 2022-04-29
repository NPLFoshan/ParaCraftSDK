@echo off

title ParacraftSDK-DEV

set param1=%1
set param2=%2
set world=
set http_env=
set touch=

for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq cmd.exe" /fo csv /nh') do (
    set cur_pid=%%i
    goto continue
)

:continue

for /f %%i in ('tasklist /fi "imagename eq paraengineclient.exe"') do (
    if "%%i" == "paraengineclient.exe" (
        set be_exist=1
    ) else (
        set be_exist=0
    )
)

if %be_exist% == 1 (
    taskkill /f /im paraengineclient.exe
)

if "%param1%" == "/h" (
    set http_debug=httpdebug="true"
) else if "%param2%"=="/h" (
    set http_debug=httpdebug="true"
)

if "%param1%" == "/world" (
    set world=world="%param2%"
)

echo %world%

if "%param1%" == "/touch" (
    set touch=IsTouchDevice="true"
)

if "%param1%" == "/http_env" (
    set http_env=http_env="%param2%" httpdebug="true"
)

pushd "%~dp0../redist/"
start /min call "ParaEngineClient.exe" ^
                mod="WorldShare|ExplorerApp|DiffWorld" ^
                %touch% ^
                %world% ^
                %http_debug% ^
                %http_env% ^
                loadpackage="%~dp0../../trunk/,;%~dp0../_mod/WorldShare/,;%~dp0../_mod/ExplorerApp/,;%~dp0../_mod/DiffWorld/" ^
                single="false" ^
                mc="true" ^
                noupdate="true" ^
                isDevEnv="true"
popd

set sdk_path=%~dp0..\

if "%param1%"=="/a" (
    code -n

    code -a %sdk_path%_mod\WorldShare\
    code -a %sdk_path%_mod\ExplorerApp\
    code -a %sdk_path%_mod\DiffWorld\
    code -a %sdk_path%..\trunk\

    code -r %sdk_path%redist\log.txt
)

for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq cmd.exe" /fo csv /nh') do (
    if %%i neq %cur_pid% (
        taskkill /f /pid %%i 2>nul
    )
)

if "%param1%" == "/e" (
    exit
) else if "%param2%" == "/e" (
    exit
)
