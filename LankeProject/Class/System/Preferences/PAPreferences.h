//
//  PAPreferences.h
//  PAPreferencesSample
//
//  Created by Denis Hennessy on 16/09/2013.
//  Copyright (c) 2013 Peer Assembly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAPropertyDescriptor;

extern NSString * const PAPreferencesDidChangeNotification;
extern NSString * const PAPreferencesChangedPropertyKey;

@interface PAPreferences : NSObject {
    NSDictionary *_properties;
    NSUserDefaults * _userDefaults;
}

/** default is YES */
@property (nonatomic, assign) BOOL shouldAutomaticallySynchronize;

+ (instancetype)sharedInstance;

//-------------------------------------------------------
//---------------------------子类如有需求可以重写
/**
 *  用于设置NSUserDefaults的suiteName
 */
- (NSString *) suiteName;
/**
 *  设置默认的数据
 */
- (NSDictionary *) setupDefaults;
/**
 *  修改key值
 *
 *  @举例 key 是name ，可以通过该方法修改为PrefixName、nameSuffix ，任何样式的key值
 */
- (NSString *) defaultsKeyForPropertyName:(NSString *)key;

//-------------------------------------------------------
//---------------------------NSUserDefault
/** 
 * 一般来说，可以不调用`synchronize`进行同步，因为`shouldAutomaticallySynchronize`默认值是YES
 */
- (BOOL)synchronize;
- (NSUserDefaults *)userDefaults;

@end


@interface PAPropertyDescriptor : NSObject

@property (nonatomic, readonly) NSString *defaultsKey;
@property (nonatomic, readonly) BOOL isSetter;
@property (nonatomic, readonly) NSString *type;

- (id)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter;

@end
