//
//  MyNewInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyNewInfoViewController.h"

@interface MyNewInfoViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *timeLB;
@property(nonatomic,strong)UIWebView *web;
@end

@implementation MyNewInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"详情";
    self.contentView.backgroundColor=BM_WHITE;
}
-(void)createUI
{
    UIView *line=[[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(10.0);
    }];

    self.titleLB=[UnityLHClass masonryLabel:self.dataSource[@"title"] font:16.0 color:BM_BLACK];
    self.titleLB.numberOfLines=0;
    [self.contentView addSubview:self.titleLB];
    
    self.timeLB=[UnityLHClass masonryLabel:@"" font:13.0 color:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00]];
    [self.contentView addSubview:self.timeLB];
    self.timeLB.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd" andTimeString:self.dataSource[@"sendTime"]];

    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLB.mas_left);
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(10);
    }];
    
    self.web=[[UIWebView alloc]init];
    self.web.scrollView.scrollEnabled=NO;
    self.web.delegate=self;
    [self.contentView addSubview:self.web];
    [self.web loadHTMLString:self.dataSource[@"content"] baseURL:nil];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLB.mas_left).offset(-5);
        make.right.mas_equalTo(self.titleLB.mas_right).offset(5);
        make.top.mas_equalTo(self.timeLB.mas_bottom).offset(10);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    [self.web mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(scrollHeight+10);
         
     }];
    
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
