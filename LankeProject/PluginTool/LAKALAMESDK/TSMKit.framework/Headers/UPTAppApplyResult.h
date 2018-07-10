//
//  AppApplyResult.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTAppApplyResult : NSObject

@property (nonatomic, readonly, copy) NSString * mPanId;
@property (nonatomic, readonly, copy) NSString * appId;
@property (nonatomic, readonly, copy) NSString * appIcon;
@property (nonatomic, readonly, copy) NSString * mPan;
/**
 *  实体卡号后四位
 */
@property (nonatomic, readonly, copy) NSString *lastFour;
@property (nonatomic, readonly, copy) NSString *result ;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
