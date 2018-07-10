//
//  QuestionDefaultView.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "QuestionDefaultView.h"

@implementation QuestionDefaultView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"questionIcon_1"];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        self.topLab = [UnityLHClass masonryLabel:@"您已参与过本次问卷调查" font:16.0 color:[UIColor colorWithHexString:@"666666"]];
        self.topLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topLab];
        [self.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(40);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        }];
        
        self.bootomLab = [UnityLHClass masonryLabel:@"请关注下次，谢谢" font:16.0 color:[UIColor colorWithHexString:@"666666"]];
        self.bootomLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.bootomLab];
        [self.bootomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
            make.top.mas_equalTo(self.topLab.mas_bottom).offset(5);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        }];
        
    }
    return self;
}

-(void)loadContenWithDataSource:(id)dataSource
{
    self.iconImageView.image = [UIImage imageNamed:dataSource[@"image"]];
    self.topLab.text = dataSource[@"titleTop"];
    self.bootomLab.text = dataSource[@"titleBootom"];
}

@end
