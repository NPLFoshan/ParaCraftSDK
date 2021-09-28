@echo off 

set Root="%~dp0../_mod/"

call :UpdateMod WorldShare
call :UpdateMod ExplorerApp
call :UpdateMod DiffWorld

popd

EXIT /B %ERRORLEVEL%

rem update mod git
:UpdateMod
echo %1
pushd %Root%%1
git pull --rebase
popd

EXIT /B 0
