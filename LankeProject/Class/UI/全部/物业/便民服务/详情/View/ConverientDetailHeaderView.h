//
//  ConverientDetailHeaderView.h
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConverientDetailHeaderView : UIView

@property (nonatomic,strong)CommonHeaderView *headerImageView;//详情的图片
@property (nonatomic,strong)UILabel *contentLab;//内容简介
//初始化方法
-(id)initWithImage:(NSString *)imageStr withContent:(NSString *)content;
//赋值
-(void)loadHeaderViewWithDataSource:(id)dataSource;

@end
