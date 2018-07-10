//
//  CommunityDetailViewController.m
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "CommunityDetailHeaderView.h"
#import "CommunityDetailInfoView.h"
@interface CommunityDetailViewController ()

@property(nonatomic,strong)CommunityDetailHeaderView *headerView;
@property(nonatomic,strong)CommunityDetailInfoView *infoView;
@property(nonatomic,strong)NSDictionary *dataSource;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *rightButton;

@end

@implementation CommunityDetailViewController

-(void)getCommunityActiviyDetail
{
    [UserServices
     getCommunityActiviyDetailWithActiviyId:self.activiyId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.dataSource=responseObject[@"data"];
            [self.headerView loadViewWithDataSource:self.dataSource];
            [self.infoView loadViewWithDataSource:self.dataSource[@"activityIntroduce"]];
            
        
            if([self.dataSource[@"applyStatus"] integerValue]==2){
                self.leftButton.enabled=YES;
                self.rightButton.enabled=YES;
            }

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
    [self showNavBarCustomByTitle:@"社区活动"];
//    [self showRightBarButtonItemHUDByName:@"分享"];
    [self getCommunityActiviyDetail];
}
-(void)createUI
{
    self.headerView=[[CommunityDetailHeaderView alloc]init];
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        
    }];

    self.infoView=[[CommunityDetailInfoView alloc]init];
    [self addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(10);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-60);
    }];
 
    
    self.leftButton=[UnityLHClass masonryButton:@"在线报名" font:15.0 color:BM_WHITE];
    self.leftButton.backgroundColor=[UIColor colorWithRed:0.95 green:0.73 blue:0.31 alpha:1.00];
    [self.view addSubview:self.leftButton];
    
    self.rightButton=[UnityLHClass masonryButton:@"电话报名" font:15.0 color:BM_WHITE];
     self.rightButton.backgroundColor=BM_Color_Blue;
    [self.view addSubview: self.rightButton];
    
    self.leftButton.enabled=NO;
    self.rightButton.enabled=NO;

    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    [ self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [self.leftButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self communityActivityApply];
    }];
    [ self.rightButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UnityLHClass callTel:self.dataSource[@"contactMobile"]];
    }];
    
   
}

-(void)communityActivityApply
{
    [UserServices
     communityActivityApplyWithActiviyId:self.activiyId
     userName:[KeychainManager readUserName]
     mobileNum:[KeychainManager readMobileNum]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [UnityLHClass showHUDWithStringAndTime:@"报名成功"];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

         }
    }];
}

-(void)baseRightBtnAction:(UIButton *)btn
{
    [[UMManager sharedUMManager] shareTitle:self.dataSource[@"activityTitle"] shareUrl:nil shareText:self.dataSource[@"activityDescription"] shareImage:[self curentImage]];

}
-(UIImage *)curentImage
{
    UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    return viewImage;
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
