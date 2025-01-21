export LANG=en_US.UTF-8
export FASTLANE_DISABLE_COLORS=1


export version="$1"
export iosVersion="$2"
export androidVersion="$3"
export buildDeploy="$4"

#version=`git describe --abbrev=0 --tags | tr -d '\\n' | tr -d '\\t'`

echo "当前版本号：${version}"
echo "依赖的iOS：${iosVersion}"
echo "依赖的Android:${androidVersion}"

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


check_ios_version() {
    if [ -f "ios/mop.podspec" ]; then
        # 使用通用的版本号匹配，可以匹配任何后缀
        local current_version=$(grep -E "s.dependency 'FinApplet'\s*,\s*'([0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.-]*)'" ios/mop.podspec | sed -E "s/.*'FinApplet'\s*,\s*'(.*)'.*/\1/")
        
        echo "找到 FinApplet 版本号: $current_version"
        
        if [[ "$current_version" == "$version" ]]; then
            echo "iOS podspec 已包含 FinApplet 版本 $version"
            return 0
        fi
    fi
    return 1
}

check_android_version() {
    if [ -f "android/build.gradle" ]; then
        # 匹配 finapplet 的版本号
        local current_version=$(grep -E "implementation 'com.finogeeks.lib:finapplet:([0-9]+\.[0-9]+\.[0-9]+[a-zA-Z0-9.-]*)'" android/build.gradle | sed -E "s/.*finapplet:(.*)'.*/\1/")
        
        echo "找到 finapplet 版本号: $current_version"
        
        if [[ "$current_version" == "$version" ]]; then
            echo "Android build.gradle 已包含 finapplet 版本 $version"
            return 0
        fi
    fi
    return 1
}

if [[ ("$iosVersionExist" == "true" && "$androidVersionExist" == "true") || (check_android_version() == 0 && check_ios_version() == 0) ]]; then
    echo "校验通过，继续执行。。。"
else
	echo "android or ios version not set, exit"
    exit 1
fi

cat pubspec.yaml

git remote add ssh-origin ssh://git@gitlab.finogeeks.club:2233/finclipsdk/finclip-flutter-sdk.git

git add .
git commit -m "release: version:$version"
git tag -d ${version}
git push ssh-origin --delete tag ${version}
git tag -a ${version} -m 'FinClip-Flutter-SDK发版'
git push ssh-origin HEAD:refs/heads/master --tags -f


#export http_proxy=http://127.0.0.1:1087
#export https_proxy=http://127.0.0.1:1087


flutter packages pub publish --dry-run --server=https://pub.dartlang.org

flutter packages pub publish --server=https://pub.dartlang.org --force

#unset http_proxy
#unset https_proxy


if [[ "$buildDeploy" == "true" ]]; then
	git remote add github ssh://git@github.com/finogeeks/mop-flutter-sdk.git

	#git push github HEAD:refs/heads/master --tags

	git push github HEAD:refs/heads/master
fi

