@echo off
REM createDiff.cmd
REM Batch file to create diff for BIP Objects. This is invoked from BIPOrchestrationUtil.cmd 
REM 
REM Created By : Ashish Shrivastava  Date - May 20th 2010
REM 

Echo Start Diffing process....

if "%1" == "" goto error

set PATCH_INFO=%1

REM echo %PATCH_INFO%


FOR /F "tokens=1,2 delims==" %%G IN (%PATCH_INFO%) DO (
 if "%%G" == "targetDir" set TARGET_DIR=%%H
 if "%%G" == "objectDir" set OBJECT_DIR=%%H
 if "%%G" == "path" set CATALOG_PATH=%%H
 if "%%G" == "webCatalog" set WEBCAT=%%H
 if "%%G" == "signature" set SIGNATURE=%%H
)

set PATCH_DIR=%TARGET_DIR%\patch
set PATCH_INFO_DIR=%TARGET_DIR%\patchInfo
set CATALOG_PATH=/shared%CATALOG_PATH%

REM echo %TARGET_DIR%
REM echo %OBJECT_DIR%
REM echo %ITEM%
REM echo %WEBCAT%
REM echo %SIGNATURE%
REM echo %PATCH_DIR%
REM echo %PATCH_INFO_DIR%
REM echo %ROOT_FOLDER%
REM echo %CATALOG_PATH%

set PROPERTY_TYPE_FLAG="N"
set INPUT_PROPERTY_FILE=""

setLocal EnableDelayedExpansion

for /f "tokens=* delims= " %%a in ('dir/b %OBJECT_DIR%') do (
setLocal EnableDelayedExpansion


if "%%~xa" == ".xdo" (

ECHO createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_report.xdo -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%"

REM createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_report.xdo -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%

runcat -cmd inject -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_report.xdo -signature "%SIGNATURE%" -forceOutputFile %PATCH_DIR%\%%~nxa.diff  

)

if "%%~xa" == ".xdm" (
echo "createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_datamodel.xdo -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%"

REM createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_datamodel.xdo -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%

runcat -cmd inject -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/_datamodel.xdo -signature "%SIGNATURE%" -forceOutputFile %PATCH_DIR%\%%~nxa.diff  

)

if "%%~xa" == ".rtf" (
echo "createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/%%~nxa -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%"

REM createDiff -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/%%~nxa -basefile %PATCH_DIR%\%%~nxa -patchInfo %PATCH_INFO%

runcat -cmd inject -item %OBJECT_DIR%%%~nxa -path %CATALOG_PATH%/%%~nxa -signature "%SIGNATURE%" -forceOutputFile %PATCH_DIR%\%%~nxa.diff  

)

if "%%~xa" == ".properties" (
echo INPUT_PROPERTY_FILE=%OBJECT_DIR%%%~nxa>>%PATCH_DIR%\%%~na.prop
echo FOLDER_PATH=%CATALOG_PATH%>>%PATCH_DIR%\%%~na.prop
copy %OBJECT_DIR%%%~nxa %PATCH_DIR%
)

echo done....
)
endLocal EnableDelayedExpansion

goto end

:error
echo missing argument!
goto end

echo Done.
:end
set PATCH_DIR=
set PATCH_INFO_DIR=
set ROOT_FOLDER=
set CATALOG_PATH=
set COMPOSITE_SIGNATURE=
echo TARGET_DIR=
echo OBJECT_DIR=
echo ITEM=
echo WEBCAT=
