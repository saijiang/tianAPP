//
//  UIView+Animation.h
//  MHProject
//
//  Created by 董駸 on 16/1/20.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LKCompletionBlock)();

@interface UIView (Animation)

@property (copy,nonatomic) LKCompletionBlock completionBlock;

- (void)viewHiddenWithDuration:(NSTimeInterval)timeInterval completion:(LKCompletionBlock)completionBlock;

- (void)viewShowWithDuration:(NSTimeInterval)timeInterval completion:(LKCompletionBlock)completionBlock;

@end
