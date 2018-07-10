//
//  FitnessMessageInputView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface FitnessMessageInputView : UIView<LKCustomViewProtocol,UITextViewDelegate>
@property (nonatomic, strong)UIButton* sendBtn;
@property (nonatomic, strong)UITextView* textInputView;

@property (nonatomic ,copy) void (^bSendHandle)(NSString *);
@end
