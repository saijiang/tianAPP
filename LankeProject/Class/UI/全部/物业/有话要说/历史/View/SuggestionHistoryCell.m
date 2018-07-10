//
//  SuggestionHistoryCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SuggestionHistoryCell.h"
#import "SelectedPhotoView.h"
#import "XWScanImage.h"
@interface SuggestionHistoryCell ()

@property (nonatomic ,strong) UILabel * historyTitleLabel;
@property (nonatomic ,strong) UILabel * historyTimeLabel;

@property (nonatomic ,strong) LKNetworkImageView * oneImageView;
@property (nonatomic ,strong) LKNetworkImageView * twoImageView;
@property (nonatomic ,strong) LKNetworkImageView * threeImageView;
@property (nonatomic ,strong) LKNetworkImageView * fourImageView;

@property (nonatomic ,strong) NSArray * imageViews;

@property (nonatomic ,strong) UILabel * replyDisplayLabel;
@property (nonatomic ,strong) UILabel * replyLabel;
@property (nonatomic ,strong) UIView * lineView;
@end
@implementation SuggestionHistoryCell

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
        
        self.oneImageView = [[LKNetworkImageView alloc] init];
        [self.contentView addSubview:self.oneImageView];
       [self.oneImageView setBTouchEndBlock:^(LKNetworkImageView *imageView){
            [XWScanImage scanBigImageWithImageView:imageView];
       }];
        self.twoImageView = [[LKNetworkImageView alloc] init];
        [self.contentView addSubview:self.twoImageView];
        [self.twoImageView setBTouchEndBlock:^(LKNetworkImageView *imageView){
            [XWScanImage scanBigImageWithImageView:imageView];
        }];
        self.threeImageView = [[LKNetworkImageView alloc] init];
        [self.contentView addSubview:self.threeImageView];
        [self.threeImageView setBTouchEndBlock:^(LKNetworkImageView *imageView){
            [XWScanImage scanBigImageWithImageView:imageView];
        }];
        self.imageViews = @[self.oneImageView,self.twoImageView,self.threeImageView,];
//
        
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
    NSInteger index = 0;
    for (LKNetworkImageView * view in self.imageViews) {
        
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo((width + margin_h) * index + padding/2);
            make.top.mas_equalTo(self.historyTimeLabel.mas_bottom).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        index ++;
    }

    [self.replyDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.historyTimeLabel.mas_left);
        make.top.mas_equalTo(self.oneImageView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(75);
    }];
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.replyDisplayLabel.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.replyDisplayLabel.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.historyTitleLabel.mas_right);
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

    return @"SuggestionHistoryCell";
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
    NSMutableArray *imageArr=data[@"imageArr"];
    for (int i=0; i<self.imageViews.count; i++)
    {
        LKNetworkImageView * imageView=self.imageViews[i];
        imageView.hidden=YES;
        if (i<imageArr.count)
        {
             imageView.hidden=NO;
             [imageView setImageURL:[NSURL URLWithString:imageArr[i]]];
        }
        
    }
   
}

+ (CGFloat)cellHeightWithData:(id)data{

    float hight=170;
    hight+=[UnityLHClass getHeight:data[@"complainContent"] wid:DEF_SCREEN_WIDTH-30 font:16];
    if ([data[@"replyContent"] length]>0) {
        hight+=[UnityLHClass getHeight:data[@"replyContent"] wid:DEF_SCREEN_WIDTH-30-75 font:14];
    }else{
        hight-=20;
    }
    return hight;
}

@end
