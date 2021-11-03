@echo off 

echo Upgrade mod starting...

set root=%~dp0

call :UpdateMod WorldShare
call :UpdateMod ExplorerApp
call :UpdateMod DiffWorld
call :UpdateMod trunk

exit /b %errorlevel%

@rem update mod git and svn
:UpdateMod
	set param1=%1
	echo %param1%

	if "%param1%" == "trunk" (
		set cur_path="%root%../../%param1%"
	) else (
		set cur_path="%root%../_mod/%param1%"
	)

	if "%param1%" == "trunk" (
		if exist %cur_path% (
			pushd %cur_path%
			svn update .
			popd
		) else (
			svn co svn://svn.paraengine.com/script/%param1% %cur_path%
		)
	) else (
		if exist %cur_path% (
			pushd %cur_path%
			git pull --rebase
			popd
		) else (
			git clone git@github.com:tatfook/%param1%.git %cur_path%
		)
	)
exit /b %errorlevel%
