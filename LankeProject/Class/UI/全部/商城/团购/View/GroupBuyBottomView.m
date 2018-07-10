//
//  GroupBuyBottomView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyBottomView.h"

@interface GroupBuyBottomView ()

@property (nonatomic ,strong) UIButton * handleButton;

@end

@implementation GroupBuyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _handleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_handleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bRushHandle) {
                self.bRushHandle();
            }
        }];
        [self addSubview:_handleButton];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [_handleButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) config:(id)data
{
    
    //isEndStatus 	String 	是否截止（01：截止时间已到 ，02：截止时间未到）
    if ([data[@"isEndStatus"] integerValue]==1)
    {
        _handleButton.userInteractionEnabled=NO;
        [_handleButton setTitle:@"已结束" forState:UIControlStateNormal];
        [_handleButton hll_setBackgroundImageWithColor:BM_Color_SeparatorColor forState:UIControlStateNormal];
        

    }
    else
    {
        [_handleButton setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_handleButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];

       
    }

}



@end
