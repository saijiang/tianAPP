//
//  LocalhostImageView.m
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LocalhostImageView.h"

@implementation LocalhostImageView

/**
 *  本地图片裁减方式
 *
 *  @param frame 坐标
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

@end
