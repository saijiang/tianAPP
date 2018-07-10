//
//  AdvDetailViewController.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AdvDetailViewController.h"
#import "UMManager.h"
#import "WXApiManager.h"

@interface AdvDetailViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) UIWebView * webView;

@end

@implementation AdvDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"shareIcon"]];
    
    [self initUI];
    
    if (self.advType == 1)
    {
        [self requestHomePageAdvertDetail];
    }
    if (self.advType == 2)
    {
        
        [self requestRestaurantAdvertDetail];
    }
    if (self.advType == 3)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.externalUrl]]];
    }
    if (self.advType == 4)
    {
        [self.webView loadHTMLString:self.data baseURL:nil];
    }
}

- (void)baseRightBtnAction:(UIButton *)btn{

//    [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
    
     [[UMManager sharedUMManager] shareTitle:self.title shareUrl:@"www.baidu.com" shareText:@"航天科技" shareImage:[UIImage imageNamed:@"AppIcon"]];
    
}
     
     

#pragma mark ----------------------------------     界面初始化     ----------------------------------------
-(void)initUI
{
    UIWebView *webView=[[UIWebView alloc]init];
    webView.scrollView.bounces=NO;
    webView.delegate = self;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    
    self.webView = webView;
}


#pragma mark -
#pragma mark Network M


- (void) requestHomePageAdvertDetail{
    
    NSString * advertID = [NSString stringWithFormat:@"%@",self.data[@"id"]];
    
    [UserServices advertAdvertDetailWithId:advertID ompletionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            
            id data = responseObject[@"data"];
            NSString * title = data[@"advertName"];
            NSString * content = data[@"advertContent"];
            
            self.title = title;
            [self.webView loadHTMLString:content baseURL:nil];
            
        }else{
            // error handle here
        }
    }];
}

- (void) requestRestaurantAdvertDetail{
    
    NSString * advertID = [NSString stringWithFormat:@"%@",self.data[@"id"]];
    
    [UserServices advertDetialWithId:advertID
                     completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSString * title = [data objectForMHKey:@"advertName"];
                NSString * content = [data objectForMHKey:@"advertContent"];
                self.title = title;
                [self.webView loadHTMLString:content baseURL:nil];

            }
            
        }
        else
        {
            // error handle here
        }
    }];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
      
}

@end
