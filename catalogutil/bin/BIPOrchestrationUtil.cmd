@echo off
REM BIPOrchestrationUtil.cmd
REM This is the main batch to run the Patching Utility from Windows OS
REM Created By : Ashish Shrivastava  Date - May 20th 2010
REM 

set JAVA_HOME=C:\Program Files\Java\jdk1.6.0_10\bin
set BIP_LIB_DIR=D:\BIP\BIPOrchestrationUtil

set LAST_COMMAND=""
set WEBCATALOG=
set SOURCE_PATH=
set MODE=
set OPERATION=

if "%1" == "" goto error
:again
rem if %1 is blank, we are finished
if "%1" == "" goto STEP2
echo.

if  "%LAST_COMMAND%" == "-webcat" set WEBCATALOG=%1
if  "%LAST_COMMAND%" == "-source" set SOURCE_PATH=%1
if  "%LAST_COMMAND%" == "-target" set TARGET_PATH=%1
if  "%LAST_COMMAND%" == "-mode" set MODE=%1
if  "%LAST_COMMAND%" == "-cmd" set OPERATION=%1

rem - shift the arguments and examine %1 again

set LAST_COMMAND=%1

shift
goto again

:STEP2
set LAST_COMMAND=

echo CMD: %OPERATION%

if "%OPERATION%" == "all" goto createDiff
if "%OPERATION%" == "createPatch" goto createDiff
if "%OPERATION%" == "applyPatch" goto  createPatch

echo Error.. Missing or invalid -cmd parameter... 
goto end

REM Creating Diff File 

:createDiff

echo %SOURCE_PATH%
echo %TARGET_PATH%
echo %MODE%
echo %WEBCATALOG%

set t=%time:~0,8% 
set t=%t::=%
Set t=%t:~1,-1%

set PATCH_DIR=%TARGET_PATH%\bip%t%
REM echo %PATCH_DIR%

mkdir %PATCH_DIR%

set CLASSPATH=%CLASSPATH%;%BIP_LIB_DIR%\lib
set CLASSPATH=%CLASSPATH%;%BIP_LIB_DIR%\lib\xmlparserv2.jar
set CLASSPATH=%CLASSPATH%;%BIP_LIB_DIR%\lib\biputil.jar
REM echo %CLASSPATH%

REM echo "java oracle.xdo.tools.catalog.BIPOrchestrationUtil -source %SOURCE_PATH% -target %PATCH_DIR% -mode %MODE% -webcat %WEBCATALOG%"

java oracle.xdo.tools.catalog.BIPOrchestrationUtil -source %SOURCE_PATH% -target %PATCH_DIR% -mode %MODE% -webcat %WEBCATALOG%

set PATCH_DIR=%PATCH_DIR%\patchInfo
REM echo %PATCH_DIR%


dir %PATCH_DIR%|find " 0 File(s)" > NUL
if errorlevel 1 goto notempty

echo "Error!!!  BIPOrchestrationUtil could not import repository object/s" 
goto end

:notempty
echo not empty 

SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%a IN (!PATCH_DIR!\*) do (
echo %%a
createDiff %%a
)

REM if "%OPERATION%" == "all" goto :createPatch

goto end
echo.

:createPatch
set PATCH_DIR=%SOURCE_PATH%\patch
echo PATCH_DIR %PATCH_DIR%
echo %WEBCATALOG%

SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%a IN (!PATCH_DIR!\*.diff,!PATCH_DIR!\*.prop) do (
echo =%%a

REM echo na %%~na
REM echo x %%~xa
echo dp %%~dpa%%~na
REM echo "applyPatch -baseFile %%~dpa%%~na -webcat %WEBCATALOG%"

if "%%~xa" == ".diff" (
 createPatch -baseFile %%~dpa%%~na -webcat %WEBCATALOG%
 applyPatch -baseFile %%~dpa%%~na -webcat %WEBCATALOG%
)
if "%%~xa" == ".prop" (
  
  FOR /F "tokens=1,2 delims==" %%G IN (%%a) DO (
    echo  %%G %%H
    if "%%G" == "FOLDER_PATH"  (
    echo "runcat -cmd setItemProperties -inputFile  %%~dpa%%~na.properties -item %%H  -offline %WEBCATALOG%"

    runcat -cmd setItemProperties -inputFile  %%~dpa%%~na.properties -item %%H  -offline %WEBCATALOG%
    
   )
   )
)

)

ENDLOCAL ENABLEDELAYEDEXPANSION

goto end

:error
echo missing argument!
goto end

echo Done.
:end