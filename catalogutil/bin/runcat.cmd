@echo off

set ORACLE_HOME=c:\build\buildtree\oraclebi\orahome
set ORACLE_INSTANCE=c:\build\buildtree\orainst
set ORACLE_BI_APPLICATION=coreapplication
set COMPONENT_NAME=coreapplication_obips1
set COMPONENT_TYPE=OracleBIPresentationServicesComponent

rem This IF is to avoid PATH being re-appended same values when executing this script in the same shell multiple times
if "%CATENVSET%"=="" (

   set PATH=%ORACLE_HOME%\bin;%ORACLE_HOME%\bifoundation\server\bin;%ORACLE_HOME%\bifoundation\web\bin;%JAVA_HOME%\bin;c:\build\buildtree\oraclebi\orahome\bifoundation\web\bin-Debug;%PATH%

)

set CATENVSET=true
rem cd %ORACLE_HOME%\bifoundation\web\catalogmanager
set CATMAN_VMARGS=-vmargs -Xmx1024M -Dosgi.clean=true -Declipse.noRegistryCache=true

if "%1"=="" (

   rem echo Running javaw
   rem Launching the catman GUI
   start javaw -jar %ORACLE_HOME%\bifoundation\web\catalogmanager\startup.jar %* %CATMAN_VMARGS%

) else (

   rem echo Running: java -jar startup.jar %* %CATMAN_VMARGS%
   rem Executing catman commandline
   java -jar %ORACLE_HOME%\bifoundation\web\catalogmanager\startup.jar %* %CATMAN_VMARGS%

)


