//
//  LaunchViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/2.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LaunchViewController.h"
#import "BMNetWorkURLs.h"
#import "BMNetworkHandler.h"

#define HK_version_getStartPage       [NSString stringWithFormat:@"%@%@",API_HOST,@"/version/getStartPage"]

#define launchImageViewURL @"applelaunchImage"

@interface LaunchViewController ()

@property (nonatomic ,strong) IBOutlet LKNetworkImageView * launchImageView;

@end

@implementation LaunchViewController

- (void)loadView
{
    [super loadView];
    NSString *urlString=(NSString *)DEF_PERSISTENT_GET_OBJECT(launchImageViewURL);
    self.launchImageView = [[LKNetworkImageView alloc] init];
    self.launchImageView.shouldShowIndicator = NO;
    if (urlString)
    {
        [self.launchImageView setImageURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        self.launchImageView.placeholderImage = [UIImage imageNamed:@"1242X2208-1.png"];//默认显示
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.launchImageView];
    [self requestLaunchInfo];
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [self.launchImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


- (void) requestLaunchInfo
{
    //设置启动页时间，不管接口成功失败
    [self performSelector:@selector(removeAdvImage) withObject:self afterDelay:3.0];

    // 启动页接口
    [[BMNetworkHandler sharedInstance] conURL:HK_version_getStartPage
                                  networkType:2
                                       params:nil
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (result == 0)
         {
             NSString * urlString = [NSString stringWithFormat:@"%@",returnData[@"data"][@"appleImage1"]];
             [self.launchImageView setImageURL:[NSURL URLWithString:urlString]];
             if (urlString)
             {
                 DEF_PERSISTENT_SET_OBJECT(urlString, launchImageViewURL);
             }
         }
         else
         {
         }
     } failureBlock:^(NSError *error)
     {

     }];
}

- (void) removeAdvImage
{
   [KAPPDELEGATE creatTabBarController];

}
@end
