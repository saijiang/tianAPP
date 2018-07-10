//
//  GuideView.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "GuideView.h"

/**
 *  引导页张数
 */
#define DEF_GUIDE_COUNT 5

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentSize                    = CGSizeMake(DEF_WIDTH(self)*DEF_GUIDE_COUNT, DEF_HEIGHT(self));
        self.pagingEnabled                  = YES;
        self.bounces                        = NO;
        self.backgroundColor                = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        
        
        
//        for (int i=0; i<DEF_GUIDE_COUNT; i++)
//        {
//            UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(DEF_WIDTH(self)*i, 0, DEF_WIDTH(self), DEF_HEIGHT(self))];
//            imageView.image         = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i+1]];
//             [self addSubview:imageView];
//            
//            if (i == DEF_GUIDE_COUNT-1)
//            {
//                imageView.userInteractionEnabled = YES;
//                
//                // 开始按钮，一般放在最后一张引导页上，frame大小自己根据需要进行调整
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(self), DEF_HEIGHT(self))];
//                [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(beginClick:) forControlEvents:UIControlEventTouchUpInside];
//                [imageView addSubview:button];
//            }
//        }
    }
    return self;
}

- (void)beginClick:(UIButton *)btn
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
