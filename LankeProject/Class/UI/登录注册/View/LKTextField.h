//
//  LKTextField.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKTextField : UITextField

@property (nonatomic ,strong) UIImage * leftImage;
@property (nonatomic ,assign) CGFloat cornerRadius;
@property (nonatomic ,assign) BOOL alwaysDisplayCleanView;

+ (instancetype) whiteTextFieldWithLeftImage:(NSString *)leftImageName;

@end


@interface LKTextField (LoginAndRegist)

- (void) configTextFieldForLogin:(NSString *)placeholder;
- (void) configTextFieldForLoginAndRegistWithPlaceholder:(NSString *)placeholder;
@end
