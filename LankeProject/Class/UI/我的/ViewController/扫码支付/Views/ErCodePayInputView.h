//
//  ErCodePayInputView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "LKBottomButton.h"

@interface ErCodePayInputView : UIView<LKCustomViewProtocol>

@property (nonatomic ,assign) CGFloat price;
@property (nonatomic ,strong) LKBottomButton * payButton;
@property (nonatomic ,copy) void (^bPayHandle)();

- (void) inputViewBecomeFirstResponder;
@end
