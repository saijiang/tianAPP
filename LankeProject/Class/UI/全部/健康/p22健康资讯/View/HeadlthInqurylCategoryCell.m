//
//  HeadlthInqurylCategoryCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HeadlthInqurylCategoryCell.h"
#import "UIView+AutoLayoutSupport.h"

@interface HeadlthInqurylCategoryCell ()

@property (nonatomic ,strong) LKNetworkImageView * backgroundImageView;

@property (nonatomic ,strong) LKNetworkImageView * categoryIconImageView;

@property (nonatomic ,strong) UILabel * categoryNameLabel;

@end

@implementation HeadlthInqurylCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if (!_backgroundImageView) {
            _backgroundImageView = [[LKNetworkImageView alloc] init];
            _backgroundImageView.placeholderImage = [UIImage imageNamed:@"default_restaurant"];
            [self.contentView addSubview:_backgroundImageView];
        }
        
        if (!_categoryNameLabel) {
            _categoryNameLabel = [UnityLHClass masonryLabel:@"****" font:17 color:[UIColor whiteColor]];
            _categoryNameLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_categoryNameLabel];
        }
        
        if (!_categoryIconImageView) {
            _categoryIconImageView = [[LKNetworkImageView alloc] init];
            _categoryIconImageView.placeholderImage = [UIImage imageNamed:@"category_vedio"];
            [self.contentView addSubview:_categoryIconImageView];
        }
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.backgroundImageView.mas_centerX);
        make.top.mas_equalTo(self.categoryIconImageView.mas_bottom).mas_offset(10);
    }];
    [self.categoryIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.backgroundImageView.mas_centerX);
        make.centerY.mas_equalTo(self.backgroundImageView.mas_centerY).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
}
#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"HeadlthInqurylCategoryCell";
}

/*
 
 @{@"background":@"category_background_food",
 @"icon":@"category_food",
 
 
 @{@"background":@"category_background_vedio",
 @"icon":@"category_vedio",
 
 */
- (void) configCellWithData:(id)data{

    self.categoryNameLabel.text = data[@"className"];

    LKWeakSelf
    [self.backgroundImageView setImageURL:[NSURL URLWithString:data[@"backgroundPicture"]] complete:^(UIImage *image) {
        
        LKStrongSelf
        _self.backgroundImageView.image = [image applyBlurWithRadius:2 tintColor:[UIColor colorWithWhite:0.1 alpha:.75] saturationDeltaFactor:1.4 maskImage:nil];
    }];
    
    self.categoryIconImageView.imageURL = [NSURL URLWithString:data[@"iconPicture"]];

}

- (void) configHRCellWithData:(id)data index:(NSInteger)index
{

    self.categoryNameLabel.text = data[@"title"];
    //self.backgroundImageView.image=[UIImage imageNamed:data[@"banner"]];
    self.categoryIconImageView.image = [UIImage imageNamed:data[@"icon"]];
    if (index<2)
    {
         self.backgroundImageView.image = [[UIImage imageNamed:data[@"banner"]] applyBlurWithRadius:0 tintColor:[UIColor colorWithWhite:0.1 alpha:.5] saturationDeltaFactor:1.4 maskImage:nil];
    }
    else
    {
        self.backgroundImageView.image = [UIImage imageNamed:data[@"banner"]];

    }
   

    
}

+ (CGFloat) cellHeight{

    return DEF_SCREEN_WIDTH/2.0;
}
@end
