//
//  AddressItem.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressItem : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * value;
@property (nonatomic,assign) BOOL  isSelected;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
