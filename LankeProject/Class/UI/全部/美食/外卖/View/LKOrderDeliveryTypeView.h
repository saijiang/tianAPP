//
//  LKOrderDeliveryTypeView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKOrderDeliveryTypeView : UIView

/** YES：自提 */
@property (nonatomic ,assign) BOOL typeOfSelfTake;
@property (nonatomic ,strong) id addressId;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * titleLabelTwo;
@property (nonatomic ,strong) UIView * shadowView;
// 送货上门
@property (nonatomic ,strong) UIButton * typeOfHomeDeliveryButton;
@property (nonatomic ,strong) UILabel * orderPriceLabel;
@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,copy) void (^bOrderDeliveryTypeChooseAddressHandle)();
@property (nonatomic ,copy) void (^bOrderDeliveryTypeChooseTypeHandle)(BOOL typeOfSelfTake);

-(void) configDeliveyTypeForGroupBuyWithData:(id)data;

- (void) configDeliveyTypeWithData:(id)data;

- (void) updateAddressInfoWithData:(id)data;
@end
