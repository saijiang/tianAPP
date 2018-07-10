//
//  PropertyRepairZoneView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface PropertyRepairZoneView : UIView<LKCustomViewProtocol>


//repairArea 	是 	string 	报修区域（01：住宅区域 ，02：科研办公区域）
//repairTypeFirst 	是 	string 	报修类型（01：公共报修， 02：室内报修）
//repairTypeSecond 	是 	string 	报修类型（二级分类：石材）
@property(nonatomic,copy)NSString *repairArea;
@property(nonatomic,copy)NSString *repairTypeFirst;
@property(nonatomic,copy)NSString *repairTypeSecond;


@end
