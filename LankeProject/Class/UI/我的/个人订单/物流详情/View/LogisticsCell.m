//
//  LogisticsCell.m
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    if (!cell)
    {
        cell=[[LogisticsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LogisticsCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0)
    {
        cell.topLine.hidden=YES;
        cell.centerDian.backgroundColor=BM_Color_Blue;
        cell.content.textColor=BM_Color_Blue;
        cell.time.textColor=BM_Color_Blue;
        cell.personLab.textColor = BM_Color_Blue;
    }
    else
    {
        cell.topLine.hidden=NO;
        cell.centerDian.backgroundColor=[UIColor groupTableViewBackgroundColor];
        cell.content.textColor=BM_Color_GrayColor;
        cell.time.textColor=BM_Color_GrayColor;
    }
    return cell;
    
}

-(void)createCell
{
    self.topLine=[[UIImageView alloc]init];
    self.topLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.topLine];
    
    self.centerDian=[[UIImageView alloc]init];
    self.centerDian.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.centerDian.layer.masksToBounds=YES;
    self.centerDian.layer.cornerRadius=15/2.0;
    [self.contentView addSubview:self.centerDian];
    
    self.bottomLine=[[UIImageView alloc]init];
    self.bottomLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.bottomLine];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.contentView.mas_left).offset(20);
    }];
    
    [self.centerDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.centerX.mas_equalTo(self.topLine.mas_centerX);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerDian.mas_bottom);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.topLine.mas_centerX);
        make.bottom.mas_equalTo(0);
    }];
    
    self.content=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_Color_GrayColor];
    self.content.numberOfLines=0;
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerDian.mas_top);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.centerDian.mas_centerX).offset(20);
    }];
    
    self.time=[UnityLHClass masonryLabel:@"" font:11.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.content.mas_bottom).offset(7);
        make.left.mas_equalTo(self.content.mas_left);
    }];
    
    self.personLab = [UnityLHClass masonryLabel:@"" font:13.0 color:BM_Color_GrayColor];
    self.personLab.hidden = YES;
    [self.contentView addSubview:self.personLab];
    [self.personLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.time.mas_bottom).offset(7);
        make.left.mas_equalTo(self.time.mas_left);
    }];

    
    UIImageView *line=[[UIImageView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.mas_equalTo(0);
        make.left.mas_equalTo(self.content.mas_left);
        make.height.mas_equalTo(1);
    }];
 

}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.content.text=dataSource[@"content"];
    self.time.text=dataSource[@"time"];

}

+(float)getCellHightWithDatasource:(id)dataSource
{
    float hight= [UnityLHClass getHeight:dataSource[@"content"] wid:DEF_SCREEN_WIDTH-50 font:13.0]+15+7+25;
    return hight;
}
-(void)loadOneShopCellWithDataSource:(id)dataSource
{
    self.content.text=[NSString stringWithFormat:@"[%@] %@",dataSource[@"operateDetail"],dataSource[@"operateRemark"]];
    
    self.time.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd hh:mm:ss" andTimeString:dataSource[@"operateTime"]];

}

//京东物流cell
-(void)loadJDshopCellWithDataSource:(id)dataSource
{
    self.content.text=[NSString stringWithFormat:@"[%@] %@",dataSource[@"operator"],dataSource[@"content"]];
    
    self.time.text= dataSource[@"msgTime"];//[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd hh:mm:ss" andTimeString:dataSource[@"operateTime"]];
    
}
//京东物流cell高度
+(float)getJDshopCellHightWithDatasource:(id)dataSource
{
    NSString *string=[NSString stringWithFormat:@"[%@] %@",dataSource[@"operator"],dataSource[@"content"]];
    float hight= [UnityLHClass getHeight:string wid:DEF_SCREEN_WIDTH-50 font:13.0]+15+7+25;
    return hight;
}

+(float)getOneShopCellHightWithDatasource:(id)dataSource
{
    NSString *string=[NSString stringWithFormat:@"[%@] %@",dataSource[@"operateDetail"],dataSource[@"operateRemark"]];
    float hight= [UnityLHClass getHeight:string wid:DEF_SCREEN_WIDTH-50 font:13.0]+15+7+25;
    return hight;
}


//京东服务单进度cell赋值
-(void)loadJDCellWithDataSource:(id)dataSource
{
    self.personLab.hidden = NO;
    
    self.personLab.text = @"经办人：京东";
    
    self.content.text = @"您的服务单 23434324234 已返厂维修中";
    
    self.time.text = @"2017-09-12 22:23:32";
}

@end
