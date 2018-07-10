//
//  ChooseDateView.h
//  LankeProject
//
//  Created by Youngrocky on 16/6/24.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateSelectedResult)(id result);

@interface ChooseDateView : UIView

@property (nonatomic ,copy) DateSelectedResult resultBlock;

- (void) showDateSelectViewAtView:(UIView *)view;

- (void) scrollDateSelectViewWithDate:(NSDate *)date;
@end
