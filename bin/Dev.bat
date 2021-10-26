@echo off

title ParacraftSDK-DEV

for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq cmd.exe" /FO CSV /NH') do (
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

pushd "%~dp0../redist/"
start /min call "ParaEngineClient.exe" mod="WorldShare|ExplorerApp|DiffWorld" loadpackage="%~dp0../../trunk/,;%~dp0../_mod/WorldShare/,;%~dp0../_mod/ExplorerApp/,;%~dp0../_mod/DiffWorld/" single="false" mc="true" noupdate="true" isDevEnv="true"
popd

for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq cmd.exe" /FO CSV /NH') do (
    if %%i neq %cur_pid% (
        taskkill /f /pid %%i 2>nul
    )
)

set param1=%1
set sdk_path=%~dp0..\

if "%param1%"=="/a" (
    code -n

    code -a %sdk_path%_mod\WorldShare\
    code -a %sdk_path%_mod\ExplorerApp\
    code -a %sdk_path%_mod\DiffWorld\
    code -a %sdk_path%..\trunk\

    code -a %sdk_path%redist\log.txt
)
