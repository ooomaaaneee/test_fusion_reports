@echo off
REM applyPatch.cmd
REM Batch file to Apply Patch file to Web Catalog. This is invoked from BIPOrchestrationUtil.cmd 
REM 
REM Created By : Ashish Shrivastava  Date - May 20th 2010
REM 

echo inside apply Patch

echo %1 

if "%1" == "" goto error

set LC=""

if "%1" == "" goto error
rem - process each of the named files
:again
rem if %1 is blank, we are finished
if "%1" == "" goto STEP2

if  "%LC%" == "-baseFile" set BASE_INPUT_FILE=%1
rem - shift the arguments and examine %1 again

set LC=%1

shift
goto again

:STEP2
set BASE_INPUT_FILE = %BASE_INPUT_FILE%

echo applying patch  

echo "runcat.cmd -cmd applyPatch -inputFile %BASE_INPUT_FILE%.createPatch -forceOutputFile %BASE_INPUT_FILE%.applyPatch"

runcat.cmd -cmd applyPatch -inputFile %BASE_INPUT_FILE%.createPatch -forceOutputFile %BASE_INPUT_FILE%.applyPatch

echo done...

