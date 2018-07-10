//
//  BaseTableViewCell.m
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BaseTableViewCell"];
    if (!cell)
    {
        cell=[[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BaseTableViewCell"];
    }
    return cell;

}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    return nil;
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}
+ (CGFloat)getCellHightWithDataSource:(id)dataSource
{
    return 44.0f;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *selectedBackgroundView=[[UIView alloc]initWithFrame:self.bounds];
        selectedBackgroundView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        self.selectedBackgroundView=selectedBackgroundView;
        [self createCell];
    }
    
    return self;
}
-(void)createCell
{
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.data=dataSource;
}
//加载的疗养券
-(void)loadThearyCellWithDataSource:(id)dataSource{
   self.data=dataSource;
}
//疗养券消费
-(void)loadThearyCellUserDetailsWithDataSource:(id)dataSource{
    self.data = dataSource;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end
