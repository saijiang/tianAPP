//
//  LKEmptyView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKEmptyView : UIView

@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,copy) void (^bRetryHandle)();

+ (instancetype)view;

@end
