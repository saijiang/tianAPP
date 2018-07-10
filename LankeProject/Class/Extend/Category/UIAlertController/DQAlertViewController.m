//
//  DQAlertViewController.m
//  MHProject
//
//  Created by 董駸 on 16/1/6.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import "DQAlertViewController.h"

@implementation DQAlertViewController

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttonTitles afterDismiss:(DQAlertViewBlock)block
{
    self = [self init];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.buttons = buttonTitles;
        self.clickBlock = block;
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    self.alert = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < buttons.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttons[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.clickBlock) {
                self.clickBlock(i);
            }
        }];
        [self.alert addAction:action];
    }
}

- (void)showAlert:(UIViewController *)viewController completion:(DQShowAlertBlock)block
{
    self.showBlock = block;
    [viewController presentViewController:self.alert animated:YES completion:^{
        if (self.showBlock) {
            self.showBlock();
        }
    }];
}

- (void)dismiss:(UIViewController *)viewController completion:(DQDismissAlertBlock)block
{
    self.dismissBlock = block;
    [viewController dismissViewControllerAnimated:YES completion:^{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

- (void)showAlert:(UIViewController *)viewController
{
    [self showAlert:viewController completion:nil];
}

- (void)dismiss:(UIViewController *)viewController
{
    [self dismiss:viewController completion:nil];
}

@end
