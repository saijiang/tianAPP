//
//  HLLAlert.h
//  One
//
//  Created by Rocky Young on 2017/2/21.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLLAlertActionSheetProtocol <NSObject>

@optional

#pragma mark - config

- (id<HLLAlertActionSheetProtocol>) title:(NSString *)titile;
- (id<HLLAlertActionSheetProtocol>) message:(NSString *)message;

/** Default handle button type is `UIAlertActionStyleDefault`. */
- (id<HLLAlertActionSheetProtocol>) buttons:(NSArray *)buttons;

/** Config special button type at index. */
- (id<HLLAlertActionSheetProtocol>) style:(UIAlertActionStyle)style index:(NSInteger)index;

#pragma mark - hide

- (id<HLLAlertActionSheetProtocol>) hide:(void(^)())hide;

@required

#pragma mark - fetch

- (id<HLLAlertActionSheetProtocol>) fetchClick:(void (^)(NSInteger index))click;

#pragma mark - show

- (id<HLLAlertActionSheetProtocol>) show;
- (id<HLLAlertActionSheetProtocol>) showIn:(__kindof UIViewController *)vc;

@end

/** 
 * `Alert` 是不允许除了添加的handle按钮之外的点击消失
 * `ActionSheet` 却允许点击空白处消失
 */
@interface HLLAlertActionSheet : NSObject

#pragma mark - config

+ (id<HLLAlertActionSheetProtocol>) alert;

+ (id<HLLAlertActionSheetProtocol>) actionSheet;

@end

