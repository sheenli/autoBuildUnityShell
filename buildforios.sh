echo "开始生成IOS版本"
fileName=`date '+%Y%m%d%H%M%S'`
ipaname=${fileName}${RANDOM}
projectPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/project/ios/Project


ExportOptionsTranPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/ExportOptionsTran.plist
PXExportOptionsPlistPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/PXExportOptions.plist
PXExportOptionsPlistTranPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/PXExportOptionsTran.plist
SQExportOptionsPlistPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/SQExportOptions.plist
AppStoreExportOptionsPath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/AppStoreExportOptions.plist
outpath=/Users/liulianbuxiangkafeibuku/Documents/BuildProject/NewBuild/project/ios/out
SignUUID="Your SignUUID"
CODE_SIGN_IDENTITYStr="iPhone Distribution:xxxx"
if [ ! -d "${workspace}/IOS" ]; then
mkdir -p ${workspace}/IOS
fi
ipaPath=${workspace}/IOS/${fileName}.ipa
allresFiles=/Users/liulianbuxiangkafeibuku/Documents/zip
cd $projectPath
svn revert -R .
#恢复所有冲突
#svn st | while read line
#do
#p1=`echo $line | awk '{print $1}'`
#p2=`echo $line | awk '{print $2}'`
#if [ "$p2" == "C" ];then
#echo $line
#file=`echo "$line" | sed "s/^$p1     $p2 //"`
#echo "$file"
#svn revert "$file@"
#fi
#done

#恢复所有修改
#svn st | while read line
#do
#state=`echo $line | awk '{print $1}'`
#file=`echo $line | awk '{print $2}'`
#if [ "$state" == "D" ];then
#echo $file
#svn revert "$file@"
#fi
#done

#恢复所有修改
#svn st | while read line
#do
#state=`echo $line | awk '{print $1}'`
#file=`echo $line | awk '{print $2}'`
#if [ "$state" == "M" ];then
#echo $file
#svn revert "$file@"
#fi
#done
svn up

if [ -d "$projectPath" ]; then
rm -rf ${outpath}/*
else
mkdir -p $outpath
fi

if [ -d "${projectPath}/Assets/StreamingAssets" ]; then
rm -rf ${projectPath}/Assets/StreamingAssets/*
fi

if [ -d "${projectPath}/Assets/Source/Generate" ]; then
rm -rf ${projectPath}/Assets/Source/Generate/*
else
mkdir -p ${projectPath}/Assets/Source/Generate/*
fi

$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}.log -executeMethod ProjectBuild.ClearLuaFiles

$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}_GenLuaAll.log -executeMethod ProjectBuild.GenLuaAll

$unity -quit -batchmode -projectPath $projectPath -logFile ${logFile}/${ipaname}_BuildProjected.log -executeMethod ProjectBuild.BuildProjected version="$version" InstallVersion="$InstallVersion" type="IOS"  channel="$channel" Collection="$Collection" outpath="$outpath" ispublic="$ispublic" Trans="$Trans"
echo "生成Xcode完成准备生成ipa"
cd $outpath
xcodebuild clean

security unlock-keychain  -p "123456" ~/Library/Keychains/login.keychain
if [ -d $allresFiles ]; then
rm -rf ${allresFiles}/*
fi

if [ -d "${projectPath}/Assets/StreamingAssets" ]; then
cp -f ${projectPath}/Assets/StreamingAssets/*.bytes ${projectPath}/Assets/StreamingAssets/*.txt ${projectPath}/Assets/StreamingAssets/*.plist $allresFiles
zip -r ${workspace}/IOS/res.zip $allresFiles/*
fi

cd $outpath

security unlock-keychain  -p "123456" ~/Library/Keychains/login.keychain

xcodebuild clean -project Unity-iPhone.xcodeproj -configuration Release -alltargets

echo "SignUUID=$SignUUID"
echo "PlistPath=$PlistPath"
echo "CODE_SIGN_IDENTITYStr=$CODE_SIGN_IDENTITYStr"
xcodebuild archive -project Unity-iPhone.xcodeproj -scheme Unity-iPhone platform=iOS -archivePath bin/Unity-iPhone.xcarchive CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITYStr" PROVISIONING_PROFILE="$SignUUID"
echo "打包ipa"
xcodebuild -exportArchive  -exportOptionsPlist "$PlistPath" -archivePath bin/Unity-iPhone.xcarchive -exportPath bin/

if [ -f ${outpath}/bin/Apps/Unity-iPhone.ipa ]; then
cp -f ${outpath}/bin/Apps/Unity-iPhone.ipa $ipaPath
fi

#fi


