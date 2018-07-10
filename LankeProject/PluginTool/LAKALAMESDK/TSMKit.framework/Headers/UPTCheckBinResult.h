//
//  CheckBinResult.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTCheckBinResult : NSObject

@property (nonatomic, readonly, copy) NSString * bankName;
@property (nonatomic, readonly, copy) NSString * cardType;
@property (nonatomic, readonly, copy) NSString * orgCode;
@property (nonatomic, readonly, copy) NSString * issuerIcon;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
