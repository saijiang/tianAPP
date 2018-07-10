//
//  JDServiceDetailView.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceDetailView.h"

@implementation JDServiceDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        self.titleLab = [UnityLHClass masonryLabel:@"审核留言" font:15.0 color:BM_BLACK];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
//            make.right.mas_equalTo(-15);
        }];
        
        _rightLab = [UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
        _rightLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).offset(5);
            make.centerY.mas_equalTo(_titleLab.mas_centerY);
            make.height.mas_equalTo(50);
            make.right.mas_equalTo(-10);
        }];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = BM_Color_LineColor;
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLab.mas_bottom);
            make.left.mas_equalTo(_titleLab.mas_left);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH-15);
            make.height.mas_equalTo(1);
        }];
        
        self.contentLab = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        self.contentLab.numberOfLines = 0;
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab.mas_left);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(_line.mas_bottom).offset(20);
        }];
        
        self.timeLab = [UnityLHClass masonryLabel:@"2017-09-08 23:09:34" font:14.0 color:BM_BLACK];
        self.timeLab.hidden = YES;
        [self addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab.mas_left);
            make.top.mas_equalTo(self.contentLab.mas_bottom).offset(15);
        }];
        
//        NSArray *array = @[[UIImage imageNamed:@"property_home_bianmin"],[UIImage imageNamed:@"property_home_bianmin"],[UIImage imageNamed:@"property_home_bianmin"],[UIImage imageNamed:@"property_home_bianmin"]];
        
        
    }
    return self;
}

-(void)setImageArray:(NSArray *)imageArray
{
    
    self.photoView = [[SelectedPhotoView alloc]initWithFrame:CGRectMake(10, 0, DEF_SCREEN_WIDTH-10*2, 100) withImageArr:imageArray];
    self.photoView.maxColumn = 5;
    self.photoView.maxImageCount = 4;
    [self addSubview:self.photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_timeLab.mas_bottom).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(100);
    }];
}

@end
