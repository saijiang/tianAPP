//
//  ChooseCityHeaderView.m
//  LankeProject
//
//  Created by itman on 17/2/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChooseCityHeaderView.h"

@implementation ChooseCityHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.title=[UnityLHClass initUILabel:@"" font:15.0 color:BM_Color_GrayColor rect:CGRectMake(10, 0, 200, DEF_HEIGHT(self))];
        [self addSubview:self.title];
        self.backgroundColor=  BM_Color_SeparatorColor;
    }
    return self;
}

@end
