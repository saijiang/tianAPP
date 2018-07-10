//
//  PropertyPayBillViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface PropertyPayBillViewController : BaseViewController

//id 	是 	string 	缴费id(多个用逗号隔开：1,2,3)
//billType 	是 	string 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
@property (nonatomic ,assign) CGFloat sumPrice;
@property (nonatomic ,assign) NSString * billType;
@property (nonatomic ,copy) NSString * billIdS;

@end
