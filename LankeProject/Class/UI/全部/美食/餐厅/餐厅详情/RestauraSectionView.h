//
//  RestauraSectionView.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface RestauraSectionView : UIView

@property (nonatomic,strong)LocalhostImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *contentLab;

-(void)loadViewWithImage:(NSString *)image title:(NSString *)title  content:(NSString *)content;

@end
