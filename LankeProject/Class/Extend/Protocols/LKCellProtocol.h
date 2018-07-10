//
//  LKCellProtocol.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKProtocolExtension.h"

@protocol LKCellProtocol <NSObject>

@optional;

+ (UINib *) nib;

+ (instancetype) loadWithBundle;

+ (NSString *) cellIdentifier;

- (void) configCellWithData:(id)data;

+ (CGFloat) cellHeight;
+ (CGFloat) cellHeightWithData:(id)data;

@end

/*
 @defs(LKCellProtocol)
 
 + (UINib *) nib{
 
 return [UINib nibWithNibName:[self cellIdentifier] bundle:nil];
 }
 
 + (instancetype) loadWithBundle{
 
 return [[[NSBundle mainBundle] loadNibNamed:[self cellIdentifier] owner:nil options:nil]firstObject];
 }
 
 + (NSString *) cellIdentifier{
 
 return NSStringFromClass([self class]);
 }
 
 + (CGFloat) cellHeight{
 
 return 50.0f;
 }
 
 @end
 */
