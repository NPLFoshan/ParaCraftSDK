@echo off 

pushd "%~dp0../redist/" 

call "ParaEngineClient.exe" mod="WorldShare|ExplorerApp|DiffWorld" loadpackage="%~dp0../../trunk/,;%~dp0../_mod/WorldShare/,;%~dp0../_mod/ExplorerApp/,;%~dp0../_mod/DiffWorld/" single="false" mc="true" noupdate="true" isDevEnv="true" http_env="RELEASE" httpdebug="true"

popd 