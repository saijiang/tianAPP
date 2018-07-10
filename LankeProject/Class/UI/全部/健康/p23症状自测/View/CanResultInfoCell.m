//
//  CanResultCell.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CanResultInfoCell.h"

@implementation CanResultInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CanResultInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CanResultInfoCell"];
    if (!cell)
    {
        cell=[[CanResultInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CanResultInfoCell"];
    }
    return cell;
    
}
-(void)loadCellWithDataSource:(id)dataSource
{
    
}
@end
