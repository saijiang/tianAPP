//
//  HistorySearchCell.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HistorySearchCell.h"
#import "MallSearchManager.h"
@implementation HistorySearchCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    HistorySearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HistorySearchCell"];
    if (!cell)
    {
        cell=[[HistorySearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HistorySearchCell"];
    }
    return cell;
}

-(void)createCell
{
    self.searceTitle=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00]];
    [self.contentView addSubview:self.searceTitle];
    [self.searceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.left.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDelet:)];
    [view addGestureRecognizer:tap];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self.searceTitle.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
    }];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"x" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIWindowLevelNormal];
    [deleteButton hll_setBackgroundImageWithColor:[UIColor colorWithHexString:@"cdcdcd"] forState:UIControlStateNormal];
    deleteButton.layer.cornerRadius = 10;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.userInteractionEnabled = NO;
//    [deleteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        if (self.bSearchHistoryDeleteHandle) {
//            self.bSearchHistoryDeleteHandle();
//        }
//    }];
    [view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.centerY);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void) tapDelet:(id)gesture{
    if (self.bSearchHistoryDeleteHandle) {
        self.bSearchHistoryDeleteHandle();
    }
}

-(void)loadCellWithDataSource:(id)dataSource
{
    MallSearchManager *searchData=(MallSearchManager *)dataSource;
    self.searceTitle.text=searchData.searchTitle;
}

@end
