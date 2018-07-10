//
//  UPTApduTaskListItem.h
//  TSMKit
//
//  Created by chenlei on 16/6/14.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTApduTaskListItem : NSObject

@property (nonatomic, readonly) BOOL blocked;
@property (nonatomic, readonly) NSString* desc;
@property (nonatomic, readonly) NSString* Id;
@property (nonatomic, readonly) NSInteger percent;
@property (nonatomic, readonly) BOOL remote;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
