//
//  RingProgressItemView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "RingProgressItemView.h"
#import "WCGraintCircleLayer.h"

@interface RingProgressItemView ()
@property (nonatomic ,strong) LocalhostImageView * backgroundImageView;
@property (nonatomic ,strong) WCGraintCircleLayer * circleLayer;
@end
@implementation RingProgressItemView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [[LocalhostImageView alloc] init];
//        self.backgroundImageView.image = [UIImage imageNamed:@"health_ring_shujuyuan"];
        [self addSubview:self.backgroundImageView];
        
        self.valueLabel = [UnityLHClass masonryLabel:@"00" font:30 color:[UIColor blackColor]];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.valueLabel];
        
        self.unitLabel = [UnityLHClass masonryLabel:@"步" font:18 color:[UIColor blackColor]];
        self.unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        make.width.mas_equalTo(self.backgroundImageView.mas_height);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.valueLabel.mas_bottom);
        make.centerX.mas_equalTo(self.valueLabel.mas_centerX);
    }];
    self.backgroundImageView.layer.masksToBounds=YES;
    self.backgroundImageView.layer.cornerRadius =self.backgroundImageView.bounds.size.height/2.0;
    self.backgroundImageView.layer.borderWidth=10;
    self.backgroundImageView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;

}
#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{

    return [[self alloc] init];
}

-(void)setProgress:(float)progress
{
    if (progress>1.0) {
        progress=1.0;
    }
    _progress=progress;
    if (self.circleLayer)
    {
        [self.circleLayer removeFromSuperlayer];
    }
    self.circleLayer = [[WCGraintCircleLayer alloc] initGraintCircleWithBounds:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height) Position:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0) FromColor:[UIColor greenColor] ToColor:[UIColor blueColor] LineWidth:10.0 ProgressWith:progress];
    [self.layer addSublayer:self.circleLayer];
    
}

- (void)config:(id)data
{
    
    
}
@end
