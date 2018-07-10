//
//  OneShopLogisticsDetailsView.m
//  LankeProject
//
//  Created by itman on 17/2/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "OneShopLogisticsDetailsView.h"
#import "LogisticsCell.h"
#import "LogisticsHeaderView.h"

@interface OneShopLogisticsDetailsView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)LogisticsHeaderView *headerView;
@property(nonatomic,strong)NSDictionary *dataSource;
@property(nonatomic,strong)NSArray *logisticsDetailList;

@end

@implementation OneShopLogisticsDetailsView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    [self addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}

-(LogisticsHeaderView *)headerView
{
    if (!_headerView)
    {
        self.headerView=[[LogisticsHeaderView alloc]initWithOneShopFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 100)];
        self.headerView.backgroundColor=BM_WHITE;
        self.headerView.toplineWithColor=[UIColor groupTableViewBackgroundColor];
        self.headerView.bottomlineWithColor=[UIColor groupTableViewBackgroundColor];
        
    }
    return _headerView;
}
- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.backgroundColor;
        self.tableCtrl.tableHeaderView=self.headerView;
    }
    return _tableCtrl;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logisticsDetailList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LogisticsCell getOneShopCellHightWithDatasource:self.logisticsDetailList[indexPath.row]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell=[LogisticsCell cellWithTableView:tableView indexPath:indexPath];
    [cell loadOneShopCellWithDataSource:self.logisticsDetailList[indexPath.row]];
    return cell;
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
//    baseView.toplineWithColor=[UIColor groupTableViewBackgroundColor];
//    UIView *sectionview=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 40)];
//    sectionview.backgroundColor=BM_WHITE;
//    [baseView addSubview:sectionview];
//    UILabel *leftTitle=[UnityLHClass masonryLabel:@"物流信息" font:15.0 color:BM_BLACK];
//    [sectionview addSubview:leftTitle];
//    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(sectionview.mas_left).offset(15);
//        make.centerY.mas_equalTo(sectionview.mas_centerY);
//    }];
//    UIImageView *line=[[UIImageView alloc]init];
//    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [sectionview addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.and.right.mas_equalTo(0);
//        make.left.mas_equalTo(leftTitle.mas_left);
//        make.height.mas_equalTo(1);
//    }];
//    
//    return baseView;
//}
-(void)loadViewWithDataSource:(id)dataSource
{
    self.dataSource=dataSource;
    self.logisticsDetailList=[[dataSource[@"logisticsDetailList"] reverseObjectEnumerator] allObjects];
    [self.headerView loadOneShopViewWithDataSource:self.dataSource];
    [self.tableCtrl reloadData];
}


@end
