//
//  NLStepLenght.h
//  MTypeSDK
//
//  Created by wanglx on 15/6/8.
//  Copyright (c) 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLStepLenght : NSObject
/**
 *  tag DF04
 *  步行歩长，单位厘米(cm)，范围0-255
 */
@property (nonatomic, assign) int walkStepLenght;
/**
 *  tag DF05
 *  跑步步长，单位厘米(cm)，范围0-255
 */
@property (nonatomic, assign) int runStepLenght;
@end
