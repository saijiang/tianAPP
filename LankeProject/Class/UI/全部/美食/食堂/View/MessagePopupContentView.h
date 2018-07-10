//
//  MessagePopupContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HLLPopupView.h"

@interface MessagePopupContentView : PopupContentView

@property (nonatomic ,copy) void (^bCommitButtonHandle)(NSString *content);

@end
