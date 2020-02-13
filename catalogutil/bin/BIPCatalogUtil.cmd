@ECHO off&setlocal
REM BI Publisher Catalog Utility
REM Product Version: 11.1.1.8.0 
REM Last Update: 12/17/2013
REM File Version: 1.00
REM

SET BIP_UTIL_JARS="biputil.jar aolj.jar commons-logging.jar orai18n-mapping.jar i18nAPI_v3.jar orai18n.jar jaxrpc.jar xdo-core.jar mail.jar xdo-server.jar xmlparserv2.jar commons-discovery.jar orai18n-collation.jar versioninfo.jar xdoparser11g.jar jaxrpc-api-1-1.jar axis_bip.jar commons-logging-1-0-4.jar orawsdl-api.jar"

SET PARAMSTR=%* 

setlocal enableDelayedExpansion

set str=%PARAMSTR%

SET START_DIR=%CD%
SET BIP_CLIENT_DIR=%CD%
SET MODULE_DIR=%START_DIR%\..\..\modules

IF NOT "%ORACLE_HOME%" == "" goto ORACLE_HOME_FOUND
IF EXIST "%MODULE_DIR%"  (
   SET ORACLE_HOME=%START_DIR%\..\..
)  ELSE (
   ECHO( module directory not found
)
IF "%ORACLE_HOME%" == "" goto ORACLE_HOME_FOUND 
SET BIP_CLASSPATH=%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\javax\jaxrpc\jaxrpc.jar;%ORACLE_HOME%\..\oracle_common\modules\oracle.webservices_11.1.1\orawsdl.jar;%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\javax\jaxws\activation.jar;%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\javax\mail.jar;%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\apache\axis.jar;%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\apache\commons\commons-logging.jar;%ORACLE_HOME%\modules\oracle.bithirdparty_11.1.1\apache\commons\commons-discovery.jar;%ORACLE_HOME%\lib\xmlparserv2.jar;%ORACLE_HOME%\jlib\orai18n-collation.jar;%ORACLE_HOME%\jlib\orai18n-mapping.jar;

:ORACLE_HOME_FOUND

IF NOT "%BIP_LIB_DIR%" == "" (
  REM BIP_LIB_DIR not set
) ELSE (
  SET BIP_LIB_DIR=%BIP_CLIENT_DIR%\lib
  IF NOT EXIST "!BIP_LIB_DIR!" (
    SET BIP_LIB_DIR=%BIP_CLIENT_DIR%\..\lib
    IF NOT EXIST "!BIP_LIB_DIR!"  (
      SET BIP_LIB_DIR=%CD%\..\lib
      IF NOT EXIST "!BIP_LIB_DIR!"  (
        SET BIP_LIB_DIR=%BIP_CLIENT_DIR%
      )
    )
  )
)
REM ECHO BIP_LIB_DIR set to = %BIP_LIB_DIR%

IF NOT "%BIP_CLIENT_CONFIG%" == "" (
  REM BIP_CLIENT_CONFIG not set 
) ELSE (
  SET BIP_CLIENT_CONFIG=%BIP_CLIENT_DIR%\config
  IF NOT EXIST "!BIP_CLIENT_CONFIG!" (
    SET BIP_CLIENT_CONFIG=%BIP_CLIENT_DIR%
  )
)
REM ECHO BIP_CLIENT_CONFIG set to = %BIP_CLIENT_CONFIG%


for %%A in (%BIP_UTIL_JARS%) DO (
  if EXIST "%BIP_LIB_DIR%\%%A"  (
    REM ECHO( found file %%A   
    SET "UTIL_CLASSPATH=!BIP_LIB_DIR!\%%A;!UTIL_CLASSPATH!
    REM ECHO( !UTIL_CLASSPATH!
  )
)
REM ECHO( BIP_CLASSPATH is %BIP_CLASSPATH%

SET "BIP_CLASSPATH=!UTIL_CLASSPATH!%BIP_CLASSPATH%

SET "CLASSPATH=.;!BIP_CLASSPATH!;%CLASSPATH%"


SET JVMOPTIONS=""

SET "JVMOPTIONS=-Dbip.client.config.dir=%BIP_CLIENT_CONFIG%"

IF  "%PARAMSTR%"  == " " (
  ECHO( 
  ECHO( Usage:
  ECHO( 
  ECHO( Unzip BIP binary object:
  ECHO( BIPCatalogUtil.sh -unzipObject source=^{source_xdoz/xdmz_path^} target=^{target_directory_path^} catalogPath=^{catalog_path^} ^[overwrite=^{true^|false^}^] ^[mode=fusionapps^]
  ECHO(
  ECHO( Zip BIP object files:
  ECHO( BIPCatalogUtil.sh -zipObject source=^{source_directory_path^} target=^{target_xdoz/xdmz_path^} ^[mode=fusionapps^]
  ECHO(
  ECHO( Export BIP object from BIP Server:
  ECHO( BIPCatalogUtil.sh -export ^[bipurl=^{http://hostname:port/xmlpserver^} username=^{username^} password=^{password^}^] catalogPath=^{catalog_path_to_object^} target=^{target_filename_or_directory_path^} ^[baseDir=^{base_output_directory_path^}^] extract=^{true^|false^} ^[overwrite=^{true^|false^}^] ^[mode=fusionapps^]
  ECHO(
  ECHO( Export catalog folder contents: 
  ECHO( BIPCatalogUtil.sh -exportFolder ^[bipurl=^{http://hostname:port/xmlpserver^} username=^{username^} password=^{password^}^] catalogPath=^{catalog_path_to_folder^} baseDir=^{base_output_directory_path^} subFolders=^{true^|false^} extract=^^{true^|false^^} ^[overwrite=^^{true^|false^^}^] ^[mode=fusionapps^]
  ECHO(
  ECHO( List catalog folder contents: 
  ECHO( BIPCatalogUtil.sh -listFolder ^[bipurl=^{http://hostname:port/xmlpserver^} username=^{username^} password=^{password^}^] catalogPath=^{catalog_path_to_folder^} subFolders=^{true^|false^}
  ECHO(
  ECHO( Import BIP object to BIP Server:
  ECHO( BIPCatalogUtil.sh -import ^[bipurl=^{http://hostname:port/xmlpserver^} username=^{username^} password=^{password^}^]  baseDir=^{base_directory_path^} ^[overwrite=true^|false^] ^[mode=fusionapps^]
  ECHO(
  ECHO( Import all BIP objects from a local folder
  ECHO( BIPCatalogUtil.sh -import ^[bipurl=^{http://hostname:port/xmlpserver^} username=^{username^} password=^{password^}^] source=^{source_xdoz/xdmz_path or directory_path_of_object_files^} ^[catalogPath=^{catalog_path^}^] ^[overwrite=true^|false^] ^[mode=fusionapps^]
  ECHO(
  ECHO( Generate XLIFF from BIP file:
  ECHO( BIPCatalogUtil.sh -xliff source=^{source_file_path^} ^[target=^{target_directory_path^}^] ^[baseDir=^{base_output_directory_path^}^] ^[overwrite=^{true^|false^}^]
  ECHO(
  ECHO( Check translatability of XLIFF:
  ECHO( BIPCatalogUtil.sh -checkXliff source=^{xliff_file_path or foler_path^} ^[level=ERROR^|WARNING^] ^[mode=fusionapps^]
  ECHO(
  ECHO( Check accessibility of Template:
  ECHO( BIPCatalogUtil.sh -checkAccessibility source=^{template_file_path or foler_path^} ^[mode=fusionapps^]
  ECHO(
  ECHO( Execute Job file:
  ECHO( BIPCatalogUtil.sh ^{job_file^}.xml ^[tasks=^{task_name1^},^{task_name2^},...,^[task_nameX^}^]
  ECHO(
  ECHO( Execute TestSuite file:
  ECHO( BIPCatalogUtil.sh ^{TestSuite_file^}.xml ^[tests=^{testcase_name1^},^{testcase_name2^},...,^[testcase_nameX^}^]
  ECHO(
  ECHO(
  ECHO( Required Environment Variables: JAVA_HOME, BIP_LIB_DIR, ^(Optional^) BIP_CLIENT_CONFIG
  ECHO( Note:  Windows path format for directories  DRIVE:\\DIR\\SUBDIR   ex. c:\\mwHome\\basedir
  ECHO(
)

IF "JAVA_HOME" == "" (
  %JAVA_HOME%/bin/java %JVMOPTIONS% oracle.xdo.tools.catalog.command.CommandRunner %*
) ELSE ( 
  ECHO %JVMOPTIONS%
  java %JVMOPTIONS% oracle.xdo.tools.catalog.command.CommandRunner %*
)


