//
//  DishesDetailCommentCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DishesDetailCommentCell.h"
#import "AXRatingView.h"

@interface DishesDetailCommentCell ()

@property (nonatomic ,strong) NetworkImageView * commentIconImageView;
@property (nonatomic ,strong) UILabel * commentNameLabel;
@property (nonatomic ,strong) UILabel * commentDateLabel;

@property (nonatomic ,strong) UILabel * commentContentLabel;

@property (nonatomic ,strong) AXRatingView * commentGradeView;
@property (nonatomic ,strong) UILabel * commentGradeLabel;

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation DishesDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_commentIconImageView) {
            _commentIconImageView = [[NetworkImageView alloc] init];
            _commentIconImageView.image = [UIImage imageNamed:@"detault_user_icon"];
            _commentIconImageView.layer.masksToBounds = YES;
            _commentIconImageView.layer.cornerRadius = 30.0f;
            [self.contentView addSubview:_commentIconImageView];
        }
        
        if (!_commentNameLabel) {
            _commentNameLabel = [UnityLHClass masonryLabel:@"飞翔的企鹅飞翔的企鹅飞翔的企鹅飞翔的企鹅" font:16 color:BM_Color_BlackColor];
            [self.contentView addSubview:_commentNameLabel];
        }
        
        if (!_commentDateLabel) {
            _commentDateLabel = [UnityLHClass masonryLabel:@"2016-12-12 12：22" font:14 color:[UIColor colorWithHexString:@"999999"]];
            [self.contentView addSubview:_commentDateLabel];
        }
        
        if (!_commentGradeView) {
            _commentGradeView = [[AXRatingView alloc] init];
            _commentGradeView.numberOfStar = 5;
            _commentGradeView.markFont = [UIFont systemFontOfSize:16];
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
        
        if (!_commentContentLabel) {
            _commentContentLabel = [UnityLHClass masonryLabel:@"非常好吃！！！！" font:14 color:BM_Color_BlackColor];
            _commentContentLabel.numberOfLines = 0;
            [self.contentView addSubview:_commentContentLabel];
        }
        
        if (!_lineView) {
            _lineView = [[UIView alloc] init];
            _lineView.backgroundColor = BM_Color_SeparatorColor;
            [self.contentView addSubview:_lineView];
        }
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.commentIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.commentGradeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.commentIconImageView.mas_top).mas_offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.commentGradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.commentGradeLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.commentGradeLabel.mas_centerY);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(20);
    }];
    [self.commentNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.commentIconImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.commentGradeLabel.mas_top);
        make.right.mas_lessThanOrEqualTo(self.commentGradeView.mas_left).mas_offset(-10);
    }];
    
    [self.commentDateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.commentNameLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.commentNameLabel.mas_left);
    }];
    
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.commentIconImageView.mas_left);
        make.top.mas_equalTo(self.commentIconImageView.mas_bottom).mas_offset(10);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-15);
        make.bottom.mas_lessThanOrEqualTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"DishesDetailCommentCell";
}

- (void) configCellWithData:(id)data{
    
    [_commentIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"headImage"]]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    
    _commentNameLabel.text = data[@"nickName"];
    
    _commentContentLabel.text = data[@"evalContent"];
    
    _commentGradeLabel.text = [NSString stringWithFormat:@"%.1f分",[data[@"evalScores"] floatValue]];
    
    self.commentGradeView.value = [data[@"evalScores"] integerValue];
    
    self.commentDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"evalAddtime"]] stringformatterDate:@"YYYY-MM-dd HH:mm"];
}

+ (CGFloat) cellHeightWithData:(id)data{
    
    CGFloat height = 0.0f;
    
    CGFloat contentHeight = [UnityLHClass getHeight:data[@"evalContent"] wid:DEF_SCREEN_WIDTH - 30  font:14];
    height += 10;
    height += 60;
    height += 20;
    height += contentHeight;
    
    return height;
}

- (void) configForRepair:(id)data{

    [_commentIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"headImage"]]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    
    _commentNameLabel.text = data[@"nickName"];
    
    _commentContentLabel.text = data[@"evalContent"];
    
    _commentGradeLabel.text = [NSString stringWithFormat:@"%.0f分",[data[@"evalScores"] floatValue]];
    
    self.commentGradeView.value = [data[@"evalScores"] integerValue];
    
    self.commentDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"evalAddtime"]] stringformatterDate:@"YYYY-MM-dd HH:mm"];

}
@end
