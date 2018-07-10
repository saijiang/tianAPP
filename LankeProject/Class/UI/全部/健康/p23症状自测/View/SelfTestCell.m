//
//  SelfTestCell.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SelfTestCell.h"

@interface SelfTestCell ()

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation SelfTestCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        if (!_sectionNameLabel)
        {
            _sectionNameLabel = [UnityLHClass masonryLabel:@"全身症状" font:15 color:BM_Color_BlackColor];
            _sectionNameLabel.textAlignment = NSTextAlignmentCenter;
            _sectionNameLabel.highlightedTextColor = BM_Color_Blue;
            [self.contentView addSubview:_sectionNameLabel];
        }
        if (!_sectionImageView)
        {
            _sectionImageView=[[LocalhostImageView alloc]init];
            [self.contentView addSubview:_sectionImageView];
        }
        if (!_lineView)
        {
            _lineView = [[UIView alloc] init];
            _lineView.backgroundColor = [UIColor whiteColor];;
            [self.contentView addSubview:_lineView];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [self.sectionImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.sectionNameLabel.mas_top).offset(-5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.width.mas_equalTo(self.sectionImageView.mas_height);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(2/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    
    self.sectionNameLabel.highlighted = selected;
    if (selected)
    {
        self.backgroundColor=[UIColor colorWithHexString:@"#Ffffff"];
        self.sectionImageView.image=[UIImage imageNamed:self.data[@"selectedImage"]];
    }
    else
    {
        self.backgroundColor=[UIColor colorWithHexString:@"#F5F5F5"];
        self.sectionImageView.image=[UIImage imageNamed:self.data[@"image"]];
    }
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"SelfTestCell";
}

- (void) configCellWithData:(id)data
{
    self.data=data;
    self.sectionImageView.image=[UIImage imageNamed:data[@"image"]];
    self.sectionNameLabel.text = [NSString stringWithFormat:@"%@",data[@"name"]];
}


@end
