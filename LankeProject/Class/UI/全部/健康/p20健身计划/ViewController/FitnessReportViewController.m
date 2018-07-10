//
//  FitnessReportViewController.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessReportViewController.h"
#import "FitReportCell.h"
#import "DishesDetailContentCell.h"
@interface FitnessReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)DishesDetailContent * tempConetnt;

@end

@implementation FitnessReportViewController

-(void)getFitnessDetail
{
    [UserServices
     getFitnessDetailWithFitnessId:self.fitnessId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            _tempConetnt.data=responseObject[@"data"];
            [self.tableCtrl reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"查看报告"];
    [self getFitnessDetail];
}

- (void)createUI
{
    _tempConetnt = [[DishesDetailContent alloc] init];
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    [self.tableCtrl registerClass:[DishesDetailContentCell class]
           forCellReuseIdentifier:[DishesDetailContentCell cellIdentifier]];
    
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
         return 300;
    }
    else
    {
        return [DishesDetailContentCell cellHeightWithData:_tempConetnt];
 
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        FitReportCell *cell=[FitReportCell cellWithTableView:tableView];
        [cell loadCellWithDataSource:_tempConetnt.data];
        return cell;
    }
    else
    {
        DishesDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailContentCell cellIdentifier] forIndexPath:indexPath];
        cell.content = _tempConetnt;
        cell.displayLabel.text = @"建议内容";
        [cell configCellForFitnessDetail:_tempConetnt.data];
        cell.bCellHeightChangedBlock = ^(){
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return cell;
    }
  
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
