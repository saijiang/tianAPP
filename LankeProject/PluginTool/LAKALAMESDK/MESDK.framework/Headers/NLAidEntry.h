//
//  NLAidEntry.h
//  MTypeSDK
//
//  Created by su on 15/12/16.
//  Copyright © 2015年 newland. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 卡包数据
 @discussion
 */
@interface NLAidEntry : NSObject
@property (nonatomic, assign, readonly) int aidLen; // 应用AID长度
@property (nonatomic, copy, readonly) NSString *aid; // 应用AID
@property (nonatomic, assign, readonly) int aidNameLen; // 显示卡包名称长度
@property (nonatomic, copy, readonly) NSString *aidName; // 显示卡包名称
- (id)initWithAidLen:(int)aidLen aid:(NSString*)aid aidNameLen:(int)aidNameLen aidName:(NSString*)aidName;
@end
