//
//  LKSimpleCalendarView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"

@interface LKSimpleCalendarView : UIView

@property (nonatomic ,copy) void (^bSimpleCalendarDidSelected)(NSInteger index,NSString * formatterDay);

// 外面应该传进来本周的具体日期
- (void) configCalendarWithData:(id)data;

// 这个方法可以在上面的方法内部调用
- (void) defaultSelectMonday;
@end

@interface LKSimpleCalendarCCell : BaseCollectionCell<LKCellProtocol>

@end
