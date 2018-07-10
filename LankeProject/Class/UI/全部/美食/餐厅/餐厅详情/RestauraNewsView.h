//
//  RestauraNewsView.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestauraNewsView : UIView
@property (nonatomic,strong)LocalhostImageView *leftImage;
@property (nonatomic,strong)ScrollTitleView  *contenLable;
-(void)loadTitleWithTitle:(NSString *)title;
@end
