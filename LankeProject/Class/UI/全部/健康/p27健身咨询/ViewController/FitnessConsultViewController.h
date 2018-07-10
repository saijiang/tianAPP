//
//  FitnessConsultViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface FitnessConsultViewController : BaseViewController

@property (nonatomic ,strong) NSString * type;

/** type 在线客服类型（01：健康 02：健身） */
- (instancetype) initWithType:(NSString *)type;
@end
