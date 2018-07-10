//
//  MyFoodOrderViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "MyFoodOrderViewController.h"
#import "UIViewController+Page.h"
#import "MyFoodOrderCell.h"
#import "LKSegmentView.h"
#import "TakeoutInfoViewController.h"
#import "ReservationOrderInfoViewController.h"
#import "ReservePayViewController.h"
#import "FoodOrderStatusViewModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DQAlertViewController.h"

@interface MyFoodOrderViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) LKSegmentView * segmentView;//

@property (nonatomic ,strong) UITableView * foodOrderTatbleView;
@property (nonatomic ,strong) NSString * orderType;// 01 订餐   02 外卖
@end

@implementation MyFoodOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的订单";
    self.orderType = @"02";
    
    LKSegmentView * segmentView = [[LKSegmentView alloc] init];
    segmentView.normalImage = [UIImage imageNamed:@"order_down_normal"];
    segmentView.selectImage = [UIImage imageNamed:@"order_down_selected"];
    segmentView.selectColor = BM_Color_Blue;
    [segmentView configSegmentViewWithItems:@[@"外卖",@"订餐"]];
    [segmentView defaultSelectedFirstItem];
    segmentView.bSegmentViewDidSelectedItem = ^(NSInteger index){

        self.orderType = index == 0 ? @"02":@"01";
        [self initiateNetworkListRequest];
      
    };
    [self addSubview:segmentView];
    self.segmentView = segmentView;
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.foodOrderTatbleView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.foodOrderTatbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.foodOrderTatbleView.delegate = self;
    self.foodOrderTatbleView.dataSource = self;
    self.foodOrderTatbleView.emptyDataSetSource = self;
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    self.foodOrderTatbleView.tableHeaderView = headerView;
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 10);
    footerView.backgroundColor = [UIColor clearColor];
    self.foodOrderTatbleView.tableFooterView = footerView;
    
    self.foodOrderTatbleView.backgroundColor = [UIColor clearColor];
    [self.foodOrderTatbleView registerClass:[MyFoodOrderCell class]
                     forCellReuseIdentifier:[MyFoodOrderCell cellIdentifier]];
    [self addSubview:self.foodOrderTatbleView];
    [self.foodOrderTatbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.mas_equalTo(self.segmentView.left);
        make.right.mas_equalTo(self.segmentView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    [self refresh];
    
    LKWeakSelf;
    [self.foodOrderTatbleView addHeaderWithCallback:^{
        LKStrongSelf;
        [_self refresh];
    }];
    
    [self.foodOrderTatbleView addFooterWithCallback:^{
        LKStrongSelf;
        [_self loadMore];
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.responseDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyFoodOrderCell cellHeightWithOrderType:self.orderType];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return .1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFoodOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyFoodOrderCell cellIdentifier] forIndexPath:indexPath];

    id orderInfo = self.responseDatas[indexPath.section];
    
    FoodOrderStatusViewModel * viewModel;
    
    if ([self.orderType  isEqual: @"01"]) {
        
        viewModel = [FoodOrderStatusViewModel viewModelWithData:orderInfo];
    }else{
        viewModel = [FoodOrderStatusViewModel viewModelWithTakeOutData:orderInfo];
    }
    [cell configCellWithData:viewModel];
    
    LKWeakSelf
    [cell receiveObject:^(id object) {
       
        LKStrongSelf
        [_self orderOperationWithObject:object orderInfo:orderInfo];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFoodOrderCell * cell = (MyFoodOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.orderType  isEqual: @"01"])
    {
        ReservationOrderInfoViewController *info=[[ReservationOrderInfoViewController alloc]init];
        info.viewModel = cell.viewModel;
        info.bDeleteOrderHandle = ^(){
            [self initiateNetworkListRequest];
        };
        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        TakeoutInfoViewController *info=[[TakeoutInfoViewController alloc]init];
        info.viewModel = cell.viewModel;
        info.bDeleteOrderHandle = ^(){
            [self initiateNetworkListRequest];
        };
        [self.navigationController pushViewController:info animated:YES];
    }
}

#pragma mark -
#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -50);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}

#pragma mark -
#pragma mark Network

- (void)initiateNetworkListRequest{

    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    
    [UserServices getMealOrderListWithuserId:[KeychainManager readUserId]
                                    pageSize:pageSize
                                   pageIndex:pageIndex
                                   orderType:self.orderType
                             completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            
            id data = responseObject[@"data"];
            
            [self responseDataList:data];
            if (self.pageItem.isRefresh) {
                [self.foodOrderTatbleView headerEndRefreshing];
            }else{
                
                if (!self.pageItem.canLoadMore) {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.foodOrderTatbleView footerEndRefreshing];
            }
            
            [self.foodOrderTatbleView reloadData];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

-(void)orderOperationWithObject:(NSString *)object orderInfo:(id)orderInfo
{
    
    NSString * orderId = [NSString stringWithFormat:@"%@",orderInfo[@"id"]];

    if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices cancelMealOrderWithOrderId:orderId
                                               orderType:self.orderType
                                         reservationType:orderInfo[@"reservationType"]
                                                 delType:@"02"
                                         completionBlock:^(int result, id responseObject)
                 {
                     
                     if (result == 0)
                     {
                         [self refresh];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }
                 }];
                
            }
        }];
        [alert showAlert:self];

        
       
        
    }
    else if ([object isEqualToString:@"删除订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定删除订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex) {
                
                [UserServices cancelMealOrderWithOrderId:orderId
                                               orderType:self.orderType
                                         reservationType:orderInfo[@"reservationType"]
                                                 delType:@"01"
                                         completionBlock:^(int result, id responseObject)
                 {
                     
                     if (result == 0)
                     {
                         [self refresh];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }
                 }];

                
            }
        }];
        [alert showAlert:self];

        
    }
    else if ([object isEqualToString:@"去付款"])
    {
        NSInteger  paymentId= [orderInfo[@"paymentId"] integerValue];//支付方式 （01：支付宝 ，02：微信 ，03：钱包支付）
        PayType payType=PayTypeWallet;
        if (paymentId==1)
        {
            payType=PayTypeZFB;
        }
        else if (paymentId==2)
        {
            payType=PayTypeWX;
        }
        else if (paymentId==3)
        {
            payType=PayTypeWallet;
        }

        ReservePayViewController *pay=[[ReservePayViewController alloc]init];
        pay.priceInfo=[orderInfo[@"orderSum"] floatValue];;
        pay.orderData=orderInfo;
        pay.payType=payType;
        [self.navigationController pushViewController:pay animated:YES];
    }
    else
    {
        [UnityLHClass showHUDWithStringAndTime:object];
    }
    
    
}
@end
