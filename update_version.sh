export LANG=en_US.UTF-8
export FASTLANE_DISABLE_COLORS=1


# 接收参数并去除可能的引号
version=$1
iosVersion=$2
androidVersion=$3

#version=`git describe --abbrev=0 --tags | tr -d '\\n' | tr -d '\\t'`

echo "当前版本号：${version}"
echo "依赖的iOS：${iosVersion}"
echo "依赖的Android:${androidVersion}"

git reset --hard
#git checkout ${version}

# 更新 pubspec.yaml
cp -r pubspec.tpl.yaml pubspec.yaml
sed -i "" "s/__mop_flutter_sdk_version__/${version}/g" pubspec.yaml

# 更新iOS podspec
if [[ -n "$iosVersion" && "$iosVersion" != "none" ]]; then
    echo "更新mop.podspec====>"
    cp -r ios/mop.podspec.tpl ios/mop.podspec
    sed -i "" "s/__finapplet_version__/${iosVersion}/g" ios/mop.podspec
else
    echo "跳过 iOS podspec 更新（未设置版本号）"
fi

# 更新android gradle
if [[ -n "$androidVersion" && "$androidVersion" != "none" ]]; then
    echo "更新build.gradle====>"
    cp -r android/build.gradle.tpl android/build.gradle
    sed -i "" "s/__finapplet_version__/${androidVersion}/g" android/build.gradle
else
    echo "跳过 Android gradle 更新（未设置版本号）"
fi

# git remote add ssh-origin ssh://git@gitlab.finogeeks.club:2233/finclipsdk/finclip-flutter-sdk.git

# git add .
# git commit -m "update version:$version"
# git push ssh-origin 
