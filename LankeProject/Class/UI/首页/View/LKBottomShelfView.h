//
//  LKBottomShelfView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKShelfItemView.h"

@interface LKBottomShelfView : UIView

@property (nonatomic ,strong) LKShelfItemView * groupItemView;

@property (nonatomic ,strong) LKShelfItemView * propertyItemView;

@end
