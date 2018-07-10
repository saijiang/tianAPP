//
//  HealthExamSelectGenderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface HealthExamSelectGenderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) NSString * male;
@property (nonatomic ,copy) void (^bSelectGenderHandle)(NSString * male);
@end
