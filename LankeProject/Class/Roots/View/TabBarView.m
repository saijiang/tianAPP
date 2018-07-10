//
//  TabBarView.h
//  LankeProject
//
//  Created by itman on 16/5/31.
//  Copyright © 2016年 张涛. All rights reserved.


#import "TabBarView.h"
#import "TabbarItem.h"
#define DEF_TAB_ITEM_COUNT 4


@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BM_WHITE;
        
        float itemWidth = DEF_SCREEN_WIDTH/DEF_TAB_ITEM_COUNT;
        NSArray *btnNameArray = @[@"首页",@"成长日记",@"淘果",@"我的"];
        NSArray *imageNormalArr = @[@"item-icon-1",@"item-icon-2",@"item-icon-3",@"item-icon-4",];
        NSArray *imageSelectedArr = @[@"item-icon-5",@"item-icon-6",@"item-icon-7",@"item-icon-8",];
        /// 创建每个item
        for (int i=0; i<btnNameArray.count; i++)
        {
            TabbarItem *itemButton = [[TabbarItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, DEF_HEIGHT(self))];
            itemButton.tag = i;
            itemButton.adjustsImageWhenHighlighted = NO;
            [itemButton setTitle:[btnNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [itemButton setTitleColor:[[UIColor colorWithWhite:0.604 alpha:1.000] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            [itemButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            itemButton.backgroundColor = BM_WHITE;
            itemButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            [itemButton setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateSelected];
            [itemButton setTitleColor:[UIColor colorWithWhite:0.604 alpha:1.000] forState:UIControlStateNormal];
            itemButton.titleLabel.font=BM_FONTSIZE(13);
            [itemButton setImage:[UIImage imageNamed:imageNormalArr[i]] forState:UIControlStateNormal];
            [itemButton setImage:[UIImage imageNamed:imageSelectedArr[i]] forState:UIControlStateSelected];
            [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemButton];
            if (i == 0)
            {
                itemButton.selected = YES;
            }
        }
    }
    return self;
}
- (void)itemClick:(UIButton *)item
{
  
    for (UIButton *button in self.subviews)
    {
        button.selected = NO;
    }
       item.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:didSelectAtIndex:)])
    {
        [self.delegate tabBarView:self didSelectAtIndex:item.tag];
    }
}
@end
