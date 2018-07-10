//
//  LKHomeNavigationBarView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKHomeNavigationBarView : UIView

@property (nonatomic ,copy) void (^bLocationButtonHandle)();
@property (nonatomic ,copy) void (^bMessageButtonHandle)();

// 设置地理信息以及红点的显示与否
-(void)updateMessageCount;
- (void) configNavigationBarWithData:(id)data;
@end
