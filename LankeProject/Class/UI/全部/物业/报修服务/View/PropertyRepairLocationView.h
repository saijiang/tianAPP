//
//  PropertyRepairLocationView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "JYZTextView.h"

@interface PropertyRepairLocationView : UIView<LKCustomViewProtocol>

@property (nonatomic ,copy) void (^bChooseAddressHandle)();
//repairAddress 	是 	string 	维修地址（个人中心的省市区小区地址楼栋房间号拼接
@property (nonatomic ,copy) NSString *repairAddress;
@property (nonatomic ,strong) JYZTextView * repairAddressView;

@property (nonatomic ,strong) JYZTextView * contentView;

@end
