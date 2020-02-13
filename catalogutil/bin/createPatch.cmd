@echo off
REM createPatch.cmd
REM Batch file to create Patch file for Web Catalog. This is invoked from BIPOrchestrationUtil.cmd 
REM 
REM Created By : Ashish Shrivastava  Date - May 20th 2010
REM 


if "%1" == "" goto error

set LC=""

if "%1" == "" goto error
rem - process each of the named files
:again
rem if %1 is blank, we are finished
if "%1" == "" goto STEP2

if  "%LC%" == "-baseFile" set BASE_INPUT_FILE=%1
if  "%LC%" == "-webcat" set WEBCAT=%1 
rem - shift the arguments and examine %1 again

set LC=%1

shift
goto again

:STEP2

echo Creating Patch File...

set BASE_INPUT_FILE = %BASE_INPUT_FILE%

echo "runcat.cmd -cmd createPatch -inputFile %BASE_INPUT_FILE%.diff -production %WEBCAT% -winsConflict latest -forceOutputFile %BASE_INPUT_FILE%.createPatch"

runcat.cmd -cmd createPatch -inputFile %BASE_INPUT_FILE%.diff -production %WEBCAT% -winsConflict latest -forceOutputFile %BASE_INPUT_FILE%.createPatch


set BASE_INPUT_FILE=

echo Create Patch file completed... %BASE_INPUT_FILE%.createPatch
