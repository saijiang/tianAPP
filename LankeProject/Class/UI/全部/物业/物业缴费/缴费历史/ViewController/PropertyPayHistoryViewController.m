//
//  PropertyPayHistoryViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayHistoryViewController.h"
#import "PropertyPayHistoryViewController.h"
#import "PropertyPayHistoryHeaderView.h"
#import "PropertyPayHistoryCell.h"
#import "PropertyPayViewController.h"
#import "PropertyPaySingleViewController.h"

@interface PropertyPayHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) PropertyPayHistoryHeaderView * historyHeaderView;
@property (nonatomic ,strong) UITableView * historyTableView;
@property (nonatomic ,assign) NSString * billType;

@end

@implementation PropertyPayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费历史";
    self.billType=nil;
}

- (void) createUI{
    
    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.emptyDataSetSource = self;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.tableHeaderView = [self tableHeaderView];
    [self.historyTableView registerClass:[PropertyPayHistoryCell class]
                  forCellReuseIdentifier:[PropertyPayHistoryCell cellIdentifier]];
    
    [self addSubview:self.historyTableView];
    LKWeakSelf
    [self.historyTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self refresh];
    }];
    [self.historyTableView addFooterWithCallback:^{
        LKStrongSelf
        [_self loadMore];
    }];
    
//    [self refresh];
}

- (UIView *) tableHeaderView{
    WeakSelf
    NSArray *dropArray=@[@"全部",@"水费",@"网费/电话费",@"停车费",@"供暖费",@"物业费",@"生活热水费",@"燃气费",];
    self.historyHeaderView = [[PropertyPayHistoryHeaderView alloc] init];
    self.historyHeaderView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 120);
    self.historyHeaderView.categoryLabel.text=dropArray[self.TypeNum];
    if (self.TypeNum!=0) {
        weakSelf.billType=[NSString stringWithFormat:@"0%ld",(long)self.TypeNum];
    }
    [weakSelf refresh];
    [self.historyHeaderView config:nil];
    
    self.historyHeaderView.bTypeHandle = ^(){
        
        
        // 缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部",@"水费",@"网费/电话费",@"停车费",@"供暖费",@"物业费",@"生活热水费",@"燃气费", nil];
        [sheet showInView:weakSelf.view withCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex<dropArray.count) {
                weakSelf.historyHeaderView.categoryLabel.text=dropArray[buttonIndex];
                weakSelf.billType=[NSString stringWithFormat:@"0%ld",(long)buttonIndex];
                if (buttonIndex==0) {
                    weakSelf.billType=nil;
                }
                [weakSelf refresh];
            }
        }];
    };
    
    [self.historyHeaderView receiveObject:^(id object) {
        [weakSelf refresh];
        
    }];
    return self.historyHeaderView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.and.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}
-(void)baseBackBtnAction:(UIButton *)btn
{
    BOOL isBackPropertyPayViewController=NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PropertyPayViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            isBackPropertyPayViewController=YES;
        }
    }
    if (!isBackPropertyPayViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [PropertyPayHistoryCell cellHeightWithData:self.responseDatas[indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyPayHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:[PropertyPayHistoryCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configCellWithData:self.responseDatas[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PropertyPaySingleViewController * vc = [[PropertyPaySingleViewController alloc] init];
        vc.typeStr=@"history";
        vc.billID=self.responseDatas[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark -
#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    NSString *beginTime=[self.historyHeaderView.startTimeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *endTime=[self.historyHeaderView.endTimeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDictionary *dic=@{@"全部":@"0",@"水费":@"01",@"网费/电话费":@"02",@"停车费":@"03",@"供暖费":@"4",@"物业费":@"05",@"生活热水费":@"06",@"燃气费":@"07",};
    for (NSString*nameStr in [dic allKeys]) {
        if ([nameStr isEqualToString:  self.historyHeaderView.categoryLabel.text]) {
            if ([dic[nameStr] integerValue]==0) {
                self.billType=nil;
            }else{
                self.billType=dic[nameStr];
            }
        }
    }
   
    
    
    [UserServices
     getPropertyBillRecordListWithBillType:self.billType
     roomId:[KeychainManager readRoomId]
     beginTime:beginTime
     endTime:endTime
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
             [self responseDataList:data];
             if (self.pageItem.isRefresh)
             {
                 [self.historyTableView headerEndRefreshing];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.historyTableView footerEndRefreshing];
             }
             [self.historyTableView reloadData];
         }else{
             // error handle here
             if (self.pageItem.isRefresh) {
                 
                 [self.historyTableView headerEndRefreshing];
             }else{
                 
                 [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 [self.historyTableView footerEndRefreshing];
             }
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
         
     }];
    
    
}

#pragma mark -
#pragma mark Navigation M



#pragma mark -
#pragma mark Network M


@end
