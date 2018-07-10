//
//  LKShelfItemView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKShelfItemView : UIView

@property (nonatomic ,strong) UIColor * tinColorForLogo;

@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UIImageView * iconImageView;
@property (nonatomic ,strong) UILabel * detailLabel;

@property (nonatomic ,copy) void (^bShelfTapHandle)();

- (void) updateSubViewForSpecialItemView;
-(void) updateSubViewForSpecialIconItemView;
-(void) updateSubViewForSpecialIconShopItemView;
@end
