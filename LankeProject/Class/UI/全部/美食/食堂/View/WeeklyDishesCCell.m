//
//  WeeklyDishesCCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "WeeklyDishesCCell.h"

@interface WeeklyDishesCCell ()

@property (nonatomic ,strong) NetworkImageView * dishesImageView;
@property (nonatomic ,strong) UILabel * dishesNameLabel;
@property (nonatomic ,strong) UIButton * gradeButton;

@end

@implementation WeeklyDishesCCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
        self.contentView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.contentView.layer.cornerRadius = 5.0f;
        
       
        _dishesImageView = [[NetworkImageView alloc] init];
        _dishesImageView.contentMode = UIViewContentModeScaleAspectFill;
        _dishesImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.contentView addSubview:_dishesImageView];
        
        _dishesNameLabel = [UnityLHClass masonryLabel:@"澳龙澳龙澳龙澳龙澳龙" font:14 color:[UIColor colorWithHexString:@"#333333"]];
        _dishesNameLabel.textAlignment = NSTextAlignmentLeft;
        _dishesNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dishesNameLabel];
      
        _gradeButton = [UnityLHClass masonryButton:@" 4.8分" imageStr:@"weekly_dishes_zan" font:13 color:BM_Color_Blue];
        _gradeButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_gradeButton];
          
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_dishesImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(_dishesImageView.mas_width);
    }];
    [_gradeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_dishesNameLabel.mas_centerY);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
    }];
    [_dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_dishesImageView.mas_bottom);
        make.left.mas_equalTo(_dishesImageView.mas_left).mas_offset(10);
        make.right.mas_lessThanOrEqualTo(_gradeButton.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"WeeklyDishesCCell";
}

- (void) configCellWithData:(id)data{
    
    _dishesNameLabel.text = data[@"dishesName"];
    
    [_gradeButton setTitle:[NSString stringWithFormat:@" %.1f分",[data[@"evalScores"] floatValue]] forState:UIControlStateNormal];
    
    [_dishesImageView sd_setImageWithURL:[NSURL URLWithString:data[@"dishesImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
}

@end
