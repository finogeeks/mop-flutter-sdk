export LANG=en_US.UTF-8
export FASTLANE_DISABLE_COLORS=1


export version="$1"
export iosVersion="$2"
export androidVersion="$3"

#version=`git describe --abbrev=0 --tags | tr -d '\\n' | tr -d '\\t'`

echo "当前版本号：${version}"
echo "依赖的iOS：${iosVersion}"
echo "依赖的Android:${androidVersion}"

#git reset --hard
#git checkout ${version}

# 更新 pubspec.yaml
cp -r pubspec.tpl.yaml pubspec.yaml
sed -i "" "s/__mop_flutter_sdk_version__/${version}/g" pubspec.yaml

# 更新iOS podspec
if [ -n "$iosVersion" ]
then
echo "更新mop.podspec====>"
cp -r ios/mop.podspec.tpl ios/mop.podspec
sed -i "" "s/__finapplet_version__/${iosVersion}/g" ios/mop.podspec

fi

# 更新android gradle
if [ -n "$androidVersion" ]
then
echo "更新build.gradle====>"
cp -r android/build.gradle.tpl android/build.gradle
sed -i "" "s/__finapplet_version__/${androidVersion}/g" android/build.gradle

fi

cat pubspec.yaml

git remote add ssh-origin ssh://git@gitlab.finogeeks.club:2233/finclipsdk/finclip-flutter-sdk.git

git add .
git commit -m "release: version:$version"
git tag -d ${version}
git push ssh-origin --delete tag ${version}
git tag -a ${version} -m 'FinClip-Flutter-SDK发版'
git push ssh-origin HEAD:refs/heads/master --tags -f


export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087


flutter packages pub publish --dry-run --server=https://pub.dartlang.org

flutter packages pub publish --server=https://pub.dartlang.org --force

unset http_proxy
unset https_proxy


git remote add github ssh://git@github.com/finogeeks/mop-flutter-sdk.git

#git push github HEAD:refs/heads/master --tags

git push github HEAD:refs/heads/master
