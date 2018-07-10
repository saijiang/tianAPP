//
//  ShoppingCarPopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"
#import "LKShoppingCarManager.h"

@interface ShoppingCarPopupContentView : PopupContentView

@property (nonatomic ,strong) LKShoppingCarManager * shoppingCarManager;

@property (nonatomic ,copy) void (^bCancelHandle)();
@property (nonatomic ,copy) void (^bSureHandle)(id data);

//- (void) configShoppingCarWithData:(id)data;
@end
