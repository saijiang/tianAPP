//
//  PropertyPayViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayViewController.h"
#import "PropertyInfoHeaderView.h"
#import "PropertyBillCell.h"
#import "PropertyPaySingleViewController.h"
#import "PropertyPayBillViewController.h"
#import "PropertyPayHistoryViewController.h"

#import "PropertyBillModel.h"

@interface PropertyPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) PropertyInfoHeaderView * headerView;
@property (nonatomic ,strong) UITableView * payTableView;
@property (nonatomic ,strong) PropertyInfoFooterView * footerView;
@property (nonatomic ,strong) NSMutableArray * payTableArray;

@property (nonatomic ,assign) NSString * roomId;

@end

@implementation PropertyPayViewController

-(void)getPropertyBill
{
    [UserServices
     getPropertyBillWithBillType:[NSString stringWithFormat:@"0%ld",(long)self.billType]
     roomId:self.roomId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self.payTableArray removeAllObjects];
            NSArray *dataArray=responseObject[@"data"];
            for (NSDictionary *dic in dataArray)
            {
                PropertyBillModel *model=[PropertyBillModel initWithDataSource:dic];
                [self.payTableArray addObject:model];
            }
            [self.payTableView reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(NSString *)getBillId
{
    NSMutableArray *billIdArray=[[NSMutableArray alloc]init];
    for (PropertyBillModel *model in self.payTableArray) {
        if (model.isSeleted) {
            [billIdArray addObject:model.billId];
        }
    }
    NSString *billIdS=[billIdArray componentsJoinedByString:@","];
    return billIdS;
}
-(CGFloat)getSumPrice
{
    CGFloat sumPrice=0.00;
    for (PropertyBillModel *model in self.payTableArray) {
        if (model.isSeleted) {
            sumPrice+=[model.billAmount floatValue];
        }
    }
    return sumPrice;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"物业缴费";
    [self showRightBarButtonItemHUDByName:@"缴费历史"];
    self.payTableArray=[[NSMutableArray alloc]init];
    
    self.roomId=[KeychainManager readRoomId];
    [self getPropertyBill];
    
}

- (void) createUI{
    
    self.payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.payTableView.dataSource = self;
    self.payTableView.delegate = self;
    self.payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.payTableView.tableHeaderView = [self tableHeaderView];
    self.payTableView.tableFooterView = [self tableFooterView];
    [self.payTableView registerClass:[PropertyBillCell class]
              forCellReuseIdentifier:[PropertyBillCell cellIdentifier]];
    
    [self addSubview:self.payTableView];
}

- (UIView *) tableHeaderView{

    WeakSelf
    _headerView = [[PropertyInfoHeaderView alloc] init];
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 120);
    _headerView.bChooseOtherInfoHandle = ^(id data){
        weakSelf.roomId=data;
        [weakSelf getPropertyBill];
    };
    [_headerView config:nil];
    return _headerView;
}

- (UIView *) tableFooterView{
    
    _footerView = [[PropertyInfoFooterView alloc] init];
    _footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150);
    _footerView.bCallOnHandle = ^(){
        [UnityLHClass callTel:[KeychainManager readMobileNum]];
    };
    [_footerView receiveObject:^(id object) {
        NSString *billIdS= [self getBillId];
        if (billIdS.length==0) {
            return ;
        }
        PropertyPayBillViewController * vc = [[PropertyPayBillViewController alloc] init];
        vc.billType=[NSString stringWithFormat:@"0%ld",(long)self.billType];
        vc.billIdS=billIdS;
        vc.sumPrice=[self getSumPrice];
        [self.navigationController pushViewController:vc animated:YES];
        [vc receiveObject:^(id object) {
            [self getPropertyBill];
        }];

    }];
    return _footerView;
}

- (void)baseRightBtnAction:(UIButton *)btn{

    PropertyPayHistoryViewController * vc = [[PropertyPayHistoryViewController alloc] init];
     vc.TypeNum=self.billType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payTableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    PropertyInfoSectionHeaderView * sectionHeaderView = [PropertyInfoSectionHeaderView view];
    return sectionHeaderView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyBillCell * cell = [tableView dequeueReusableCellWithIdentifier:[PropertyBillCell cellIdentifier] forIndexPath:indexPath];
    PropertyBillModel *model=self.payTableArray[indexPath.row];
    [cell loadCellWithDataSource:model];
    [cell receiveObject:^(id object) {
        model.isSeleted=!model.isSeleted;
        [tableView reloadData];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PropertyBillModel *model=self.payTableArray[indexPath.row];
    PropertyPaySingleViewController * vc = [[PropertyPaySingleViewController alloc] init];
    vc.billID=model.billId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark Navigation M



#pragma mark -
#pragma mark Network M
@end
