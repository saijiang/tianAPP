//
//  HRDivisionWebViewController.m
//  LankeProject
//
//  Created by itman on 17/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDivisionWebViewController.h"

@interface HRDivisionWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *web;

@end

@implementation HRDivisionWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业健康方案";
    
    [self requestDivisionWeb];
}

-(void)createUI
{
    self.web=[[UIWebView alloc]init];
    self.web.delegate=self;
    [self.view addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}

#pragma mark -
#pragma mark Network M

- (void) requestDivisionWeb{
    
    // 接口
    [UserServices getHealthReportWithUserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        if (result == 0) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                NSString * healthReport = data[@"healthReport"];
                [self.web loadHTMLString:healthReport baseURL:nil];
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
