//
//  DishesDetailHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBottomButton.h"

@interface DishesDetailHeaderView : UIView

@property (nonatomic ,strong) LKBottomButton * wantGradeButton;

@property (nonatomic ,copy) void (^bGradeButtonHandle)();

- (void) configDetailHeaderViewWithData:(id)data;
@end
