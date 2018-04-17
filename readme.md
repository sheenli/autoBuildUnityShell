## 使用方法
修改所有脚本里面的路径为你自己的地址

```

workspace=${workspace}/${BUILD_NUMBER}_${version}

```
> 这个东西因为我是用jenkins调用的所以有BUILD_NUMBER和version
> 此处修改成自己要生成的地址就可以

bash build.sh 参数1名称=参数1值 参数2名称=参数2值 ...

之后会调用unity工程里面的 ProjectBuild.cs里面相应函数

>例如 -executeMethod ProjectBuild.ClearLuaFiles
>那就是调用 ProjectBuild 里面的 ClearLuaFiles方法

获取参数值的方法参考ProjectBuild.cs文件


## 目录结构

- build.sh 总入口
- buildforAndroid.sh 安卓生成的脚本里面有ant打包
- buildforios.sh ios生成的脚本包含生成xcode工程和生成ipa