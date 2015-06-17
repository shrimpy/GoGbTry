@ECHO off

IF DEFINED WEBROOT_PATH (
    ECHO WEBROOT_PATH is %WEBROOT_PATH%
    GOTO :SETUP
)

ECHO set WEBROOT_PATH to D:\home\site\wwwroot
SET WEBROOT_PATH=D:\home\site\wwwroot

:SETUP
SET GOROOT=D:\Program Files\go\1.4.2
SET GOPATH=%WEBROOT_PATH%\gopath
SET GOEXE="%GOROOT%\bin\go.exe"
SET FOLDERNAME=azureapp
SET GOAZUREAPP=%WEBROOT_PATH%\gopath\src\%FOLDERNAME%
SET PATH=%PATH%;%GOROOT%\bin

IF EXIST %GOPATH% (
    ECHO %GOPATH% already exist

    ECHO Removing %GOAZUREAPP%
    RMDIR /S /Q %GOAZUREAPP%
) else (
    ECHO creating %GOPATH%\bin
    MKDIR "%GOPATH%\bin"
    ECHO creating %GOPATH%\pkg
    MKDIR "%GOPATH%\pkg"
    ECHO creating %GOPATH%\src
    MKDIR "%GOPATH%\src"
)

IF EXIST "%WEBROOT_PATH%\azureapp" (
    PUSHD "%WEBROOT_PATH%"
    ECHO Renaming azureapp ...
    RENAME azureapp azureapptmp
    POPD
)

%GOEXE% get github.com/constabulary/gb/...
SET GBEXE="%GOROOT%\bin\gb.exe"

ECHO creating %GOAZUREAPP%
MKDIR %GOAZUREAPP%

:: DELETE ME
SET DEPLOYMENT_SOURCE=D:\home\site\repository

ECHO --------------------------------------------
ECHO GOROOT: %GOROOT%
ECHO GOEXE: %GOEXE%
ECHO GOPATH: %GOPATH%
ECHO GOAZUREAPP: %GOAZUREAPP%
ECHO GBEXE: %GBEXE%
ECHO DEPLOYMENT_SOURCE: %DEPLOYMENT_SOURCE%
ECHO --------------------------------------------

ECHO copying source code to %GOAZUREAPP%
ROBOCOPY "%DEPLOYMENT_SOURCE%" "%GOAZUREAPP%" /E /NFL /NDL /NP /XD .git .hg /XF .deployment deploy.cmd

PUSHD "%GOAZUREAPP%"
ECHO Building ...
%GBEXE% build all
POPD

ECHO copying web.config
COPY /Y "%DEPLOYMENT_SOURCE%\web.config" "%WEBROOT_PATH%

::ECHO cleaning up ...
DEL /F /Q "%WEBROOT_PATH%\hostingstart.html"
IF EXIST "%WEBROOT_PATH%\azureapptmp" (
    ECHO removing "%WEBROOT_PATH%\azureapptmp" ...
    RMDIR /S /Q "%WEBROOT_PATH%\azureapptmp"
)

ECHO DONE!
