//
//  UINavigationController+DQExtension.h
//  MHProject
//
//  Created by 董駸 on 15/7/1.
//  Copyright (c) 2015年 董駸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DQExtension)

@property (assign,nonatomic) CGFloat navigationBarBackgroundAlpha;

@property (assign,nonatomic) BOOL fullScreenInteractivePopGestureRecognizer;

- (void)setNavigationBarSize:(CGSize)navigationBarSize;

- (void)setToolbarSize:(CGSize)toolbarSize;

@end

@interface UINavigationBar (DQExtension)

@property (assign,nonatomic) BOOL viewMove;

@end

@interface UIViewController (DQExtension)

@property (assign,nonatomic) BOOL hidesNavigationBarWhenPushed;

@end