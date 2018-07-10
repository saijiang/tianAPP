//
//  PropertyPayViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface PropertyPayViewController : BaseViewController

//缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）

@property(nonatomic,assign)NSInteger billType;

@end
