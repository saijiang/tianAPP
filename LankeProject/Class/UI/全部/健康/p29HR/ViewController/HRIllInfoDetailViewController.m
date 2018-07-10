//
//  HRIllInfoDetailViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRIllInfoDetailViewController.h"
#import "GridTableViewCell.h"
#import "GridHeaderContentView.h"

@interface HRIllInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * illInfoDetailTableView;
@property (nonatomic ,strong) NSMutableArray * illInfoDetailList;
@end

@implementation HRIllInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"患病名单";
    self.illInfoDetailList = [NSMutableArray array];
    
    [self requestIllInfoDetail];
}

- (void) createUI{
    
    self.illInfoDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.illInfoDetailTableView.backgroundColor = [UIColor clearColor];
    self.illInfoDetailTableView.delegate = self;
    self.illInfoDetailTableView.dataSource = self;
    self.illInfoDetailTableView.tableFooterView = [UIView new];
    self.illInfoDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.illInfoDetailTableView.showsVerticalScrollIndicator = NO;
    self.illInfoDetailTableView.emptyDataSetSource=self;
//    self.illInfoDetailTableView.tableHeaderView = [self headerView];
    self.illInfoDetailTableView.rowHeight = [GridTableViewCell cellHeight];
    [self.illInfoDetailTableView registerNib:[GridTableViewCell nib]
                      forCellReuseIdentifier:[GridTableViewCell cellIdentifier]];
    [self addSubview:self.illInfoDetailTableView];
    
}

- (UIView *)headerView{
    
    GridHeaderContentView * headerView = [GridHeaderContentView view];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 200);
    [headerView configIllDetail:nil];
    [headerView setupContentView:^UIView *{
        
        LocalhostImageView * imageView = [[LocalhostImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"health_header_ill_Detail"];
        return imageView;
    }];
    return headerView;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.illInfoDetailTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.illInfoDetailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GridTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[GridTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell configIllDetail:self.illInfoDetailList[indexPath.row]];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.illInfoDetailList.count==0) {
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
    if (self.illInfoDetailList.count==0) {
        return nil;
    }
    return [self headerView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (void) requestIllInfoDetail{
    
    // 患病详情接口
    [UserServices getSickenListWithUserId:[KeychainManager readUserId] flag:self.illInfo[@"bodyInfoType"] completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            id data = responseObject[@"data"];
            [self.illInfoDetailList removeAllObjects];
            if (data) {
                [self.illInfoDetailList addObjectsFromArray:data];
            }
            [self.illInfoDetailTableView reloadData];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
