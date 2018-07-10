//
//  CommunityHeadCell.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityHeadCell.h"

@implementation CommunityHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommunityHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityHeadCell"];
    if (!cell)
    {
        cell=[[CommunityHeadCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommunityHeadCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.title=[UnityLHClass masonryLabel:@"" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.title];
    
    self.time=[UnityLHClass masonryLabel:@"" font:13.0 color:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00]];
    [self.contentView addSubview:self.time];
    
    self.info=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00]];
    self.info.numberOfLines=0;
    [self.contentView addSubview:self.info];
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.title.mas_bottom).offset(10);
    }];
    
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.time.mas_bottom).offset(10);
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.info.mas_left);
        make.right.mas_equalTo(self.info.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.title.text=dataSource[@"title"];
    self.time.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd" andTimeString:dataSource[@"publishTime"]];

    self.info.text=dataSource[@"introduction"];

}
+(float)getCellHightWithDataSource:(NSDictionary *)dataSource tableView:(UITableView *)tableView;
{
 
    float hight=0;
    hight+=15;
    hight+=20;
    hight+=10;
    hight+=17;
    hight+=10;
    hight+=15;
    hight+=[UnityLHClass getHeight:dataSource[@"introduction"] wid:DEF_SCREEN_WIDTH-30 font:15.0];
    return hight;
}

@end
