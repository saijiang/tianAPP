//
//  MallcommentCell.h
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JYZTextView.h"
#import "AXRatingView.h"
#import "MallcommentModel.h"
@interface MallcommentCell : BaseTableViewCell<UITextViewDelegate>

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)JYZTextView *note;
@property(nonatomic,strong)AXRatingView *commentGradeView;

@property(nonatomic,strong)MallcommentModel *model;

@end
