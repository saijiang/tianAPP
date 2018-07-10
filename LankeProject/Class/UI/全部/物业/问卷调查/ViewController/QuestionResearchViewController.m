//
//  QuestionResearchViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "QuestionResearchViewController.h"
//cell
#import "QuestionReserachCustomCell.h"
//底部按钮
#import "LKBottomButton.h"
//默认view
#import "QuestionDefaultView.h"
//提交完成
#import "QuestionFinishedViewController.h"
//无问答
#import "NonQuestionViewController.h"

#import "QuestionInfoModel.h"

@interface QuestionResearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
}

@property (nonatomic,strong)UITableView *tableCtrl;
@property (nonatomic,strong)id dataSource;
@property (nonatomic,strong)LKBottomButton *submitButton;
@end

@implementation QuestionResearchViewController

-(void)checkQuestionList
{
    NSMutableArray *questionListArray=[[NSMutableArray alloc]init];
    for (QuestionSectionModel *sectionMode in dataArray)
    {
        NSArray *infoArray=sectionMode.listQuestionOptions;
        for (QuestionInfoModel *infoModel in infoArray)
        {
            if (infoModel.seleted)
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [questionListArray addObject:dic];
            }
        }
    }

    if (questionListArray.count==dataArray.count)
    {
        self.submitButton.enabled=YES;

    }
}

-(NSString *)questionList
{
    //提交格式： [{"titleId": "1","optionsId": "1"},{"titleId": "2","optionsId": "1"}]
    NSMutableArray *questionListArray=[[NSMutableArray alloc]init];
    for (QuestionSectionModel *sectionMode in dataArray)
    {
        NSArray *infoArray=sectionMode.listQuestionOptions;
        for (QuestionInfoModel *infoModel in infoArray)
        {
            if (infoModel.seleted)
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setValue:infoModel.titleId forKey:@"titleId"];
                [dic setValue:infoModel.optionsId forKey:@"optionsId"];
                [questionListArray addObject:dic];
            }
        }
    }
    NSString *questionListJson=[JsonManager jsonWithDict:questionListArray];
    return questionListJson;
}

-(void)getQuestionInfo
{
    dataArray = [[NSMutableArray alloc]init];
    [UserServices
     getQuestionInfoWithUserId:[KeychainManager readUserId]
     districtId:[KeychainManager readDistrictId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.dataSource=[responseObject[@"data"] firstObject];
             NSArray *listQuestionArray=self.dataSource[@"listQuestion"];
             for (int i=0; i<listQuestionArray.count; i++)
             {
                 NSDictionary *data=listQuestionArray[i];
                 QuestionSectionModel *model=[QuestionSectionModel initWithDataSource:data];
                 model.index=i;
                 [dataArray addObject:model];
             }
             
             self.tableCtrl.tableHeaderView=[self tableHeaderView];
             [self.tableCtrl reloadData];
             [self initFooterView];
             if (listQuestionArray.count==0) {
                 [self setDefaultView:nil];
             }

         }
         else
         {
             [self setDefaultView:responseObject[@"msg"]];
            
         }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"问卷调查"];
    [self.view addSubview:self.tableCtrl];
    [self getQuestionInfo];
}


#pragma mark --- 提交问卷事件
-(void)commitBtnAction:(UIButton *)sender
{
    NSString *questionList=[self questionList];
    [UserServices
     submitQuestionInfoWithUserId:[KeychainManager readUserId]
     questionId:self.dataSource[@"questionId"]
     questionList:questionList
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             QuestionFinishedViewController *finish = [[QuestionFinishedViewController alloc]init];
             [self.navigationController pushViewController:finish animated:YES];
             if (self.navigationController && [self.navigationController.viewControllers count])
             {
                 NSMutableArray * vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                 [vcs removeObjectAtIndex:vcs.count-2];
                 self.navigationController.viewControllers = vcs;
             }

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
  
}

#pragma mark -- 创建底部提交按钮
-(void)initFooterView
{
    //确认
    LKBottomButton *sureBtn = [[LKBottomButton alloc] init];
    [sureBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"提交问卷" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = BM_FONTSIZE(17.0);
    [self.view addSubview:sureBtn];
    self.submitButton=sureBtn;
    self.submitButton.enabled=NO;
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.offset(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
    }];
}

-(UIView *)tableHeaderView
{
    CGFloat hight=[UnityLHClass getHeight:self.dataSource[@"questionName"] wid:DEF_SCREEN_WIDTH-30 font:16.0]+[UnityLHClass getHeight:self.dataSource[@"questionInstructions"] wid:DEF_SCREEN_WIDTH-30 font:14.0]+30+20;
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, hight)];
    baseView.backgroundColor = BM_WHITE;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = self.contentView.backgroundColor;
    [baseView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseView.mas_top);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(10);
    }];
    UILabel *titleLab = [UnityLHClass masonryLabel:self.dataSource[@"questionName"] font:16.0 color:BM_BLACK];
    [baseView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baseView.mas_left).offset(15);
        make.top.mas_equalTo(view.mas_bottom).offset(10);
        make.right.mas_equalTo(baseView.mas_right).offset(-15);
        
    }];
    UILabel *contentLab = [UnityLHClass masonryLabel:self.dataSource[@"questionInstructions"] font:14.0 color:[UIColor colorWithHexString:@"666666"]];
    contentLab.numberOfLines = 0;
    [baseView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(15);
        make.left.mas_equalTo(titleLab.mas_left);
        make.right.mas_equalTo(baseView.mas_right).offset(-15);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLab.mas_left);
        make.right.mas_equalTo(baseView.mas_right).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(baseView.mas_bottom);
    }];
    return baseView;

}

#pragma mark -- 调接口如果没有问卷调查或者已经参与过显示默认图
-(void)setDefaultView:(NSString *)msg
{
    if ([msg isEqualToString:@"您已参与过本次问卷调查"])
    {
        QuestionFinishedViewController *finish = [[QuestionFinishedViewController alloc]init];
        finish.view.frame=self.view.frame;
        [self.view addSubview:finish.view];
    }
    else
    {
        NonQuestionViewController *nofinish = [[NonQuestionViewController alloc]init];
        nofinish.view.frame=self.view.frame;
        [self.view addSubview:nofinish.view];
    }
   
}

//初始化表
-(UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT-85) style:UITableViewStyleGrouped];
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
        self.tableCtrl.backgroundColor=self.contentView.backgroundColor;
    }
    return _tableCtrl;
}

#pragma mark ----- tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QuestionSectionModel *model=dataArray[section];
    return model.listQuestionOptions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    QuestionSectionModel *model=dataArray[section];
    return model.sectionHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionSectionModel *model=dataArray[indexPath.section];
    QuestionInfoModel *infoModel=model.listQuestionOptions[indexPath.row];
    return infoModel.hight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionSectionModel *model=dataArray[indexPath.section];
    NSArray *listArray=model.listQuestionOptions;
    QuestionReserachCustomCell *cell = [QuestionReserachCustomCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:listArray[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QuestionSectionModel *model=dataArray[section];
    UIView *baseView = [[UIView alloc]init];
    baseView.backgroundColor = BM_WHITE;
    UILabel *titleLab = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"%@.%@",model.titleSort,model.titleName] font:16.0 color:BM_BLACK];
    titleLab.numberOfLines = 0;
    [baseView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baseView.mas_left).offset(15);
        make.top.mas_equalTo(baseView.mas_top).offset(10);
        make.right.mas_equalTo(baseView.mas_right).offset(-15);
    }];
    return baseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionSectionModel *model=dataArray[indexPath.section];
    NSArray *listArray=model.listQuestionOptions;
    for (int i=0; i<listArray.count; i++) {
        QuestionInfoModel *model=listArray[i];
        model.seleted=NO;
        if (indexPath.row==i) {
            model.seleted=YES;
        }
    }
    [tableView reloadData];
    
    [self checkQuestionList];

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
