//
//  NLLocalConsumeRecord.h
//  MTypeSDK
//
//  Created by su on 15/12/16.
//  Copyright © 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLLocalConsumeRecord : NSObject
@property (nonatomic, assign, readonly) int aidLen; // AID长度
@property (nonatomic, copy, readonly) NSString *aid; // 产生记录的应用标识符
@property (nonatomic, assign, readonly) int dataLen; // 记录数据总长度
@property (nonatomic, assign, readonly) int dataNum; // 消费记录数目
@property (nonatomic, strong, readonly) NSArray *recordList; // 消费记录<NSString>
- (id)initWithData:(NSData*)data;
@end
