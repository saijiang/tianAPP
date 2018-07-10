//
//  GroupBuyDeliverTypeView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"
@class GroupBuyDeliverTypeItem;

@interface GroupBuyDeliverTypeView : UIView

@property (nonatomic ,strong ,readonly) GroupBuyDeliverTypeItem * typeItem;

@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,strong) id addressId;

@property (nonatomic ,copy) void (^bChooseTypeHandle)(id);
@property (nonatomic ,copy) void (^bOrderDeliveryTypeChooseAddressHandle)();
-(void) configDeliveyTypeForGroupBuyWithData:(id)data changeHeight:(void(^)(CGFloat))handle;

- (void) updateAddressInfoWithData:(id)data;
- (void) updateAddress;
@end


#pragma mark -
#pragma mark Private Item

@interface GroupBuyDeliverTypeItem : NSObject

@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * display;
/** 配送方式：（01：客户自提， 02：自家配送， 03：快递配送） */
@property (nonatomic ,strong) NSString * flag;

@property (nonatomic ,assign) CGFloat price;//运费

@property (nonatomic ,assign) BOOL select;

- (instancetype)initWithData:(id)data;
@end


#pragma mark -
#pragma mark TableView view

@interface GroupBuyDeliverTypeCell : UITableViewCell<LKCellProtocol>

@property (nonatomic ,strong) UIImageView * selectImageView;
@property (nonatomic ,strong) UILabel * typeLabel;

@property (nonatomic ,strong) UILabel * contentLabel;
@property (nonatomic ,strong) UIView * lineView;
+ (CGFloat)configCellHeightWithData:(GroupBuyDeliverTypeItem *)data;

@end

@interface GroupBuyDeliverTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UIView * lineView;

+ (NSString *) identifier;
@end

@interface GroupBuyDeliverTypeFooterView : UITableViewHeaderFooterView

@property (nonatomic ,strong) UILabel * pickAddressNameLabel;
@property (nonatomic ,strong) UILabel * pickAddressPhoneNumberLabel;
@property (nonatomic ,strong) UILabel * pickAddressLabel;

@property (nonatomic ,strong) UILabel * defaultPickAddressLabel;

@property (nonatomic ,copy) void (^bChooseAddressHandle)();

@property (nonatomic ,strong) LocalhostImageView * arrowImageView;
+ (NSString *) identifier;
- (void) config:(id)data;
@end
