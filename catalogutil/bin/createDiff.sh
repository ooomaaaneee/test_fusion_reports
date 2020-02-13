#!/bin/bash
PATCH_INFO=$@

COMPOSITE_SIGNATURE=`grep "^compositeSignature" $PATCH_INFO | cut -d"=" -f2`
TARGET_DIR=`grep "^targetDir" $PATCH_INFO | cut -d"=" -f2`
SOURCE_PATH=`grep "^path" $PATCH_INFO | cut -d"=" -f2`
OBJECT_DIR=`grep "^objectDir" $PATCH_INFO | cut -d"=" -f2`
ITEM=`grep "^item" $PATCH_INFO | cut -d"=" -f2`
SIGNATURE=`grep "^signature" $PATCH_INFO | cut -d"=" -f2`
CAPTION=`grep "^caption" $PATCH_INFO | cut -d"=" -f2`
L_CAPTION=`grep "^l_caption" $PATCH_INFO | cut -d"=" -f2`
ENGLISH_XLIFF=`grep "^englishXliff" $PATCH_INFO | cut -d"=" -f2`

OBJECT_PREFIX=`grep "^objectName" $PATCH_INFO | cut -d"=" -f2`
SECURITY_FILE=`grep "^security" $PATCH_INFO | cut -d"=" -f2`
PROPERTIES_FILE=`grep "^properties" $PATCH_INFO | cut -d"=" -f2`
DESCRIPTION=`grep "^DESCRIPTION" $PATCH_INFO | cut -d"=" -f2`
L_DESCRIPTION=`grep "^l_description" $PATCH_INFO | cut -d"=" -f2`
PATCH_TYPE=`grep "^patchType" $PATCH_INFO | cut -d"=" -f2`
NLS_LANGUAGE=`grep "^language" $PATCH_INFO | cut -d"=" -f2`

PATCH_DIR=$TARGET_DIR/patch
PATCH_INFO_DIR=$TARGET_DIR/patchInfo
ROOT_FOLDER=/shared
CAPTION="l_en="$CAPTION
DESCRIPTION="l_en="$DESCRIPTION

if  [[ "$PATCH_TYPE" = "NLS" ]];
then
CAPTION=$CAPTION:"l_"$NLS_LANGUAGE=$L_CAPTION
DESCRIPTION=$DESCRIPTION:"l_"$NLS_LANGUAGE=$L_DESCRIPTION
fi
#echo CAPTION $CAPTION
#echo $COMPOSITE_SIGNATURE
#echo $PATCH_DIR
#echo $SOURCE_PATH
#echo $OBJECT_DIR
#echo $ITEM
#echo $SIGNATURE
#echo $PATCH_INFO_DIR
#echo CAPTION $CAPTION
#echo $OBJECT_PREFIX
#echo SECURITY_FILE $SECURITY_FILE
#echo DESCRIPTION $DESCRIPTION
SOURCE_PATH=$ROOT_FOLDER$SOURCE_PATH
EXT=""
OBJECT_NAME=""
PROPERTY_TYPE_FLAG="N"
INPUT_PROPERTY_FILE=""

DIFF_FILE=$PATCH_DIR/$OBJECT_PREFIX.folderDiff
#Calling Folder Inject Command

if  [[ "$PROPERTIES_FILE" != "" ]];
then
echo sh runcat.sh  -cmd inject -path "$SOURCE_PATH" -signature "Folder" -caption "$CAPTION"  -description "$DESCRIPTION" -properties $PROPERTIES_FILE -security $SECURITY_FILE -forceOutputFile "$DIFF_FILE"

sh runcat.sh  -cmd inject -path "$SOURCE_PATH" -signature "Folder" -caption "$CAPTION"  -description "$DESCRIPTION" -properties $PROPERTIES_FILE -security $SECURITY_FILE -forceOutputFile "$DIFF_FILE"

fi
for i in $OBJECT_DIR/*;
do
#echo file  $i
OBJECT_NAME=`basename "$i"`
EXT=`echo $i | cut -d"." -f2`
#echo $fname
#echo EXT $EXT

OBJECT_PATH=$SOURCE_PATH/$OBJECT_NAME

echo OBJECT_NAME  $OBJECT_NAME
if  [ "$EXT" = "meta" ]
then
continue
fi

if  [ "$EXT" = "xlf" ]
then
if  [ "$PATCH_TYPE" != "NLS" ]
then
   if [ "$ENGLISH_XLIFF" = "false" ]
   then
   continue
   fi

fi
FOLDER_XLF=_$NLS_LANGUAGE.xlf
FOLDER_XLF=$OBJECT_PREFIX$FOLDER_XLF
META_NLS_XLF=_meta_$NLS_LANGUAGE.xlf
META_NLS_XLF=$OBJECT_PREFIX$META_XLF
echo $FOLDER_XLF
META_XLF=_meta.xlf
META_XLF=$OBJECT_PREFIX$META_XLF

if  [ "$OBJECT_NAME" = "$META_XLF" ]
then
continue
fi

if  [ "$OBJECT_NAME" = "$META_NLS_XLF" ]
then
continue
fi
    
if  [ "$PATCH_TYPE" != "NLS" ]
then
   if [ "$ENGLISH_XLIFF" = "true" ]
   then
     OBJECT_PATH=$SOURCE_PATH/$OBJECT_NAME
   fi
fi

if  [ "$PATCH_TYPE" = "NLS" ]
then
     if  [ "$COMPOSITE_SIGNATURE" = ".xss" ]
     then
      OBJECT_PATH=$SOURCE_PATH/_template_$NLS_LANGUAGE.xlf
     fi
     if  [ "$COMPOSITE_SIGNATURE" = ".xsb" ]
     then
      OBJECT_PATH=$SOURCE_PATH/_template_$NLS_LANGUAGE.xlf
     fi


  if  [ "$OBJECT_NAME" = "$FOLDER_XLF" ]
  then
   
    if  [ "$COMPOSITE_SIGNATURE" = ".xdo" ]
    then
      OBJECT_PATH=$SOURCE_PATH/bip\\~xlatxdo_$NLS_LANGUAGE.xlf
    fi
    if  [ "$COMPOSITE_SIGNATURE" = ".xdm" ]
    then
      OBJECT_PATH=$SOURCE_PATH/bip\\~xlatxdm_$NLS_LANGUAGE.xlf
    fi
    if  [ "$COMPOSITE_SIGNATURE" = ".xsb" ]
    then
      OBJECT_PATH=$SOURCE_PATH/bip\\~xlatxsb_$NLS_LANGUAGE.xlf
    fi
    if  [ "$COMPOSITE_SIGNATURE" = ".xss" ]
    then
      OBJECT_PATH=$SOURCE_PATH/bip\\~xlatxss_$NLS_LANGUAGE.xlf
    fi

  fi
fi
fi

if  [ "$EXT" = "xdo" ]
then
OBJECT_PATH=$SOURCE_PATH/_report.xdo
fi

if  [ "$EXT" = "cfg" ]
then
OBJECT_PATH=$SOURCE_PATH/xdo.cfg
fi


if  [ "$EXT" = "xdm" ]
then
OBJECT_PATH=$SOURCE_PATH/_datamodel.xdm
fi

if  [ "$EXT" = "rtf" ]
then
if  [ "$COMPOSITE_SIGNATURE" = ".xsb" ]
then
  
OBJECT_PATH=$SOURCE_PATH/_template_en.rtf
fi
fi

if  [ "$EXT" = "xsl" ]
then
if  [ "$COMPOSITE_SIGNATURE" = ".xsb" ]
then
  
OBJECT_PATH=$SOURCE_PATH/_template_en.xsl
fi
fi


if  [ "$EXT" = "rtf" ]
then
if  [ "$COMPOSITE_SIGNATURE" = ".xss" ]
then
  
OBJECT_PATH=$SOURCE_PATH/_template_en.rtf
fi
fi

if  [ "$EXT" = "xsl" ]
then
if  [ "$COMPOSITE_SIGNATURE" = ".xss" ]
then
  
OBJECT_PATH=$SOURCE_PATH/_template_en.xsl
fi
fi


ITEM=$OBJECT_DIR/$OBJECT_NAME

if  [ "$OBJECT_NAME" = "security.xml" ]
then
cp $ITEM $PATCH_DIR/$OBJECT_PREFIX"."$OBJECT_NAME
continue
fi

if  [ "$EXT" = "properties" ]
then
INPUT_PROPERTY_FILE=$ITEM
PROPERTY_TYPE_FLAG='Y'
cp  $ITEM $PATCH_DIR/$OBJECT_NAME
PROPERTY_TARGET_FOLDER=$WEBCAT/root$SOURCE_PATH	
continue
fi

DIFF_FILE=$PATCH_DIR/$OBJECT_NAME.diff

#echo $DIFF_FILE
#echo $OBJECT_PATH

#Inject Command
echo item $ITEM

echo sh runcat.sh   -cmd inject -item $ITEM -path $OBJECT_PATH -signature "$SIGNATURE"   -forceOutputFile "$DIFF_FILE"

sh runcat.sh   -cmd inject -item "$ITEM" -path "$OBJECT_PATH" -signature "$SIGNATURE"  -forceOutputFile "$DIFF_FILE"

done

