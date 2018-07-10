//
//  HRTCMViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRTCMViewController.h"
#import "GridTableViewCell.h"
#import "GridHeaderContentView.h"
#import "HRTCMDetailViewController.h"

@interface HRTCMViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * tcmTableView;

@property (nonatomic ,strong) NSMutableArray * tcmList;

@property (nonatomic ,strong) GridHeaderContentView * headerView;

@end

@implementation HRTCMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工中医体质检测情况";
    
    self.tcmList = [NSMutableArray array];
    
    [self requestHRIllInfo];
}

- (void) createUI{
    
    self.tcmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tcmTableView.backgroundColor = [UIColor clearColor];
    self.tcmTableView.delegate = self;
    self.tcmTableView.dataSource = self;
    self.tcmTableView.tableFooterView = [UIView new];
    self.tcmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tcmTableView.showsVerticalScrollIndicator = NO;
    self.tcmTableView.emptyDataSetSource=self;
    self.tcmTableView.rowHeight = [GridTableViewCell cellHeight];
    [self.tcmTableView registerNib:[GridTableViewCell nib]
                forCellReuseIdentifier:[GridTableViewCell cellIdentifier]];
    [self addSubview:self.tcmTableView];
    
}

- (GridHeaderContentView *)headerView{
    
    if (!_headerView)
    {
        _headerView = [GridHeaderContentView view];
        _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150);
        [_headerView configTCM:nil];
        [_headerView setupContentView:^UIView *{
            
            UIView * contentView = [UIView new];
            contentView.userInteractionEnabled = NO;
            contentView.backgroundColor = [UIColor clearColor];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 101010;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"health_icon_ill_info"] forState:UIControlStateNormal];
            [button setTitle:@"   本单位总人数0人,参与检测人数0人" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
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
    
    [self.tcmTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tcmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GridTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[GridTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configTCM:self.tcmList[indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tcmList.count==0) {
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
    if (self.tcmList.count==0) {
        return nil;
    }
    return [self headerView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRTCMDetailViewController*detail=[[HRTCMDetailViewController alloc]init];
    detail.dicData=self.tcmList[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
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
     getTCMInfoUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"][@"list"];
            UIButton * button = [self.headerView.contentView viewWithTag:101010];
            [button setTitle:[NSString stringWithFormat:@"   本单位总人数%@人,参与检测人数%@人",responseObject[@"data"][@"total"],responseObject[@"data"][@"joinNum"]] forState:UIControlStateNormal];
            
            [self.tcmList removeAllObjects];
            if (data)
            {
                [self.tcmList addObjectsFromArray:data];
            }
            [self.tcmTableView reloadData];
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
