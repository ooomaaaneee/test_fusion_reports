#!/bin/bash
#echo '$@'
PARAMETER_LIST=$@
LAST_COMMAD=""

for i in $PARAMETER_LIST;
do
#echo last commad : $LAST_COMMAND
#echo $i

if  [ "$LAST_COMMAND" = "-source" ]
then
DIFF_FILE=$i
fi

if  [ "$LAST_COMMAND" = "-webcat" ]
then
WEBCAT=$i
fi

if  [ "$LAST_COMMAND" = "-msgdb" ]
then
PROD_MSG_DB=$i
fi

LAST_COMMAND=$i
done

echo ORACLE_INST $ORACLE_INST

#echo $DIFF_FILE
#echo $WEBCAT

CREATE_PATCH_FILE=$DIFF_FILE.createPatch
APPLY_PATCH_FILE=$DIFF_FILE.applyPatch

#echo $CREATE_PATCH_FILE
#echo $APPLY_PATCH_FILE


# create Patch Command

echo sh runcat.sh -cmd createPatch -inputFile $DIFF_FILE -production $WEBCAT -winsConflict latest -productionMsgDB "$PROD_MSG_DB" -forceOutputFile $CREATE_PATCH_FILE

sh runcat.sh -cmd createPatch -inputFile "$DIFF_FILE" -production "$WEBCAT" -winsConflict latest -productionMsgDB "$PROD_MSG_DB" -forceOutputFile "$CREATE_PATCH_FILE"

# Apply Patch Comamnd

echo sh runcat.sh -cmd applyPatch -inputFile $CREATE_PATCH_FILE  -forceOutputFile $APPLY_PATCH_FILE  -persistNewApplicationRoles

sh runcat.sh -cmd applyPatch -inputFile "$CREATE_PATCH_FILE"  -forceOutputFile "$APPLY_PATCH_FILE"  -persistNewApplicationRoles

