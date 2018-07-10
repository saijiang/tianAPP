//
//  RestauraNewsView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestauraNewsView.h"

@implementation RestauraNewsView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;

        LocalhostImageView *iconImage = [[LocalhostImageView alloc]initWithImage:[UIImage imageNamed:@"notiIcon"]];
        [self addSubview:iconImage];
        self.leftImage=iconImage;
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
            make.left.mas_equalTo(iconImage.mas_right).offset(10);
        }];
        
        self.contenLable=[[ScrollTitleView alloc]initWithFrame:CGRectMake(50, 0, DEF_SCREEN_WIDTH-60, 50) textScrollModel:ZHTTextScrollFromOutside direction:ZHTTextScrollMoveLeft];
        [self addSubview:self.contenLable];
      
    }
    return self;
}

-(void)loadTitleWithTitle:(NSString *)title
{
    [self.contenLable startScrollWithText:title textColor:BM_Color_BlackColor font:[UIFont systemFontOfSize:15.0]];


}

@end
