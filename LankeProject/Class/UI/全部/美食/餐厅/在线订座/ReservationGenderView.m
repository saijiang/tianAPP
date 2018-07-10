//
//  ReservationGenderView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationGenderView.h"

@implementation ReservationGenderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.leftTitle=[UnityLHClass masonryLabel:@"性别" font:14.0 color:BM_BLACK];
        [self addSubview:self.leftTitle];
        [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *nanshi=[UnityLHClass masonryButton:@" 男士" imageStr:@"choose-off" font:14.0 color:BM_BLACK];
        [nanshi setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self addSubview:nanshi];
       
        UIButton *nvshi=[UnityLHClass masonryButton:@" 女士" imageStr:@"choose-off" font:14.0 color:BM_BLACK];
        [nvshi setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self addSubview:nvshi];
        
        
        [nanshi handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            nanshi.selected=YES;
            nvshi.selected=NO;
            if (self.bChooseGenderHandle) {
                self.bChooseGenderHandle(@"01");
            }
        }];
        [nvshi handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            nanshi.selected=NO;
            nvshi.selected=YES;
            if (self.bChooseGenderHandle) {
                self.bChooseGenderHandle(@"02");
            }
        }];
        
        [nanshi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftTitle.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [nvshi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nanshi.mas_right).offset(30);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *line=[[UIView alloc]init];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftTitle.mas_left);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

- (void)didMoveToSuperview{

    [super didMoveToSuperview];
    
}

@end
