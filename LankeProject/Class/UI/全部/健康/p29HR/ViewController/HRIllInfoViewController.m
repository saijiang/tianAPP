//
//  HRIllInfoViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRIllInfoViewController.h"
#import "GridTableViewCell.h"
#import "GridHeaderContentView.h"
#import "HRIllInfoDetailViewController.h"

@interface HRIllInfoViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * illInfoTableView;
@property (nonatomic ,strong) NSMutableArray * illInfoList;
@property (nonatomic ,strong) GridHeaderContentView * headerView;
@property (nonatomic ,strong) NSString * total;
@end

@implementation HRIllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.illInfoList = [NSMutableArray array];
    
    self.title = @"单位人员患病情况";
    
    [self requestHRIllInfo];
}

- (void) createUI{
    
    self.illInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.illInfoTableView.backgroundColor = [UIColor clearColor];
    self.illInfoTableView.delegate = self;
    self.illInfoTableView.dataSource = self;
    self.illInfoTableView.tableFooterView = [UIView new];
    self.illInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.illInfoTableView.showsVerticalScrollIndicator = NO;
    self.illInfoTableView.emptyDataSetSource=self;
//    self.illInfoTableView.tableHeaderView = [self headerView];
    self.illInfoTableView.rowHeight = [GridTableViewCell cellHeight];
    [self.illInfoTableView registerNib:[GridTableViewCell nib]
                forCellReuseIdentifier:[GridTableViewCell cellIdentifier]];
    [self addSubview:self.illInfoTableView];
    
}

- (GridHeaderContentView *)headerView{

    if (!_headerView)
    {
        WeakSelf
        _headerView = [GridHeaderContentView view];
        _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150);
        [_headerView configEmployeeIllInfo:nil];
        [_headerView setupContentView:^UIView *{
            
            UIView * contentView = [UIView new];
            contentView.userInteractionEnabled = NO;
            contentView.backgroundColor = [UIColor clearColor];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 101010;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"health_icon_ill_info"] forState:UIControlStateNormal];
            [button setTitle:weakSelf.total forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo(contentView.mas_width).multipliedBy(0.8);
                make.height.mas_equalTo(80);
                make.centerY.mas_equalTo(0);
                make.centerX.mas_equalTo(0);
            }];
            return contentView;
        }];

    }
    return _headerView;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.illInfoTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.illInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GridTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[GridTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configEmployeeIllInfo:self.illInfoList[indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRIllInfoDetailViewController * infoDetail = [[HRIllInfoDetailViewController alloc] init];
    infoDetail.illInfo = self.illInfoList[indexPath.row];
    [self.navigationController pushViewController:infoDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.illInfoList.count==0) {
        return 0.1;
    }
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.illInfoList.count==0) {
        return nil;
    }
    return [self headerView];
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

- (void) requestHRIllInfo{
    
    // 患病情况接口
    [UserServices
     getSickenListWithUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"][@"list"];
            self.total=[NSString stringWithFormat:@"   本单位总人数%@人",responseObject[@"data"][@"total"]];
            [self.illInfoList removeAllObjects];
            if (data)
            {
                [self.illInfoList addObjectsFromArray:data];
            }
            [self.illInfoTableView reloadData];
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
