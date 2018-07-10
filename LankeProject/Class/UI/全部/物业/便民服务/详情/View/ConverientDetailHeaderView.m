//
//  ConverientDetailHeaderView.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ConverientDetailHeaderView.h"

@implementation ConverientDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        self.headerImageView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/2)];
        [self addSubview:self.headerImageView];
        self.contentLab = [UnityLHClass masonryLabel:nil font:14.0 color:[UIColor colorWithHexString:@"666666"]];
        self.contentLab.numberOfLines = 0;
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.headerImageView.mas_left).offset(15);
            make.right.mas_equalTo(self.headerImageView.mas_right).offset(-15);
        }];

    }
    return self;
}

-(id)initWithImage:(NSString *)imageStr withContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        self.headerImageView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/2)];
        [self addSubview:self.headerImageView];
        
        self.contentLab = [UnityLHClass masonryLabel:content font:14.0 color:[UIColor colorWithHexString:@"666666"]];
        self.contentLab.numberOfLines = 0;
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.headerImageView.mas_left).offset(15);
            make.right.mas_equalTo(self.headerImageView.mas_right).offset(-15);
        }];
    }
    
    return self;
}

//赋值
-(void)loadHeaderViewWithDataSource:(id)dataSource
{
    [self.headerImageView configureBannerViewWithImageData:dataSource[@"imageArr"]];
    self.contentLab.text=dataSource[@"merchantDescription"];

}

@end
