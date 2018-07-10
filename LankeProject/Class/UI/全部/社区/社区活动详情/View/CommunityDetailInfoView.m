//
//  CommunityDetailInfoView.m
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityDetailInfoView.h"

@interface CommunityDetailInfoView ()<UIWebViewDelegate>

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIWebView *web;

@end

@implementation CommunityDetailInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.title=[UnityLHClass masonryLabel:@"活动介绍" font:15.0 color:BM_BLACK];
    [self addSubview: self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    self.web=[[UIWebView alloc]init];
    self.web.delegate=self;
    self.web.scrollView.bounces=NO;
    [self addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_top).offset(-15);
        make.bottom.mas_equalTo(self.web.mas_bottom).offset(15);
        make.left.and.right.mas_equalTo(0);

    }];
}
-(void)loadViewWithDataSource:(id)data
{
    [self.web loadHTMLString:data baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   
   
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth,oldheight;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "oldheight = myimg.height;"
    "myimg.width = %f;"
    "myimg.height = oldheight/oldwidth*myimg.width;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width-30,[UIScreen mainScreen].bounds.size.width-30];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    [self.web mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(scrollHeight+10);
         
     }];

}
@end
