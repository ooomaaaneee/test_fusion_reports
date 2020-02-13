#!/bin/bash
# 
# BI Publisher Patching Utility
# Product Version: 11.1.1.6.0 
# Last Update: 06/06/2011
# File Version: 1.21
#
#echo '$@'
PARAMETER_LIST=$@
LAST_COMMAD=""
NLS_LANGUAGE="en"
NLS="false"
TRANSLATION_SOURCE_PATH="NULL"
ENGLISH_XLIFF="false"
for i in $PARAMETER_LIST;
do
#echo $LAST_COMMAND
#echo $i

if  [ "$LAST_COMMAND" = "-cmd" ]
then
OPERATION=$i
fi

if  [ "$LAST_COMMAND" = "-source" ]
then
SOURCE_PATH=$i
fi


if  [ "$LAST_COMMAND" = "-target" ]
then
TARGET_PATH=$i
fi


if  [ "$LAST_COMMAND" = "-webcat" ]
then
WEBCAT=$i
fi

if  [ "$LAST_COMMAND" = "-securityFile" ]
then
SECURITY_FILE=$i
fi

if  [ "$LAST_COMMAND" = "-logFile" ]
then
LOG_FILE=$i
fi


if  [ "$LAST_COMMAND" = "-translationSource" ]
then
TRANSLATION_SOURCE_PATH=$i
fi

if  [ "$LAST_COMMAND" = "-language" ]
then
NLS_LANGUAGE=$i
fi

if  [ "$LAST_COMMAND" = "-nls" ]
then
NLS=$i
fi

if  [ "$LAST_COMMAND" = "-englishXliff" ]
then
ENGLISH_XLIFF=$i
fi

if  [ "$LAST_COMMAND" = "-oracleInstance" ]
then
PROD_MSG_DB=$i/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/msgdb/

fi
if  [ "$LAST_COMMAND" = "-mode" ]
then

MODE=$i
fi
LAST_COMMAND=$i
done

# Validate Input parameters

if [ -f  $SOURCE_PATH ]; then
   if  [[ "$MODE" = "folder" ||   "$MODE" = "repository" ]];
   then
      echo "Invalid parameter...  -source $SOURCE_PATH or -mode  $MODE"
     exit 1
   fi
else
   if  [ -d  $SOURCE_PATH ]; then

    if  [ "$MODE" = "object" ]; then
       echo "Invalid parameter...  -source $SOURCE_PATH or -mode  $MODE"
       exit 1
    fi
   fi
fi


echo $OPERATION$
echo $SOURCE_PATH
echo $TARGET_PATH
echo $MODE
echo $WEBCAT

# if OPERATION=all or OPERATION=createPatch, extract the source objects and  execute the diff operation.
if  [[ "$OPERATION" = "createPatch" ||   "$OPERATION" = "all"   ]];
then


PATCH_DIR=$TARGET_PATH/bip$$
echo $PATCH_DIR

mkdir -p $PATCH_DIR
mkdir -p $PATCH_DIR/patch

BIP_UTIL_JARS=" biputil.jar aolj.jar commons-lang.jar commons-logging.jar orai18n-mapping.jar orawsdl.jar i18nAPI_v3.jar orai18n.jar axis.jar jaxrpc.jar xdo-core.jar mail.jar xdo-server.jar collections.jar xmlparserv2.jar commons-discovery.jar orai18n-collation.jar versioninfo.jar xdoparser11g.jar gson-1.3.jar"

BIP_CLIENT_DIR=`dirname $0`
if [ -z $ORACLE_HOME ]; then
  if [ -d $BIP_CLIENT_DIR/../../modules ]; then
     ORACLE_HOME="$BIP_CLIENT_DIR/../.."
  fi
fi

if [ -n $ORACLE_HOME ]; then
 if [ -d $ORACLE_HOME/modules ]; then
    BIP_CLASSPATH=$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/javax/jaxrpc/jaxrpc.jar:$ORACLE_HOME/../oracle_common/modules/oracle.webservices_11.1.1/orawsdl.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/javax/jaxws/activation.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/javax/mail.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/apache/axis.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/apache/commons/commons-logging.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/apache/commons/commons-lang.jar:$ORACLE_HOME/modules/oracle.bithirdparty_11.1.1/apache/commons/commons-discovery.jar:$ORACLE_HOME/lib/xmlparserv2.jar:$ORACLE_HOME/jlib/orai18n-collation.jar:$ORACLE_HOME/jlib/orai18n-mapping.jar
  fi
fi

if [ -z $BIP_LIB_DIR ]; then
  if [ -d "./lib" ]; then
    BIP_LIB_DIR="./lib"
  elif [ -d $BIP_CLIENT_DIR/lib ]; then
    BIP_LIB_DIR=$BIP_CLIENT_DIR/lib
  elif [ -d $BIP_CLIENT_DIR/../lib ]; then
    BIP_LIB_DIR=$BIP_CLIENT_DIR/../lib
  else
    BIP_LIB_DIR=$BIP_CLIENT_DIR
  fi
fi

for i in $BIP_UTIL_JARS;
do
  BIP_UTIL_JAR=$BIP_LIB_DIR/$i
  if [ -f $BIP_UTIL_JAR ]; then
    BIP_CLASSPATH=$BIP_UTIL_JAR:$BIP_CLASSPATH
  fi
done
#echo $BIP_CLASSPATH
export CLASSPATH=$BIP_CLASSPATH:$CLASSPATH;

if [ -n "$JAVA_HOME" ];
 then
echo $JAVA_HOME/bin/java $JVMOPTIONS oracle.xdo.tools.catalog.BIPOrchestrationUtil  -source $SOURCE_PATH -target $PATCH_DIR -mode $MODE -language $NLS_LANGUAGE -nls $NLS -translationSource $TRANSLATION_SOURCE_PATH -englishXliff $ENGLISH_XLIFF 

  $JAVA_HOME/bin/java $JVMOPTIONS oracle.xdo.tools.catalog.BIPOrchestrationUtil  -source $SOURCE_PATH -target $PATCH_DIR -mode $MODE -language $NLS_LANGUAGE -nls $NLS -translationSource $TRANSLATION_SOURCE_PATH -englishXliff $ENGLISH_XLIFF 
else
echo  java $JVMOPTIONS oracle.xdo.tools.catalog.BIPOrchestrationUtil  -source $SOURCE_PATH -target $PATCH_DIR -mode $MODE  -language $NLS_LANGUAGE -nls $NLS -translationSource $TRANSLATION_SOURCE_PATH -englishXliff $ENGLISH_XLIFF

  java $JVMOPTIONS oracle.xdo.tools.catalog.BIPOrchestrationUtil  -source $SOURCE_PATH -target $PATCH_DIR -mode $MODE  -language $NLS_LANGUAGE -nls $NLS -translationSource $TRANSLATION_SOURCE_PATH -englishXliff $ENGLISH_XLIFF
fi


#if  [[ "$OPERATION" = "createPatch" ||   "$OPERATION" = "all"  ||  "$OPERATION" = "createNLSPatch"   ]];
if  [[ "$OPERATION" = "createPatch" ||   "$OPERATION" = "all" ]];
then
      SOURCE_PATH=$PATCH_DIR
fi

PATCH_DIR=$PATCH_DIR/patchInfo
echo $PATCH_DIR

if [ "$(ls -A $PATCH_DIR)" ]; then
    shopt -s nullglob
    
    for i in $PATCH_DIR/*.patchInfo;
    do
    # echo $i
           sh createDiff.sh $i
    done 
else
 echo "Error!!!  BIPOrchestrationUtil could not import repository object/s" 
fi
fi
# End of Creat Patch operation.
# if OPERATION=ALL or applyPatch, following code will exceute the createpatch and apply patch operation on the target web-cat.
#if  [ "$OPERATION" = "applyPatch" ]; then

if  [[ "$OPERATION" = "applyPatch" ||   "$OPERATION" = "all" ]];
then
PATCH_DIR=$SOURCE_PATH/patch
echo $PATCH_DIR
if [ "$(ls -A $PATCH_DIR)" ]; then
   
   # First Apply Folder diffs# 
    shopt -s nullglob
    for i in $PATCH_DIR/*.folderDiff;
    do
     echo $i
     sh applyPatch.sh -source $i -webcat $WEBCAT -msgdb $PROD_MSG_DB
    done
   # apply Object Diffs 
    for i in $PATCH_DIR/*.diff;
    do
     echo $i
     sh applyPatch.sh -source $i -webcat $WEBCAT -msgdb $PROD_MSG_DB
    done
else
 echo "Error!!!  BIPOrchestrationUtil could not apply the patch" 
fi

# Applying the folder properites #
# This logic moved to folder level injection
#if [ "$(ls -A $PATCH_DIR)" ]; then
#    shopt -s nullglob
#    
#    for i in $PATCH_DIR/*.properties;
#    do
#     #echo $i
#     FOLDER_PATH=`grep "^path" $i | cut -d"=" -f2`
#     FOLDER_PATH=/shared$FOLDER_PATH
#     echo $FOLDER_PATH
#     
#echo sh runcat.sh -cmd setItemProperties -inputFile  $i -#item "$FOLDER_PATH"  -offline $WEBCAT
#sh runcat.sh -cmd setItemProperties -inputFile  $i -item #"$FOLDER_PATH"  -offline $WEBCAT
#    done
#else
# echo "Error!!!  BIPOrchestrationUtil could not apply the #folder properties" 
#fi

fi

if  [ "$OPERATION" = "applySecurity" ]; then

echo  sh runcat.sh -cmd publisherPermissionsImport -inputFile "$SECURITY_FILE" -offline "$WEBCAT" -forceOutputFile "$LOG_FILE"


  sh runcat.sh -cmd publisherPermissionsImport -inputFile "$SECURITY_FILE" -offline "$WEBCAT" -forceOutputFile "$LOG_FILE"

fi
