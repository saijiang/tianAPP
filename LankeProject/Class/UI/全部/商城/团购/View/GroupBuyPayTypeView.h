//
//  GroupBuyPayTypeView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kTopHeightGroupBuy
#define kTopHeightGroupBuy  45
#endif

#ifndef kMarginGroupBuy
#define kMarginGroupBuy 15
#endif

#ifndef kCommentHeightGroupBuy
#define kCommentHeightGroupBuy 60
#endif

@interface GroupBuyPayTypeItemView : UIView

@property (nonatomic ,strong) LocalhostImageView * iconImageView;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UILabel * detailLabel;
@property (nonatomic ,strong) LocalhostImageView * chooseImageView;

@end

@interface GroupBuyPayTypeView : UIView

@property (nonatomic ,copy) void (^bChoosePayTypeHandle)(NSInteger type);
@property (nonatomic ,assign) NSInteger currentSelectPayType;// 1钱包支付  2微信支付  3支付宝支付

- (void) configChoosePayTypeView;
@end


