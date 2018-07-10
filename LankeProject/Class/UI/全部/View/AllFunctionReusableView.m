//
//  AllFunctionReusableView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AllFunctionReusableView.h"
#import "UIView+MHExtension.h"
#import "AllFunctionConfig.h"


@interface AllFunctionHeaderView ()

@property (nonatomic ,strong) UILabel * titleLabel;

@end
@implementation AllFunctionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;

        UILabel *titleLB = [UnityLHClass masonryLabel:@"****" font:16.0 color:[UIColor colorWithHexString:@"#333333"]];
        titleLB.backgroundColor=BM_CLEAR;
        [self addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 0, 0));
        }];
        self.titleLabel = titleLB;
    }
    return self;
}

// ChooseSection
- (void) configureHeaderViewWithData:(Section *)data{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",data.section];
}

+ (NSString *)reuseIdentifier{
    
    return @"AllFunctionHeaderView";
}
@end


@implementation AllFunctionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addLineUp:NO andDown:YES andColor:[UIColor colorWithHexString:@"#EFEFEF"]];
    }
    return self;
}

+ (NSString *)reuseIdentifier{
    
    return @"AllFunctionFooterView";
}

@end
