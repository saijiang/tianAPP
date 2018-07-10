//
//  MallgoodsCell.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallgoodsCell.h"

@implementation MallgoodsCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00].CGColor;
        self.backgroundColor=BM_WHITE;
        
        self.mallIcon=[[NetworkImageView alloc]init];
        [self.contentView addSubview:self.mallIcon];
        
        self.mallName=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
        [self.contentView addSubview:self.mallName];
        
        self.mallEvaluation=[UnityLHClass masonryLabel:@"" font:13.0 color:[UIColor colorWithHexString:@"666666"]];
        [self.contentView addSubview:self.mallEvaluation];
        
        self.mallPrice=[UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithRed:0.92 green:0.62 blue:0.30 alpha:1.00]];
        [self.contentView addSubview:self.mallPrice];
        
        self.mallBuy=[UnityLHClass masonryButton:@"  订购  " font:13.0 color:BM_WHITE];
        self.mallBuy.backgroundColor=[UIColor colorWithRed:0.38 green:0.70 blue:0.85 alpha:1.00];
        self.mallBuy.layer.cornerRadius=5;
        self.mallBuy.layer.masksToBounds=YES;
        [self.contentView addSubview:self.mallBuy];
        [self.mallBuy addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
        
        _couponPriceLabel = [UnityLHClass masonryLabel:@"0.00" font:12 color:BM_GRAY];
        _couponPriceLabel.textAlignment = NSTextAlignmentLeft;
        _couponPriceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_couponPriceLabel];

        _couponPricelineView = [UIView new];
        _couponPricelineView.backgroundColor = BM_GRAY;
        [_couponPriceLabel addSubview:_couponPricelineView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mallIcon mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.and.right.and.top.mas_equalTo(0);
         make.height.mas_equalTo(self.mallIcon.mas_width);
     }];
    
    [self.mallName mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(self.mallIcon.mas_bottom).offset(10);
         make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
         make.left.mas_equalTo(self.mallPrice.mas_left);
     }];
    [self.mallEvaluation mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(self.mallName.mas_bottom).mas_offset(10);
         make.left.mas_equalTo(self.mallPrice.mas_left);
     }];
    [self.mallPrice mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(self.mallEvaluation.mas_bottom).mas_offset(10);
         make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
     }];
    
    [self.couponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.mallPrice.mas_left);
    }];
    
    [self.couponPricelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_couponPriceLabel.mas_centerY);
        make.width.mas_equalTo(_couponPriceLabel.mas_width);
        make.centerX.mas_equalTo(_couponPriceLabel.mas_centerX);
        make.height.mas_equalTo(1.0);
    }];

    [self.mallBuy mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
         make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
         
     }];

}

+(CGSize)getCGSizeWithDataSource:(id)dataSource
{
    float width=(DEF_SCREEN_WIDTH-3*10)/2.0-0.1;
    float hight=width;
    if ([dataSource[@"couponPrice"] floatValue]==[dataSource[@"salePrice"] floatValue]) {
        hight=width+90;
    }
    else{
        hight=width+110;
    }
    return CGSizeMake(width,hight);
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.data=dataSource;
    [self.mallIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.mallName.text = dataSource[@"goodsName"];
    self.mallEvaluation.text = [NSString stringWithFormat:@"好评%.0f%%",100 * [dataSource[@"evalScores"] floatValue]];//@"好评95%";
    self.mallPrice.text = [NSString stringWithFormat:@"￥%.2f",[dataSource[@"couponPrice"] floatValue]];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dataSource[@"salePrice"] floatValue]];
    if ([dataSource[@"couponPrice"] floatValue]==[dataSource[@"salePrice"] floatValue]) {
        self.couponPriceLabel.hidden=YES;
    }
    else{
        self.couponPriceLabel.hidden=NO;
    }

}


-(void)addGoods
{
    if ([KeychainManager islogin])
    {
        [UserServices addGoodsInShopCarListWithGoodsId:self.data[@"goodsId"]
                                                userId:[KeychainManager readUserId]
                                            merchantId:self.data[@"merchantId"]
                                              goodsNum:@"1"
                                              cartType:@"01"
                                              userName:[KeychainManager readUserName]
                                           productType:@""
                                       completionBlock:^(int result, id responseObject)
         {
             if (result == 0)
             {
                 [UnityLHClass showHUDWithStringAndTime:@"添加购物车成功!"];
             }else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
    }else
    {
        [KeychainManager gotoLogin];
    }
    
}


#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{

    return NSStringFromClass([self class]);
}
@end
