//
//  CommunityHeadInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHeadInfoViewController.h"

@interface CommunityHeadInfoViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *timeLB;
@property(nonatomic,strong)UILabel *departmentLB;
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)NSDictionary *dataSource;

@end

@implementation CommunityHeadInfoViewController

-(void)getNoticeAnnounceDetail
{
    [UserServices
     getDistrictInfoWithTitleId:self.titleId
     userId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.dataSource=responseObject[@"data"];
            [self loadViewWithDataSource];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"头条详情";
//    self.contentView.backgroundColor=BM_WHITE;
    [self createView];
    [self getNoticeAnnounceDetail];
    
}

-(void)loadViewWithDataSource
{
    self.titleLB.text=self.dataSource[@"title"];
    self.departmentLB.text=self.dataSource[@"publishUserName"];
    self.timeLB.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd" andTimeString:self.dataSource[@"publishTime"]];
    [self.web loadHTMLString:self.dataSource[@"content"] baseURL:nil];

    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_collection_select"]];
    if ([self.dataSource[@"isCollect"] integerValue]==0) {
        [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_collection_normal"]];
    }

}

-(void)createView
{
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-10)];
    bgView.backgroundColor=BM_WHITE;
    [self.contentView addSubview:bgView];
    self.titleLB=[UnityLHClass masonryLabel:nil font:16.0 color:BM_BLACK];
    self.titleLB.numberOfLines=0;
    [bgView addSubview:self.titleLB];
    
    self.timeLB=[UnityLHClass masonryLabel:nil font:13.0 color:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00]];
    [bgView addSubview:self.timeLB];
    
    self.departmentLB=[UnityLHClass masonryLabel:nil font:15.0 color:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00]];
    [bgView addSubview:self.departmentLB];
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
    }];
    
    [self.departmentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLB.mas_left);
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.departmentLB.mas_right).offset(10);
        make.centerY.mas_equalTo(self.departmentLB.mas_centerY);
    }];
    
    self.web=[[UIWebView alloc]init];
    self.web.scrollView.scrollEnabled=NO;
    self.web.delegate=self;
    [bgView addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.departmentLB.mas_bottom).offset(10);
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
-(void)baseRightBtnAction:(UIButton *)btn
{
   
    if ([self.dataSource[@"isCollect"] integerValue]==0) {
        [UserServices
         collectionHeadlthAdviceWithUserId:[KeychainManager readUserId]
         itemsId:self.titleId
         collectType:@"06"
         userName:[KeychainManager readUserName]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0) {
                 [self getNoticeAnnounceDetail];
             }else{
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
    }
    else{
        
        [UserServices
         cancelHealthAdviceWithUserId:[KeychainManager readUserId]
         itemsId:self.titleId
         collectType:@"06"
         completionBlock:^(int result, id responseObject)
        {
            if (result==0) {
                [self getNoticeAnnounceDetail];
            }else{
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }

        }];
    }

   
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
