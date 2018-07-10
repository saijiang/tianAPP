//
//  HRDivisionViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDivisionViewController.h"
#import "HeadlthInqurylCategoryCell.h"
#import "HRIllInfoViewController.h"
#import "HRDailyFitnessViewController.h"
#import "HRTCMViewController.h"
#import "HRDivisionWebViewController.h"

@interface HRDivisionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * hrDivisionTableView;

@property (nonatomic ,strong) NSMutableArray * hrDatas;

@end

@implementation HRDivisionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hrDatas = [NSMutableArray array];
    [self.hrDatas addObject:@{@"title":@"员工患病情况",
                              @"icon":@"health_icon_one",
                              @"banner":@"health_pic_one"}];
    [self.hrDatas addObject:@{@"title":@"员工健康情况",
                              @"icon":@"health_icon_two",
                              @"banner":@"health_pic_two"}];
    [self.hrDatas addObject:@{@"title":@"员工中医体质检测情况",
                              @"icon":@"health_icon_three",
                              @"banner":@"health_pic_three"}];
    [self.hrDatas addObject:@{@"title":@"企业健康方案",
                              @"icon":@"health_icon_four",
                              @"banner":@"health_pic_four"}];
    self.title = @"HR专区";
}

- (void) createUI{
    
    self.hrDivisionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.hrDivisionTableView.backgroundColor = [UIColor clearColor];
    self.hrDivisionTableView.delegate = self;
    self.hrDivisionTableView.dataSource = self;
    self.hrDivisionTableView.tableFooterView = [UIView new];
    self.hrDivisionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hrDivisionTableView.showsVerticalScrollIndicator = NO;
    self.hrDivisionTableView.rowHeight = [HeadlthInqurylCategoryCell cellHeight];
    [self.hrDivisionTableView registerClass:[HeadlthInqurylCategoryCell class]
                     forCellReuseIdentifier:[HeadlthInqurylCategoryCell cellIdentifier]];
    [self addSubview:self.hrDivisionTableView];

}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.hrDivisionTableView mas_makeConstraints:^(MASConstraintMaker *make){
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
    
    [cell configHRCellWithData:self.hrDatas[indexPath.section] index:indexPath.section];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.hrDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HRIllInfoViewController * info = [[HRIllInfoViewController alloc] init];
        [self.navigationController pushViewController:info animated:YES];
    }
    if (indexPath.section == 1) {
        HRDailyFitnessViewController * fitness = [[HRDailyFitnessViewController alloc] init];
        [self.navigationController pushViewController:fitness animated:YES];
    }
    if (indexPath.section == 2) {
        HRTCMViewController * tcm = [[HRTCMViewController alloc] init];
        [self.navigationController pushViewController:tcm animated:YES];
    }
    if (indexPath.section == 3) {
        HRDivisionWebViewController * tcm = [[HRDivisionWebViewController alloc] init];
        [self.navigationController pushViewController:tcm animated:YES];
    }
}


#pragma mark -
#pragma mark Network M


@end
