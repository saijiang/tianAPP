//
//  JDServiceViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceViewController.h"
#import "EHHorizontalSelectionView.h"
#import "UIViewController+Page.h"
#import "MallOrderPayViewController.h"
#import "MallorderDetailViewController.h"
#import "MallcommentModel.h"
#import "MallcommentViewController.h"
#import "LogisticsDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DQAlertViewController.h"
//申请记录cell
#import "JDServiceRecordCell.h"
//申请售后服务
#import "JDAddServiceViewController.h"
//服务单详情
#import "JDServiceDetailViewController.h"
//售后申请cell
#import "JDServiceApplyCell.h"
//填写快递单号
#import "AddLogisticsViewController.h"


@interface JDServiceViewController ()<EHHorizontalSelectionViewProtocol,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) IBOutlet EHHorizontalSelectionView * orderSegmentView;
@property (nonatomic ,strong) NSArray * orderSegments;

//状态（全部：空或不传，01:申请记录）
@property (nonatomic ,strong) NSString * orderState;

@property (nonatomic ,strong) UITableView * orderTableView;

@end

@implementation JDServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"售后申请"];
}

-(void)createUI
{
    self.orderSegments = @[@"售后申请",@"申请记录"];
    
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
    [self.orderTableView registerClass:[JDServiceApplyCell class]
                forCellReuseIdentifier:@"JDServiceApplyCell"];
    [self addSubview:self.orderTableView];
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderSegmentView.mas_bottom);
        make.left.mas_equalTo(self.orderSegmentView.left);
        make.right.mas_equalTo(self.orderSegmentView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
 
    
    LKWeakSelf;
    [self.orderTableView addHeaderWithCallback:^{
        LKStrongSelf;
        [_self refresh];
    }];
    
    [self.orderTableView addFooterWithCallback:^{
        LKStrongSelf;
        [_self loadMore];
    }];
       [self refresh];
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
    if ([self.orderState integerValue] == 2)
    {
        return 1;
    }
    return [self.responseDatas[section][@"zkJdOrderItemMapList"] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.orderState integerValue] == 2)
    {
        return 150;
    }
    return 140;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.orderState integerValue] == 2)
    {
        return 10;
    }
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.orderState integerValue] == 2)
    {
        return nil;
    }
    JDServiceApplyHeaderView *header = [[JDServiceApplyHeaderView alloc]init];
    id data = self.responseDatas[section];
    [header configJDServiceApplyHeaderViewWithData:data];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.orderState integerValue] == 2)
    {
        return 40;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.orderState integerValue] == 2)
    {
        JDServiceRecordFooterView *footerView = [[JDServiceRecordFooterView alloc]init];
        id data = self.responseDatas[section];
        [footerView loadViewWithData:data];
        [footerView.cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ([footerView.cancelBtn.titleLabel.text isEqualToString:@"取消申请"])
            {
                //取消申请
                //  [UnityLHClass showHUDWithStringAndTime:@"取消申请"];
                [self requestOrderHandleWith:@"取消申请" orderInfo:data];
                
            }
            else if ([footerView.cancelBtn.titleLabel.text isEqualToString:@"填写快递"])
            {
                AddLogisticsViewController *vc = [[AddLogisticsViewController alloc]init];
                vc.afsServiceId = data[@"afsServiceId"];
                [vc receiveObject:^(id object) {
                    [self refresh];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        return footerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.orderState integerValue] == 2)
    {
        //申请记录的cell
        JDServiceRecordCell *cell = [JDServiceRecordCell cellWithTableView:tableView];
        id data = self.responseDatas[indexPath.section];
        [cell configCellWithData:data];
        
        return cell;
    }
    else
    {
        //售后申请
        JDServiceApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDServiceApplyCell" forIndexPath:indexPath];
        
        id orderInfo = self.responseDatas[indexPath.section][@"zkJdOrderItemMapList"][indexPath.row];
    
        
        [cell configJDServiceCellWithData:orderInfo];
        
        LKWeakSelf
        [cell receiveObject:^(id object) {
            
            LKStrongSelf
            //申请售后
            JDAddServiceViewController *vc = [[JDAddServiceViewController alloc]init];
            vc.orderData = orderInfo;
            [vc receiveObject:^(id object) {
                [self refresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.orderState integerValue] == 2)
    {
        //申请记录详情
        id data = self.responseDatas[indexPath.section];
        JDServiceDetailViewController *vc = [[JDServiceDetailViewController alloc]init];
        vc.afsServiceId = data[@"afsServiceId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        self.orderState = [NSString stringWithFormat:@"0%lu",index+1];
    }else{
        self.orderState = @"";
    }
    [self refresh];
    [self.orderTableView reloadData];
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
    
    
    
    if ([self.orderState integerValue] == 2)
    {
        //申请记录
        [self applyRecordListRequest];
        
    }
    else
    {
        [self jdAfterSellApplyGetOrderListRequest];
    }
    
    
}

#pragma mark --- 申请记录接口
-(void)applyRecordListRequest
{
    NSString * pageSize = @"5";//[NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    
    [UserServices jdAfterSellApplyGetJdAfterSellApplyListWithUserId:[KeychainManager readUserId]
                                                          imageSize:@"n1"
                                                          pageIndex:pageIndex
                                                           pageSize:pageSize
                                                    completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"];
             [self responseDataList:data[@"result"]];
//            if ([data isKindOfClass:[NSDictionary class]])
//            {
//                if ([data[@"result"] isKindOfClass:[NSArray class]] && [data[@"result"] count] > 0)
//                {
//                    [self responseDataList:data[@"result"]];
//                }
//                
//            }
            
            if (self.pageItem.isRefresh)
            {
                [self.orderTableView headerEndRefreshing];
            }
            else
            {
                
                if (!self.pageItem.canLoadMore)
                {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.orderTableView footerEndRefreshing];
            }
            
            [self.orderTableView reloadData];
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        
    }];
}

#pragma mark --- 售后申请接口
-(void)jdAfterSellApplyGetOrderListRequest
{
    NSString * pageSize = @"5";//[NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    [UserServices jdAfterSellApplyGetOrderListWithUserId:[KeychainManager readUserId]
                                               imageSize:@"n1"
                                               pageIndex:pageIndex
                                                pageSize:pageSize
                                         completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             
             id data = responseObject[@"data"];
             if ([data isKindOfClass:[NSDictionary class]])
             {
                 if ([data[@"result"] isKindOfClass:[NSArray class]] && [data[@"result"] count] > 0)
                 {
                     [self responseDataList:data[@"result"]];
                 }
                 
             }
             
             if (self.pageItem.isRefresh)
             {
                 [self.orderTableView headerEndRefreshing];
             }
             else
             {
                 
                 if (!self.pageItem.canLoadMore)
                 {
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 }
                 [self.orderTableView footerEndRefreshing];
             }
             
             [self.orderTableView reloadData];
             
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}


#pragma mark --- 取消申请
- (void) requestOrderHandleWith:(id)object orderInfo:(id)orderInfo{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消申请" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            if ([object isEqualToString:@"取消申请"])
            {
                [UserServices jdAfterSellApplyAuditCancelWithAfsServiceId:orderInfo[@"afsServiceId"]
                                                          completionBlock:^(int result, id responseObject)
                 {
                     if (result == 0)
                     {
                         [UnityLHClass showHUDWithStringAndTime:@"取消成功"];
                         [self refresh];
                     }
                     else
                     {
                         [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                     }
                 }];
            }
        }
    }];
    
    
    
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
