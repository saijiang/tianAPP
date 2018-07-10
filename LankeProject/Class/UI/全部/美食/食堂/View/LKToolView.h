//
//  LKToolView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKToolView : UIView

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) UIButton * cancelButton;

@property (nonatomic ,strong) UIButton * sureButton;

@property (nonatomic ,copy) void (^bCancelHandle)();

@property (nonatomic ,copy) void (^bSureHandle)();

@end
