//
//  LDBraceletEMVController.h
//  LDBraceletSDK
//
//  Created by houhm on 16/12/13.
//  Copyright © 2016年 houhm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBraceletEMVOperationDelegate.h"
#import "LDBraceletOutType.h"

@interface LDBraceletEMVController : NSObject

- (void)setBalanceRemindInfo:(int)balance;

- (int)balanceRemindInfo;

/**
 *  获取固件存储的消费记录
 *
 * 返回数据格式如下：
 * [
 *  {
 *    aid:986500000000001,
 *    recordList:[
 "DF18889989898978987876",
 "DF18889989898978987876",
 "DF18889989898978987876"
 *      ]
 *  },
 *  {
 *      同上
 *  }
 *
 *  ]
 *
 */
-(NSArray*)localConsumeRecordList;

/**
 *  清除固件存储的消费记录
 *
 */
-(BOOL)setLocalConsumeRecords;

-(BOOL)flushBalance:(NSArray*)AIDList;



-(void)icTransferWithAmout:(NSString*)amount
            processingCode:(int)processingCode
       innerProcessingCode:(int)innerProcessingCode
             isForceOnline:(BOOL)isForceOnline
            emvResultBlock:(void(^)(EMVResult *emvResult))emvResultBlock;

- (BOOL)initEMVKernel;

- (void)setAid:(int)aid emvResultBlock:(void(^)(EMVResult *emvResult))emvResultBlock;

- (NSArray *)getPbocLog;

- (EMVResult *)fetchAcctInfo:(NSData*)requestAid;

@end
