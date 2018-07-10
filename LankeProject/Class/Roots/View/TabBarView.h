//
//  TabBarView.h
//  LankeProject
//
//  Created by itman on 16/5/31.
//  Copyright © 2016年 张涛. All rights reserved.

#import <UIKit/UIKit.h>

@class TabBarView;

/**
 *  TabBarView的委托协议
 */
@protocol TabBarViewDelegate <NSObject>
@optional
/**
 *  TabBarView被选中的item
 *
 *  @param tabBarView 当前TabBarView对象
 *  @param index      被选中的item的index
 */
- (void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(NSInteger)index;

@end

@interface TabBarView : UIView
{
   
}

/**
 *  TabBarView对象
 */
@property (nonatomic, assign) id<TabBarViewDelegate> delegate;


@end
