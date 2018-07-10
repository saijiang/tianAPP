//
//  CanResultInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CanResultInfoViewController.h"
@interface CanResultInfoViewController ()<UIWebViewDelegate>


@end

@implementation CanResultInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.dataSource[@"diseaseName"];
}

- (void)createUI
{
  

    UIWebView *info=[[UIWebView alloc]init];
    info.delegate=self;
    [self.view addSubview:info];
    [info loadHTMLString:self.dataSource[@"diseaseIntroduction"] baseURL:nil];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.5);
        make.left.and.bottom.and.right.mas_equalTo(0);

    }];
    
  
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
