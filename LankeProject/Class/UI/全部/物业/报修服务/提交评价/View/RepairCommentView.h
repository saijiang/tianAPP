//
//  RepairCommentView.h
//  LankeProject
//
//  Created by itman on 17/5/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYZTextView.h"
#import "AXRatingView.h"

@interface RepairCommentView : UIView

@property(nonatomic,strong)JYZTextView *contentView;
@property(nonatomic,strong)AXRatingView *commentGradeView;

@end
