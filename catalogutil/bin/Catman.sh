#!/bin/bash
#PATCH_INFO=$@
PATCH_INFO=$1
WEBCAT=$2
COMPOSITE_SIGNATURE=`grep "^compositeSignature" $PATCH_INFO | cut -d"=" -f2`
TARGET_DIR=`grep "^targetDir" $PATCH_INFO | cut -d"=" -f2`
SOURCE_PATH=`grep "^path" $PATCH_INFO | cut -d"=" -f2`
OBJECT_DIR=`grep "^objectDir" $PATCH_INFO | cut -d"=" -f2`
ITEM=`grep "^item" $PATCH_INFO | cut -d"=" -f2`
#WEBCAT=`grep "^webCatalog" $PATCH_INFO | cut -d"=" -f2`
SIGNATURE=`grep "^signature" $PATCH_INFO | cut -d"=" -f2`

PATCH_DIR=$TARGET_DIR/patch
PATCH_INFO_DIR=$TARGET_DIR/patchInfo
ROOT_FOLDER=/shared
echo $COMPOSITE_SIGNATURE
echo $PATCH_DIR
echo $SOURCE_PATH
echo $OBJECT_DIR
echo $ITEM
echo $WEBCAT
echo $SIGNATURE
echo $PATCH_INFO_DIR
SOURCE_PATH=$ROOT_FOLDER$SOURCE_PATH
EXT=""
OBJECT_NAME=""
PROPERTY_TYPE_FLAG="N"
INPUT_PROPERTY_FILE=""

for i in $OBJECT_DIR/*;
do
echo $i
OBJECT_NAME=`basename $i`
EXT=`echo $i | cut -d"." -f2`
echo $fname
echo $EXT

OBJECT_PATH=$SOURCE_PATH/$OBJECT_NAME

echo OBJECT_NAME  $OBJECT_NAME
if  [ "$EXT" = "meta" ]
then
continue
fi

if  [ "$EXT" = "xlf" ]
then
continue
fi

if  [ "$EXT" = "xdo" ]
then
OBJECT_PATH=$SOURCE_PATH/_report.xdo
fi


if  [ "$EXT" = "xdm" ]
then
OBJECT_PATH=$SOURCE_PATH/_datamodel.xdm
fi


ITEM=$OBJECT_DIR/$OBJECT_NAME

if  [ "$EXT" = "properties" ]
then
INPUT_PROPERTY_FILE=$ITEM
PROPERTY_TYPE_FLAG='Y'
PROPERTY_TARGET_FOLDER=$WEBCAT/root$SOURCE_PATH	
continue
fi

DIFF_FILE=$PATCH_DIR/$OBJECT_NAME.diff
CREATE_PATCH_FILE=$PATCH_DIR/$OBJECT_NAME.createPatch
APPLY_PATCH_FILE=$PATCH_DIR/$OBJECT_NAME.applyPatch

echo $DIFF_FILE
echo $CREATE_PATCH_FILE
echo $APPLY_PATCH_FILE
echo $OBJECT_PATH

#Inject Command
echo item $ITEM
sh runcat.sh   -cmd inject -item $ITEM -path $OBJECT_PATH -signature "$SIGNATURE" -forceOutputFile $DIFF_FILE

# create Patch Command


sh runcat.sh -cmd createPatch -inputFile $DIFF_FILE -production $WEBCAT -winsConflict latest  -forceOutputFile $CREATE_PATCH_FILE

# Apply Patch Comamnd

sh runcat.sh -cmd applyPatch -inputFile $CREATE_PATCH_FILE  -forceOutputFile $APPLY_PATCH_FILE

done

echo $PROPERTY_TYPE_FLAG

if  [ "$PROPERTY_TYPE_FLAG" = "Y" ]
then
echo "Applying folder properties..."
 echo sh runcat.sh -cmd setItemProperties -inputFile  $INPUT_PROPERTY_FILE -item $SOURCE_PATH  -offline $WEBCAT 
 sh runcat.sh -cmd setItemProperties -inputFile  $INPUT_PROPERTY_FILE -item $SOURCE_PATH  -offline $WEBCAT 
fi
