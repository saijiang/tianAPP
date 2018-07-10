//
//  GroupBuyPayReuseView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyPayReuseView.h"

@interface GroupBuyPayHeaderView ()
@property (nonatomic ,strong) UIView * whiteView;
@end
@implementation GroupBuyPayHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.whiteView = [[UIView alloc] init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.whiteView];
    }
    return self;
}

- (void)layoutSubviews{
 
    [super layoutSubviews];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
}

+ (NSString *) identifier{

    return @"GroupBuyPayHeaderView";
}

@end

@interface GroupBuyPayFooterView ()
@property (nonatomic ,strong) UIView * whiteView;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UILabel * amountLabel;

@end
@implementation GroupBuyPayFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        self.whiteView = [[UIView alloc] init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.whiteView];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"合计" font:15 color:BM_Color_BlackColor];
        [self.contentView addSubview:self.displayLabel];
        
        self.amountLabel = [UnityLHClass masonryLabel:@"￥260.00" font:15 color:[UIColor colorWithHexString:@"#FF9525"]];
        [self.contentView addSubview:self.amountLabel];
        
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
    }];
}

+ (NSString *) identifier{

    return @"GroupBuyPayFooterView";
}
- (void) price:(CGFloat)price{
    
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
}
@end
