//
//  BookPopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "LKBottomButton.h"

@interface BookPopupContentView : PopupContentView

@property (nonatomic ,strong) LocalhostImageView * iconImageView;

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) UIButton * nothingButton;

@property (nonatomic ,strong) LKBottomButton * commitButton;

- (void) configLeftButton:(NSString *)left handle:(void(^)())handle;
- (void) configRightButton:(NSString *)right handle:(void(^)())handle;

@end
