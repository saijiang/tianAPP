//
//  AllFunctionCCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AllFunctionCCell.h"
#import "AllFunctionConfig.h"

@interface AllFunctionCCell ()
@property (nonatomic ,strong) LocalhostImageView * itemImageView;
@property (nonatomic ,strong) UILabel * itemLabel;

@end

@implementation AllFunctionCCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView * selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        selectedBackgroundView.layer.cornerRadius = 5.0f;
        selectedBackgroundView.layer.masksToBounds = YES;
        self.selectedBackgroundView = selectedBackgroundView;
        
        if (!_itemImageView) {
            _itemImageView = [[LocalhostImageView alloc] init];
            _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:_itemImageView];
            [_itemImageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(20);
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }];
        }
        if (!_itemLabel) {
            _itemLabel = [UnityLHClass masonryLabel:@"CCCC" font:14 color:[UIColor colorWithHexString:@"#333333"]];
            _itemLabel.textAlignment = NSTextAlignmentCenter;
            _itemLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_itemLabel];
            [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(_itemImageView.mas_bottom).mas_offset(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(self.contentView.mas_right);
                make.bottom.mas_equalTo(0);
            }];
        }
    }
    return self;
}
+ (NSString *)cellIdentifier{
    
    return @"AllFunctionCCell";
}

// Item
- (void) configCellWithData:(Item *)data{
    
    self.itemLabel.text = [NSString stringWithFormat:@"%@",data.item[@"title"]];
    UIImage * itemImage = [UIImage imageNamed:data.item[@"icon_name"]];
    if (itemImage) {
        _itemImageView.image = itemImage;
    }
}

@end
