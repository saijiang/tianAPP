//
//  NLPbocLogDetail.h
//  MTypeSDK
//
//  Created by wanglx on 15/1/25.
//  Copyright (c) 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLPbocLogDetail : NSObject
/**
 *  交易日期
 */
@property (nonatomic, strong) NSString * transactionDate;
/**
 *  交易时间
 */
@property (nonatomic, strong) NSString * transactionTime;
/**
 *  授权金额
 */
@property (nonatomic, strong) NSString * amountAuthorisedNumeric;
/**
 *  其它金额
 */
@property (nonatomic, strong) NSString * amountOtherNumeric;
/**
 *  终端国家代码
 */
@property (nonatomic, strong) NSString * terminalCountryCode;
/**
 *  交易货币代码
 */
@property (nonatomic, strong) NSString * transactionCurrencyCode;
/**
 *  商户名称
 */
@property (nonatomic, strong) NSString * merchantName;
/**
 *  交易类型（中文描述）
 */
@property (nonatomic, strong) NSString * transactionType;
-(id)initWithData:(NSData *)data;
/*
 @method
 @abstract 交易类型， 与transactionType属性对应，值参考NLProcessingCode
 @return
 */
- (int)transType;
@end
