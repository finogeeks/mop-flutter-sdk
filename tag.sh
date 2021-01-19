#!/bin/bash

version=$1
message=$2
sdkType=$3
if [ -z "$message" ]; then
   echo "============发布内容不能为空==============="
   echo "Usage: bash tag.sh 1.0.0 '发布说明文字填这里' debug"
   exit
fi


echo ${sdkType}

if [[ "$sdkType" = "debug" ]]
then
	echo "准备发版：for debug 版本"
	cp HelpFile/framework.zip FinApplet/Resources/FinApplet.bundle/framework.zip
	cp HelpFile/FATMacro_debug.h FinApplet/Common/Header/Macro/FATMacro.h
else
	echo "准备发版：for non debug 版本"
	rm -rf FinApplet/Resources/FinApplet.bundle/framework.zip
	cp HelpFile/FATMacro.h FinApplet/Common/Header/Macro/FATMacro.h
fi

git tag |xargs git tag -d
git pull --tags
git tag -d $1
git push origin --delete tag $1
git add -u && git commit -m "add tag $1"
git tag -m "$message" $1
git push --follow-tags
