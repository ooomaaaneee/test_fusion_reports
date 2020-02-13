@ECHO OFF
setLocal EnableDelayedExpansion
@REM *************************************************************************
@REM Purpose: Runs BI Publisher Catalog Utility on Windows OS 
@REM Author: Dmitry Nefedkin (Dmitry.Nefedkin@oracle.com)
@REM Description: script is based on BIPCatalogUtil.sh 
@REM  found in $MW_HOME\Oracle_BI1\clients\bipublisher\ of Oracle BI EE 11.1.1.6 installation
@REM  Last changed: Oct, 25, 2012 18:00
@REM  Version: 0.1
@REM *************************************************************************
GOTO :ENDFUNCTIONS

:usage
  echo(
  echo Usage: 
  echo(
  echo Unzip BIP binary object:
  echo "BIPCatalogUtil.cmd -unzipObject source={source_xdoz/xdmz_path} target={target_directory_path} catalogPath={catalog_path} [overwrite={true|false}] [mode=fusionapps]"
  echo(
  echo Zip BIP object files:
  echo "BIPCatalogUtil.cmd -zipObject source={source_directory_path} target={target_xdoz/xdmz_path} [mode=fusionapps]"
  echo(
  echo Export BIP object from BIP Server:
  echo "BIPCatalogUtil.cmd -export [bipurl={http://hostname:port/xmlpserver} username={username} password={password}] catalogPath={catalog_path_to_object} target={target_filename_or_directory_path} [baseDir={base_output_directory_path}] extract={true|false} [overwrite={true|false}] [mode=fusionapps]"
  echo(
  echo Export catalog folder contents: 
  echo "BIPCatalogUtil.cmd -exportFolder [bipurl={http://hostname:port/xmlpserver} username={username} password={password}] catalogPath={catalog_path_to_folder} baseDir={base_output_directory_path} subFolders={true|false} extract={true|false} [overwrite={true|false}] [mode=fusionapps]"
  echo(
  echo List catalog folder contents: 
  echo "BIPCatalogUtil.cmd -listFolder [bipurl={http://hostname:port/xmlpserver} username={username} password={password}] catalogPath={catalog_path_to_folder} subFolders={true|false}"
  echo(
  echo Import BIP object to BIP Server:
  echo "BIPCatalogUtil.cmd -import [bipurl={http://hostname:port/xmlpserver} username={username} password={password}]  baseDir={base_directory_path} [overwrite=true|false] [mode=fusionapps]"
  echo(
  echo Import all BIP objects from a local folder
  echo "BIPCatalogUtil.cmd -import [bipurl={http://hostname:port/xmlpserver} username={username} password={password}] source={source_xdoz/xdmz_path or directory_path_of_object_files} [catalogPath={catalog_path}] [overwrite=true|false] [mode=fusionapps]"
  echo(
  echo Generate XLIFF from BIP file:
  echo "BIPCatalogUtil.cmd -xliff source={source_file_path} [target={target_directory_path}] [baseDir={base_output_directory_path}] [overwrite={true|false}]"
  echo(
  echo Check translatability of XLIFF:
  echo "BIPCatalogUtil.cmd -checkXliff source={xliff_file_path or foler_path} [level=ERROR|WARNING] [mode=fusionapps]"
  echo(
  echo Check accessibility of Template:
  echo "BIPCatalogUtil.cmd -checkAccessibility source={template_file_path or foler_path} [mode=fusionapps]"
  echo(
  echo Execute Job file:
  echo "BIPCatalogUtil.cmd {job_file}.xml [tasks={task_name1},{task_name2},...,[task_nameX}]"
  echo(
  echo Execute TestSuite file:
  echo "BIPCatalogUtil.cmd {TestSuite_file}.xml [tests={testcase_name1},{testcase_name2},...,[testcase_nameX}]"
  echo(
  echo Required Environment Variables: ORACLE_HOME, JAVA_HOME, BIP_LIB_DIR, (Optional) BIP_CLIENT_CONFIG
  echo(
GOTO :EOF

:ENDFUNCTIONS
if "%1"=="" (
		CALL :usage %0
		GOTO :EOF	
)

SET BIP_CLIENT_DIR=%~dp0\..

REM For sake of simplicity assume that libraries are located at %BIP_CLIENT_DIR%\..\lib
REM If you want to implement more sophisticated logic - you're welcome
SET BIP_LIB_DIR=%BIP_CLIENT_DIR%\lib

REM Add all libs from BIP_LIB_DIR to classpath
for /R %BIP_LIB_DIR% %%a in (*.jar) do (
   set BIP_CLASSPATH=!BIP_CLASSPATH!;%%a
 )
set BIP_CLASSPATH=!BIP_CLASSPATH!

REM echo BIP_CLASSPATH: %BIP_CLASSPATH%

set CLASSPATH=%BIP_CLASSPATH%;%CLASSPATH%

if "%BIP_CLIENT_CONFIG%"=="" (
  SET BIP_CLIENT_CONFIG=%BIP_CLIENT_DIR%\config
)

SET JVMOPTIONS=%JVMOPTIONS% -Dbip.client.config.dir=%BIP_CLIENT_CONFIG%
REM echo %JVMOPTIONS% 

if EXIST %JAVA_HOME% (
  %JAVA_HOME%\bin\java %JVMOPTIONS% oracle.xdo.tools.catalog.command.CommandRunner %*
) ELSE (
   echo Incorrect JAVA_HOME, please set JAVA_HOME to the directory where JDK or JRE has been installed
   GOTO :EOF   
)