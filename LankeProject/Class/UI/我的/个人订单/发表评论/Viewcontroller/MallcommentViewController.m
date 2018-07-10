//
//  MallcommentViewController.m
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallcommentViewController.h"
#import "MallcommentCell.h"


@interface MallcommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;

@end

@implementation MallcommentViewController

-(void)addGoodsEvaluate
{
    NSMutableArray *evaluateListArr=[[NSMutableArray alloc]init];
    for (MallcommentModel *model in self.tableArray)
    {
        NSDictionary *data=[model dictionaryRepresentation];
        
        if (model.evalContent.length==0) {
            [UnityLHClass showAlertView:@"评论不能为空"];
            return;
        }
        [evaluateListArr addObject:data];
    }
    
    NSString *evaluateList=[JsonManager jsonWithDict:evaluateListArr];
    
    if (self.isJD)
    {

        [UserServices addJDGoodsEvaluateWithJdOrderCode:self.orderCode
                                                 userId:[KeychainManager readUserId]
                                               //userName:[KeychainManager readUserName]
                                           evaluateList:evaluateList
                                        completionBlock:^(int result, id responseObject)
        {
            if (result==0)
            {
                //刷新我的订单列表
                [self sendObject:@"reload"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
    else
    {
        [UserServices
         addGoodsEvaluateWithOrderCode:self.orderCode
         merchantId:self.merchantId
         merchantName:self.merchantName
         userId:[KeychainManager readUserId]
         userName:[KeychainManager readNickName]
         evaluateList:evaluateList
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 //刷新我的订单列表
                 [self sendObject:@"reload"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"订单评价"];
}
-(void)createUI
{
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    UIView *botomView=[[UIView alloc]init];
    botomView.backgroundColor=BM_WHITE;
    botomView.toplineWithColor=BM_Color_LineColor;
    [self.view addSubview:botomView];
    [botomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.and.left.mas_equalTo(0);
        make.top.mas_equalTo(self.tableCtrl.mas_bottom);
    }];

    UIButton *commentButton=[UnityLHClass masonryButton:@"发表评论" font:15.0 color:BM_WHITE];
    commentButton.backgroundColor=BM_Color_Blue;
    [botomView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    [commentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self addGoodsEvaluate];
    }];
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
    return self.tableArray.count;
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
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallcommentCell *cell=[MallcommentCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.tableArray[indexPath.section]];
    return cell;
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
