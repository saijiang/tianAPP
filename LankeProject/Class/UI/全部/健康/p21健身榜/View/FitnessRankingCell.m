//
//  FitnessRankingCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessRankingCell.h"

@interface FitnessRankingCell ()

@property (nonatomic ,strong) UILabel * rankLabel;
@property (nonatomic ,strong) NetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * calorieLabel;

@property (nonatomic ,strong) UIButton * goodButton;// 点赞
@property (nonatomic ,strong) UIButton * attentionButton;// 关注

@property (nonatomic ,strong) UIView * lineView;

@property (nonatomic ,strong) FitnessRankingItem * item;
@end

@implementation FitnessRankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        //
        self.rankLabel = [UnityLHClass masonryLabel:@"1" font:17 color:BM_BLACK];
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.rankLabel];
        
        CGFloat width = [FitnessRankingCell cellHeight] - 20;
        //
        self.iconImageView = [[NetworkImageView alloc] init];
//        self.iconImageView.image = [UIImage imageNamed:@"detault_user_icon"];
        self.iconImageView.layer.cornerRadius = width/2;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        //
        self.nameLabel = [UnityLHClass masonryLabel:@"dddd" font:15 color:BM_BLACK];
        [self.contentView addSubview:self.nameLabel];
        
        //
        self.calorieLabel = [UnityLHClass masonryLabel:@"224cal" font:14 color:[UIColor colorWithHexString:@"999999"]];
        self.calorieLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.calorieLabel];
        
        UIImage * dZanImage = [UIImage imageNamed:@"health_ranking_didnt_zan"];
        UIImage * zanImage = [UIImage imageNamed:@"health_ranking_did_zan"];
        
        //
        self.goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.goodButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.goodButton setImage:dZanImage forState:UIControlStateNormal];
        [self.goodButton setImage:zanImage forState:UIControlStateSelected];
        [self.goodButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.goodButton setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
        [self.goodButton setTitle:@" 9" forState:UIControlStateNormal];
        [self.contentView addSubview:self.goodButton];
        [self.goodButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * button) {
            
            if (self.bZanHandle) {
                self.bZanHandle(self.item,button.isSelected);
            }
        }];
        
        //
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.attentionButton hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentionButton hll_setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.attentionButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateSelected];
        [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionButton setTitle:@"取消关注" forState:UIControlStateSelected];
        self.attentionButton.layer.cornerRadius = 5.0f;
        self.attentionButton.layer.masksToBounds = YES;
        self.attentionButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.attentionButton.layer.borderColor = BM_Color_Blue.CGColor;
        [self.contentView addSubview:self.attentionButton];
        [self.attentionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * button) {
           
            if (self.bAttendHandle) {
                self.bAttendHandle(self.item,!button.isSelected);
            }
        }];
        //
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.iconImageView.mas_left);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(30);
        CGFloat width = [FitnessRankingCell cellHeight] - 20;
        make.size.mas_equalTo(CGSizeMake(width,width));
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.rankLabel.mas_top);
        make.height.mas_equalTo(self.rankLabel.mas_height);
        make.right.mas_lessThanOrEqualTo(self.calorieLabel.mas_left).mas_offset(-5);
    }];
    
    [self.calorieLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(2);
    }];
    
    [self.goodButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_right).mas_offset(-120);
        make.height.mas_equalTo(25);
    }];
    
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.rankLabel.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(self.attentionButton.mas_right);
    }];
}

- (void) configCellWithData:(id)data atIndexPath:(NSIndexPath *)indexPath{

    self.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    self.item = data;
    self.item.indexPath = indexPath;
    
    if (indexPath.row < 3)
    {
        self.calorieLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        self.calorieLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    [self configCellWithData:data];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(FitnessRankingItem *)item{
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    
    self.nameLabel.text = item.name;
    self.calorieLabel.text = item.calorie;
    self.attentionButton.hidden=NO;
    if ([item.userId isEqualToString:[KeychainManager readUserId]])
    {
      self.nameLabel.text=@"我";
      self.attentionButton.hidden=YES;
    }
    if (item.hasAttention)
    {// 已经关注
        self.attentionButton.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        self.attentionButton.selected = YES;
    }
    else
    {
        self.attentionButton.layer.borderColor = BM_Color_Blue.CGColor;
        self.attentionButton.selected = NO;
    }
    
    [self.goodButton setTitle:item.zanCount forState:UIControlStateNormal];
    self.goodButton.selected = item.didZan;
    
}

+ (CGFloat) cellHeight{
    
    CGFloat height = 60.0f;
    return height;
}

@end


@implementation FitnessRankingItem

-(instancetype) initItemWith:(id)data{
    
    self = [super init];
    if (self) {
        
        self.icon = data[@"headImage"];
        self.name = data[@"nickName"];
        self.rang = [data[@"rowNum"] integerValue];
        self.userId = data[@"userId"];
        
        self.calorie = [NSString stringWithFormat:@"%@千卡",data[@"consumeCalories"]];
        
        if ([data[@"isAttent"] isEqual:@"1"]) {// 已经关注
            self.hasAttention = YES;
        }else{
            self.hasAttention = NO;
        }
        
        self.zanCount = [NSString stringWithFormat:@" %@",data[@"praiseNum"]];
        if ([data[@"isClick"] isEqual:@"1"]) {// 已经点赞
            self.didZan = YES;
        }else{
            self.didZan = NO;
        }
    }
    return self;
}

@end
