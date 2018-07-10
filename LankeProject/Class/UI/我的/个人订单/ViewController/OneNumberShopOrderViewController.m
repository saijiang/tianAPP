//
//  MyGoodsOrderViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OneNumberShopOrderViewController.h"
#import "EHHorizontalSelectionView.h"
#import "UIViewController+Page.h"
#import "MyGoodsOrderCell.h"
#import "MallOrderPayViewController.h"
#import "MallorderDetailViewController.h"
#import "MallcommentModel.h"
#import "MallcommentViewController.h"
#import "OneShopLogisticsDetailsViewController.h"
#import "DQAlertViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface OneNumberShopOrderViewController ()<EHHorizontalSelectionViewProtocol,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) IBOutlet EHHorizontalSelectionView * orderSegmentView;
@property (nonatomic ,strong) NSArray * orderSegments;

//状态（全部：空或不传，02：待付款 ， 03：待发货 ， 04：待收货  ，05：待评价）
@property (nonatomic ,strong) NSString * orderState;

@property (nonatomic ,strong) UITableView * orderTableView;
@end

@implementation OneNumberShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
}

- (void)createUI{
    
    self.orderSegments = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    
    self.orderSegmentView = [[EHHorizontalSelectionView alloc] initWithFrame:CGRectZero];
    self.orderSegmentView.backgroundColor = [UIColor whiteColor];
    [self.orderSegmentView registerCellWithClass:[EHHorizontalLineViewCell class]];
    self.orderSegmentView.delegate = self;
    self.orderSegmentView.tintColor = BM_Color_Blue;
    self.orderSegmentView.normalTextColor = BM_BLACK;
    self.orderSegmentView.selectTextColor = BM_Color_Blue;
    self.orderSegmentView.font = [UIFont systemFontOfSize:16];
    self.orderSegmentView.fontMedium = [UIFont systemFontOfSize:16];
    self.orderSegmentView.maxDisplayCount = 4;
    
    [EHHorizontalLineViewCell updateColorHeight:3.f];
    
    [self addSubview:self.orderSegmentView];
    
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.emptyDataSetSource = self;
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    self.orderTableView.tableHeaderView = headerView;
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 10);
    footerView.backgroundColor = [UIColor clearColor];
    self.orderTableView.tableFooterView = footerView;
    
    self.orderTableView.backgroundColor = [UIColor clearColor];
    [self.orderTableView registerClass:[MyGoodsOrderCell class]
                forCellReuseIdentifier:[MyGoodsOrderCell cellIdentifier]];
    [self addSubview:self.orderTableView];
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderSegmentView.mas_bottom);
        make.left.mas_equalTo(self.orderSegmentView.left);
        make.right.mas_equalTo(self.orderSegmentView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self refresh];
    
    LKWeakSelf;
    [self.orderTableView addHeaderWithCallback:^{
        LKStrongSelf;
        [_self refresh];
    }];
    
    [self.orderTableView addFooterWithCallback:^{
        LKStrongSelf;
        [_self loadMore];
    }];
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.orderSegmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.view.mas_right);
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
    GoodsOrderStatusViewModel * viewModel = self.responseDatas[indexPath.section];
    
    return [MyGoodsOrderCell cellHeightWithData:viewModel];
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
    MyGoodsOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyGoodsOrderCell cellIdentifier] forIndexPath:indexPath];
    
    GoodsOrderStatusViewModel * viewModel = self.responseDatas[indexPath.section];
    [cell configOneNumberShopCellWithData:viewModel];
    LKWeakSelf
    [cell receiveObject:^(id object) {
        
        LKStrongSelf
        [_self requestOrderHandleWith:object orderInfo:viewModel.orderData];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallorderDetailViewController *detail=[[MallorderDetailViewController alloc]init];
    GoodsOrderStatusViewModel *viewModel=self.responseDatas[indexPath.section];
    detail.viewModel=viewModel;
    [self.navigationController pushViewController:detail animated:YES];
    [detail receiveObject:^(id object) {
        [self refresh];
    }];
}


#pragma mark -
#pragma mark EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.orderSegments.count;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.orderSegments[index];
}

- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index{
    
    if (index) {
        self.orderState = [NSString stringWithFormat:@"0%lu",index + 1];
    }else{
        self.orderState = @"";
    }
    [self refresh];
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
#pragma mark Network M

-(void)initiateNetworkListRequest{
    
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    
    [UserServices
     getYhdOrderListWithUserId:[KeychainManager readUserId]
     orderState:self.orderState
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             
             NSArray * data = responseObject[@"data"];
             
             NSMutableArray * temp = [NSMutableArray arrayWithCapacity:data.count];
             for (NSDictionary * data_ in data) {
                 GoodsOrderStatusViewModel * viewModel = [GoodsOrderStatusViewModel oneNumberShopviewModelWithData:data_];
                 [temp addObject:viewModel];
             }
             
             [self responseDataList:temp];
             if (self.pageItem.isRefresh) {
                 [self.orderTableView headerEndRefreshing];
             }else{
                 
                 if (!self.pageItem.canLoadMore) {
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 }
                 [self.orderTableView footerEndRefreshing];
             }
             
             [self.orderTableView reloadData];
         }else{
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             if (self.pageItem.isRefresh) {
                 [self.orderTableView headerEndRefreshing];
             }else{
                 [self.orderTableView footerEndRefreshing];
             }
             
         }
     }];
}

- (void) requestOrderHandleWith:(id)object orderInfo:(id)orderInfo{
    
    if ([object isEqualToString:@"取消订单"])
    {
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定取消订单？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex)
            {
                
                [UserServices
                 cancelOrderWithOrderCode:orderInfo[@"orderCode"]
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
    else if ([object isEqualToString:@"确认收货"])
    {

        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"是否确认收货？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
            
            if (buttonIndex)
            {
                
                
                [UserServices
                 changeOrderStatusWithOrderCode:orderInfo[@"orderCode"]
                 orderFlag:@"02" completionBlock:^(int result, id responseObject)
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
            
            if (buttonIndex)
            {
                
                [UserServices
                 deleteOrderWithOrderCode:orderInfo[@"orderCode"]
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
        [UserServices
         checkOrderStatusWithOrderCode:orderInfo[@"orderCode"]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 MallOrderPayViewController * pay = [[MallOrderPayViewController alloc] init];
                 pay.orderType = @"04";
                 pay.orderCode = orderInfo[@"orderCode"];
                 pay.sumPrice = [orderInfo[@"orderAmount"] floatValue];
                 [self.navigationController pushViewController:pay animated:YES];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 [self refresh];
             }
        }];
     
    }
    else if ([object isEqualToString:@"评价"])
    {
        [UserServices
         getYhdOrderDetailWithOrderCode:orderInfo[@"orderCode"]
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 NSDictionary *dataSource=responseObject[@"data"];
                 NSMutableArray *evaluateList=[[NSMutableArray alloc]init];
                 for (NSDictionary *data in dataSource[@"orderItemList"])
                 {
                     MallcommentModel *model=[MallcommentModel initOneShopModelwithDataSource:data];
                     [evaluateList addObject:model];
                 }
                 MallcommentViewController *comment=[[MallcommentViewController alloc]init];
                 comment.tableArray=evaluateList;
                 comment.orderCode=dataSource[@"orderCode"];
                 comment.merchantId=@"YHD";
                 comment.merchantName=@"YHD";
                 [self.navigationController pushViewController:comment animated:YES];
                 [comment receiveObject:^(id object) {
                     //刷新我的订单列表
                     [self refresh];
                 }];
                 
             }
         }];
    }
    else if ([object isEqualToString:@"查看物流"])
    {
        OneShopLogisticsDetailsViewController *logistic=[[OneShopLogisticsDetailsViewController alloc]init];
        logistic.orderCode=orderInfo[@"orderCode"];
        [self.navigationController pushViewController:logistic animated:YES];
    }
}
@end
