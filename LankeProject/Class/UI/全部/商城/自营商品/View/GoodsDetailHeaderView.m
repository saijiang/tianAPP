//
//  GoodsDetailHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GoodsDetailHeaderView.h"
#import "LKBannerView.h"
#import "LKStepView.h"

@interface GoodsDetailHeaderView ()

@property (nonatomic ,strong) LKBannerView * bannerView;

@property (nonatomic ,strong) UILabel * goodsNameLabel;
@property (nonatomic ,strong) UIButton * likeGoodsButton;

@property (nonatomic ,strong) UILabel * goodsPriceLabel;

@property (nonatomic ,strong) UILabel * couponPriceLabel;
@property (nonatomic ,strong) UILabel * skuLabel;//商品编号
@property (nonatomic ,strong) UILabel * praiseLabel;//好评率
@property (nonatomic ,strong) UILabel * salesLabel;//销量

@property (nonatomic ,strong) UIView  * couponPricelineView;

@property (nonatomic ,strong) UIView * lineView;

@property (nonatomic ,strong) id goodsData;

@end
@implementation GoodsDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _bannerView = [[LKBannerView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH + 100)];
        _bannerView.myPageView.duration = 3.0f;
        [self addSubview:_bannerView];
        
        _goodsNameLabel = [UnityLHClass masonryLabel:@"" font:16 color:BM_Color_BlackColor];
        _goodsNameLabel.numberOfLines = 0;
        [self addSubview:_goodsNameLabel];
        
        _skuLabel = [UnityLHClass masonryLabel:@"" font:15 color:BM_Color_huiColor];
        _skuLabel.numberOfLines = 1;
        [self addSubview:_skuLabel];
        _praiseLabel = [UnityLHClass masonryLabel:@"" font:15 color:BM_Color_huiColor];
        _praiseLabel.numberOfLines = 1;
        [self addSubview:_praiseLabel];
        
        _salesLabel = [UnityLHClass masonryLabel:@"" font:15 color:BM_Color_huiColor];
        _salesLabel.numberOfLines = 1;
        [self addSubview:_salesLabel];
        
        _goodsPriceLabel = [UnityLHClass masonryLabel:@"" font:16 color:[UIColor colorWithHexString:@"#FF8B00"]];
        [self addSubview:_goodsPriceLabel];
        
        _likeGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeGoodsButton setImage:[UIImage imageNamed:@"mall_shop_detail_collect_normal"] forState:UIControlStateNormal];
        [_likeGoodsButton setImage:[UIImage imageNamed:@"mall_shop_detail_collect_select"] forState:UIControlStateSelected];
        [_likeGoodsButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * sender) {
            
            [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                
                if (sender.isSelected) {
                    [self requestCancelCollect];
                }else{
                    [self requestCollect];
                }
            }];
        }];
        [self addSubview:_likeGoodsButton];
        
        _stepView = [LKStepView view];
        _stepView.value = 1;
        [self addSubview:_stepView];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BM_Color_SeparatorColor;
        [self addSubview:_lineView];
        
        
        if (!_couponPriceLabel) {
            _couponPriceLabel = [UnityLHClass masonryLabel:@"0.00" font:12 color:BM_GRAY];
            _couponPriceLabel.textAlignment = NSTextAlignmentLeft;
            _couponPriceLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_couponPriceLabel];
        }
        if (!_couponPricelineView) {
            _couponPricelineView = [UIView new];
            _couponPricelineView.backgroundColor = BM_GRAY;
            [_couponPriceLabel addSubview:_couponPricelineView];
        }
        
        self.couponPriceLabel.hidden=YES;
        

    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH);
        //make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-100);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    

    
    [_likeGoodsButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.bannerView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_likeGoodsButton.mas_top);
        make.right.mas_equalTo(self.mas_right).mas_offset(-55);

//        make.right.mas_lessThanOrEqualTo(self.likeGoodsButton.mas_left).mas_offset(-10);
    }];
    
    
    [_skuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_goodsNameLabel.mas_bottom).offset(5);
        make.right.mas_lessThanOrEqualTo(self.likeGoodsButton.mas_left).mas_offset(-10);
    }];
    [_praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_skuLabel.mas_bottom).offset(5);
        make.right.mas_lessThanOrEqualTo(self.likeGoodsButton.mas_left).mas_offset(-10);
    }];
    [_salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.top.mas_equalTo(_skuLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);

        make.right.mas_lessThanOrEqualTo(self.likeGoodsButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(_praiseLabel.mas_centerY).mas_offset(-10);
    }];
    [_stepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_salesLabel.mas_bottom).mas_offset(10);
        
    }];
    [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        //make.top.mas_equalTo(self.goodsNameLabel.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        make.left.mas_equalTo(self.goodsNameLabel.mas_left);
    }];
    
    [_couponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_goodsPriceLabel.mas_centerY);
        make.left.mas_equalTo(_goodsPriceLabel.mas_right).offset(5);
    }];
    [_couponPricelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_couponPriceLabel.mas_centerY);
        make.width.mas_equalTo(_couponPriceLabel.mas_width);
        make.centerX.mas_equalTo(_couponPriceLabel.mas_centerX);
        make.height.mas_equalTo(1.0);
    }];
}

- (NSInteger) currentGoodsCount{

    return self.stepView.value;
}

- (void) configForStoreOneWith:(id)data{

    self.goodsData = data;
    self.goodsNameLabel.text =data[@"productCname"];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data[@"price"] floatValue]];
    self.likeGoodsButton.selected = [data[@"isCollect"] integerValue] >= 1;
    NSArray *bannerList=data[@"picList"];
    if ([data[@"picList"] count]==0)
    {
        bannerList=@[@"default_dishes"];
    }
    [self.bannerView configureBannerViewWithBannerList:bannerList];
}
- (void) configForStoreJDWith:(id)data{
    
    self.goodsData = data;
    self.goodsNameLabel.text =data[@"name"];
  
    self.skuLabel.text =[NSString stringWithFormat:@"商品编号:%@",data[@"sku"]];
    NSString *str2 = [NSString stringWithFormat:@"%.1f%%",[data[@"evaluateScore"] floatValue]*100];

    self.praiseLabel.text =[NSString stringWithFormat:@"好评率:%@",str2];
    self.salesLabel.text =[NSString stringWithFormat:@"销量:%@",data[@"salesVolume"]];


    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data[@"zkPrice"] floatValue]];
    self.likeGoodsButton.selected = [data[@"isCollect"] integerValue] >= 1;
    NSArray *bannerList=data[@"imageList"];
    NSMutableArray*arrayImage=[NSMutableArray  array];
    if ([data[@"imageList"] count]==0)
    {
       // bannerList=@[@"default_dishes"];
        [arrayImage addObject:@"default_dishes"];
        
    }else{
        for (int i=0; i<bannerList.count; i++) {
            NSDictionary*dic=bannerList[i];
            [arrayImage addObject:dic[@"path"]];
        }
    }
   
    [self.bannerView configureBannerViewWithBannerList:arrayImage];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    self.goodsData = data;
    
    //self.goodsNameLabel.attributedText = [self transformAttributString:data[@"goodsName"]];
    self.goodsNameLabel.text = data[@"goodsName"];

    self.likeGoodsButton.selected = [data[@"isCollect"] integerValue] >= 1;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [data[@"imageArr"] count]; i++)
    {
        UIImage *imge = [UIImage imageWithData:[NSData
                                                dataWithContentsOfURL:[NSURL URLWithString:data[@"imageArr"][i]]]];
        if (imge != nil && imge != NULL)
        {
            [array addObject:data[@"imageArr"][i]];
        }
    }
    
    [self.bannerView configureBannerViewWithBannerList:array];
    
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[data[@"couponPrice"] floatValue]];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f",[data[@"salePrice"] floatValue]];
    if ([data[@"salePrice"] floatValue]==[data[@"couponPrice"] floatValue]) {
        self.couponPriceLabel.hidden=YES;
    }
    else{
        self.couponPriceLabel.hidden=NO;
        
    }

}

- (NSAttributedString *)transformAttributString:(NSString *)string{
    
    NSMutableAttributedString * mAttString = [[NSMutableAttributedString alloc] initWithString:string];
    [mAttString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                        range:NSMakeRange(0, string.length - 1)];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    if (!self.isSelfSupport) {
        
        attachment.image = [UIImage imageNamed:@"mall_shop_detail_shop_one"];
        attachment.bounds = CGRectMake(0, -2, 20, 18);
    }else{
        
        attachment.image = [UIImage imageNamed:@"mall_shop_detail_self_support"];
        attachment.bounds = CGRectMake(0, -2, 30, 15);
    }
    
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    [mAttString appendAttributedString:imageAttr];
    
    return mAttString;
}


#pragma mark -
#pragma mark Network M

- (void) requestCollect{
    
    if ([self.isTypeShop isEqualToString:@"JD"]) {
      
        [UserServices collectionHeadlthAdviceWithUserId:[KeychainManager readUserId] itemsId:self.goodsData[@"sku"] collectType:@"07" userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];
                self.likeGoodsButton.selected = YES;
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
            
        }];

    }else{
        NSString * itemId = self.isSelfSupport ? self.goodsData[@"goodsId"] : self.goodsData[@"productId"];
        
        [UserServices collectionHeadlthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemId collectType:@"01" userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];
                self.likeGoodsButton.selected = YES;
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
            
        }];

    }
   }

- (void) requestCancelCollect{
    
    if ([self.isTypeShop isEqualToString:@"JD"]) {

        
        [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId: self.goodsData[@"sku"] collectType:@"07" completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
                self.likeGoodsButton.selected = NO;
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }else{
    NSString * itemId = self.isSelfSupport ? self.goodsData[@"goodsId"] : self.goodsData[@"productId"];
    
    [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemId collectType:@"01" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
            self.likeGoodsButton.selected = NO;
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    }
}


@end
