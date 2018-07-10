//
//  BMNetworkItem.m
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-5-12.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "BMNetworkItem.h"
#import "BMNetworkHandler.h"
@implementation BMNetworkItem


- (BMNetworkItem *) initWithtype:(NetWorkType) networkType
                             url:(NSString *) url
                          params:(NSDictionary *) params
                        delegate:(id) delegate
                       hashValue:(NSUInteger) hashValue
                         showHUD:(BOOL) showHUD
                    successBlock:(NWSuccessBlock) successBlock
                    failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.params = params;
        self.delegate = delegate;
        self.hashValue = hashValue;
        self.showHUD = showHUD;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        [[BMNetworkHandler sharedInstance] addItem:self];
        DEF_DEBUG(@"BM网络请求接口url：%@\n参数：%@", url, params);
        
        
        if (showHUD)
        {
            [SVProgressHUD showWithStatus:@"加载中..."];
            
        }
        if (networkType == NetWorkGET)
        {
//            __weak BMNetworkItem *weakSelf = self;
            
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
            securityPolicy.allowInvalidCertificates = YES;
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.securityPolicy=securityPolicy;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            self.httpRequest = [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DEF_DEBUG(@"BM网络请求接口url:%@的回返数据 responseString:\n%@", url, responseObject);
                
                if (self.successBlock) {
                    self.successBlock(responseObject);
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
                if (showHUD)
                {
                    [SVProgressHUD dismiss];

                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UnityLHClass showHUDWithStringAndTime:[NSString stringWithFormat:@"%@",@"您的网络好像不给力，请稍后重试"]];
                DEF_DEBUG(@"BM网络请求接口url:%@访问错误 error:\n%@", url, error);
                if (self.failureBlock)
                {
                    self.failureBlock(error);
                }
                else
                {
               
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
                if (showHUD)
                {
                    [SVProgressHUD dismiss];
                    
                }
            }];
        }
        else if (networkType == NetWorkPOST)
        {
//            __weak BMNetworkItem *weakSelf = self;
            
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
            securityPolicy.allowInvalidCertificates = YES;
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.securityPolicy=securityPolicy;
            self.httpRequest = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DEF_DEBUG(@"BM网络请求接口url:%@的回返数据 responseString:\n%@", url, responseObject);
                
                    if (self.successBlock)
                    {
                        self.successBlock(responseObject);
               
                    }

                [[BMNetworkHandler sharedInstance] removeItem:self];
                if (showHUD)
                {
                    [SVProgressHUD dismiss];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UnityLHClass showHUDWithStringAndTime:[NSString stringWithFormat:@"%@",@"您的网络好像不给力，请稍后重试"]];
                DEF_DEBUG(@"BM网络请求接口url:%@访问错误 error:\n%@", url, error);
                if (self.failureBlock)
                {
                    self.failureBlock(error);
                }
                else
                {
                   
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
                if (showHUD)
                {
                    [SVProgressHUD dismiss];
                    
                }
            }];
        }
    }
    
    return self;
}


/**
 *  表单上传
 *
 *  @param networkType  <#networkType description#>
 *  @param url          <#url description#>
 *  @param params       <#params description#>
 *  @param images       <#images description#>
 *  @param delegate     <#delegate description#>
 *  @param hashValue    <#hashValue description#>
 *  @param showHUD      <#showHUD description#>
 *  @param successBlock <#successBlock description#>
 *  @param failureBlock <#failureBlock description#>
 *
 *  @return <#return value description#>
 */
- (BMNetworkItem *) initWithtype:(NetWorkType) networkType
                             url:(NSString *) url
                          params:(NSDictionary *) params
                          images:(NSDictionary *) images
                        delegate:(id) delegate
                       hashValue:(NSUInteger) hashValue
                         showHUD:(BOOL) showHUD
                    successBlock:(NWSuccessBlock) successBlock
                    failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.params = params;
        self.delegate = delegate;
        self.hashValue = hashValue;
        self.showHUD = showHUD;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        
        [[BMNetworkHandler sharedInstance] addItem:self];
        if (showHUD)
        {
            [SVProgressHUD showWithStatus:@"加载中..."];
            
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager POST:url
           parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
              DEF_DEBUG(@"BM网络请求接口url:%@的回返数据 responseString:\n", url);
             NSArray *allKeys = [images allKeys];
             for (int index=0; index<allKeys.count; index++)
             {
                 NSString *keyValue = allKeys[index];
                 //多图片上传
                 NSArray *imageArray = [[NSArray alloc] initWithArray:[images objectForKey:keyValue]];
                 for (int i = 0; i<imageArray.count; i++)
                 {
                     [formData appendPartWithFileData:UIImageJPEGRepresentation(imageArray[i], 0.5)
                                                 name:keyValue
                                             fileName:[NSString stringWithFormat:@"doubi%d.jpg",i]
                                             mimeType:@"image/pjpeg"]; //image/pjpeg
                 }
                 
             }
            
         }success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
               DEF_DEBUG(@"图片上传成功: %@", responseObject);
             NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             if (showHUD)
             {
                 [SVProgressHUD dismiss];
             }
             if (self.successBlock)
             {
                 self.successBlock(json);
             }
             [[BMNetworkHandler sharedInstance] removeItem:self];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (showHUD)
             {
                 [SVProgressHUD dismiss];
                 [UnityLHClass showHUDWithStringAndTime:@"您的网络好像不给力，请稍后重试"];
             }
              DEF_DEBUG(@"图片上传失败: %@", error);
             if (self.failureBlock) {
                 self.failureBlock(error);
             } else
             {
                 
             }
             [[BMNetworkHandler sharedInstance] removeItem:self];
         }];
        
        
    }
    return self;
}


//- (BMNetworkItem *) initWithtype:(NetWorkType) networkType
//                             url:(NSString *) url
//                          params:(NSDictionary *) params
//                          images:(NSDictionary *) images
//                        delegate:(id) delegate
//                       hashValue:(NSUInteger) hashValue
//                         showHUD:(BOOL) showHUD
//                    successBlock:(NWSuccessBlock) successBlock
//                    failureBlock:(NWFailureBlock) failureBlock
//{
//    if (self = [super init])
//    {
//        self.networkType = networkType;
//        self.url = url;
//        self.params = params;
//        self.delegate = delegate;
//        self.hashValue = hashValue;
//        self.showHUD = showHUD;
//        self.successBlock = successBlock;
//        self.failureBlock = failureBlock;
//        
//        [[BMNetworkHandler sharedInstance] addItem:self];
//        
//        for (NSData *image in images) {
//            DEF_DEBUG(@"图片：%@", image);
//            
////            __weak BMNetworkItem *weakSelf = self;
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                
//                for (NSString *keyString in [images allKeys])
//                {
//                    NSData *imgData = [images objectForKey:keyString];
//                    if (imgData.length > 0) {
//                        
//                        [formData appendPartWithFormData:imgData name:keyString];
//                        DEF_DEBUG(@"图片上传%@",keyString);
//                        
//                    }
//                }
//                
//            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DEF_DEBUG(@"图片上传成功: %@", responseObject);
//                if (self.successBlock) {
//                    self.successBlock(responseObject);
//                }
//                [[BMNetworkHandler sharedInstance] removeItem:self];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                DEF_DEBUG(@"图片上传失败: %@", error);
//                if (self.failureBlock) {
//                    self.failureBlock(error);
//                } else {
////                    [UIAlertView alertWithTitle:@"提示" message:@"网络异常，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                }
//                [[BMNetworkHandler sharedInstance] removeItem:self];
//            }];
//        }
//    }
//    
//    return self;
//}

- (BMNetworkItem *) initDownloadWithtype:(NetWorkType) networkType
                                     url:(NSString *) url
                                delegate:(id) delegate
                               hashValue:(NSUInteger) hashValue
                              startBlock:(NWStartBlock) startBlock
                            successBlock:(NWSuccessBlock) successBlock
                            failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.delegate = delegate;
        self.hashValue = hashValue;
    }
    
    return self;
}

@end
