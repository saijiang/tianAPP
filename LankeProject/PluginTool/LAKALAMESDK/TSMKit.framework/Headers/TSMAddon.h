//
//  TSMAddon.h
//  TSMKit
//
//  Created by chenlei on 16/6/8.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning 版本更新时需更新此处
static NSString* const kTSMAddonVersion = @"1";

@protocol TSMInterface;

@interface TSMAddon : NSObject<TSMInterface>

@end
