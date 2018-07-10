//
//  UpdateInfo.h
//  TSMKit
//
//  Created by chenlei on 16/6/12.
//  Copyright © 2016年 TangZhixiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPTUpdateInfo : NSObject

@property (nonatomic, readonly, copy) NSString * type;
@property (nonatomic, readonly, copy) NSString * downloadUrl;
@property (nonatomic, readonly, copy) NSArray<NSString *> * desc;

@end
