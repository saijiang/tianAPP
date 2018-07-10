//
//  SwitchServerManager.m
//  LankeProject
//
//  Created by itman on 17/5/27.
//  Copyright © 2017年 张涛. All rights reserved.
//


#import "SwitchServerManager.h"

@interface SwitchServerManager()

@property(nonatomic,copy)NSString *currentServerUrl;

@property(nonatomic,strong)NSMutableArray *serverData;

@end

@implementation SwitchServerManager

+(instancetype)sharedInstance
{
    static SwitchServerManager *sharedSwitchServerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSwitchServerManager = [[self alloc] init];
    });
    return sharedSwitchServerManager;
    
}
//获取所有服务器
-(NSArray *)getServerUrlDataSource
{
    return self.serverData;
}
//获取当前服务器
-(NSString*)getCurrentServer
{
    return _currentServerUrl;
}
//切换当前服务器
-(void)setCurrentServer:(NSString *)server
{
    _currentServerUrl=server;
}
//传入url 获取切换服务器之后的url
-(NSString*)getServerUrlWithServerUrl:(NSString *)url
{
    NSString *serverUrl=url;
    NSString *apiSeverid=API_SEVERID;
    NSString *currenturl=self.currentServerUrl;
    serverUrl=[serverUrl stringByReplacingOccurrencesOfString:apiSeverid withString:currenturl];
    return serverUrl;
}
//添加服务器地址 传入ur
-(void)addServerUrlWithServerUrl:(NSString *)url
{
    if (!url) {
        return;
    }
    NSString *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(url != nil);
    result = nil;
    trimmedStr = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0))
    {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound)
        {
            result = [NSString stringWithFormat:@"http://%@", trimmedStr];
        }
        else
        {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) )
            {
                result = trimmedStr;
            }
            else
            {
            }
        }
    }
    if (result.length>0)
    {
        [self.serverData addObject:result];
    }
}
//所有服务器
-(NSMutableArray*)serverData
{
    if (!_serverData)
    {
        _serverData=[[NSMutableArray alloc]init];
        [_serverData addObject:@"http://175.102.18.12:8083"];//测试服务器
        [_serverData addObject:@"http://139.159.218.169:8080"];//客户服务器
        [_serverData addObject:@"http://180.163.192.17:8083"];//测试服务器

    }
    return _serverData;
}
//当前服务器
-(NSString *)currentServerUrl
{
    if (!_currentServerUrl)
    {
        _currentServerUrl=API_SEVERID;
    }
    return _currentServerUrl;
}

@end
