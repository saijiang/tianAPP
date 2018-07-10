//
//  JDProgressView.h
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDProgressView : UIView

@property (nonatomic,strong)UIButton *button1;
@property (nonatomic,strong)UIButton *button2;
@property (nonatomic,strong)UIButton *button3;
@property (nonatomic,strong)UIButton *button4;

@property (nonatomic,strong)UIView *line1;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UIView *line3;

@property (nonatomic,strong)UILabel *lable1;
@property (nonatomic,strong)UILabel *lable2;
@property (nonatomic,strong)UILabel *lable3;
@property (nonatomic,strong)UILabel *lable4;


@property (nonatomic,strong)UILabel *progressLab;//进度状态
@property (nonatomic,strong)UIButton *detailBtn;//进度详情按钮

-(void)loadViewWithData:(id)data;

@end
