//
//  MoreCommunityDetailViewController.m
//  LankeProject
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MoreCommunityDetailViewController.h"
#import "CommunityTermsViewController.h"
@interface MoreCommunityDetailViewController ()
@property(nonatomic,strong)UIButton *termsButton;

@property(nonatomic,strong)NetworkImageView *communityIcon;

@property(nonatomic,strong)UILabel  *communityTitle;
@property(nonatomic,strong)UILabel  *communityClassification;
@property(nonatomic,strong)UILabel  *communityNum;

@property(nonatomic,strong)UILabel  *communityIntroduction;
@property(nonatomic,strong)UIImageView *biaoqianView;

@end

@implementation MoreCommunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"社区详情";
    NSLog(@"%@",self.data);
    
    
}
-(void)createUI
{
    
    self.communityIcon=[[NetworkImageView alloc]init];
    [self addSubview:self.communityIcon];
    [self.communityIcon sd_setImageWithURL:[NSURL URLWithString:self.data[@"associationImage"]]];
    [self.communityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    self.communityTitle=[UnityLHClass  masonryLabel:@"全民炫跑活动召集令" font:15.0 color:BM_BLACK];
    self.communityTitle.text=self.data[@"associationTitle"];

    [self addSubview:self.communityTitle];
    [self.communityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.communityIcon.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
    }];
    UIImageView *biaoqianView=[[UIImageView alloc]init];
    biaoqianView.image=[UIImage imageNamed:@"Community_biaoqian-1"];
    [self addSubview:biaoqianView];
    self.biaoqianView=biaoqianView;
    [biaoqianView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(self.communityTitle.mas_left);
         make.top.mas_equalTo(self.communityTitle.mas_bottom).offset(10);
         make.width.mas_equalTo(130);
         
     }];
    
    self.communityClassification=[UnityLHClass  masonryLabel:@"亲子" font:13.0 color:BM_WHITE];
    self.communityClassification.textAlignment=NSTextAlignmentCenter;
    [biaoqianView addSubview:self.communityClassification];
    self.communityClassification.text=self.data[@"className"];

    [self.communityClassification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(biaoqianView.mas_centerY);
        make.left.mas_equalTo(biaoqianView.mas_left).offset(-2);
        make.width.mas_equalTo(biaoqianView.mas_width).multipliedBy(0.5);
    }];
    
    self.communityNum=[UnityLHClass  masonryLabel:@"188人" font:13.0 color:[UIColor colorWithRed:0.98 green:0.41 blue:0.32 alpha:1.00]];
    self.communityNum.textAlignment=NSTextAlignmentCenter;
    [biaoqianView addSubview:self.communityNum];
    self.communityNum.text=[NSString stringWithFormat:@"%@人",self.data[@"userCount"]];

    [self.communityNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(biaoqianView.mas_centerY);
        make.right.mas_equalTo(biaoqianView.mas_right);
        make.width.mas_equalTo(biaoqianView.mas_width).multipliedBy(0.5);
    }];
    
    self.communityIntroduction=[UnityLHClass  masonryLabel:@"通过此次活动希望大家能泰语到运动健身中，从而懂得健康养生" font:13.0 color:BM_Color_GrayColor];
    self.communityIntroduction.numberOfLines=0;
    self.communityIntroduction.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.communityIntroduction];
    self.communityIntroduction.text=self.data[@"associationDescription"];

    [self.communityIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.communityTitle.mas_left);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH-30);
        make.top.mas_equalTo(biaoqianView.mas_bottom).offset(10);
    }];
//
    self.termsButton=[UnityLHClass masonryButton:@"加入" font:15.0 color:BM_WHITE];
    self.termsButton.backgroundColor=BM_Color_Blue;
    [self.view addSubview:self.termsButton];
    self.termsButton.frame=CGRectMake(0, DEF_SCREEN_HEIGHT-109, DEF_SCREEN_WIDTH, 45);
    
    [self.termsButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        CommunityTermsViewController *terms=[[CommunityTermsViewController alloc]init];
        terms.style=TermsStyleReading;
        terms.data=self.data;
        [self.navigationController pushViewController:terms animated:YES];
        
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
