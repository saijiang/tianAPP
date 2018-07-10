//
//  MallOrderConfirmAddressView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface MallOrderConfirmAddressView : UIView<LKCustomViewProtocol>

@property (nonatomic ,assign ,getter=isValidAddress) BOOL validAddress;

@property (nonatomic ,strong) id addressData;
@property (nonatomic ,strong) id addressId;

@property (nonatomic ,copy) void (^bFinishLoadAddressHandle)();
@property (nonatomic ,copy) void (^bFinishLoadJDAddressHandle)();

@property (nonatomic ,copy) void (^bTapAddressHandle)();
-(void)requestDefaultAddress;
-(void)requestJDDefaultAddress;
- (void) updateAddressInfoWithData:(id)data;
- (void) updateJDAddressInfoWithData:(id)data;
@end
