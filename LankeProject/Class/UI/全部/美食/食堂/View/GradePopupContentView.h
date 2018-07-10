//
//  GradePopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "AXRatingView.h"
#import "JYZTextView.h"

@interface GradePopupContentView : PopupContentView

@property (nonatomic ,strong) AXRatingView * ratingView;
@property (nonatomic ,strong) JYZTextView * contentTextView;

@property (nonatomic ,copy) void (^bCommitButtonHandle)(NSString * content,NSInteger rate ,PopupContentView *popupContentView);
@end
