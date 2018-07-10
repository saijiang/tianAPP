//
//  LKTopShelfView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKShelfItemView.h"

@interface LKTopShelfView : UIView

@property (nonatomic ,strong) LKShelfItemView * shoppingItemView;

@property (nonatomic ,strong) LKShelfItemView * healthItemView;

@property (nonatomic ,strong) LKShelfItemView * foodItemView;

@property(nonatomic,strong) LKShelfItemView * TherapyItemView;
@end
