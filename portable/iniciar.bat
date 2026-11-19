@echo off
title Bioflow
cd /d "%~dp0"

rem Isolate from any R installation or library the user may have
set R_LIBS=
set R_LIBS_USER=
set R_LIBS_SITE=
set R_PROFILE_USER=
set R_ENVIRON_USER=

rem Quoted "set" avoids invisible trailing spaces in the path
set "RSCRIPT=%~dp0R-Portable\bin\Rscript.exe"
if not exist "%RSCRIPT%" set "RSCRIPT=%~dp0R-Portable\bin\x64\Rscript.exe"

rem --- Checks (clear message instead of "cannot find the path") ---
if not exist "%RSCRIPT%" (
  echo ERROR: R was not found at:
  echo   %~dp0R-Portable\bin\Rscript.exe
  echo Make sure the zip was fully extracted and the folder "R-Portable"
  echo is next to this file and contains bin\Rscript.exe
  goto :end
)
if not exist "%~dp0run.R" (
  echo ERROR: run.R was not found in %~dp0
  goto :end
)
if not exist "%~dp0library\bioflow" (
  echo ERROR: the "library" folder with bioflow was not found in %~dp0
  goto :end
)

echo Starting Bioflow... (Don't close this window)
"%RSCRIPT%" --vanilla "%~dp0run.R"

:end
pause
