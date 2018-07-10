//
//  CommunityHomeHeaderCell.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHomeHeaderCell.h"
#import "CommunityHomeView.h"

#import "MoreCommunityViewController.h"

@interface CommunityHomeHeaderCell()

@property(nonatomic,strong)CommunityHomeView *oneView;
@property(nonatomic,strong)CommunityHomeView *twoView;
@property(nonatomic,strong)CommunityHomeView *threeView;

@end

@implementation CommunityHomeHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommunityHomeHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityHomeHeaderCell"];
    if (!cell)
    {
        cell=[[CommunityHomeHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityHomeHeaderCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)createCell
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreCommunity)];
    [self addGestureRecognizer:tap];
    
    
    UIButton *addCommunity=[UnityLHClass masonryButton:@"加入更多社群" font:16.0 color:BM_WHITE];
    addCommunity.backgroundColor=BM_Color_Blue;
    addCommunity.layer.cornerRadius=5;
    addCommunity.layer.masksToBounds=YES;
    [self.contentView addSubview:addCommunity];
    [addCommunity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    [addCommunity handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
       
        [self moreCommunity];
    }];
    
 
    
    float viewWidth=(DEF_SCREEN_WIDTH-15*4)/3.0;
    self.oneView=[[CommunityHomeView alloc]init];
    [self addSubview:self.oneView];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(addCommunity.mas_top).offset(-20);
        make.width.mas_equalTo(viewWidth);
    }];
    
    self.twoView=[[CommunityHomeView alloc]init];
    [self addSubview:self.twoView];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.oneView.mas_centerY);
        make.width.mas_equalTo(self.oneView.mas_width);
        make.height.mas_equalTo(self.oneView.mas_height);
        make.left.mas_equalTo(self.oneView.mas_right).offset(15);
    }];
    
    self.threeView=[[CommunityHomeView alloc]init];
    [self addSubview:self.threeView];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.oneView.mas_centerY);
        make.width.mas_equalTo(self.oneView.mas_width);
        make.height.mas_equalTo(self.oneView.mas_height);
        make.left.mas_equalTo(self.twoView.mas_right).offset(15);
    }];
    
    [self.oneView receiveObject:^(id object) {
        [self sendObject:object];
    }];
    [self.twoView receiveObject:^(id object) {
        [self sendObject:object];

    }];
    [self.threeView receiveObject:^(id object) {
        [self sendObject:object];

    }];

    
}
-(void)moreCommunity
{
    MoreCommunityViewController *more=[[MoreCommunityViewController alloc]init];
    [self.topViewController.navigationController pushViewController:more animated:YES];
}
-(void)loadCellWithDataSource:(id)dataSource
{
    NSArray *dataSourceArr=(NSArray *)dataSource;
    switch (dataSourceArr.count)
    {
        case 0:
        {
            [self.oneView loadViewWithDataSource:nil];
            [self.twoView loadViewWithDataSource:nil];
            [self.threeView loadViewWithDataSource:nil];
 
        }
            break;
            
        case 1:
        {
            [self.oneView loadViewWithDataSource:dataSourceArr[0]];
            [self.twoView loadViewWithDataSource:nil];
            [self.threeView loadViewWithDataSource:nil];
        }
            break;
        case 2:
        {
            [self.oneView loadViewWithDataSource:dataSourceArr[0]];
            [self.twoView loadViewWithDataSource:dataSourceArr[1]];
            [self.threeView loadViewWithDataSource:nil];
        }
            break;
        case 3:
        {
            [self.oneView loadViewWithDataSource:dataSourceArr[0]];
            [self.twoView loadViewWithDataSource:dataSourceArr[1]];
            [self.threeView loadViewWithDataSource:dataSourceArr[2]];

        }
            break;
            
        default:
            break;
    }
}
@end
