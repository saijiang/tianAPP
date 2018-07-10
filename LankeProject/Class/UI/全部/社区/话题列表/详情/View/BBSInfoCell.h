//
//  BBSInfoCell.h
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@class BBSInfoImageView;
@interface BBSInfoCell : BaseTableViewCell

-(void)setCommentCount:(int)commentCount;
+(CGFloat)getCellHightWithDataSource:(id)dataSource;

@end


@interface BBSInfoImageView : UIView

-(void)loadViewWithDataSource:(NSArray *)imageArray;

@end
