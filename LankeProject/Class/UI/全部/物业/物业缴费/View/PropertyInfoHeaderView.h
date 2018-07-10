//
//  PropertyInfoHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "LKBottomButton.h"

@interface PropertyInfoHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) UILabel * nameDisplayLabel;
@property (nonatomic ,strong) UILabel * nameLabel;

@property (nonatomic ,strong) UILabel * addressDisplayLabel;
@property (nonatomic ,strong) UILabel * addressLabel;

@property (nonatomic ,strong) UIImageView * arrowImageView;

@property (nonatomic ,copy) void (^bChooseOtherInfoHandle)(id data);

@end

@interface PropertyInfoSectionHeaderView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UIView * lineView;

@end

@interface PropertyInfoFooterView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) LKBottomButton * callOnButton;
@property (nonatomic ,strong) LKBottomButton * payButton;

@property (nonatomic ,copy) void (^bCallOnHandle)();
@property (nonatomic ,copy) void (^bGotoPayHandle)();

@end
