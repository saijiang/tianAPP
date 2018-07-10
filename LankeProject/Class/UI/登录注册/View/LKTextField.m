//
//  LKTextField.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKTextField.h"

@implementation LKTextField


+ (instancetype) whiteTextFieldWithLeftImage:(NSString *)leftImageName{

    LKTextField * textField = [[LKTextField alloc] init];
    textField.leftImage = [UIImage imageNamed:leftImageName];
    textField.background = [UIImage imageWithColor:[UIColor whiteColor]];
    return textField;
}
- (void)setLeftImage:(UIImage *)leftImage{

    _leftImage = leftImage;
    
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{

    _cornerRadius = cornerRadius;
    if (cornerRadius) {
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }    
}

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    if (self.leftImage) {
        
        CGFloat height = CGRectGetHeight(rect);
        UIButton * leftView = [[UIButton alloc] init];
        [leftView setImage:_leftImage forState:UIControlStateNormal];
        leftView.userInteractionEnabled = NO;
        leftView.frame = CGRectMake(0, 0, height, height);
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftView;
    }
    
    if (self.alwaysDisplayCleanView) {
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}
@end
@implementation LKTextField (LoginAndRegist)

- (void) configTextFieldForLogin:(NSString *)placeholder{

    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:15];
    self.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    self.textColor = [UIColor colorWithHexString:@"#ffffff"];
    NSAttributedString * attPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"BBC2CC"],NSFontAttributeName:self.font}];
    self.attributedPlaceholder = attPlaceholder;
}

- (void) configTextFieldForLoginAndRegistWithPlaceholder:(NSString *)placeholder{

    self.placeholder = placeholder;
    self.font = [UIFont systemFontOfSize:16];
    self.tintColor = BM_Color_Placeholder;
    NSAttributedString * attPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:BM_Color_Placeholder,NSFontAttributeName:self.font}];
    self.attributedPlaceholder = attPlaceholder;
}

@end

