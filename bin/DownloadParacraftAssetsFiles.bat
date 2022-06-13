@echo off

title Download paracraft assets files

set boot=%~dp0DownloadParacraftAssetsFiles.lua
set cur_dir=%cd%

pushd "%~dp0../redist/"
call "ParaEngineClient.exe" bootstrapper="%boot%" cur_dir="%cur_dir%"
