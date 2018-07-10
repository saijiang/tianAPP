//
//  VersionUpdateManager.m
//  LankeProject
//
//  Created by itman on 17/5/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "VersionUpdateManager.h"

@interface VersionUpdateManager()

@property(nonatomic,assign)BOOL update;//更新状态

@end

@implementation VersionUpdateManager

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        //初始化
        _update=NO;//没有更新
    }
    return self;
}

+ (VersionUpdateManager *)sharedVersionUpdateManager
{
    static VersionUpdateManager *sharedVersionUpdateManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVersionUpdateManager = [[self alloc] init];
    });
    return sharedVersionUpdateManager;
    
}
- (void)versionUpdate
{
    if (self.update)
    {
        //点击了
        return;
    }
//    参数名 	类型 	说明
//    status 	int 	返回状态 0成功 1失败
//    msg 	string 	返回处理信息
//    id 	string 	版本编号
//    version 	int 	版本号
//    updateContent 	string 	更新内容
//    installPackage 	string 	安装包路径
//    way 	string 	是否强制更新：0、否，1、是
//  https://fir.im/unys fir更新连接
    [UserServices
     upVersionWithcompletionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]])
            {
                return ;
            }
            NSDictionary *dataSource=responseObject[@"data"];
            NSString *version=DEF_Version;
            NSString *way=dataSource[@"way"];
            if ([dataSource[@"version"] floatValue]>[version floatValue])
            {
                if ([way integerValue]==1)
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"发现新版本确认去更新？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                        _update=YES;
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/mbyp"]];

                    }];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"发现新版本确认去更新？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    [alert showWithCompletionHandler:^(NSInteger buttonIndex)
                    {
                        _update=YES;
                        if (buttonIndex==1)
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/mbyp"]];
                        }
                    }];
                }
                
            }
        }
    }];
}
@end
