//
//  JDProgressDetailViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDProgressDetailViewController.h"
#import "LogisticsCell.h"

@interface JDProgressDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSDictionary *dataSource;
@property(nonatomic,strong)NSArray *logisticsList;

@end

@implementation JDProgressDetailViewController

-(void)getZiYingLogisticsInfo
{
    NSString *com=self.orderInfo[@"deliveryCompanyCom"];
    NSString *num=self.orderInfo[@"deliverySn"];
    
    
    //    NSString *com=@"shentong";
    //    NSString *num=@"3322049007100";
    
    [UserServices
     getLogisticsInfoWithCom:com
     num:num
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             _dataSource=[[NSDictionary alloc]initWithDictionary:responseObject[@"data"]];
             self.logisticsList=[[_dataSource[@"logisticsList"] reverseObjectEnumerator] allObjects];
             
             [self.tableCtrl reloadData];
             
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
    [self showNavBarCustomByTitle:@"审核进度"];
//    [self getZiYingLogisticsInfo];
    
}
-(void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}


- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;//[self.logisticsList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;//[LogisticsCell getCellHightWithDatasource:self.logisticsList[indexPath.row]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 15;
    }
    return 0.0000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell=[LogisticsCell cellWithTableView:tableView indexPath:indexPath];
    [cell loadJDCellWithDataSource:nil];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    baseView.toplineWithColor=[UIColor groupTableViewBackgroundColor];
    UIView *sectionview=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 40)];
    sectionview.backgroundColor=BM_WHITE;
    [baseView addSubview:sectionview];
    UILabel *leftTitle=[UnityLHClass masonryLabel:@"物流信息" font:15.0 color:BM_BLACK];
    [sectionview addSubview:leftTitle];
    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionview.mas_left).offset(15);
        make.centerY.mas_equalTo(sectionview.mas_centerY);
    }];
    UIImageView *line=[[UIImageView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [sectionview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.mas_equalTo(0);
        make.left.mas_equalTo(leftTitle.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    return nil;
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
