//
//  BBSInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BBSInfoViewController.h"
#import "BBSInfoCell.h"
#import "BBSCommentsCell.h"
#import "CommomNoCommentCell.h"
#import "ReplyToListViewController.h"
#import "IQKeyboardManager.h"
#import "BottomCommentView.h"

@interface BBSInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;

@property(nonatomic,strong)NSDictionary *infoDataSource;

@property(nonatomic,assign)NSInteger total;
@property(nonatomic,strong)BottomCommentView *bottom;

@property(nonatomic,assign)BOOL isGroup;//是否为群主，只有群主身份才可以进行拉黑删除操作

@end

@implementation BBSInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];

}

-(void)baseRightBtnAction:(UIButton *)btn
{
    if ([self.infoDataSource[@"isCollect"] integerValue]==1)
    {
        [self cancelHealthAdvice];
    }
    else
    {
        [self collectHealthAdvice];
    }
}

//取消收藏
-(void)cancelHealthAdvice
{
    
    [UserServices
     cancelHealthAdviceWithUserId:[KeychainManager readUserId]
     itemsId:self.topicId
     collectType:@"04"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self getTopicDetail];
             [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             
         }
     }];

}
//收藏
-(void)collectHealthAdvice
{
    [UserServices
     collectionHeadlthAdviceWithUserId:[KeychainManager readUserId]
     itemsId:self.topicId
     collectType:@"04"
     userName:[KeychainManager readUserName]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self getTopicDetail];
            [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];

            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            
        }
    }];
}

//获取最新的5条评论
-(void)getTopicEvaluate
{
    [UserServices
     getTopicEvaluateWithassociationId:self.topicId
     pageIndex:@"1"
     pageSize:@"5"
     completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             
             NSArray * data = responseObject[@"data"][@"list"];
             self.total=[responseObject[@"data"][@"total"] intValue];
             self.responseDatas=data;
             [self.tableCtrl headerEndRefreshing];
             [self.tableCtrl reloadData];
             
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
         
     }];

}
//获取话题详情
-(void)getTopicDetail
{
    [UserServices
     getTopicDetailWithassociationId:self.topicId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.infoDataSource=responseObject[@"data"];
            
            [self showRightBarButtonItemHUDByName:@"收藏"];
            if ([self.infoDataSource[@"isCollect"] integerValue]==1)
            {
                [self showRightBarButtonItemHUDByName:@"取消收藏"];

            }
            if ([self.infoDataSource[@"isGroup"] integerValue]==1)
            {
                //是群主身份
                self.isGroup=YES;
            }
          
            [self.tableCtrl reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
//发表评论
-(void)addTopicEvaluate
{
    [UserServices
     addTopicEvaluateWithassociationId:self.topicId
     userId:[KeychainManager readUserId]
     userName:[KeychainManager readNickName]
     evalContent:self.bottom.comment.text
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self getTopicEvaluate];
            [self sendObject:@"reload"];


        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

        }
    }];
}
//删除话题
-(void)delTopicWithTopicId:(NSString *)topicId
{
    [UserServices
     delTopicWithassociationId:topicId
     userId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self sendObject:@"reload"];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

        }
    }];
}

//拉黑用户
-(void)delAssociationUserWithPublishUserId:(NSString *)publishUserId
{
    [UserServices
     delAssociationUserWithassociationId:self.topicId
     userId:[KeychainManager readUserId]
     publishUserId:publishUserId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self getTopicEvaluate];
            [self sendObject:@"reload"];
            [UnityLHClass showHUDWithStringAndTime:@"该用户已被拉黑"];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

        }
    }];
}
//删除用户评论
-(void)delTopicEvaluateWithevalId:(NSString *)evalId
{
    [UserServices
     delTopicEvaluateWithassociationId:self.topicId
     userId:[KeychainManager readUserId]
     evalId:evalId
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self getTopicEvaluate];
             [self sendObject:@"reload"];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

         }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.total=0;
    [self showNavBarCustomByTitle:@"话题详情"];
    [self getTopicDetail];
    [self getTopicEvaluate];
}
- (void)createUI
{
    [self.view addSubview:self.tableCtrl];
    self.tableCtrl.frame=CGRectMake(0,10,DEF_SCREEN_WIDTH, DEF_CONTENT-DEF_TABBARHEIGHT-10);
    
    _bottom=[[BottomCommentView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.tableCtrl), DEF_SCREEN_WIDTH, DEF_TABBARHEIGHT)];
    _bottom.backgroundColor=BM_WHITE;
    [self.view addSubview:_bottom];
    
    [self.bottom receiveObject:^(id object) {
        DEF_DEBUG(@"%@",object);
        [self addTopicEvaluate];
    }];
    
        LKWeakSelf
        [self.tableCtrl addHeaderWithCallback:^{
    
            LKStrongSelf
          
            [_self getTopicEvaluate];
          
        }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        return 50;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        if (self.total==0) {
            return 1;
        }
        return self.responseDatas.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        CGFloat hight= [BBSInfoCell getCellHightWithDataSource:self.infoDataSource];
        return hight;
    }
    else
    {
        if (self.total==0)
        {
            return [CommomNoCommentCell cellHeight];
        }
        CGFloat hight= [BBSCommentsCell getCellHightWithDataSource:self.responseDatas[indexPath.row]];
        return hight;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        
        BBSInfoCell *cell=[BBSInfoCell cellWithTableView:tableView];
        [cell loadCellWithDataSource:self.infoDataSource];
        [cell setCommentCount:self.total];
        [cell receiveObject:^(id object) {
            DEF_DEBUG(@"%@",object);
            //0删除话题  1踢出群组
            if ([object integerValue]==0)
            {
                [self delTopicWithTopicId:self.infoDataSource[@"id"]];
            }
            else
            {
                [self delAssociationUserWithPublishUserId:self.infoDataSource[@"publishUserId"]];
            }
        }];
        return cell;
    }
    else
    {
        
        if (self.total==0)
        {
            CommomNoCommentCell * cell = [CommomNoCommentCell cellWithTableView:tableView];
            return cell;
        }
        else
        {
            BBSCommentsCell *cell=[BBSCommentsCell cellWithTableView:tableView];
            [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
            if (!self.isGroup)
            {
                //非群主身份隐藏操作按钮
                [cell  hideCaoZuoView];
            }
            if(self.isGroup&&[self.responseDatas[indexPath.row][@"publishUserId"] isEqualToString:[KeychainManager readUserId]])
            {
                [cell  hideLaheiView];
                
            }
            [cell receiveObject:^(id object) {
                DEF_DEBUG(@"%@",object);
                //0删除评论  1拉黑
                if ([object integerValue]==0)
                {
                    [self delTopicEvaluateWithevalId:self.responseDatas[indexPath.row][@"evalId"]];
                }
                else
                {
                    [self delAssociationUserWithPublishUserId:self.responseDatas[indexPath.row][@"publishUserId"]];
                }
            }];
            
            return cell;

        }
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
        UILabel *commentNum=[UnityLHClass masonryLabel:[NSString stringWithFormat:@"回复（%ld）",(long)self.total] font:14.0 color:BM_Color_GrayColor];
        [sectionView addSubview:commentNum];
        [commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(sectionView.mas_centerY);
        }];
        UIImageView *more=[[UIImageView alloc]init];
        more.image=[UIImage imageNamed:@"right_arrow"];
        [sectionView addSubview:more];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(sectionView.mas_centerY);
        }];
        more.hidden=NO;
        if (self.total<6) {
            more.hidden=YES;
        }
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreComment)];
        [sectionView addGestureRecognizer:tap];
        
        return sectionView;

    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)moreComment
{
    if (self.total<6) {
        return;
    }
    ReplyToListViewController *replyToList=[[ReplyToListViewController alloc]init];
    replyToList.topicId=self.topicId;
    replyToList.isGroup=self.isGroup;
    [self.navigationController pushViewController:replyToList animated:YES];
    [replyToList receiveObject:^(id object) {
        [self getTopicDetail];
        [self getTopicEvaluate];
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
