//
//  UIView+Animation.m
//  MHProject
//
//  Created by 董駸 on 16/1/20.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/runtime.h>

@implementation UIView (Animation)

static const void *_completionBlock = &_completionBlock;

- (void)setCompletionBlock:(LKCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, _completionBlock, completionBlock, OBJC_ASSOCIATION_COPY);
}

- (LKCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, _completionBlock);
}

- (void)viewHiddenWithDuration:(NSTimeInterval)timeInterval completion:(LKCompletionBlock)completionBlock
{
    if (timeInterval == 0) {
        self.hidden = YES;
        self.completionBlock ();
        return;
    }
    self.completionBlock = completionBlock;
    [UIView animateWithDuration:timeInterval animations:^{
        self.hidden = YES;
    } completion:^(BOOL finished) {
        if (self.completionBlock) {
            self.completionBlock ();
        }
    }];
}

- (void)viewShowWithDuration:(NSTimeInterval)timeInterval completion:(LKCompletionBlock)completionBlock
{
    if (timeInterval == 0) {
        self.hidden = NO;
        self.completionBlock ();
        return;
    }
    self.completionBlock = completionBlock;
    [UIView animateWithDuration:timeInterval animations:^{
        self.hidden = NO;
    } completion:^(BOOL finished) {
        if (self.completionBlock) {
            self.completionBlock ();
        }
    }];
}

@end
