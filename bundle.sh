export LANG=en_US.UTF-8
export FASTLANE_DISABLE_COLORS=1


export version="$1"
export iosVersion="$2"
export androidVersion="$3"
export branch=$4

#version=`git describe --abbrev=0 --tags | tr -d '\\n' | tr -d '\\t'`

echo "当前版本号：${version}"
echo "依赖的iOS：${iosVersion}"
echo "依赖的Android:${androidVersion}"
echo "branch: $branch"

git reset --hard
#git checkout ${version}

# 更新 pubspec.yaml
cp -r pubspec.tpl.yaml pubspec.yaml
sed -i "" "s/__mop_flutter_sdk_version__/${version}/g" pubspec.yaml

iosVersionExist=false
androidVersionExist=false

# 更新iOS podspec
if [[ -n "$iosVersion" && "$iosVersion" != "none" ]]; then
	iosVersionExist=true
    echo "更新mop.podspec====>"
    cp -r ios/mop.podspec.tpl ios/mop.podspec
    sed -i "" "s/__finapplet_version__/${iosVersion}/g" ios/mop.podspec
else
    echo "跳过 iOS podspec 更新（未设置版本号）"
fi

# 更新android gradle
if [[ -n "$androidVersion" && "$androidVersion" != "none" ]]; then
	androidVersionExist=true
    echo "更新build.gradle====>"
    cp -r android/build.gradle.tpl android/build.gradle
    sed -i "" "s/__finapplet_version__/${androidVersion}/g" android/build.gradle
else
    echo "跳过 Android gradle 更新（未设置版本号）"
fi

git remote add ssh-origin ssh://git@gitlab.finogeeks.club:2233/finclipsdk/finclip-flutter-sdk.git

git add .
git commit -m "release: version:$version"
git push ssh-origin HEAD:refs/heads/${branch}

# 主要发布流程
do_publish() {
    cat pubspec.yaml

    git add .
	git commit -m "release: version:$version"
	git tag -d ${version}
	git push ssh-origin --delete tag ${version}
	git tag -a ${version} -m 'FinClip-Flutter-SDK发版'
	git push ssh-origin --tags -f


	export http_proxy=http://127.0.0.1:1087
	export https_proxy=http://127.0.0.1:1087


	flutter packages pub publish --dry-run --server=https://pub.dartlang.org

	flutter packages pub publish --server=https://pub.dartlang.org --force

	unset http_proxy
	unset https_proxy

	# 在执行 GitHub 相关操作之前添加分支检查
	if [ "$branch" = "master" ]; then
	    echo "当前在 master 分支，继续执行 GitHub 推送..."
	    git remote add github ssh://git@github.com/finogeeks/mop-flutter-sdk.git

	    #git push github HEAD:refs/heads/master --tags

	    git push github HEAD:refs/heads/master
	else
	    echo "当前分支是 ${branch}，不是 master 分支，跳过 GitHub 推送操作"
	fi
}

echo "iosVersionExist: $iosVersionExist"
echo "androidVersionExist: $androidVersionExist"

# 使用更明确的条件判断
if [ "$iosVersionExist" = "true" ] && [ "$androidVersionExist" = "true" ]; then
    echo "新版本号均有设置--通过"
    do_publish
else
	echo " ❌❌❌ android or ios version not set, exit"
fi


