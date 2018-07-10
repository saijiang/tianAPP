//
//  AddSportHistoryViewController.m
//  LankeProject
//
//  Created by itman on 2017/7/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "AddSportHistoryViewController.h"
#import "GridTableViewCell.h"
#import "GridHeaderContentView.h"
#import "HRIllInfoDetailViewController.h"
#import "MyHandRingViewController.h"
@interface AddSportHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic ,strong) UITableView * illInfoTableView;

@end

@implementation AddSportHistoryViewController

-(void)baseRightBtnAction:(UIButton *)btn
{
    MyHandRingViewController *myHand=[[MyHandRingViewController alloc]init];
    [self.navigationController pushViewController:myHand animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[LAKALABraceletManager sharedInstance] isConnected])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健身数据";
    [self showRightBarButtonItemHUDByName:@"连接手环"];
}


- (void) createUI{
    
    self.illInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.illInfoTableView.backgroundColor = [UIColor clearColor];
    self.illInfoTableView.delegate = self;
    self.illInfoTableView.dataSource = self;
    self.illInfoTableView.emptyDataSetSource = self;
    self.illInfoTableView.tableFooterView = [UIView new];
    self.illInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.illInfoTableView.showsVerticalScrollIndicator = NO;
    self.illInfoTableView.rowHeight = [GridTableViewCell cellHeight];
    [self.illInfoTableView registerNib:[GridTableViewCell nib]
                forCellReuseIdentifier:[GridTableViewCell cellIdentifier]];
    [self addSubview:self.illInfoTableView];
    
}

- (UIView *)headerView{
    
    GridHeaderContentView * headerView = [GridHeaderContentView view];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 200);
    [headerView configAddSportFitnessPlanDetail:nil];
    [headerView setupContentView:^UIView *{
        
        UIView * contentView = [UIView new];
        contentView.userInteractionEnabled = NO;
        contentView.backgroundColor = [UIColor clearColor];
        NetworkImageView *image=[[NetworkImageView alloc]init];
        image.image=[UIImage imageNamed:@"health_header_fitness_detail"];
        [contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(contentView);
        }];
        UILabel *titleLb=[UnityLHClass masonryLabel:[NSString stringWithFormat:@"总消耗:%@千卡",self.data[@"consumeCalories"]] font:20.0 color:BM_BLACK];
        [contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(image.mas_centerY);
            make.centerX.mas_equalTo(image.mas_centerX);
            
        }];
        return contentView;
    }];
    return headerView;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.data[@"customSportsPlanList"] count]==0) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.data[@"customSportsPlanList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GridTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[GridTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell configAddSportFitnessPlanDetail:self.data[@"customSportsPlanList"][indexPath.row]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self headerView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark DZNEmptyDataSetSource

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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
