//
//  PropertyRepairCommentHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairCommentHeaderView.h"
#import "AXRatingView.h"

@interface PropertyRepairCommentHeaderView ()

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) NetworkImageView * commentIconImageView;
@property (nonatomic ,strong) UILabel * commentNameLabel;
@property (nonatomic ,strong) UILabel * commentPhoneLabel;

@property (nonatomic ,strong) AXRatingView * commentGradeView;
@property (nonatomic ,strong) UILabel * commentGradeLabel;

@end

@implementation PropertyRepairCommentHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        if (!_commentIconImageView) {
            _commentIconImageView = [[NetworkImageView alloc] init];
            _commentIconImageView.image = [UIImage imageNamed:@"detault_user_icon"];
            _commentIconImageView.layer.masksToBounds = YES;
            _commentIconImageView.layer.cornerRadius = 30.0f;
            [self.contentView addSubview:_commentIconImageView];
        }
        
        if (!_commentNameLabel) {
            _commentNameLabel = [UnityLHClass masonryLabel:@"张师傅" font:16 color:BM_Color_BlackColor];
            [self.contentView addSubview:_commentNameLabel];
        }
        
        if (!_commentPhoneLabel) {
            _commentPhoneLabel = [UnityLHClass masonryLabel:@"1343534534" font:14 color:[UIColor colorWithHexString:@"999999"]];
            [self.contentView addSubview:_commentPhoneLabel];
        }
        
        if (!_commentGradeView) {
            _commentGradeView = [[AXRatingView alloc] init];
            _commentGradeView.numberOfStar = 5;
            _commentGradeView.value = 4;
            _commentGradeView.markFont = [UIFont systemFontOfSize:25];
            _commentGradeView.baseColor = [UIColor colorWithHexString:@"#CCCCCC"];
            _commentGradeView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
            [_commentGradeView setStepInterval:1.0];
            _commentGradeView.userInteractionEnabled = NO;
            [self.contentView addSubview:_commentGradeView];
        }
        if (!_commentGradeLabel) {
            _commentGradeLabel = [UnityLHClass masonryLabel:@"4.8分" font:14 color:BM_Color_BlackColor];
            [self.contentView addSubview:_commentGradeLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
    [self.commentIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.commentNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.commentIconImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.commentIconImageView.mas_top).mas_offset(5);
    }];
    
    [self.commentPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.commentNameLabel.mas_centerY);
        make.left.mas_equalTo(self.commentNameLabel.mas_right).mas_offset(5);
    }];
    
    [self.commentGradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentNameLabel.mas_left);
        make.top.mas_equalTo(self.commentNameLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(110.0f);
        make.height.mas_equalTo(30);
    }];
    
    [self.commentGradeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.commentGradeView.mas_centerY);
        make.left.mas_equalTo(self.commentGradeView.mas_right).mas_offset(10);
    }];
    
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

-(void)config:(id)data
{
    
    [self.commentIconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"employeeHeadImage"]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    self.commentNameLabel.text=data[@"userName"];
    self.commentPhoneLabel.text=data[@"propertyMobileNum"];
    self.commentGradeLabel.text=[NSString stringWithFormat:@"%.1f分",[data[@"averageScores"] floatValue]];
    self.commentGradeView.value=[data[@"averageScores"] floatValue];
}

@end
