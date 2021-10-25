@echo off 

echo Upgrade mod starting...

set root=%~dp0

call :UpdateMod WorldShare
call :UpdateMod ExplorerApp
call :UpdateMod DiffWorld
call :UpdateMod trunk

popd

EXIT /B %ERRORLEVEL%

rem update mod git
:UpdateMod
	echo %1

	if "%1" == "trunk" (
		pushd "%root%../../%1"
		svn update .
		popd
	) else (
		pushd "%root%../_mod/%1"
		git pull --rebase
		popd
	)

EXIT /B 0
