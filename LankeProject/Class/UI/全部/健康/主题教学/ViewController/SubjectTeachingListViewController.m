//
//  SubjectTeachingListViewController.m
//  LankeProject
//
//  Created by itman on 2017/7/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SubjectTeachingListViewController.h"
#import "EHHorizontalSelectionView.h"
#import "HeadlthInqurylCell.h"
#import "HealthDetailViewController.h"
#import "HealthInqurylSearchView.h"
@interface SubjectTeachingListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,EHHorizontalSelectionViewProtocol>

@property (nonatomic ,strong) IBOutlet EHHorizontalSelectionView * teachSegmentView;
@property (nonatomic ,strong) NSMutableArray * teachSegments;
@property (nonatomic ,strong) UITableView * teachTableView;

@property (nonatomic ,copy) NSString * videoClassId;
@property (nonatomic ,copy) NSString * searchString;

@end

@implementation SubjectTeachingListViewController


-(NSMutableArray *)teachSegments
{
    if (!_teachSegments)
    {
        _teachSegments=[[NSMutableArray alloc]init];
        NSMutableDictionary *allDic=[[NSMutableDictionary alloc]init];
        [allDic setValue:@"" forKey:@"id"];
        [allDic setValue:@"全部" forKey:@"className"];
        [_teachSegments addObject:allDic];
    }
    return _teachSegments;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTeachVideoClass];
    [self refresh];
    
}
- (void)createUI
{
    WeakSelf
    HealthInqurylSearchView *headerSearchView = [[HealthInqurylSearchView alloc] init];
    headerSearchView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50);
    headerSearchView.bSearchBarSearchButtonDidClicked = ^(NSString * content){
        weakSelf.searchString=content;
        [weakSelf refresh];
    };
    [self.view addSubview:headerSearchView];

    self.teachSegmentView = [[EHHorizontalSelectionView alloc] initWithFrame:CGRectZero];
    self.teachSegmentView.backgroundColor = [UIColor whiteColor];
    [self.teachSegmentView registerCellWithClass:[EHHorizontalLineViewCell class]];
    self.teachSegmentView.delegate = self;
    self.teachSegmentView.tintColor = BM_Color_Blue;
    self.teachSegmentView.normalTextColor = BM_BLACK;
    self.teachSegmentView.selectTextColor = BM_Color_Blue;
    self.teachSegmentView.font = [UIFont systemFontOfSize:16];
    self.teachSegmentView.fontMedium = [UIFont systemFontOfSize:16];
    self.teachSegmentView.maxDisplayCount = 4;
    [EHHorizontalLineViewCell updateColorHeight:3.f];
    [self.view addSubview:self.teachSegmentView];
    
    self.teachTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.teachTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teachTableView.delegate = self;
    self.teachTableView.dataSource = self;
    self.teachTableView.emptyDataSetSource = self;
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    self.teachTableView.tableHeaderView = headerView;
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 10);
    footerView.backgroundColor = [UIColor clearColor];
    self.teachTableView.tableFooterView = footerView;
    self.teachTableView.backgroundColor = [UIColor clearColor];
    [self.teachTableView registerClass:[HeadlthInqurylCell class]
                forCellReuseIdentifier:[HeadlthInqurylCell cellIdentifier]];
    [self.view addSubview:self.teachTableView];

    
    [self.teachTableView addHeaderWithCallback:^{
       
        [weakSelf refresh];
    }];
    
    [self.teachTableView addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    
    
    [self.teachSegmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(headerSearchView.mas_bottom);
        if ([weakSelf.teachingType isEqualToString:@"01"]) {
            make.height.mas_equalTo(45);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
    [self.teachTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([weakSelf.teachingType isEqualToString:@"01"]) {
            make.top.mas_equalTo(self.teachSegmentView.mas_bottom).offset(10);
        }else{
            make.top.mas_equalTo(self.teachSegmentView.mas_bottom);
        }
        make.left.mas_equalTo(self.teachSegmentView.left);
        make.right.mas_equalTo(self.teachSegmentView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
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
    return [HeadlthInqurylCell cellHeightWithData:self.responseDatas[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return .1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeadlthInqurylCell *cell=[tableView dequeueReusableCellWithIdentifier:[HeadlthInqurylCell cellIdentifier]];
    if (!cell)
    {
        cell = [[HeadlthInqurylCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[HeadlthInqurylCell cellIdentifier]];
    }
    [cell loadCellWithDataSource:self.responseDatas[indexPath.section]];
    return cell;
};

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * data = self.responseDatas[indexPath.section];
    HealthDetailViewController *detail = [[HealthDetailViewController alloc] init];
    detail.teachId = data[@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.teachSegments.count;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    NSDictionary *data=self.teachSegments[index];
    NSString *className=data[@"className"];
    return className;
}

- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index{
    
    NSDictionary *data=self.teachSegments[index];
    NSString *classId=data[@"id"];
    self.videoClassId = classId;
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
- (void) initiateNetworkListRequest{
    
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    
    [UserServices
     getTeachListWithVideoClassId:self.videoClassId
     title:self.searchString
     teachingType:self.teachingType
     pageIndex:pageIndex
     pageSize:pageSize
     completionBlock:^(int result, id responseObject)
     {
         
         if (result == 0) {
             
             NSArray * data = responseObject[@"data"];
             [self responseDataList:data];
             if (self.pageItem.isRefresh) {
                 [self.teachTableView headerEndRefreshing];
             }else{
                 
                 if (!self.pageItem.canLoadMore) {
                     [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                 }
                 [self.teachTableView footerEndRefreshing];
             }
             
             [self.teachTableView reloadData];
         }else{
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

-(void)getTeachVideoClass
{
  
    [UserServices
     getTeachVideoClassCompletionBlock:^(int result, id responseObject)
     {
         id data=responseObject[@"data"];
         if (result==0) {
             if ([data isKindOfClass:[NSArray class]]) {
                 [self.teachSegments addObjectsFromArray:data];
             }
             
         }
         else{
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
         [self.teachSegmentView reloadData];

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
