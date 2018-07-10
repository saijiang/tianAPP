//
//  ReserveChoosePayTypeView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReserveChoosePayTypeView.h"

@implementation ReserveChoosePayTypeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds=YES;
        {
            self.iconImageView = [[LocalhostImageView alloc] init];
            self.iconImageView.image = [UIImage imageNamed:@"pay_wallet"];
            [self addSubview:self.iconImageView];
            
            self.displayLabel = [UnityLHClass masonryLabel:@"XX支付" font:14 color:BM_Color_BlackColor];
            [self addSubview:self.displayLabel];
            
            self.detailLabel = [UnityLHClass masonryLabel:@"XXXXXX" font:12 color:[UIColor lightGrayColor]];
            [self addSubview:self.detailLabel];
            
            self.couponLabel = [UnityLHClass masonryLabel:@"" font:12 color:BM_RED];
            [self addSubview:self.couponLabel];
        
            
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
    CGSize iconSize = CGSizeMake(kCommentHeight - 2 * margin, kCommentHeight - 2 * margin);
    CGSize chooseSize = CGSizeMake(15, 15);
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(self.mas_top).mas_offset(margin);
        make.size.mas_equalTo(iconSize);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(margin);
    }];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
        make.left.mas_equalTo(self.displayLabel.mas_right).mas_offset(5);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
        make.left.mas_equalTo(self.displayLabel.mas_left);
    }];
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(chooseSize);
        make.right.mas_equalTo(self.mas_right).mas_offset(-kMargin);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
}

@end


@interface ReserveChoosePayTypeView ()

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) ReserveChoosePayTypeItemView * walletItemView;
@property (nonatomic ,strong) ReserveChoosePayTypeItemView * wechatItemView;
@property (nonatomic ,strong) ReserveChoosePayTypeItemView * aliPayItemView;

@property (nonatomic ,strong) NSArray * payTypeChooseArray;
@property (nonatomic ,strong) id  data;

@end

@implementation ReserveChoosePayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"支付方式" font:15 color:BM_Color_BlackColor];
        [self addSubview:self.displayLabel];
        
        self.noteLabel = [UnityLHClass masonryLabel:@"(注：运费不参与折扣活动)" font:13 color:BM_RED];
        [self addSubview:self.noteLabel];
        [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
            make.left.mas_equalTo(self.displayLabel.mas_right);
        }];
        
        UIView *line=[[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor=[UIColor colorWithHexString:@"#DFDFDF"];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(self.displayLabel.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
      self.currentSelectPayType = 1;
        
        {
            self.walletItemView = [[ReserveChoosePayTypeItemView alloc] init];
            self.walletItemView.displayLabel.text = @"i币支付";
            self.walletItemView.detailLabel.text = @"i币安全支付";
            self.walletItemView.iconImageView.image = [UIImage imageNamed:@"pay_wallet"];
            self.walletItemView.payType=PayTypeWallet;
            [self addSubview:self.walletItemView];
        }
        
        {
            self.wechatItemView = [[ReserveChoosePayTypeItemView alloc] init];
            self.wechatItemView.displayLabel.text = @"微信支付";
            self.wechatItemView.detailLabel.text = @"微信安全支付";
            self.wechatItemView.iconImageView.image = [UIImage imageNamed:@"pay_wechat"];
            self.wechatItemView.payType=PayTypeWX;
            [self addSubview:self.wechatItemView];
        }
        {
            self.aliPayItemView = [[ReserveChoosePayTypeItemView alloc] init];
            self.aliPayItemView.displayLabel.text = @"支付宝支付";
            self.aliPayItemView.detailLabel.text = @"支付宝安全支付";
            self.aliPayItemView.iconImageView.image = [UIImage imageNamed:@"pay_aliPay"];
            self.aliPayItemView.payType=PayTypeZFB;
            [self addSubview:self.aliPayItemView];
        }
        
        self.payTypeChooseArray = @[self.walletItemView,
                                    self.wechatItemView,
                                    self.aliPayItemView];
        for (UIView *payView in self.payTypeChooseArray)
        {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
            [payView addGestureRecognizer:tap];
        }
        
      
    }
    return self;
}

- (void)configuration
{
//    ouponPaymentType 	String 	支付方式（01：支付宝, 02：微信 , 03：钱包支付）
//    couponStartDate 	String 	活动开始时间
//    couponEndDate 	String 	活动结束时间
//    couponDiscount 	String 	优惠折扣
//    goodAmount 	String 	商品总价（不包含运费）
//    payOrderAmount 	String 	实付金额（不包含运费）
//    couponOrderAmount 	String 	优惠价格
//    isEnd 	String 	活动状态（01：未开始，02：进行中，03：已结束）
//    isPayFlg 	String 	此支付是否开通优惠（0：否 ，1：是）
//    couponState 	String 	板块开启状态（01：开启，02：关闭）
    BOOL walletPaymentFlg=NO;
    BOOL weixinPaymentFlg=NO;
    BOOL alipayPaymentFlg=NO;
    
    for (NSDictionary *paymentFlg in self.data)
    {
        NSString *couponStartDate=[UnityLHClass getCurrentTimeWithType:@"YYYY.MM.dd" andTimeString:paymentFlg[@"couponStartDate"]];
        NSString *couponEndDate=[UnityLHClass getCurrentTimeWithType:@"YYYY.MM.dd" andTimeString:paymentFlg[@"couponEndDate"]];
        
        float couponOrderAmount=[paymentFlg[@"couponOrderAmount"] floatValue];//优惠的价格
        float payOrderAmount=[paymentFlg[@"payOrderAmount"] floatValue];//实际支付的价格
        float coupon=[paymentFlg[@"couponDiscount"] floatValue];
 
        
            if ([paymentFlg[@"couponPaymentType"] integerValue]==1)
            {
                alipayPaymentFlg=YES;
             
                self.aliPayItemView.couponOrderAmount=couponOrderAmount;
                self.aliPayItemView.price=payOrderAmount;
                if ([paymentFlg[@"isEnd"] integerValue]==2&&[paymentFlg[@"isPayFlg"] integerValue]==1&&[paymentFlg[@"couponState"] integerValue]==1)
                {
                    self.aliPayItemView.detailLabel.text=[NSString stringWithFormat:@"优惠时间：%@-%@",couponStartDate,couponEndDate];
                    self.aliPayItemView.couponLabel.text=[NSString stringWithFormat:@"限时%.1f折优惠",coupon];
                        
                    
                }
                
            }
            else if ([paymentFlg[@"couponPaymentType"] integerValue]==2)
            {
                weixinPaymentFlg=YES;
               
                self.wechatItemView.couponOrderAmount=couponOrderAmount;
                self.wechatItemView.price=payOrderAmount;
                if ([paymentFlg[@"isEnd"] integerValue]==2&&[paymentFlg[@"isPayFlg"] integerValue]==1&&[paymentFlg[@"couponState"] integerValue]==1)
                {
                    self.wechatItemView.detailLabel.text=[NSString stringWithFormat:@"优惠时间：%@-%@",couponStartDate,couponEndDate];
                    self.wechatItemView.couponLabel.text=[NSString stringWithFormat:@"限时%.1f折优惠",coupon];
                    
                }
               
            }
            else if ([paymentFlg[@"couponPaymentType"] integerValue]==3)
            {
                walletPaymentFlg=YES;
              
                self.walletItemView.couponOrderAmount=couponOrderAmount;
                self.walletItemView.price=payOrderAmount;
                if ([paymentFlg[@"isEnd"] integerValue]==2&&[paymentFlg[@"isPayFlg"] integerValue]==1&&[paymentFlg[@"couponState"] integerValue]==1)
                {
                    self.walletItemView.detailLabel.text=[NSString stringWithFormat:@"优惠时间：%@-%@",couponStartDate,couponEndDate];
                    self.walletItemView.couponLabel.text=[NSString stringWithFormat:@"限时%.1f折优惠",coupon];
                        
                    
                }

            }
        }
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMargin);
        make.height.mas_equalTo(kTopHeight);
    }];
    
    [self.walletItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).offset(0.5);
        make.right.mas_equalTo(self.mas_right);
        if (!walletPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
            
        }
    }];
    
    [self.wechatItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.walletItemView.mas_left);
        make.top.mas_equalTo(self.walletItemView.mas_bottom);
        make.right.mas_equalTo(self.walletItemView.mas_right);
        if (!weixinPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self.aliPayItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.wechatItemView.mas_left);
        make.top.mas_equalTo(self.wechatItemView.mas_bottom);
        make.right.mas_equalTo(self.wechatItemView.mas_right);
        if (!alipayPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.top.mas_equalTo(self.displayLabel.mas_top);
        make.bottom.mas_equalTo(self.aliPayItemView.mas_bottom);
    }];
}

//- (void)drawRect:(CGRect)rect
//{
//    
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGPoint startPoint_h = CGPointMake(0, kTopHeight);
//    CGPoint stopPoint_h = CGPointMake(CGRectGetWidth(rect),kTopHeight);
//    choose_drawLineWithContext(context, startPoint_h, stopPoint_h);
//    startPoint_h = CGPointMake(kMargin, kTopHeight + kCommentHeight);
//    stopPoint_h = CGPointMake(CGRectGetWidth(rect) - kMargin,kTopHeight + kCommentHeight);
//    startPoint_h = CGPointMake(kMargin, kTopHeight + kCommentHeight * 2);
//    stopPoint_h = CGPointMake(CGRectGetWidth(rect) - kMargin,kTopHeight + kCommentHeight * 2);
//}
//
//void choose_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
//    
//    CGPoint lines[] = {
//        start_point,
//        stop_point
//    };
//    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
//    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
//    CGContextStrokePath(context);
//};
- (void) configPay:(PayType)payType
{
 
    self.currentSelectPayType =payType;

    BOOL walletPaymentFlg=NO;
    BOOL weixinPaymentFlg=NO;
    BOOL alipayPaymentFlg=NO;
    
    if (payType==PayTypeWallet)
    {
        walletPaymentFlg=YES;
        self.walletItemView.chooseImageView.highlighted = YES;
        [UserServices
         getWalletBalanceWithuserId:[KeychainManager readUserId]
         completionBlock:^(int result, id responseObject)
         {
             NSString * wallet;
             if (result==0)
             {
                 wallet = [NSString stringWithFormat:@"¥%.2f",[responseObject[@"data"][@"WalletBalance"] floatValue]];
             }
             else
             {
                 wallet = [NSString stringWithFormat:@"¥%@",@"0.00"];
             }
             NSString * walletString = [NSString stringWithFormat:@"i币余额 %@ 元",wallet];
             NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:walletString];
             [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD992D"]} range:[walletString rangeOfString:wallet]];
             self.walletItemView.detailLabel.attributedText = att;
         }];

    }
    else if (payType==PayTypeWX)
    {
        weixinPaymentFlg=YES;
        self.wechatItemView.chooseImageView.highlighted = YES;

    }
    else if (payType==PayTypeZFB)
    {
        alipayPaymentFlg=YES;
        self.aliPayItemView.chooseImageView.highlighted = YES;
    }
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMargin);
        make.height.mas_equalTo(kTopHeight);
    }];
    
    [self.walletItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).offset(0.5);
        make.right.mas_equalTo(self.mas_right);
        if (!walletPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
            
        }
    }];
    
    [self.wechatItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.walletItemView.mas_left);
        make.top.mas_equalTo(self.walletItemView.mas_bottom);
        make.right.mas_equalTo(self.walletItemView.mas_right);
        if (!weixinPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self.aliPayItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.wechatItemView.mas_left);
        make.top.mas_equalTo(self.wechatItemView.mas_bottom);
        make.right.mas_equalTo(self.wechatItemView.mas_right);
        if (!alipayPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.top.mas_equalTo(self.displayLabel.mas_top);
        make.bottom.mas_equalTo(self.aliPayItemView.mas_bottom);
    }];
 
}

- (void) configChoosePayTypeViewWithData:(NSArray*)data
{
    
    NSMutableArray *typeArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < data.count; i++)
    {
        NSString*typeStr=data[i][@"couponPaymentType"];
        [typeArr addObject:typeStr];
        //        支付方式（01：支付宝, 02：微信 , 03：钱包支付）
        
    }
    
    if ([typeArr containsObject:@"03"])
    {
        self.currentSelectPayType=self.walletItemView.payType;
        self.walletItemView.chooseImageView.highlighted = YES;
    }
    else if ([typeArr containsObject:@"02"])
    {
        self.currentSelectPayType=self.wechatItemView.payType;
        self.wechatItemView.chooseImageView.highlighted = YES;
    }
    else if ([typeArr containsObject:@"01"])
    {
        self.currentSelectPayType=self.aliPayItemView.payType;
        self.aliPayItemView.chooseImageView.highlighted = YES;
    }else{
         self.currentSelectPayType=0;
    }
    self.data=data;
    
    [self configuration];
    
    self.currentPrice=self.walletItemView.price;

    self.couponOrderAmount=self.walletItemView.couponOrderAmount;

    if (self.bChoosePayTypeHandle)
    {
        self.bChoosePayTypeHandle(self.currentSelectPayType);
    }
 

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
         NSString * walletString = [NSString stringWithFormat:@"i币支付（余额 %@ 元）",wallet];
         NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:walletString];
         [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD992D"]} range:[walletString rangeOfString:wallet]];
         self.walletItemView.displayLabel.attributedText = att;
    }];
    
}
- (void) configShopOnePay
{
    BOOL walletPaymentFlg=YES;
    BOOL weixinPaymentFlg=YES;
    BOOL alipayPaymentFlg=YES;
        [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMargin);
        make.height.mas_equalTo(kTopHeight);
    }];
    
    [self.walletItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).offset(0.5);
        make.right.mas_equalTo(self.mas_right);
        if (!walletPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
            
        }
    }];
    
    [self.wechatItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.walletItemView.mas_left);
        make.top.mas_equalTo(self.walletItemView.mas_bottom);
        make.right.mas_equalTo(self.walletItemView.mas_right);
        if (!weixinPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self.aliPayItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.wechatItemView.mas_left);
        make.top.mas_equalTo(self.wechatItemView.mas_bottom);
        make.right.mas_equalTo(self.wechatItemView.mas_right);
        if (!alipayPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.top.mas_equalTo(self.displayLabel.mas_top);
        make.bottom.mas_equalTo(self.aliPayItemView.mas_bottom);
    }];
    
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
         NSString * walletString = [NSString stringWithFormat:@"i币支付（余额 %@ 元）",wallet];
         NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:walletString];
         [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD992D"]} range:[walletString rangeOfString:wallet]];
         self.walletItemView.detailLabel.attributedText = att;
     }];

}
- (void) configJDShopPay
{
    BOOL walletPaymentFlg=YES;
    BOOL weixinPaymentFlg=NO;
    BOOL alipayPaymentFlg=NO;
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMargin);
        make.height.mas_equalTo(kTopHeight);
    }];
    
    [self.walletItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_bottom).offset(0.5);
        make.right.mas_equalTo(self.mas_right);
        if (!walletPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
            
        }
    }];
    
    [self.wechatItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.walletItemView.mas_left);
        make.top.mas_equalTo(self.walletItemView.mas_bottom);
        make.right.mas_equalTo(self.walletItemView.mas_right);
        if (!weixinPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self.aliPayItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.wechatItemView.mas_left);
        make.top.mas_equalTo(self.wechatItemView.mas_bottom);
        make.right.mas_equalTo(self.wechatItemView.mas_right);
        if (!alipayPaymentFlg)
        {
            make.height.mas_equalTo(0);
        }
        else
        {
            make.height.mas_equalTo(kCommentHeight);
        }
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.top.mas_equalTo(self.displayLabel.mas_top);
        make.bottom.mas_equalTo(self.aliPayItemView.mas_bottom);
    }];
    
    
    self.currentSelectPayType=self.walletItemView.payType;
    self.walletItemView.chooseImageView.highlighted = YES;
    
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
         NSString * walletString = [NSString stringWithFormat:@"i币支付（余额 %@ 元）",wallet];
         NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:walletString];
         [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD992D"]} range:[walletString rangeOfString:wallet]];
         self.walletItemView.detailLabel.attributedText = att;
     }];
    
}

- (void) tapHandle:(UITapGestureRecognizer *)tap
{
    
    for (NSInteger index = 0;index < self.payTypeChooseArray.count ; index ++)
    {
        ReserveChoosePayTypeItemView *payView=self.payTypeChooseArray[index];
        payView.chooseImageView.highlighted = NO;
    }
    ReserveChoosePayTypeItemView *payView=(ReserveChoosePayTypeItemView *)tap.view;
    payView.chooseImageView.highlighted = YES;
    self.currentSelectPayType =payView.payType;
    self.currentPrice=payView.price;
    self.couponOrderAmount=payView.couponOrderAmount;
    
    if (self.bChoosePayTypeHandle)
    {
        self.bChoosePayTypeHandle(self.currentSelectPayType);
    }
}

@end

@implementation ReservePayAmountView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"支付金额" font:15 color:BM_Color_BlackColor];
        [self addSubview:self.displayLabel];
        
        self.amountLabel = [UnityLHClass masonryLabel:@"￥260.00" font:15 color:[UIColor colorWithHexString:@"#FF9525"]];
        [self addSubview:self.amountLabel];
        
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-kMargin);
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
    }];
}

- (void) configPayAmountWithData:(CGFloat)price{

    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
}
@end

