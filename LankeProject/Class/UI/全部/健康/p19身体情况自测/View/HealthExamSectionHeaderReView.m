//
//  HealthExamSectionHeaderReView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamSectionHeaderReView.h"

@interface HealthExamSectionHeaderReView()

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) UILabel * displayLabel;

@end

@implementation HealthExamSectionHeaderReView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _displayLabel = [UnityLHClass masonryLabel:@"***" font:16 color:BM_Color_BlackColor];
        _displayLabel.numberOfLines = 0;
        [_contentView addSubview:_displayLabel];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark API

- (void) configForTCM:(NSString *)name{
    
    self.displayLabel.text = name;
}

- (void) config:(id)data{
    
    NSString * normal = data[@"normalText"];
    NSString * att = data[@"attributeText"];
    NSString * displayString = [NSString stringWithFormat:@"%@%@",normal,att];
    
    NSDictionary * attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#C3C3C3"],
                                  NSFontAttributeName:[UIFont systemFontOfSize:16]};
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:displayString];
    if (att.length) {
        [attString addAttributes:attributes
                           range:[displayString rangeOfString:att]];
    }
    self.displayLabel.attributedText = attString;
}

+ (NSString *) reuseIdentifier{
    
    return @"HealthExamSectionHeaderView";
}

+ (CGSize) headerReferenceSizeForTCM:(NSString *)name{

    CGFloat width = DEF_SCREEN_WIDTH - 20;
    NSString * displayString = name;
    CGFloat height = [UnityLHClass getHeight:displayString wid:width font:16];
    height += 15;
    height += 20;
    return (CGSize){DEF_SCREEN_WIDTH,height};
}

+ (CGSize) headerReferenceSizeWithData:(id)data{
    
    CGFloat width = DEF_SCREEN_WIDTH - 20;
    NSString * normal = data[@"normalText"];
    NSString * att = data[@"attributeText"];
    NSString * displayString = [NSString stringWithFormat:@"%@%@",normal,att];
    CGFloat height = [UnityLHClass getHeight:displayString wid:width font:16];
    height += 15;
    height += 20;
    return (CGSize){DEF_SCREEN_WIDTH,height};
}
@end

@implementation HealthExamSectionFooterReView

+ (NSString *)reuseIdentifier{

    return @"HealthExamSectionFooterReView";
}

@end
