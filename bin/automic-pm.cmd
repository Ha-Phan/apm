@echo off
set "PM_BIN=%~dp0"
call :resolve "%PM_BIN%\.."
set "PM_HOME=%result%"
set CURRENT_DIR=%cd%

SET CP=""
set CP=%CP%;%PM_HOME%;%PM_HOME%\lib\*
set CP=%CP%;%PM_HOME%\conf\log4j

set UPDATE_APM_TXT=%PM_BIN%update-apm.txt
if exist %UPDATE_APM_TXT% (
	del "%UPDATE_APM_TXT%"
) 

java %JAVA_OPTS% -Dapm.home="%PM_HOME%" -classpath "%CP%" com.automic.pm.PackageManager %*

rem execute post update command
if exist %UPDATE_APM_TXT% (
	for /f "Tokens=* delims=" %%x in (%UPDATE_APM_TXT%) do set SCRIPT_CONTENT=%%x
	del "%UPDATE_APM_TXT%"
	%SCRIPT_CONTENT%
) 
cd "%CURRENT_DIR%"
set retcode=%errorlevel%
exit /b %retcode%

rem // resolve relative path to absolute path
:resolve
  set REL_PATH=%1
  set ABS_PATH=

  rem // save current directory and change to target directory
  pushd %REL_PATH%
  rem // save value of CD variable (current directory)
  set ABS_PATH=%CD%
  rem // restore original directory
  popd
  set result=%ABS_PATH%
goto :eof
