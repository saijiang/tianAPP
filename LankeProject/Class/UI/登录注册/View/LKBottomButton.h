//
//  LKBottomButton.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKBottomButton : UIButton

+ (instancetype) buttonForOrder;

- (void) configTextColor:(UIColor *)textColor
                    text:(NSString *)text
             borderColor:(UIColor *)borderColor
         backgroundColor:(UIColor *)backgroundColor;
@end
