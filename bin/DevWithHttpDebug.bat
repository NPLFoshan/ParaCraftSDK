@echo off 

pushd "%~dp0../../redist/" 

call "ParaEngineClient.exe" mod="WorldShare|ExplorerApp|DiffWorld" loadpackage="%~dp0../../trunk/,;%~dp0./WorldShare/,;%~dp0./ExplorerApp/,;%~dp0./DiffWorld/" single="false" mc="true" noupdate="true" isDevEnv="true" httpdebug="true"

popd 