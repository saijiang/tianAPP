//
//  EntryPasswordPopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/29.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "ModyPasswordViewController.h"
#import "LKBottomButton.h"
@interface EntryPasswordPopupContentView : PopupContentView
@property (nonatomic ,strong) LKBottomButton * commitButton;
@property (nonatomic ,strong) LKBottomButton * cancelButton;
@property (nonatomic ,copy) void (^bSureHandle)(NSString * password);

@end
