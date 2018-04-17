android=/Users/liulianbuxiangkafeibuku/Documents/android-sdk/tools/android
androidProjectName="游客学院"
echo "开始生成安卓版本"

echo "version = $version"
echo "InstallVersion = $InstallVersion"
echo "channel = $channel"
echo "Collection = $Collection"
echo "ispublic = $ispublic"
projectPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/project/and/Project
allresFiles=/Users/liulianbuxiangkafeibuku/Documents/zip
fileName=`date '+%Y%m%d%H%M%S'`
if [ ! -d "${workspace}/AND" ]; then
mkdir -p ${workspace}/AND
fi
ipaname=${fileName}${RANDOM}.apk
#if [ -d "$outpath" ]; then
#rm -rf ${outpath}/*
#else
#mkdir -p $outpath
#fi
outpath=${workspace}/AND/${fileName}.apk

cd $projectPath
svn revert -R .
svn status | grep '^a?' | sed -e 's/^.//' | xargs rm
svn status | grep '^aM' | sed -e 's/^.//' | xargs rm
svn up

if [ -d "${projectPath}/Assets/StreamingAssets" ]; then
rm -rf ${projectPath}/Assets/StreamingAssets/*
fi

if [ -d "${projectPath}/Assets/Source/Generate" ]; then
rm -rf ${projectPath}/Assets/Source/Generate/*
else
mkdir -p ${projectPath}/Assets/Source/Generate/*
fi

$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}.log -executeMethod ProjectBuild.ClearLuaFiles

$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}.log -executeMethod ProjectBuild.GenLuaAll


$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}.log -executeMethod ProjectBuild.BuildProjected version="$version" InstallVersion="$InstallVersion" type="AND" channel="$channel" Collection="$Collection" outpath="$outpath" ispublic="$ispublic" Trans="$Trans"
if [ -d $allresFiles ]; then
rm -rf ${allresFiles}/*
fi
if [ -d "${projectPath}/Assets/StreamingAssets" ]; then
cp -f ${projectPath}/Assets/StreamingAssets/*.bytes ${projectPath}/Assets/StreamingAssets/*.txt $allresFiles
zip -r ${workspace}/AND/res.zip $allresFiles/*
fi
#cd $outpath
#echo "开始生成 apk包 time: `date '+%Y%m%d%H%M%S'`"
#ls | while read line
#do
#$android update project -p $line/ -t 2
#done

#cd ${outpath}/${androidProjectName}
#cp ${buildROOT}/fsmj.keystore ${outpath}/${androidProjectName}/fsmj.keystore
#cp ${buildROOT}/ant.properties ${outpath}/${androidProjectName}/ant.properties
#$ant clean
#$ant release

#echo ${workspace}/${fileName}.apk
#if [ -f "${outpath}/${androidProjectName}/bin/UnityPlayerActivity-release.apk" ]; then
#echo "文件存在"
#cp ${outpath}/${androidProjectName}/bin/UnityPlayerActivity-release.apk ${workspace}/${fileName}.apk
#else
#echo "${outpath}/${androidProjectName}/bin/UnityPlayerActivity-release.apk"
#echo "文件不存在"
#fi
