//
//  BBSCommentsCell.h
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BBSCommentsCell : BaseTableViewCell

-(void)hideCaoZuoView;
-(void)hideLaheiView;
+(CGFloat)getCellHightWithDataSource:(id)dataSource;

@end
