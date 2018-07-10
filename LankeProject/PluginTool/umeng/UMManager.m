//
//  UMStatistical.m
//  LankeProject
//
//  Created by itman on 17/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "UMManager.h"
#import "WXApi.h"
@implementation UMManager

singleton_for_class(UMManager)

-(void)loadTheConfiguration
{
//    UMConfigInstance.appKey = @"57fdd666e0f55ab4b4002bc7";
//    UMConfigInstance.channelId = @"App Store";
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
//    [MobClick setLogEnabled:YES];
    //设置友盟AppKey
    [UMSocialData setAppKey:@"58d9f988ae1bf84dfc001624"];
    
    
    //设置微信AppId、appSecret，分享url
    [WXApi registerApp:@"wxbdaac583baefa412"];

    [UMSocialWechatHandler setWXAppId:@"wxbdaac583baefa412"
                            appSecret:@"56c24879a47afcf6af3adf0e7fc9d8e4"
                                  url:@"https://fir.im/mbyp"];
    
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105679791"
                               appKey:@"IffDB9o6pPrqF8lD"
                                  url:@"https://fir.im/mbyp"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaSSOHandler"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"108481842" secret:@"fbd4496d28b3790038f87be9712d7fe1" RedirectURL:@"https://fir.im/mbyp"];

}

///** 自动页面时长统计, 开始记录某个页面展示时长.
// 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
// @param pageName 统计的页面名称.
// @return void.
// */
//+ (void)beginLogPageView:(UIViewController *)pageName
//{
//    if (pageName.title.length>0)
//    {
//        [MobClick beginLogPageView:pageName.title];
//
//    }
//}
//
///** 自动页面时长统计, 结束记录某个页面展示时长.
// 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
// @param pageName 统计的页面名称.
// @return void.
// */
//+ (void)endLogPageView:(UIViewController *)pageName
//{
//    if (pageName.title.length>0)
//    {
//        [MobClick endLogPageView:pageName.title];
//        
//    }
//
//}


-(void)shareTitle:(NSString *)title shareUrl:(NSString *)url shareText:(NSString *)shareText shareImage:(UIImage *)shareImage
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialSnsService presentSnsIconSheetView:self.topViewController
                                         appKey:@"58d9f988ae1bf84dfc001624"
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];

}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode==UMSResponseCodeSuccess)
    {
        [UnityLHClass showHUDWithStringAndTime:@"分享成功"];
    }
}

@end
