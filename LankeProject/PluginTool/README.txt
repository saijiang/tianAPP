
/**
 *  非常重要
 *
 *  请仔细阅读项目文件目录下所有已写好的 宏、单例方法
 *
 */



/**
 *
 *  Xcode 6 下创建 PrefixHeader.pch 预载文件
 *  Build Setting -> Prefix Header -> 设置为 $(SRCROOT)/项目名/PrefixHeader.pch
 *  Build Setting -> Precompile Prefix Header 为YES
 *
 */


// 忽略警告
// 编译时，编译警告忽略掉某些文件
// 只需在在文件的Compiler Flags 中加入 -w 参数


// 使用.ttf字体的方法
// 将.ttf作为资源文件加入到项目中
// 并且在项目的 Info.plist 中加上 Fonts provided by application 这个属性，这个作为Array，在其item中加入 .ttf字体的名字+后缀


// 本地化应用程序名称：
// 1，新建一个strings文件，必需命名为 InfoPlist.strings
// 2，编辑PROJECT - Info - Localizations - 取消选中 Use Base Internationalization
// 3，编辑PROJECT - Info - Localizations - 点击+号添加需要支持的本地化语言
// 4，选中InfoPlist.strings文件，设置Localization支持需要的本地化语言
// 5，分别在InfoPlist.strings (English) 和 InfoPlist.strings (Chinese (Simplified)) 文件里写入 "CFBundleDisplayName" = "English Name"; 和 "CFBundleDisplayName" = "中文名字";



/// 所有第三方库所用到的framework



/**
 *  AFNetworking
 *
 * 	@framework
 *
 *      CFNetwork.framework
 *      SystemConfiguration.framework
 *      MobileCoreServices.framework
 *      Security.framework
 *
 *  非ARC模式下，需要对AFNetworking相关类添加 -fobjc-arc
 */


/**
 *  ASIHttpRequest
 *
 *  @framework
 *
 *      SystemConfiguration.framework
 *      MobileCoreServices.framework
 *      CFNetwork.framework
 *      CoreGraphics.framework
 *      libz.dylib
 *
 *  ARC模式下，需要对ASIHttpRequest相关类添加 -fno-objc-arc
 */


/**
 *  SRWebSocket
 *
 *  @framework
 *
 *      libicucore.dylib
 *      CFNetwork.framework
 *      Security.framework
 *      Foundation.framework
 */


/**
 *  GCDAsyncSocket
 *
 *  @framework
 *
 *      Security.framework
 *      CFNetwork.framework
 */


/**
 *  GDataXMLNode
 *  
 * 	@framework
 * 
 *      libxml2.dylib
 *	Header Search Paths 改为 ${SDKROOT}/usr/include/libxml2
 *	
 *	ARC模式下，Build Phases->Complile Sources->GDataXMLNode.m->Complier Flags设置为 -fno-objc-arc
 */


/**
 *  SVProgressHUD
 *
 *  @framework
 *
 *      QuartzCore.framework
 */


/**
 *  GPSLocationManager GPS定位
 *
 * 	@framework
 *
 *      MapKit.framework
 */


/**
 *  图片模糊效果 UIImage+MHBlur
 *
 *  @framework
 *      Accelerate.framework
 *      QuartzCore.framework
 */


/**
 *  Apple 内购
 *
 *  @framework
 *      StoreKit.framework
 */