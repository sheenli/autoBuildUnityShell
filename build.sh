export unity=/Applications/Unity/Unity.app/Contents/MacOS/Unity
export logFile=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/log
export buildROOT=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/project
export workspace=/Users/liulianbuxiangkafeibuku/.jenkins/workspace/newdsmj
buildforAndorid=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/buildforAndroid.sh
buildforIos=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/buildforios.sh
workspace=${workspace}/${BUILD_NUMBER}_${version}

if [ ! -d "$workspace" ];then
mkdir -p $workspace
fi

echo "$BUILD_NUMBER"
echo "开始生成包";
for a in $*
do
r=`echo $a | sed "s/--//g"`
eval $r
done

echo "version = $version"
echo "InstallVersion = $InstallVersion"
echo "channel = $channel"
echo "Collection = $Collection"
echo "ispublic = $ispublic"
echo "Trans = $Trans"

if [ "$platform" = "AND" ]; then
echo "准备生成android版本"
bash $buildforAndorid $version $ispublic $Collection $InstallVersion
elif [ "$platform" = "IOS" ];then
echo "准备生成ios版本"
bash $buildforIos $version $ispublic $Collection $InstallVersion
else
echo "准备生成所有的包"
bash $buildforAndorid $version $ispublic $Collection $InstallVersion
bash $buildforIos $version $ispublic $Collection $InstallVersion
fi
