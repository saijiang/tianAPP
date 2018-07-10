//
//  GroupBuyRushInfoView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyRushInfoView.h"

@interface GroupBuyRushInfoView ()

@property (nonatomic ,strong) UILabel * endDateDisplayLabel;
@property (nonatomic ,strong) UILabel * endDateContentLabel;

@property (nonatomic ,strong) UILabel * countLabel;
@property (nonatomic ,strong) UILabel * countDisplayLabel;

@property (nonatomic ,strong) UIView * separatorView;

@property (nonatomic ,strong) UILabel * currentCountLabel;
@end

@implementation GroupBuyRushInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#DEF5FE"];
        
        _endDateDisplayLabel = [UnityLHClass masonryLabel:@"截止时间：" font:14 color:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_endDateDisplayLabel];
        
        _endDateContentLabel = [UnityLHClass masonryLabel:@"2017.1.10 15:00" font:14 color:BM_BLACK];
        [self addSubview:_endDateContentLabel];
        
        _countLabel = [UnityLHClass masonryLabel:@" 10人成团 " font:14 color:BM_Color_Blue];
        _countLabel.layer.borderColor = BM_Color_Blue.CGColor;
        _countLabel.layer.borderWidth = 1;
        _countLabel.layer.cornerRadius = 5.0f;
        _countLabel.layer.masksToBounds = YES;
        [self addSubview:_countLabel];
        
        _countDisplayLabel = [UnityLHClass masonryLabel:@"人数不足自动退款" font:14 color:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_countDisplayLabel];
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = BM_BLACK;
        [self addSubview:_separatorView];
        
        _currentCountLabel = [UnityLHClass masonryLabel:@"100人已抢" font:15 color:BM_BLACK];
        [self addSubview:_currentCountLabel];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.currentCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.centerY.mas_equalTo(self.currentCountLabel.mas_centerY);
        make.right.mas_equalTo(self.currentCountLabel.mas_left).mas_offset(-20);
    }];
    
    [self.endDateDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    
    [self.endDateContentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.endDateDisplayLabel.mas_top);
        make.left.mas_equalTo(self.endDateDisplayLabel.mas_right).mas_offset(0);
//        make.right.mas_equalTo(self.separatorView.mas_left).mas_offset(-10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.endDateDisplayLabel.mas_left);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.endDateDisplayLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.countDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.countLabel.mas_centerY);
        make.top.mas_equalTo(self.countLabel.mas_top);
        make.left.mas_equalTo(self.countLabel.mas_right).mas_offset(5);
//        make.right.mas_equalTo(self.separatorView.mas_left).mas_offset(-10);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) config:(id)data{
    
    // date
    
    // count
       NSString * displayText = @"";
     NSString * count=@"";
    NSInteger groupRule= [data[@"groupRule"] integerValue];
    if (groupRule==1) {
        _countLabel.text = [NSString stringWithFormat:@" %@人成团 ",data[@"groupNumber"]];
       // _countDisplayLabel.text=@"人数不足自动退款";
         _countDisplayLabel.text=@"商品确认未成团自动退款";
        count  = data[@"alreadyBuyNum"];
        displayText = [NSString stringWithFormat:@"%@人已抢",count];
        
    }else if(groupRule == 2){
        _countLabel.text = [NSString stringWithFormat:@" %@件成团 ",data[@"groupGoodsNumber"]];
//        _countDisplayLabel.text=@"件数不足自动退款";
        _countDisplayLabel.text=@"商品确认未成团自动退款";
        count  = data[@"alreadyBuyGoodsNum"];
        displayText = [NSString stringWithFormat:@"%@件已抢",count];
        
    }
 
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:displayText];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FF8B00"]}
                 range:NSMakeRange(0, count.length + 1)];
    self.currentCountLabel.attributedText = att;
    
    _endDateContentLabel.text=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM.dd HH:mm" andTimeString:data[@"endDate"]];
    
 

    
}

@end
