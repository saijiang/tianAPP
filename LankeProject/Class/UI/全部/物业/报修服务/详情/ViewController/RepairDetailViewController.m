//
//  RepairDetailViewController.m
//  LankeProject
//
//  Created by itman on 17/5/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "RepairDetailViewController.h"
#import "SelectedPhotoView.h"
@interface RepairDetailViewController ()

@property(nonatomic,strong)UILabel *repairArea;
@property(nonatomic,strong)UILabel *repairType;
@property(nonatomic,strong)UILabel *repairAddress;
@property(nonatomic,strong)UILabel *repairContent;
@property(nonatomic,strong)SelectedPhotoView * photo;

@end

@implementation RepairDetailViewController

-(void)getRepairRecordDetail
{
    [UserServices
     getRepairRecordDetailWithRepairId:self.repairId
     completionBlock:^(int result, id responseObject)
     {
        if (result==0)
        {
            [self createView:responseObject[@"data"]];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"报修详情"];
    [self getRepairRecordDetail];
}
-(void)createView:(NSDictionary *)dataSource
{
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=BM_WHITE;
    [self addSubview:headerView];
    
    NSString *repairAreaString=@"报修区域：  ";
//    repairArea 	string 	报修区域（01：住宅区域， 02：科研办公区域）
//    repairTypeFirst 	string 	报修一级分类（01：公共报修 ， 02：室内报修）
    
    if ([dataSource[@"repairArea"] integerValue]==1)
    {
       repairAreaString= [repairAreaString stringByAppendingString:@"住宅区域"];
    }
    else
    {
       repairAreaString= [repairAreaString stringByAppendingString:@"科研办公区域"];
    }
    
    
    UILabel *repairArea=[UnityLHClass masonryLabel:repairAreaString font:15.0 color:BM_BLACK];
    [headerView addSubview:repairArea];
    self.repairArea=repairArea;
    [repairArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_top).offset(15);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    
    NSString *repairTypeString=@"报修类型：  ";
    NSString *repairContentTypeString=@"室";

    if ([dataSource[@"repairTypeFirst"] integerValue]==1)
    {
        repairTypeString= [repairTypeString stringByAppendingString:@"公共报修"];
        repairContentTypeString=@"公";
    }
    else
    {
        repairTypeString= [repairTypeString stringByAppendingString:@"室内报修"];
        repairContentTypeString=@"室";
    }
    repairTypeString= [repairTypeString stringByAppendingString:@"  "];
    repairTypeString= [repairTypeString stringByAppendingString:dataSource[@"repairTypeSecond"]];
    UILabel *repairType=[UnityLHClass masonryLabel:repairTypeString font:15.0 color:BM_BLACK];
    [headerView addSubview:repairType];
    self.repairType=repairType;
    [repairType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repairArea.mas_bottom).offset(15);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    NSString *repairAddressString=@"维修地点：  ";
    repairAddressString= [repairAddressString stringByAppendingString:dataSource[@"repairAddress"]];

    UILabel *repairAddress=[UnityLHClass masonryLabel:repairAddressString font:15.0 color:BM_BLACK];
    [headerView addSubview:repairAddress];
    repairAddress.numberOfLines=0;
    self.repairAddress=repairAddress;
    [repairAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repairType.mas_bottom).offset(15);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(repairAddress.mas_bottom).offset(15);
    }];

    UIView *centerView=[[UIView alloc]init];
    centerView.backgroundColor=BM_WHITE;
    [self addSubview:centerView];
    
    UILabel *repairContentType=[UnityLHClass masonryLabel:repairContentTypeString font:15.0 color:BM_WHITE];
    [centerView addSubview:repairContentType];
    repairContentType.backgroundColor=BM_ORANGE;
    repairContentType.textAlignment=NSTextAlignmentCenter;
    repairContentType.layer.masksToBounds=YES;
    repairContentType.layer.cornerRadius=5;
    [repairContentType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_top).offset(15);
        make.left.mas_equalTo(15);
        make.width.and.height.mas_equalTo(20);
    }];
    UILabel *repairContent=[UnityLHClass masonryLabel:[NSString stringWithFormat:@"%@",dataSource[@"repairContent"]] font:15.0 color:BM_BLACK];
    [centerView addSubview:repairContent];
    repairContent.numberOfLines=0;
    self.repairContent=repairContent;
    [repairContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_top).offset(15);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(repairContentType.mas_right).offset(10);
    }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(repairContent.mas_bottom).offset(15);
    }];
    
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=BM_WHITE;
    [self addSubview:bottomView];
    
    self.photo=[[SelectedPhotoView alloc]initWithFrame:CGRectMake(10,15, DEF_SCREEN_WIDTH-10*2, 100) withImageArr:dataSource[@"imageArr"]];
    self.photo.maxColumn=3;
    self.photo.maxImageCount=4;
    [bottomView addSubview:self.photo];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.photo.mas_bottom).offset(15);
    }];
    
    if ([dataSource[@"imageArr"] count]==0) {
        bottomView.hidden=YES;
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
