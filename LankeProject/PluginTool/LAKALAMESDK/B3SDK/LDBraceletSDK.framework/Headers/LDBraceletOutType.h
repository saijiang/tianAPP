//
//  LDBraceletOutType.h
//  LDBraceletSDK
//
//  Created by houhm on 16/12/13.
//  Copyright © 2016年 houhm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonClass.h"


@interface AidCandInfo : NSObject

@property(nonatomic,assign)int index;//在硬件的索引
@property(nonatomic,copy)NSData *aidName;
@property(nonatomic,copy)NSString *apnName;
@end

@interface PBOCLog : NSObject

@property(nonatomic,copy)NSString *tradeDate;
@property(nonatomic,copy)NSString *tradeTime;
@property(nonatomic,assign)float authAmount;
@property(nonatomic,assign)float otherAmount;
@property(nonatomic,copy)NSString *countryCode;
@property(nonatomic,copy)NSString *currencyCode;
@property(nonatomic,copy)NSString *merchantName;
@property(nonatomic,copy)NSString * tradeTypeName;
@property(nonatomic,assign)int tradeType;
@property(nonatomic,copy)NSString *ATC;

- (instancetype)initWithData:(NSData *)data;

@end

@interface AccountInfo : NSObject
@property(nonatomic,assign)Byte type;
@property(nonatomic,strong)NSString *ksn;
@property(nonatomic,copy)NSString *cerType;
@property(nonatomic,copy)NSString *cerNO;
@property(nonatomic,copy)NSString *pan;
@property(nonatomic,copy)NSString *panSN;
@property(nonatomic,copy)NSString *panValidDate;
@property(nonatomic,copy)NSString *offlineBalance;
@property(nonatomic,strong)NSData *track2;
@property(nonatomic,copy)NSString *currencyCode;
@property(nonatomic,strong)NSData *area55Data;


@end


@interface EMVResult : NSObject

@property(nonatomic,assign)PBOC_RET_CODE retCode;
@property(nonatomic,readonly)NSArray *candInfoList;//aid列表
@property(nonatomic,readonly)AccountInfo *accountInfo;//账户信息
@property(nonatomic,readonly)NSDictionary *ic55Dic;
@property(nonatomic,copy)NSString *resultInfo;

- (instancetype)initWithCode:(PBOC_RET_CODE)retCode candInfoList:(NSArray *)candInfoList ;
- (instancetype)initWithCode:(PBOC_RET_CODE)retCode accountInfo:(AccountInfo *)accountInfo;
- (instancetype)initWithCode:(PBOC_RET_CODE)retCode resultInfo:(NSString *)resultInfo;
- (instancetype)initWithCode:(PBOC_RET_CODE)retCode ic55Dic:(NSDictionary *)ic55Dic;
@end


