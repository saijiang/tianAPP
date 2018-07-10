//
//  UINavigationController+DQExtension.m
//  MHProject
//
//  Created by 董駸 on 15/7/1.
//  Copyright (c) 2015年 董駸. All rights reserved.
//

#import "UINavigationController+DQExtension.h"
#import <objc/runtime.h>

@implementation UINavigationController (DQExtension)

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha
{
    [[self.navigationBar valueForKey:@"_backgroundView"] setAlpha:navigationBarBackgroundAlpha];
}

- (CGFloat)navigationBarBackgroundAlpha
{
    return [[self.navigationBar valueForKey:@"_backgroundView"] alpha];
}

- (BOOL)fullScreenInteractivePopGestureRecognizer
{
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (void)setFullScreenInteractivePopGestureRecognizer:(BOOL)fullScreenInteractivePopGestureRecognizer
{
    if (fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        //更改self.interactivePopGestureRecognizer的类
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setNavigationBarSize:(CGSize)navigationBarSize
{
    CGRect rect = self.navigationBar.frame;
    rect.size = navigationBarSize;
    self.navigationBar.frame = rect;
}

- (void)setToolbarSize:(CGSize)toolbarSize {
    CGRect rect = self.toolbar.frame;
    rect.size = toolbarSize;
    self.toolbar.frame = rect;
}

@end

@implementation UINavigationBar (DQExtension)
static const void *_viewMove = &_viewMove;

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.viewMove)
    {
        CGSize newSize = [super sizeThatFits:size];
        return CGSizeMake(newSize.width == 320.f ? [UIScreen mainScreen].bounds.size.width : newSize.width, newSize.height);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
}

- (void)setViewMove:(BOOL)viewMove
{
    //给self设置新的名为viewMove的属性作关联
    objc_setAssociatedObject(self, _viewMove, @(viewMove), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)viewMove
{
    //获取关联self名为viewMove的属性
    return [objc_getAssociatedObject(self, _viewMove) boolValue];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([[self valueForKey:@"_backgroundView"] alpha] < 1.0f)
    {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end