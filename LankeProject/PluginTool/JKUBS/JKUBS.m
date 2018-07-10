//
//  JKUBS.m
//  Pods
//
//  Created by Jack on 17/4/5.
//
//

#import "JKUBS.h"

NSString const *JKUBSPVKey = @"PV";
NSString const *JKUBSEventKey = @"Event";
NSString const *JKUBSEventIDKey = @"EventID";
NSString const *JKUBSEventConfigKey = @"EventConfig";
NSString const *JKUBSSelectorStrKey = @"selectorStr";
NSString const *JKUBSTargetKey = @"target";

@interface JKUBS()

@property (nonatomic,strong,readwrite) NSDictionary *configureData;

@end

@implementation JKUBS
static JKUBS *_ubs =nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ubs = [JKUBS new];
    });
    return _ubs;
}

+ (void)configureDataWithJSONFile:(NSString *)jsonFilePath{
    NSData *data = [NSData dataWithContentsOfFile:jsonFilePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [JKUBS shareInstance].configureData = dic;
    if ([JKUBS shareInstance].configureData) {
        [self setUp];
    }
}

+ (void)configureDataWithPlistFile:(NSString *)plistFileName{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"]];
    [JKUBS shareInstance].configureData = dic;
    if ([JKUBS shareInstance].configureData) {
        [self setUp];
    }
}

+ (void)setUp{
    [self configPV];
    [self configEvents];
}

#pragma mark  - - - - PVConfig - - - -

+ (void)configPV{
    for (NSString *vcName in [[JKUBS shareInstance].configureData[JKUBSPVKey] allKeys]) {
        Class target = NSClassFromString(vcName);
        [target aspect_hookSelector:@selector(viewDidAppear:) withOptions:JKUBSAspectPositionAfter usingBlock:^(id data){
            [self JKhandlePV:data status:JKUBSPV_ENTER];
        } error:nil];
        [target aspect_hookSelector:@selector(viewDidDisappear:) withOptions:JKUBSAspectPositionAfter usingBlock:^(id data){
            [self JKhandlePV:data status:JKUBSPV_LEAVE];
        } error:nil];
    }
}

+ (void)JKhandlePV:(id<JKUBSAspectInfo>)data status:(JKUBSPVSTATUS)status{
    static NSString *enterTime ;

    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"JKUBSConfig.plist"];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];

    NSString *vcName = NSStringFromClass([[data instance] class]);
//    NSDictionary *dic = [JKUBS shareInstance].configureData[@"PV"][vcName];
    NSDictionary *dic = dataDic[@"PV"][vcName];
    if (status ==JKUBSPV_ENTER) {
        NSLog(@"enter data:%@",dic);
     
        enterTime = [UnityLHClass getCurrentTimeWith:@"YYYY-MM-dd HH:mm:ss"];
    
        NSDictionary *enterTimeDic = @{@"enterTime":enterTime};
        [self saveBuryingPointData:enterTimeDic withClassName:vcName];
        
        
    }else{
        NSLog(@"leave data:%@",dic);
        
        
//        [UserServices
//         getMerchantDetailInfoWithUserId:str
//         merchantId:@"12"
//         completionBlock:^(int result, id responseObject)
//         {
//             
//             if (result == 0)
//             {
//                 
//             }
//             else
//             {
//                 // error handle here
//                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//             }
//         }];
    }
    
    
}

+ (void)saveBuryingPointData:(NSDictionary *)dic withClassName:(NSString *)className{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"JKUBSConfig.plist"];

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSMutableDictionary *classDic = data[@"PV"][className];
    [classDic addEntriesFromDictionary:dic];

    //输入写入
    [data writeToFile:filename atomically:YES];

}




#pragma mark - - - - EventConfig - - - -

+ (void)configEvents{
    NSDictionary *eventsDic = [JKUBS shareInstance].configureData[JKUBSEventKey];
    NSArray *events =[eventsDic allValues];
    for (NSDictionary *dic in events) {
        NSString * EventID = dic[JKUBSEventIDKey];
        NSArray *eventConfigs = [dic[JKUBSEventConfigKey] allValues];
        for (NSDictionary *eventConfig in eventConfigs) {
            NSString *selectorStr = eventConfig[JKUBSSelectorStrKey];
            NSString *targetClass = eventConfig[JKUBSTargetKey];
            Class target =NSClassFromString(targetClass);
            if ([selectorStr hasPrefix:@"+"]) {
                selectorStr = [selectorStr substringFromIndex:1];
                SEL selector = NSSelectorFromString(selectorStr);
                [target  aspect_hookClassSelector:selector withOptions:JKUBSAspectPositionBefore usingBlock:^(id<JKUBSAspectInfo> data){
                    [self JKHandleEvent:data EventID:EventID];
                } error:nil];
            }else{
             SEL selector = NSSelectorFromString(selectorStr);
                [target aspect_hookSelector:selector withOptions:JKUBSAspectPositionBefore usingBlock:^(id<JKUBSAspectInfo> data){
                    [self JKHandleEvent:data EventID:EventID];
                } error:nil];
            }
    
        }
    }
}

+ (void)JKHandleEvent:(id<JKUBSAspectInfo>)data EventID:(NSString *)eventId{}

@end
