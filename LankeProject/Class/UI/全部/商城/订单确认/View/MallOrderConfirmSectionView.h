//
//  MallOrderConfirmSectionView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageBtn.h"
#import "LKCellProtocol.h"

@interface MallOrderConfirmHeaderView : UITableViewHeaderFooterView<LKCellProtocol>

@property (nonatomic ,strong) UIView * shopContentView;

@property (nonatomic ,strong) LocalhostImageView * iconImageView;
@property (nonatomic ,strong) UILabel * shopNameDisplayLabel;
@property (nonatomic ,strong) UILabel * freeSendLable;
@property (nonatomic ,strong) UIView * lineView;
@end


@interface MallOrderConfirmFooterView : UITableViewHeaderFooterView<LKCellProtocol>

@property (nonatomic ,copy) void (^bChooseTypeHandle)();
@property (nonatomic ,copy) void (^bMessageChangeHandle)(NSString * message);

@property (nonatomic ,strong) UILabel * typeDisplayLabel;

@property (nonatomic ,strong) UIButton * typeButton;
@property (nonatomic ,strong) UIButton * typeOneShopButton;

@property (nonatomic ,strong) UIView * topLineView;

@property (nonatomic ,strong) UILabel * messageDisplayLabel;
@property (nonatomic ,strong) UITextField * messageTextField;

@property (nonatomic ,strong) UIView * bottmLineView;


@property (nonatomic ,strong) UILabel * jDInvoiceLabel;
@property (nonatomic ,strong) UIButton * jDInvoiceBtn;

@property (nonatomic ,strong) UIView * jDBottmLineView;

@property (nonatomic ,strong) UILabel * priceLabel;
- (void) configCellWithOneShopData:(id)assist;
- (void) configCellWithJDShopData:(id )assist;
@end

@class DeliveryType;

@interface MallAssist : NSObject

@property (nonatomic ,assign) BOOL enable;

@property (nonatomic ,strong) DeliveryType * type;

@property (nonatomic ,strong) NSString * message;

@property (nonatomic ,assign) CGFloat price;
@property (nonatomic ,assign ,readonly) CGFloat expressPrice;

@property (nonatomic ,strong ) NSString *merchantId;
@property (nonatomic ,strong ) NSString *merchantName;

+ (instancetype) assistCouponWith:(id)data;//配置打折数据
+ (instancetype) assistWith:(id)data;

- (void) modifyDelieveryAtIndex:(NSInteger )index;
- (void)modifyDelieveryFreeAtIndex:(NSInteger)index;
- (void) modifyExpressPriceForOneShop:(CGFloat)price;
- (void)modifyExpressPriceForJDShop:(CGFloat)price;
@end

@interface DeliveryType : NSObject

@property (nonatomic ,strong) id deliveryContent;// 地址或者配送费
@property (nonatomic ,copy) NSString * shippingName;//配送方式（01：客户自提， 02：自家配送， 03：快递配送）

+ (instancetype) deliveryWith:(id)data;

- (NSArray *) deliveryType;
- (NSArray *) deliveryFreeType;
- (NSArray *) deliverySegmentDatas;
- (NSArray *)deliveryFreeSegmentDatas;
@end
