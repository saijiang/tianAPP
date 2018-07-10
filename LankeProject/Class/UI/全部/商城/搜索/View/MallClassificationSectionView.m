//
//  MallClassificationSectionView.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallClassificationSectionView.h"

@implementation MallClassificationSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.title=[UnityLHClass masonryLabel:@"" font:16.0 color:BM_BLACK];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.title.font = [UIFont boldSystemFontOfSize:16.0f];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)tapAction
{
    [self sendObject:@"tap"];
}
+(NSString*)cellIdentifier
{
    return @"MallClassificationSectionView";
}

@end
