//
//  ShoppingCarListFootView.m
//  LankeProject
//
//  Created by Justin on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShoppingCarListFootView.h"

@implementation ShoppingCarListFootView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.labelView = [[UIView alloc] init];
        self.labelView.backgroundColor = BM_WHITE;
        [self addSubview:self.labelView];
    
        //计算当前店铺中商品的总价
        self.priceLB = [UnityLHClass masonryLabel:@"小计:100元" font:14.0 color:BM_BLACK];
        self.priceLB.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLB];
    
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];//<color name="white_smoke">#F5F5F5</color>
        [self addSubview:self.lineView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.height.offset(50);
    }];

    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.labelView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.labelView.mas_centerY);
        make.width.mas_equalTo(self.labelView.mas_width);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.labelView.mas_bottom);
        make.height.offset(10);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ChooseSection *)dataSource{
    
    self.priceLB.text = [NSString stringWithFormat:@"小计:%.2f",dataSource.price];
}

+ (CGFloat)cellHeight{
    
    return 60;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
