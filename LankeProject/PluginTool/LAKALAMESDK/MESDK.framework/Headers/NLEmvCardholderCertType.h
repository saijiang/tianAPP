//
//  NLEmvCardholderCertType.h
//  MTypeSDK
//
//  Created by wanglx on 15/1/5.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    /**
     * 居民身份证
     */
    NLEmvCardholderCertType_CITIZEN_IDCARD,
    /**
     * 军官证
     */
    NLEmvCardholderCertType_MILITARY_IDCARD,
    /**
     * 护照
     */
    NLEmvCardholderCertType_PASSPORT,
    /**
     * 入境证明
     */
    NLEmvCardholderCertType_ENTRY_PERMIT,
    /**
     * 临时居民身份证
     */
    NLEmvCardholderCertType_TEMPORARY_CITIZEN_IDCARD,
    /**
     * 其他
     */
    NLEmvCardholderCertType_OTHERS,
}NLEmvCardholderCertType;



@interface NLEmvCardholderCertTypeDesc : NSObject
+(NSString *)getDescByCertType:(NLEmvCardholderCertType)type;
@end
