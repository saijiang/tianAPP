//
//  ProprietaryTopView.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodSearchItem.h"

@interface ProprietaryTopView : UIView

@property(nonatomic,strong)GoodSearchItem *item;

@property (nonatomic ,copy) void (^bSelectFilterHandle)();

- (void) clearFilterState;
@end
