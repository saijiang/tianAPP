//
//  CanResultsViewController.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CanResultsViewController.h"
#import "CanResultsCell.h"
#import "CanResultInfoViewController.h"
@interface CanResultsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSArray *datasource;

@end

@implementation CanResultsViewController

-(void)getDiseaseInfo
{
    [UserServices
     getDiseaseInfoWithSymptomsId:self.symptomsId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.datasource=[[NSArray alloc]initWithArray:responseObject[@"data"]];
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
    [self getDiseaseInfo];
}

- (void)createUI
{

    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    
}
- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CanResultsCell *cell=[CanResultsCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.datasource[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
    sectionView.backgroundColor=BM_WHITE;
    UIButton *canResult=[UnityLHClass masonryButton:@"可能的患病结果" imageStr:@"zice_sousuo" font:16.0 color:BM_Color_Blue];
    canResult.userInteractionEnabled=NO;
    [sectionView addSubview:canResult];
    [canResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(sectionView);
    }];
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CanResultInfoViewController *info=[[CanResultInfoViewController alloc]init];
    info.dataSource=self.datasource[indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
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
