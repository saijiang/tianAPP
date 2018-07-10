//
//  TCMResultItemView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface TCMResultItemView : UIView<LKCustomViewProtocol>

- (void) configForTop:(id)data;
- (void) configForCenter:(id)data;
- (void) configForBottom:(id)data;
@end
