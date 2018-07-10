//
//  MallShopInfoHeaderView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"

@interface MallShopInfoHeaderView : UICollectionReusableView<LKCustomViewProtocol>

@property (nonatomic ,assign) BOOL finishLoadBannerImage;

@property (nonatomic ,copy) void (^bShopCollectHandle)();
@end

@interface MallShopInfoFooterView : UICollectionReusableView<LKCustomViewProtocol>

@property (nonatomic ,strong) UIButton * titleButton;
@end

@interface MallShopInfoOptionsFooterView : UICollectionReusableView<LKCustomViewProtocol,SliderViewDelegate>

@property(nonatomic,strong)SliderView  *sliderView;

@end
