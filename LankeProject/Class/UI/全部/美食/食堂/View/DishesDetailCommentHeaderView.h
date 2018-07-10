//
//  DishesDetailCommentHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishesDetailCommentHeaderView : UIView

@property (nonatomic ,copy) void (^bCommentHeaderTapHandle)();

- (void) configCommentHeaderViewWithData:(id)data;
- (void) configEvalScoresHeaderViewWithData:(id)data;

//京东详情评价区头赋值
- (void) configJDCommentHeaderViewWithData:(id)data;


@end
