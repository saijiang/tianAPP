//
//  ExpenseViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ExpenseViewController.h"
#import "ExpenseCell.h"
@interface ExpenseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *testArray;
}
@property (nonatomic, strong) UITableView *tableCtrl;
@end

@implementation ExpenseViewController

-(void)getWalletDetail
{
    [UserServices
     getWalletDetailWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            testArray=responseObject[@"data"];
            [self.tableCtrl reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"data"][@"msg"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"消费记录"];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self initUI];
    [self getWalletDetail];

}

- (void)initUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, DEF_SCREEN_WIDTH, DEF_CONTENT - 15) style:UITableViewStylePlain];
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.separatorStyle = 0;
    self.tableCtrl.backgroundColor = BM_CLEAR;
    [self.view addSubview:self.tableCtrl];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = BM_WHITE;
    [tableView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tableView.mas_width);
        make.top.offset(0);
        make.height.offset(40);
    }];
    
    UILabel *nameLB = [UnityLHClass masonryLabel:@"项目" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    nameLB.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:nameLB];
    
    UILabel *timeLB = [UnityLHClass masonryLabel:@"时间" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    timeLB.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:timeLB];
    
    UILabel *priceLB = [UnityLHClass masonryLabel:@"金额" font:16.5 color:[UIColor colorWithHexString:@"#333333"]];
    priceLB.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:priceLB];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [headView addSubview:line];


    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(headView.mas_width).multipliedBy(0.3);
        make.left.offset(0);
        make.height.mas_equalTo(headView.mas_height);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(headView.mas_width).multipliedBy(0.4);
        make.left.mas_equalTo(nameLB.mas_right);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.height.mas_equalTo(headView.mas_height);
    }];
    
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(headView.mas_width).multipliedBy(0.3);
        make.right.offset(0);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.height.mas_equalTo(headView.mas_height);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-0.8);
        make.height.offset(0.8);
    }];

    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    ExpenseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[ExpenseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = BM_WHITE;
    }
    
    [cell loadCellWithDataSource:testArray[indexPath.row]];
    if (indexPath.row == testArray.count - 1)
    {
        cell.line.hidden = YES;
    }
    
    return cell;
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
