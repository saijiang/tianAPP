//
//  GroupBuyPayTypeView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyPayTypeView.h"

@implementation GroupBuyPayTypeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        {
            self.iconImageView = [[LocalhostImageView alloc] init];
            self.iconImageView.image = [UIImage imageNamed:@"pay_wallet"];
            [self addSubview:self.iconImageView];
            
            self.displayLabel = [UnityLHClass masonryLabel:@"XX支付" font:14 color:BM_Color_BlackColor];
            [self addSubview:self.displayLabel];
            self.detailLabel = [UnityLHClass masonryLabel:@"XXXXXX" font:12 color:BM_Color_GrayColor];
            [self addSubview:self.detailLabel];
            
            self.chooseImageView = [[LocalhostImageView alloc] init];
            self.chooseImageView.image = [UIImage imageNamed:@"circle_choose_off"];
            self.chooseImageView.highlightedImage = [UIImage imageNamed:@"circle_choose_on"];
            [self addSubview:self.chooseImageView];
        }
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat margin = 10.0f;
    CGSize iconSize = CGSizeMake(kCommentHeightGroupBuy - 2 * margin, kCommentHeightGroupBuy - 2 * margin);
    CGSize chooseSize = CGSizeMake(15, 15);
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMarginGroupBuy * 2 + chooseSize.width);
        make.top.mas_equalTo(self.mas_top).mas_offset(margin);
        make.size.mas_equalTo(iconSize);
    }];
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(chooseSize);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-kMarginGroupBuy);
        make.left.mas_equalTo(self.mas_left).mas_offset(kMarginGroupBuy);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(margin);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
        make.left.mas_equalTo(self.displayLabel.mas_left);
    }];
}

@end


@interface GroupBuyPayTypeView ()

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) GroupBuyPayTypeItemView * walletItemView;
@property (nonatomic ,strong) GroupBuyPayTypeItemView * wechatItemView;
@property (nonatomic ,strong) GroupBuyPayTypeItemView * aliPayItemView;

@property (nonatomic ,strong) NSArray * payTypeChooseArray;

@end

@implementation GroupBuyPayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"支付方式" font:15 color:BM_Color_BlackColor];
        [self addSubview:self.displayLabel];
        
        self.currentSelectPayType = 1;
        
        {
            self.walletItemView = [[GroupBuyPayTypeItemView alloc] init];
            self.walletItemView.displayLabel.text = @"i币支付";
            self.walletItemView.detailLabel.text = @"i币余额 1000 元";
            self.walletItemView.iconImageView.image = [UIImage imageNamed:@"pay_wallet"];
            self.walletItemView.chooseImageView.highlighted = YES;
            [self addSubview:self.walletItemView];
        }
        
        {
            self.wechatItemView = [[GroupBuyPayTypeItemView alloc] init];
            self.wechatItemView.displayLabel.text = @"微信支付";
            self.wechatItemView.detailLabel.text = @"微信安全支付";
            self.wechatItemView.iconImageView.image = [UIImage imageNamed:@"pay_wechat"];
            [self addSubview:self.wechatItemView];
        }
        {
            self.aliPayItemView = [[GroupBuyPayTypeItemView alloc] init];
            self.aliPayItemView.displayLabel.text = @"支付宝支付";
            self.aliPayItemView.detailLabel.text = @"支付宝安全支付";
            self.aliPayItemView.iconImageView.image = [UIImage imageNamed:@"pay_aliPay"];
            [self addSubview:self.aliPayItemView];
        }
        
        self.payTypeChooseArray = @[self.walletItemView.chooseImageView,
                                    self.wechatItemView.chooseImageView,
                                    self.aliPayItemView.chooseImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMarginGroupBuy);
        make.height.mas_equalTo(kTopHeightGroupBuy);
    }];
    
    [self.walletItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(kCommentHeightGroupBuy);
    }];
    
    [self.wechatItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.walletItemView.mas_left);
        make.top.mas_equalTo(self.walletItemView.mas_bottom);
        make.right.mas_equalTo(self.walletItemView.mas_right);
        make.height.mas_equalTo(self.walletItemView.mas_height);
    }];
    
    [self.aliPayItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.wechatItemView.mas_left);
        make.top.mas_equalTo(self.wechatItemView.mas_bottom);
        make.right.mas_equalTo(self.wechatItemView.mas_right);
        make.height.mas_equalTo(self.wechatItemView.mas_height);
    }];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint_h = CGPointMake(0, kTopHeightGroupBuy);
    CGPoint stopPoint_h = CGPointMake(CGRectGetWidth(rect),kTopHeightGroupBuy);
    GroupBuy_drawLineWithContext(context, startPoint_h, stopPoint_h);
    
    startPoint_h = CGPointMake(kMarginGroupBuy, kTopHeightGroupBuy + kCommentHeightGroupBuy);
    stopPoint_h = CGPointMake(CGRectGetWidth(rect) - kMarginGroupBuy,kTopHeightGroupBuy + kCommentHeightGroupBuy);
    //choose_drawLineWithContext(context, startPoint_h, stopPoint_h);
    
    startPoint_h = CGPointMake(kMarginGroupBuy, kTopHeightGroupBuy + kCommentHeightGroupBuy * 2);
    stopPoint_h = CGPointMake(CGRectGetWidth(rect) - kMarginGroupBuy,kTopHeightGroupBuy + kCommentHeightGroupBuy * 2);
    //choose_drawLineWithContext(context, startPoint_h, stopPoint_h);
}

void GroupBuy_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    CGContextStrokePath(context);
};

- (void) configChoosePayTypeView
{
    
    [UserServices
     getWalletBalanceWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         NSString * wallet;
         if (result==0)
         {
             wallet = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"WalletBalance"] floatValue]];
         }
         else
         {
             wallet = [NSString stringWithFormat:@"%@",@"0.00"];
         }
         NSString * walletString = [NSString stringWithFormat:@"i币余额 %@ 元",wallet];
         NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:walletString];
         [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD992D"]} range:[walletString rangeOfString:wallet]];
         self.walletItemView.detailLabel.attributedText = att;
     }];
}

- (void) tapHandle:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:tap.view];
    
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopHeightGroupBuy), point)) {
        return;
    }
    CGRect walletRect = CGRectMake(0, kTopHeightGroupBuy, CGRectGetWidth(self.bounds), kCommentHeightGroupBuy);
    CGRect wechatRect = CGRectMake(0, kTopHeightGroupBuy + kCommentHeightGroupBuy, CGRectGetWidth(self.bounds), kCommentHeightGroupBuy);
    CGRect aliPayRect = CGRectMake(0, kTopHeightGroupBuy + 2 * kCommentHeightGroupBuy, CGRectGetWidth(self.bounds), kCommentHeightGroupBuy);
    
    NSInteger selectedType = 0;
    
    if (CGRectContainsPoint(walletRect, point)) {
        selectedType = 1;
    }
    if (CGRectContainsPoint(wechatRect, point)) {
        selectedType = 2;
    }
    if (CGRectContainsPoint(aliPayRect, point)) {
        selectedType = 3;
    }
    if (self.currentSelectPayType == selectedType) {
        return;
    }else{
        self.currentSelectPayType = selectedType;
    }
    
    for (NSInteger index = 0;index < self.payTypeChooseArray.count ; index ++) {
        
        UIImageView * chooseImageView = self.payTypeChooseArray[index];
        chooseImageView.highlighted = index == selectedType - 1;
    }
    if (self.bChoosePayTypeHandle) {
        self.bChoosePayTypeHandle(selectedType);
    }
}

@end
