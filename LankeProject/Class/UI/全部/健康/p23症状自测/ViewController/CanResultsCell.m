//
//  CanResultsCell.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CanResultsCell.h"

@interface CanResultsCell()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *progress;
@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation CanResultsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CanResultsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CanResultsCell"];
    if (!cell)
    {
        cell=[[CanResultsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CanResultsCell"];
    }
    return cell;
    
}
-(void)createCell
{
    self.name=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.name];
    self.progress=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.progress];
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.layer.cornerRadius = 5.0f;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.tintColor = BM_Color_Blue;
    [self.contentView addSubview:self.progressView];
    UIImageView *goImage=[[UIImageView alloc]init];
    goImage.image=[UIImage imageNamed:@"right_arrow"];
    [self.contentView addSubview:goImage];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineView];

    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        
    }];
    [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.name.mas_centerY);
        
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImage.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.name.mas_centerY);
        
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(7);
        make.top.mas_equalTo(self.name.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);

    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.progressView.mas_right);
        make.left.mas_equalTo(self.progressView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.name.text=dataSource[@"diseaseName"];
    self.progress.text=[NSString stringWithFormat:@"%@%相似病例",dataSource[@"similarCasesPer"]];
    self.progressView.progress=[dataSource[@"similarCasesPer"] floatValue]/100.0;
}
@end
