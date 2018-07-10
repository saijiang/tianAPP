//
//  MallClassificationView.m
//  LankeProject
//
//  Created by itman on 17/3/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallHomeClassificationView.h"

@implementation MallHomeClassificationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        [self createView];
    }
    return self;
}

-(void)createView
{
    
    for (int i=0; i<8; i++)
    {
        MallRotatingView *classView=[[MallRotatingView alloc]init];
        classView.tag=100+i;
        classView.backgroundColor=[UIColor randomColor];
        [self addSubview:classView];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [classView addGestureRecognizer:tap];

    }
    [self layoutSubviewsWithView:self];

}

-(void)layoutSubviewsWithView:(UIView *)view
{
    UIView *oneView =[view viewWithTag:100];
    UIView *twoView =[view viewWithTag:100+1];
    UIView *threeView =[view viewWithTag:100+2];
    UIView *fourView =[view viewWithTag:100+3];
    UIView *fiveView =[view viewWithTag:100+4];
    UIView *sixView =[view viewWithTag:100+5];
    UIView *senvenView =[view viewWithTag:100+6];
    UIView *eightView =[view viewWithTag:100+7];
    oneView.backgroundColor=[UIColor colorWithRed:1.00 green:0.40 blue:0.34 alpha:1.00];
    twoView.backgroundColor=[UIColor colorWithRed:1.00 green:0.71 blue:0.48 alpha:1.00];
    threeView.backgroundColor=[UIColor colorWithRed:0.30 green:0.56 blue:0.91 alpha:1.00];
    fourView.backgroundColor=[UIColor colorWithRed:0.16 green:0.72 blue:0.93 alpha:1.00];
    fiveView.backgroundColor=[UIColor colorWithRed:0.48 green:0.88 blue:0.64 alpha:1.00];
    sixView.backgroundColor=[UIColor colorWithRed:1.00 green:0.35 blue:0.61 alpha:1.00];
    senvenView.backgroundColor=[UIColor colorWithRed:0.99 green:0.80 blue:0.41 alpha:1.00];
    eightView.backgroundColor=[UIColor colorWithRed:0.76 green:0.45 blue:0.97 alpha:1.00];

    float height=DEF_SCREEN_WIDTH/4.5;
    float space=sqrt(2)*height;
    space=space+2;
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(twoView.mas_centerY);
        make.centerX.mas_equalTo(twoView.mas_centerX).offset(-space);
        make.width.and.height.mas_equalTo(height);
    }];
    
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY).offset(-space/2.0);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.and.height.mas_equalTo(height);
    }];
   
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(twoView.mas_centerY);
        make.centerX.mas_equalTo(twoView.mas_centerX).offset(space);
        make.width.and.height.mas_equalTo(height);
    }];
    
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.centerX.mas_equalTo(view.mas_centerX).offset(-space/2.0);
        make.width.and.height.mas_equalTo(height);
    }];
    
    [fiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.centerX.mas_equalTo(view.mas_centerX).offset(space/2.0);
        make.width.and.height.mas_equalTo(height);
    }];
    
    [sixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(senvenView.mas_centerY);
        make.centerX.mas_equalTo(senvenView.mas_centerX).offset(-space);
        make.width.and.height.mas_equalTo(height);
    }];
    
    [senvenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY).offset(space/2.0);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.and.height.mas_equalTo(height);
    }];

    [eightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(senvenView.mas_centerY);
        make.centerX.mas_equalTo(senvenView.mas_centerX).offset(space);
        make.width.and.height.mas_equalTo(height);
    }];

    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    NSArray *data=dataSource;
    
    if (data.count==0)
    {
        return;
    }
    for (int i=0; i<8; i++)
    {
        if (data.count>=i)
        {
            MallRotatingView *classView =[self viewWithTag:100+i];
            [classView.icon sd_setImageWithURL:[NSURL URLWithString:data[i][@"classImage"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
            classView.title.text=data[i][@"classNameFirst"];
            
            
        }
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self sendObject:@(tap.view.tag-100)];
}

@end


@implementation MallRotatingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createView];
    }
    return self;
}
-(void)createView
{
    
    UIView *baseView=[[UIView alloc]init];
    [self addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    NetworkImageView *imageView=[[NetworkImageView alloc]init];
    [baseView addSubview:imageView];
    self.icon=imageView;
    UILabel *titleLb=[UnityLHClass masonryLabel:@"" font:11.0 color:BM_WHITE];
    [baseView addSubview:titleLb];
    self.title=titleLb;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(baseView.mas_centerY).offset(-15);
        make.width.and.height.mas_equalTo(baseView.mas_width).multipliedBy(0.5);
        make.centerX.mas_equalTo(baseView.mas_centerX);
    }];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(7);
        make.centerX.mas_equalTo(baseView.mas_centerX);
    }];
    baseView.transform=CGAffineTransformMakeRotation(-M_PI/4);
    self.transform=CGAffineTransformMakeRotation(M_PI/4);

}

@end
