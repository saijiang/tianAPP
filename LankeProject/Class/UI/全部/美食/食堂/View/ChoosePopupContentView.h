//
//  ChoosePopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "LKToolView.h"

typedef NS_ENUM(NSInteger ,ChoosePopupViewType) {

    ChoosePopupContentCommom = 0,
    ChoosePopupContentDateYYYYMMDD=1,
    ChoosePopupContentDate

};

@interface ChoosePopupContentView : PopupContentView

@property (nonatomic ,strong) LKToolView * toolView;

@property (nonatomic ,copy) void (^bCancelHandle)();
@property (nonatomic ,copy) void (^bSureHandle)(id data);

- (instancetype) initPopupViewWithType:(ChoosePopupViewType)type;

- (void) configChooseViewWithData:(NSArray *)data;
@end
