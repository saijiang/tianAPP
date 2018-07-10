//
//  SuggestionHistoryImageCell.m
//  LankeProject
//
//  Created by admin on 2017/7/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SuggestionHistoryImageCell.h"

@interface SuggestionHistoryImageCell ()

@property (nonatomic ,strong) UILabel * historyTitleLabel;
@property (nonatomic ,strong) UILabel * historyTimeLabel;

@property (nonatomic ,strong) UILabel * replyDisplayLabel;
@property (nonatomic ,strong) UILabel * replyLabel;
@property (nonatomic ,strong) UIView * lineView;

@end
@implementation SuggestionHistoryImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds=YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.historyTitleLabel = [UnityLHClass masonryLabel:@"10月份的电费问题" font:16 color:[UIColor blackColor]];
        self.historyTitleLabel.numberOfLines=0;
        [self.contentView addSubview:self.historyTitleLabel];
        
        self.historyTimeLabel = [UnityLHClass masonryLabel:@"2016/02/12" font:14 color:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:self.historyTimeLabel];
        
        self.replyDisplayLabel = [UnityLHClass masonryLabel:@"物业回复：" font:14 color:BM_Color_Blue];
        self.replyDisplayLabel.hidden=YES;
        [self.contentView addSubview:self.replyDisplayLabel];
        
        self.replyLabel = [UnityLHClass masonryLabel:@"拨打1233534" font:14 color:[UIColor blackColor]];
        self.replyLabel.numberOfLines=0;
        [self.contentView addSubview:self.replyLabel];
        
        self.lineView = [UIView lineView];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat padding = 30;
    CGFloat margin_h = 10;
    CGFloat width = (CGRectGetWidth(self.bounds) - padding - 3 * margin_h) /3.0;
    CGFloat height = width;
    
    [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(padding/2);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-padding/2);
    }];
    [self.historyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.historyTitleLabel.mas_left);
        make.top.mas_equalTo(self.historyTitleLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.historyTitleLabel.mas_right);
    }];
       [self.replyDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.historyTimeLabel.mas_left);
        make.top.mas_equalTo(self.historyTimeLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(75);
    }];
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.replyDisplayLabel.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.replyDisplayLabel.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.historyTitleLabel.mas_right);
        //        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(padding/2);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-padding/2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"SuggestionHistoryImageCell";
}

- (void)configCellWithData:(id)data{
    self.historyTitleLabel.text=data[@"complainContent"];
    self.replyLabel.text=data[@"replyContent"];
    
    self.historyTimeLabel.text=[UnityLHClass getCurrentTimeWithType:@"yyyy/MM/dd" andTimeString:data[@"complainTime"]];
    if (self.replyLabel.text.length==0) {
        self.replyDisplayLabel.hidden=YES;
        
    }else{
        self.replyDisplayLabel.hidden=NO;
        
    }
    
}

+ (CGFloat)cellHeightWithData:(id)data{
    
    float hight=60;
    hight+=[UnityLHClass getHeight:data[@"complainContent"] wid:DEF_SCREEN_WIDTH-30 font:16];
    if ([data[@"replyContent"] length]>0) {
        hight+=[UnityLHClass getHeight:data[@"replyContent"] wid:DEF_SCREEN_WIDTH-30-75 font:14];
    }else{
        hight-=20;
    }
    return hight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
