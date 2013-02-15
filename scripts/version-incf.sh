#!/bin/bash
#set -x

cd ..

###################################################
## replace in template
###################################################
rslt=`grep -r "$1-.*~a.$2" *`
file=`echo $rslt | cut -d ':' -f 1`
oldVersion=`echo $rslt | cut -d ':' -f 2 | cut -d \" -f 2 | cut -d - -f 2 | cut -d \~ -f 1`
newVersion=`expr $oldVersion + 1`
oldString=`echo $1-$oldVersion~a.$2`
newString=`echo $1-$newVersion~a.$2`
#echo [$file] [$oldString] [$oldVersion] [$newVersion] [$newString]
sed -e "s/${oldString}/${newString}/" $file > $file.tmp && mv $file.tmp $file

###################################################
## git mv
###################################################
file=`\find . -name "$1-$oldVersion.$2"`
dir=`dirname $file`
cd $dir
git mv "$1-$oldVersion.$2" "$1-$newVersion.$2"
git mv "$1-$oldVersion-min.$2" "$1-$newVersion-min.$2"
