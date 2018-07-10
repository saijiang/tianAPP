//
//  HealthInquiryHomeViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthInquiryHomeViewController.h"
#import "HeadlthInqurylCategoryCell.h"
#import "HealthInqurylSearchView.h"

#import "HealthDetailViewController.h"
#import "HealthInquiryViewController.h"

@interface HealthInquiryHomeViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * healthInquiryCategoryTableView;

@property (nonatomic ,strong) NSMutableArray * categoryData;

@property (nonatomic ,strong) HealthInqurylSearchView * headerSearchView;
@end

@implementation HealthInquiryHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _categoryData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康资讯";
    
    [self creatUI];
    
    [self requestHealthCategoryWithKeyword:nil];
}

- (void) creatUI{
    
    _healthInquiryCategoryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _healthInquiryCategoryTableView.backgroundColor = [UIColor clearColor];
    _healthInquiryCategoryTableView.delegate = self;
    _healthInquiryCategoryTableView.dataSource = self;
    _healthInquiryCategoryTableView.tableFooterView = [UIView new];
    _healthInquiryCategoryTableView.tableHeaderView = [self headerView];
    _healthInquiryCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _healthInquiryCategoryTableView.showsVerticalScrollIndicator = NO;
    _healthInquiryCategoryTableView.rowHeight = [HeadlthInqurylCategoryCell cellHeight];
    _healthInquiryCategoryTableView.emptyDataSetSource=self;
    [_healthInquiryCategoryTableView registerClass:[HeadlthInqurylCategoryCell class]
                            forCellReuseIdentifier:[HeadlthInqurylCategoryCell cellIdentifier]];
    [self addSubview:_healthInquiryCategoryTableView];
    
    [self headerView];
}

- (UIView *) headerView{

    LKWeakSelf
    _headerSearchView = [[HealthInqurylSearchView alloc] init];
    _headerSearchView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50);
    _headerSearchView.bSearchBarSearchButtonDidClicked = ^(NSString * content){
        
        LKStrongSelf
        HealthInquiryViewController * detail = [[HealthInquiryViewController alloc] init];
        detail.key = content;
        [_self.navigationController pushViewController:detail animated:YES];
    };
    return _headerSearchView;
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [_healthInquiryCategoryTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadlthInqurylCategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:[HeadlthInqurylCategoryCell cellIdentifier] forIndexPath:indexPath];
    [cell configCellWithData:self.categoryData[indexPath.section]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.categoryData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary * data = self.categoryData[indexPath.section];
    HealthInquiryViewController * detail = [[HealthInquiryViewController alloc] init];
    detail.adviceClassId = data[@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void) requestHealthCategoryWithKeyword:(NSString *)keyword{
    
    [UserServices
     healthAdviceClassWithClassName:keyword
     completionBlock:^(int result, id responseObject)
    {
       
        if (result == 0) {
            id data = responseObject[@"data"];
            
            [self.categoryData removeAllObjects];
            [self.categoryData addObjectsFromArray:data];
            [self.healthInquiryCategoryTableView reloadData];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
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

@end
