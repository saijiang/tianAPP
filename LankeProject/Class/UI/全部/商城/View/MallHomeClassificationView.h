//
//  MallClassificationView.h
//  LankeProject
//
//  Created by itman on 17/3/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallRotatingView;
@interface MallHomeClassificationView : BaseCollectionCell

@end

@interface MallRotatingView : UIView

@property(nonatomic,strong)NetworkImageView *icon;
@property(nonatomic,strong)UILabel *title;

@end
