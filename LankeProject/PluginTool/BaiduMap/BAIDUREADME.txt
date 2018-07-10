
/**
 *   注意事项 iOS SDK
 *
 */


1、静态库中采用ObjectC++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即在Xcode的Project -> Edit Active Target -> Build Setting 中找到 Compile Sources As，并将其设置为"Objective-C++"

2、如果您只在Xib文件中使用了BMKMapView，没有在代码中使用BMKMapView，编译器在链接时不会链接对应符号，需要在工程属性中显式设定：在Xcode的Project -> Edit Active Target -> Build Setting -> Other Linker Flags中添加-ObjC

3、授权Key的申请：新、旧Key之间不可通用，即新Key只可以使用在v2.0.2及后续版本的SDK中，旧的Key只适用于v2.0.1及之前版本的SDK；如果还没有授权Key，请 申请密钥

4、自v3.2.0起，百度地图iOS SDK全面支持HTTPS，需要广大开发者导入第三方openssl静态库：libssl.a和libcrypto.a（SDK打好的包存放于thirdlib目录下）

添加方法：在 TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择libssl.a和libcrypto.a添加到工程中 。}}

5、如果在iOS9中使用了调起百度地图客户端功能，必须在"Info.plist"中进行如下配置，否则不能调起百度地图客户端。

<key>LSApplicationQueriesSchemes</key>
<array>
<string>baidumap</string>
</array>

6、管理地图的生命周期：自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate，代码如下：

(void)viewWillAppear:(BOOL)animated
{
[_mapView viewWillAppear];
_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
[_mapView viewWillDisappear];
_mapView.delegate = nil; // 不用时，置nil
}

7、自iOS SDK v2.5.0起，为了对iOS8的定位能力做兼容，做了相应的修改，开发者在使用过程中注意事项如下：

需要在info.plist里添加（以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription）：

NSLocationWhenInUseUsageDescription ，允许在前台使用时获取GPS的描述

NSLocationAlwaysUsageDescription ，允许永久使用GPS的描述

8、在使用Xcode6进行SDK开发过程中，需要在info.plist中添加：Bundle display name ，且其值不能为空（Xcode6新建的项目没有此配置，若没有会造成manager start failed）

9、百度地图iOS SDK v2.5.0起，对arm64进行了支持适配，开发包体积有所增加。但根据开发者在研发过程中的选择，最终生成的APP体积并不会发生较大的变化。

10、确认项目中添加mapapi.bundle文件以及添加方法正确，不能删除或随意更改其中files文件夹下的内容：

注：mapapi.bundle中存储了定位、默认大头针标注View及路线关键点的资源图片，还存储了矢量地图绘制必需的资源文件。

如果您不需要使用内置的图片显示功能，则可以删除bundle文件中的image文件夹。您也可以根据具体需求任意替换或删除该bundle中image文件夹的图片文件。

添加方式：将mapapi.bundle拷贝到您的工程目录，直接将该bundle文件托拽至Xcode工程左侧的Groups&Files中即可。

若您需要替换定位、指南针的图标，请保留原文件名称，否则不显示替换的新图片，默认大头针标注与路线关键点的新图片名称可自定义名称。

11、注意BMKManager对象的生命周期管理，在使用地图SDK期间不能释放该对象，尤其在arc情况下注意避免提前被自动释放，否则，该对象一旦被释放，网络模块将不可用，地图无法加载，检索失败。

12、app在前后台切换时，需要使用下面的代码停止地图的渲染和openGL的绘制（V2.10.0后不需要再调用）：

- (void)applicationWillResignActive:(UIApplication *)application {
[BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
[BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}
