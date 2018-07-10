//
//  SwitchServerManager.h
//  LankeProject
//
//  Created by itman on 17/5/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchServerManager : NSObject

+(instancetype)sharedInstance;

//获取所有服务器
-(NSArray *)getServerUrlDataSource;
//获取当前服务器
-(NSString*)getCurrentServer;
//切换当前服务器
-(void)setCurrentServer:(NSString *)server;
//传入url 获取切换服务器之后的url
-(NSString*)getServerUrlWithServerUrl:(NSString *)url;
//添加服务器地址 传入ur
-(void)addServerUrlWithServerUrl:(NSString *)url;
@end
