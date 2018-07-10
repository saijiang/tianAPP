//
//  ChooseAddressPopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "LKToolView.h"

@interface ChooseAddressPopupContentView : PopupContentView

@property (nonatomic ,strong) LKToolView * toolView;

@property (nonatomic ,copy) void (^bCancelHandle)();
@property (nonatomic ,copy) void (^bSureHandle)(id data ,NSInteger row);

- (void) configChooseViewWithData:(NSArray *)data withTitleKey:(NSString *)key;

@end
