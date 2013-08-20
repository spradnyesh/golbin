#!/bin/bash
#set -x

cd ..

###################################################
## replace in template
###################################################
rslt=`find . -name template.lisp | xargs grep "$1-.*-min.$2"`
file=`echo $rslt | cut -d ':' -f 1`
currVersion=`echo $rslt | cut -d \- -f 2`
oldVersion=`expr $currVersion - 1`
newVersion=`expr $currVersion + 1`
currString=`echo $1-$currVersion-min.$2`
newString=`echo $1-$newVersion-min.$2`
#echo [$file] [$currString] [$oldVersion] [$currVersion] [$newVersion] [$newString]
sed -e "s/${currString}/${newString}/" $file > $file.tmp && mv $file.tmp $file

###################################################
## git mv
###################################################
file=`\find . -name "$1-$currVersion-min.$2"`
dir=`dirname $file`
cd $dir
ln -s "$1-min.$2" "$1-$newVersion-min.$2"
git add "$1-min.$2"
