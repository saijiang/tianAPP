//
//  JDFilterHeaderView.m
//  LankeProject
//
//  Created by zhounan on 2017/12/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDFilterHeaderView.h"

@interface JDFilterHeaderView ()

@property (nonatomic ,strong) UILabel * titleLabel;

@end
@implementation JDFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //        self.userInteractionEnabled = NO;
        
        UILabel *titleLB = [UnityLHClass masonryLabel:@"****" font:16.0 color:[UIColor colorWithHexString:@"#999999"]];
        titleLB.backgroundColor=BM_CLEAR;
        [self addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
      //   make.edges.mas_equalTo(UIEdgeInsetsMake(10, 20, 0, 0));
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.mas_equalTo(self.mas_top).offset(20);
            make.width.mas_equalTo(60);
            
        }];
        
        self.titleLabel = titleLB;
        
        UIButton *filterButton=[UnityLHClass masonryButton:@"全部" imageStr:@"" font:13.0 color:[UIColor colorWithHexString:@"#999999"]];
        
//        [filterButton setImage:[UIImage imageNamed:@"Mall_xiala"] forState:UIControlStateSelected];
       // filterButton.hidden=YES;
        [filterButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
        [self addSubview:filterButton];
        self.filterButton=filterButton;
        [filterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [filterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(filterButton.selected)];
        }];

    }
    return self;
}

- (void) configureHeaderViewWithData:(id)data{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",data[@"filterSection"]];
}

+ (NSString *)reuseIdentifier{
    
    return @"JDFilterHeaderView";
}
@end
