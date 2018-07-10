//
//  MHLocalSubstitutionCache.h
//  MHProject
//
//  Created by MengHuan on 15/5/4.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//


// 用法
/*
 // 设置使用自定义Cache机制
 MHLocalSubstitutionCache *urlCache = [[MHLocalSubstitutionCache alloc] initWithMemoryCapacity:200 * 1024 * 1024
 diskCapacity:200 * 1024 * 1024
 diskPath:nil
 cacheTime:0];
 [MHLocalSubstitutionCache setSharedURLCache:urlCache];
 
 
 UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, DEF_WIDTH(self.view), DEF_HEIGHT(self.view)-20)];
 webView.delegate = self;
 [self.view addSubview:webView];
 [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]]];
*/

/*
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 
 
 // 清除缓存
 MHLocalSubstitutionCache *urlCache = (MHLocalSubstitutionCache *)[NSURLCache sharedURLCache];
 [urlCache removeAllCachedResponses];
 }
 */


#import <Foundation/Foundation.h>

@interface MHLocalSubstitutionCache : NSURLCache

@property(nonatomic, assign) NSInteger cacheTime;
@property(nonatomic, retain) NSString *diskPath;
@property(nonatomic, retain) NSMutableDictionary *responseDictionary;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity
                diskCapacity:(NSUInteger)diskCapacity
                    diskPath:(NSString *)path
                   cacheTime:(NSInteger)cacheTime;

@end
