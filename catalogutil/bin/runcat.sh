#!/bin/sh
ORACLE_HOME=/scratch/aime/bea1/Oracle_BI1
export ORACLE_HOME
ORACLE_INSTANCE=/scratch/aime/bea1/instances/instance1
export ORACLE_INSTANCE
ORACLE_BI_APPLICATION=coreapplication
export ORACLE_BI_APPLICATION
ODBCINI=$ORACLE_INSTANCE/bifoundation/OracleBIApplication/$ORACLE_BI_APPLICATION/setup/odbc.ini
export ODBCINI

COMPONENT_NAME=coreapplication_obips1
export COMPONENT_NAME

COMPONENT_TYPE=OracleBIPresentationServicesComponent
export COMPONENT_TYPE


JAVAHOMEBIN_DIR=$JAVA_HOME/bin
export JAVAHOMEBIN_DIR
source $ORACLE_INSTANCE/bifoundation/OracleBIApplication/$ORACLE_BI_APPLICATION/setup/user.sh



os_name=`uname -s`

case "$os_name" in
    SunOS)
        ANA_VARIANT="Solaris"
   ;;
    HP-UX)
        ANA_VARIANT="HPUX"
   ;;
    AIX)
        ANA_VARIANT="AIX"
   ;;
    Linux)
        ANA_VARIANT="Linux"
   ;;
    *)
      ANA_VARIANT="UnknownOS"
   ;;
esac

case "$ANA_VARIANT" in
    Solaris)
   if [ "$ANA_SERVER_64" = "1" ]; then
      ANA_LIB_PATH=LD_LIBRARY_PATH_64
   else
      ANA_LIB_PATH=LD_LIBRARY_PATH
   fi
   ;;
    HPUX)
   ANA_LIB_PATH=SHLIB_PATH
   ;;
    AIX)
   ANA_LIB_PATH=LIBPATH
   ;;
    Linux)
   ANA_LIB_PATH=LD_LIBRARY_PATH
   ;;
    *)
   ;;
esac

ANA_BIN_DIR=$ORACLE_HOME/bifoundation/server/bin
ANA_WEB_DIR=$ORACLE_HOME/bifoundation/web/bin
ANA_BIHOMELIB_DIR=$ORACLE_HOME/lib
if [ "$ANA_SERVER_64" = "1" ]; then
   ANA_ODBCLIB_DIR=$ORACLE_HOME/bifoundation/odbc/lib64
else
   ANA_ODBCLIB_DIR=$ORACLE_HOME/bifoundation/odbc/lib
fi


eval ${ANA_LIB_PATH}="${ANA_BIN_DIR}:${ANA_WEB_DIR}:${ANA_ODBCLIB_DIR}:${ANA_BIHOMELIB_DIR}:$JAVAHOMEBIN_DIR:/usr/lib:/lib:\$${ANA_LIB_PATH}"

PATH=${ANA_BIN_DIR}:${ANA_WEB_DIR}:${ANA_BIHOMELIB_DIR}:$JAVAHOMEBIN_DIR:$PATH

eval export ${ANA_LIB_PATH} PATH

echo PATH $PATH
echo  LD_LIBRARY_PATH $LD_LIBRARY_PATH
CATENVSET=true
export CATENVSET
#cd $ORACLE_HOME/bifoundation/web/catalogmanager
CATMAN_VMARGS="-vmargs -Xmx1024M -Dosgi.clean=true -Declipse.noRegistryCache=true"
export CATMAN_VMARGS
# Launching catman
# echo java -jar $ORACLE_HOME/bifoundation/web/catalogmanager/startup.jar $@ $CATMAN_VMARGS
java -jar $ORACLE_HOME/bifoundation/web/catalogmanager/startup.jar "$@" $CATMAN_VMARGS



