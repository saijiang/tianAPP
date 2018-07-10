//
//  PropertyRepairHistoryViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairHistoryViewController.h"
#import "PropertyRepairHeaderView.h"
#import "PropertyRepairRecordCell.h"
#import "PropertyRepairCommentViewController.h"
#import "RepairDetailViewController.h"
#import "RepairCommentView.h"

@interface PropertyRepairHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) PropertyRepairHeaderView * headerView;

@property (nonatomic ,strong) UITableView * recordTableView;
@property (nonatomic ,copy)   NSString *repairState;
@end

@implementation PropertyRepairHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修记录";
    self.repairState=@"01";
    [self refresh];
    
    LKWeakSelf
    [self.recordTableView addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
    }];
    [self.recordTableView addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];
}

-(void)createUI{
    
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.recordTableView.dataSource = self;
    self.recordTableView.delegate = self;
    self.recordTableView.emptyDataSetSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    self.recordTableView.tableFooterView = footerView;
    
    UIView * tableHeaderView = [[UIView alloc] init];
    tableHeaderView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.recordTableView.tableHeaderView = tableHeaderView;
    
    self.recordTableView.backgroundColor = [UIColor clearColor];
    [self.recordTableView registerClass:[PropertyRepairRecordCell class]
                 forCellReuseIdentifier:[PropertyRepairRecordCell cellIdentifier]];
    
    [self addSubview:self.recordTableView];
    
    self.headerView = [PropertyRepairHeaderView view];
    [self addSubview:self.headerView];
    [self.headerView  receiveObject:^(id object) {
        self.repairState=object;
        [self refresh];
    }];
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.responseDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [PropertyRepairRecordCell cellHeightWithData:self.responseDatas[indexPath.section]];
    

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
    PropertyRepairRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:[PropertyRepairRecordCell cellIdentifier] forIndexPath:indexPath];
    NSDictionary *data=self.responseDatas[indexPath.section];
    NSString *repairState=data[@"repairState"];
    cell.bCommentHandle = ^(){
        PropertyRepairCommentViewController * vc = [[PropertyRepairCommentViewController alloc] init];
        vc.dataSource=data;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.bOtherHandle = ^(){
        //repairState 	String 	报修状态（01：处理中， 02：已分派， 03：待评价， 04：完成， 05：已取消）
        if ([repairState integerValue]==2)
        {
            //确认完成
            [self confirmRepairRecord:data[@"id"]];
        }
        else if ([repairState integerValue]==3)
        {
            //评论
            [self submitRepairEvaluation:data withRepairId:data[@"id"]];
            
        }
    };
    
    //2017.07.28
    [cell.bottomView receiveObject:^(id object) {
        NSDictionary *dic = (NSDictionary *)object;
        
        if ([dic[@"title"] isEqualToString:@"评论"])
        {
            PropertyRepairCommentViewController * vc = [[PropertyRepairCommentViewController alloc] init];
            vc.dataSource=dic[@"data"];
            vc.repairId = data[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
                        //repairState 	String 	报修状态（01：处理中， 02：已分派， 03：待评价， 04：完成， 05：已取消）
            if ([repairState integerValue]==2)
            {
                
                //确认完成
                [self confirmRepairRecord:data[@"id"]];
            }
            else if ([repairState integerValue]==3)
            {
                //评论
                [self submitRepairEvaluation:dic withRepairId:data[@"id"]];
                
            }
        }
    }];
    if (data!=nil) {
        [cell configCellWithData:data];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RepairDetailViewController *detai=[[RepairDetailViewController alloc]init];
    detai.repairId=self.responseDatas[indexPath.section][@"id"];
    [self.navigationController pushViewController:detai animated:YES];
    
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

#pragma mark -提交报修评价
-(void)submitRepairEvaluation:(NSDictionary *)data withRepairId:(NSString *)repairId
{
    NSArray *array = [NSArray arrayWithArray:data[@"data"]];
    NSMutableString *idStrings = [[NSMutableString alloc]init];
    for (int i = 0; i < array.count; i++) {
        [idStrings appendString:[NSString stringWithFormat:@"%@,",array[i][@"repairUserId"]]];
    }

    
    RepairCommentView *commentView=[[RepairCommentView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-90, 280)];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:commentView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
    [commentView receiveObject:^(id object) {
       //提交评价
        [UserServices
         submitRepairEvaluationWithRepairId:repairId
         evalScores:[NSString stringWithFormat:@"%.0f",commentView.commentGradeView.value]
         evalContent:commentView.contentView.text
         evalUserId:[KeychainManager readUserId]
         repairUserId:idStrings
         completionBlock:^(int result, id responseObject)
        {
            if (result==0)
            {
                [UnityLHClass showHUDWithStringAndTime:@"提交评价成功"];
                [self refresh];
            }
            else
            {
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }

        }];
        
    }];
}
#pragma mark -确认完成
-(void)confirmRepairRecord:(NSString *)repairId
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认完成？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1)
        {
            [UserServices
             confirmRepairRecordWithRepairId:repairId
             repairState:@"03"
             completionBlock:^(int result, id responseObject)
             {
                 if (result==0)
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
   
}

#pragma mark Network M

- (void)initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];

    [UserServices
     getRepairRecordWithRepairState:self.repairState
     userId:[KeychainManager readUserId]
     districtId:[KeychainManager readDistrictId]
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             id data = responseObject[@"data"];
//             data=[self getTestData];//测试数据
             [self responseDataList:data];
             if (self.pageItem.isRefresh)
             {
                 [self.recordTableView headerEndRefreshing];
             }else{
               
                      [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
              
                
                 [self.recordTableView footerEndRefreshing];
             }
             [self.recordTableView reloadData];
         }else{
             // error handle here
             if (self.pageItem.isRefresh) {
                 
                 [self.recordTableView headerEndRefreshing];
             }else{
                 
               
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                              [self.recordTableView footerEndRefreshing];
             }
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }

    }];
    


}

-(NSArray *)getTestData
{
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"repairTemp" ofType:@"json"]];
    
    NSError * error = nil;
    
    NSArray * datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    return datas;

}

@end
