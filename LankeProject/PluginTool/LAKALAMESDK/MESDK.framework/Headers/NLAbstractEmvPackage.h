//
//  NLAbstractEmvPackage.h
//  MTypeSDK
//
//  Created by su on 14-1-26.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLVPackage.h"
#import "NLEmvTagDefined.h"

@interface NLAbstractEmvPackage : NSObject
- (void)setExternalWithTag:(int)tag value:(NSData*)value;
- (NSData*)externalForTag:(int)tag;
- (void)removeExternalByTag:(int)tag;
- (id<TLVPackage>)externalPackage;
- (NSArray*)relativeTags;
+ (NSArray*)relativeTags;
+ (NSArray*)relativeTagsWithEmvPackageClass:(Class)entityClass;

@end
