//
//  JDAddressViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDAddressViewController.h"
#import "JDAddressCell.h"
#import "NewJDAddressViewController.h"
@interface JDAddressViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableCtrl;
@property (nonatomic, strong) NSMutableArray *tableArr;



@end

@implementation JDAddressViewController

-(NSMutableArray *)tableArr
{
    if (!_tableArr)
    {
        _tableArr=[[NSMutableArray alloc]init];
    }
    return _tableArr;
}

-(void)getAddressList
{
    [UserServices
     getJDAddressListWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.tableArr removeAllObjects];
             [self.tableArr addObjectsFromArray:responseObject[@"data"]];
             [self.tableCtrl reloadData];
             
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self getAddressList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"京东收货地址"];
    self.view.backgroundColor = BM_WHITE;
    [self.view addSubview:self.tableCtrl];
    
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(addAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"UserCenter-Add"] forState:UIControlStateNormal];
    [addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    //    addBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0);
    //    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addBtn setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    [addBtn setBackgroundColor:BM_WHITE];
    addBtn.titleLabel.font = BM_FONTSIZE(15.0);
    [self.view addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.tableCtrl.mas_bottom);
        make.height.offset(60);
    }];
    
}

-(UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT -60) style:UITableViewStyleGrouped];
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.emptyDataSetSource = self;
        self.tableCtrl.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        self.tableCtrl.separatorStyle = 0;
    }
    
    return _tableCtrl;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    JDAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[JDAddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = BM_WHITE;
        
    }
    id addressData = self.tableArr[indexPath.section];
    
    [cell receiveObject:^(id object) {
        
        if ([object integerValue]==1)
        {
            NewJDAddressViewController*address = [[NewJDAddressViewController alloc] init];
            address.data = addressData;
            [self.navigationController pushViewController:address animated:YES];
        }
        else
        {
            [self performSelector:@selector(getAddressList) withObject:nil afterDelay:0.2];
            
        }
    }];
    
    [cell loadCellWithDataSource:addressData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bSelectAddressHandle) {
        self.bSelectAddressHandle(self.tableArr[indexPath.section]);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)addAddressAction:(UIButton *)sender
{
    NewJDAddressViewController *address = [[NewJDAddressViewController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
}
#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -100);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
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

