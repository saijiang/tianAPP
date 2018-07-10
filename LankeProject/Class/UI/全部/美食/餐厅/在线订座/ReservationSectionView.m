//
//  ReservationSectionView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationSectionView.h"

@implementation ReservationSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.leftTitle=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        [self addSubview:self.leftTitle];
        
        self.rightTitle=[UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:self.rightTitle];
        
        UIImageView *goImage=[[UIImageView alloc]init];
        goImage.image=[UIImage imageNamed:@"right_arrow"];
        [self addSubview:goImage];
        
        [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        [self.rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(goImage.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *line=[[UIView alloc]init];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftTitle.mas_left);
            make.right.mas_equalTo(goImage.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) tapHandle:(UITapGestureRecognizer *)tapGestgure{
    
    if (self.bTapHandle) {
        self.bTapHandle();
    }
}
@end
