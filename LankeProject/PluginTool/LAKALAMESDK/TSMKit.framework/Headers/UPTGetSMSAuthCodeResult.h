//
//  GetSMSAuthCodeResult.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTGetSMSAuthCodeResult : NSObject

@property (nonatomic, strong) NSString* expireNote;

- (instancetype)initWithExpireNote:(NSString*)expireNote;

@end
