//
//  MallOrderConfirmSectionView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderConfirmSectionView.h"

@implementation MallOrderConfirmHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.shopContentView = [[UIView alloc] init];
        self.shopContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.shopContentView];
        
        self.iconImageView = [[LocalhostImageView alloc] init];
        self.iconImageView.image=[UIImage imageNamed:@"mall_shop"];
        [self.shopContentView addSubview:self.iconImageView];
        
        self.shopNameDisplayLabel = [UnityLHClass masonryLabel:@"商家3" font:15 color:BM_BLACK];
        [self.shopContentView addSubview:self.shopNameDisplayLabel];
        self.freeSendLable = [UnityLHClass masonryLabel:@"" font:15 color:BM_Color_huiColor];
        [self.shopContentView addSubview:self.freeSendLable];
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.shopContentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.shopContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [self.shopNameDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        //        make.width.mas_equalTo(80);
    }];
    
   
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.shopNameDisplayLabel.mas_centerY);
        make.width.and.height.mas_equalTo(15);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.shopContentView.mas_right);
        make.bottom.mas_equalTo(self.shopContentView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(id )data{
 
    self.shopNameDisplayLabel.text = data[@"merchantName"];

    if ([data[@"freeSendFlg"] floatValue]>0){
        self.freeSendLable.text = [NSString stringWithFormat:@"(满%@元免运费)",data[@"freeSendMoney"]];
        
        CGFloat bigwidth=[UnityLHClass getWidth:data[@"merchantName"] wid:20 font:15]+[UnityLHClass getWidth:[NSString stringWithFormat:@"(满%@元免运费)",data[@"freeSendMoney"]] wid:20 font:15]+50;
        if (bigwidth>DEF_SCREEN_WIDTH) {
            
            [self.freeSendLable mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(self.shopNameDisplayLabel.mas_left);
                make.top.mas_equalTo(self.shopNameDisplayLabel.mas_bottom);
                make.bottom.mas_equalTo(self.shopContentView.mas_bottom);
                //        make.width.mas_equalTo(80);
            }];
            [self.shopNameDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(40);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(20);
            }];
            
        }else{
            
            [self.freeSendLable mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(self.shopNameDisplayLabel.mas_right).mas_offset(10);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(20);

                //        make.width.mas_equalTo(80);
            }];
        }
        
    }else{
        self.freeSendLable.text =@"";
    }
   
}
+ (CGFloat) cellHeightWithData:(id)data{
    
   CGFloat bigwidth=[UnityLHClass getWidth:data[@"merchantName"] wid:20 font:15]+[UnityLHClass getWidth:[NSString stringWithFormat:@"(满%@元免运费)",data[@"freeSendMoney"]] wid:20 font:15]+50;
    if (bigwidth>DEF_SCREEN_WIDTH) {
        
        return 70;
        
    }else{
        
        return 50;
    }
    
}

@end


@implementation MallOrderConfirmFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.typeDisplayLabel = [UnityLHClass masonryLabel:@"配送方式" font:15 color:BM_BLACK];
        [self.contentView addSubview:self.typeDisplayLabel];
        
        self.typeButton = [RightImageButton buttonWithType:UIButtonTypeCustom];
        [self.typeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            if (self.bChooseTypeHandle) {
                self.bChooseTypeHandle();
            }
        }];
        [self.typeButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        self.typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.typeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.typeButton setTitleColor:BM_BLACK forState:UIControlStateNormal];
        self.typeButton.adjustsImageWhenHighlighted = NO;
        [self.typeButton setTitle:@"快递 免邮" forState:UIControlStateNormal];
        [self.contentView addSubview:self.typeButton];
        
        
        
     
        
        self.typeOneShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.typeOneShopButton.hidden=YES;
        [self.typeOneShopButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            if (self.bChooseTypeHandle) {
                self.bChooseTypeHandle();
            }
        }];
        self.typeOneShopButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.typeOneShopButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.typeOneShopButton setTitleColor:BM_BLACK forState:UIControlStateNormal];
        self.typeOneShopButton.adjustsImageWhenHighlighted = NO;
        [self.typeOneShopButton setTitle:@"" forState:UIControlStateNormal];
        [self.contentView addSubview:self.typeOneShopButton];

        
        
        
        
        
        self.topLineView = [UIView new];
        self.topLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.topLineView];
        self.jDInvoiceLabel = [UnityLHClass masonryLabel:@"发票" font:15 color:BM_BLACK];
        self.jDInvoiceLabel.hidden=YES;
        [self.contentView addSubview:self.jDInvoiceLabel];
        
        self.jDInvoiceBtn = [RightImageButton buttonWithType:UIButtonTypeCustom];
        self.jDInvoiceBtn.hidden=YES;
        [self.jDInvoiceBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            if (self.bChooseTypeHandle) {
                self.bChooseTypeHandle();
            }
        }];
        [self.jDInvoiceBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        self.jDInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.jDInvoiceBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.jDInvoiceBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
        self.jDInvoiceBtn.adjustsImageWhenHighlighted = NO;
        [self.jDInvoiceBtn setTitle:@"电子发票(明细-个人)" forState:UIControlStateNormal];
        [self.contentView addSubview:self.jDInvoiceBtn];
        
        self.jDBottmLineView = [UIView new];
        self.jDBottmLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.jDBottmLineView];
        
        self.messageDisplayLabel = [UnityLHClass masonryLabel:@"买家留言" font:15 color:BM_BLACK];
        [self.contentView addSubview:self.messageDisplayLabel];
        
        self.messageTextField = [[UITextField alloc] init];
        self.messageTextField.placeholder = @"选填:对本次交易的说明";
        self.messageTextField.textAlignment = NSTextAlignmentRight;
        self.messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.messageTextField.font = [UIFont systemFontOfSize:15];
        [self.messageTextField addTarget:self action:@selector(messageChangeHandle:) forControlEvents:UIControlEventEditingDidEnd];
        [self.contentView addSubview:self.messageTextField];
        
        self.bottmLineView = [UIView new];
        self.bottmLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.bottmLineView];
        
        self.priceLabel = [UnityLHClass masonryLabel:@"小计:2.00元" font:16 color:BM_BLACK];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat heiht = [MallOrderConfirmFooterView cellHeight];//self.contentView.frame.size.height;
    
    [self.typeDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.contentView.mas_top);
        //make.bottom.mas_equalTo(self.topLineView.mas_bottom);
        make.height.mas_equalTo(heiht/4);
        make.width.mas_equalTo(80);
    }];
    
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.left.mas_equalTo(self.typeDisplayLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeDisplayLabel.mas_centerY);
    }];
    
    [self.typeOneShopButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(self.typeDisplayLabel.mas_centerY);
    }];
    
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(heiht/4);
    }];
    
    [self.jDInvoiceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.topLineView.mas_bottom);
        //make.bottom.mas_equalTo(self.topLineView.mas_bottom);
        make.height.mas_equalTo(heiht/4);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.jDInvoiceBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.left.mas_equalTo(self.typeDisplayLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.jDInvoiceLabel.mas_centerY);
    }];
    
    [self.jDBottmLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(self.topLineView.mas_height);
        make.left.mas_equalTo(self.topLineView.mas_left);
        make.right.mas_equalTo(self.topLineView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-heiht/2);
    }];
    [self.messageDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.typeDisplayLabel.mas_left);
        make.bottom.mas_equalTo(self.bottmLineView.mas_bottom);
        make.width.mas_equalTo(self.typeDisplayLabel.mas_width);
        make.top.mas_equalTo(self.jDBottmLineView.mas_top);
    }];
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.messageDisplayLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(self.messageDisplayLabel.mas_height);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
        make.centerY.mas_equalTo(self.messageDisplayLabel.mas_centerY);
    }];
    
    [self.bottmLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(self.topLineView.mas_height);
        make.left.mas_equalTo(self.topLineView.mas_left);
        make.right.mas_equalTo(self.topLineView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-heiht/4);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(self.bottmLineView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(0);
    }];
}

- (void) messageChangeHandle:(UITextField *)textField{
    
    if (self.bMessageChangeHandle) {
    
        self.bMessageChangeHandle(textField.text);
    }
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(MallAssist *)assist{
    
   
    [self.typeButton setTitle:assist.type.deliveryContent forState:UIControlStateNormal];
    self.messageTextField.text = assist.message;
    self.priceLabel.text = [NSString stringWithFormat:@"小计：%.2f元",assist.price];
    self.typeButton.enabled = assist.enable;
    self.messageTextField.hidden =
    self.bottmLineView.hidden =
    self.messageDisplayLabel.hidden = !assist.enable;
}
- (void) configCellWithOneShopData:(MallAssist *)assist{
    
    self.typeOneShopButton.hidden=NO;
    self.typeButton.hidden=YES;
    self.typeDisplayLabel.text=@"快递配送";
    [self.typeOneShopButton setTitle:assist.type.deliveryContent forState:UIControlStateNormal];
    self.messageTextField.text = assist.message;
    self.priceLabel.text = [NSString stringWithFormat:@"小计：%.2f元",assist.price];
    self.typeOneShopButton.enabled = assist.enable;
    self.messageTextField.hidden =
    self.bottmLineView.hidden =
    self.messageDisplayLabel.hidden = !assist.enable;
}
- (void) configCellWithJDShopData:(MallAssist *)assist{
    
    self.jDBottmLineView.hidden=self.jDInvoiceLabel.hidden=self.jDInvoiceBtn.hidden=NO;
    self.typeOneShopButton.hidden=NO;
    self.typeButton.hidden=YES;
    self.typeDisplayLabel.text=@"配送方式";
    [self.typeOneShopButton setTitle:[NSString stringWithFormat:@"京东配送:配送费%.2f元", assist.expressPrice] forState:UIControlStateNormal];
//    self.typeDisplayLabel.hidden=YES;
   
    self.messageTextField.text = assist.message;
    self.priceLabel.text = [NSString stringWithFormat:@"小计：%.2f元",assist.price];
    self.typeOneShopButton.enabled = NO;
    self.messageTextField.hidden =
    self.bottmLineView.hidden =
    self.messageDisplayLabel.hidden = NO;
}

+ (CGFloat)cellHeight{

    return 160;
}

+ (CGFloat)cellHeightWithData:(MallAssist *)data{

    if (data.enable) {
        return 120;
    }
    return 80;
}
@end

@interface MallAssist ()

@property (nonatomic ,assign) CGFloat sum;
@property (readwrite) CGFloat expressPrice;
@end

@implementation MallAssist

+ (instancetype) assistCouponWith:(id)data{
    
    CGFloat sum = 0.0f;
    for (NSDictionary * goods in data[@"listGoods"]) {
        
        sum += ([goods[@"couponPrice"] floatValue] * [goods[@"goodsNum"] integerValue]);
    }
    
    DeliveryType * type = [DeliveryType deliveryWith:data];
    
    MallAssist * assist = [[MallAssist alloc] init];
    
   // assist.enable = !data[@"oneShop"];
    assist.enable =YES;
    assist.merchantId=data[@"merchantId"];
    assist.merchantName=data[@"merchantName"];
    assist.type = type;
    assist.message = @"";
    assist.expressPrice = 0;
    assist.sum = sum;
    assist.price = assist.sum + assist.expressPrice;
    if (assist.enable) {
        
        if ([data[@"freeSendFlg"] integerValue]==0) {
              [assist modifyDelieveryAtIndex:0];
        }else{
            
            if (assist.sum>=[data[@"freeSendMoney"] floatValue]) {
                
                [assist modifyDelieveryFreeAtIndex:0];
                
            }else{
                
                [assist modifyDelieveryAtIndex:0];
            }
        }
        
      
    }else{
        assist.type.deliveryContent = @"快递配送";
    }
    return assist;
}

+ (instancetype) assistWith:(id)data{
    
    CGFloat sum = 0.0f;
    for (NSDictionary * goods in data[@"listGoods"]) {
        
        sum += ([goods[@"marketPrice"] floatValue] * [goods[@"goodsNum"] integerValue]);
    }
    
    DeliveryType * type = [DeliveryType deliveryWith:data];
    
    MallAssist * assist = [[MallAssist alloc] init];
    
    //assist.enable = !data[@"oneShop"];
    assist.merchantId=data[@"merchantId"];
    assist.merchantName=data[@"merchantName"];
    assist.type = type;
    assist.message = @"";
    assist.expressPrice = 0;
    assist.sum = sum;
    assist.price = assist.sum + assist.expressPrice;
    if (assist.enable) {
        [assist modifyDelieveryAtIndex:0];
    }else{
        assist.type.deliveryContent = @"快递配送";
    }
    return assist;
}

- (void)modifyDelieveryAtIndex:(NSInteger)index{

    if ([self.type deliveryType].count!=0) {
        
        // 快递价格
        self.expressPrice = [[self.type deliveryType][index][@"price"] floatValue];
        // 快递方式内容
        self.type.deliveryContent = [self.type deliveryType][index][@"content"];
        // 快递-id
        self.type.shippingName = [self.type deliveryType][index][@"id"];
        
   }
 
    
    // 订单价格
    self.price = self.sum + self.expressPrice;

}
- (void)modifyDelieveryFreeAtIndex:(NSInteger)index{
    
    // 快递价格
    //self.expressPrice = [[self.type deliveryType][index][@"price"] floatValue];
    if ([self.type deliveryFreeType].count!=0) {
        // 快递方式内容
        self.type.deliveryContent = [self.type deliveryFreeType][index][@"content"];
        
        // 快递-id
        self.type.shippingName = [self.type deliveryFreeType][index][@"id"];
    }
    
    // 订单价格
    self.price = self.sum;
    
  
}
- (void)modifyExpressPriceForOneShop:(CGFloat)price{
    
    // 快递价格
    self.expressPrice = price;
    
    // 订单价格
    self.price = self.sum + self.expressPrice;
    
    // 快递方式内容
    self.type.deliveryContent = [NSString stringWithFormat:@"快递配送 快递费：%.2f元",price];
    
    // 快递-id
    self.type.shippingName = @"03";
}
- (void)modifyExpressPriceForJDShop:(CGFloat)price{
    
    // 快递价格
    self.expressPrice = price;
    
    // 订单价格
    self.price = self.sum + self.expressPrice;
    
    // 快递方式内容
    self.type.deliveryContent = [NSString stringWithFormat:@"快递配送 快递费：%.2f元",price];
    
    // 快递-id
    self.type.shippingName = @"03";
}

@end

@interface DeliveryType()

@property (nonatomic ,strong) id data;

@end

@implementation DeliveryType

/** 
 selfDeliveryFlg            客户自提标志 (0：否 ，1：是)
 merchantDeliveryFlg		自家配送 (0：否 ，1：是)
 expressDeliveryFlg         快递配送 (0：否 ，1：是)
 */
+ (instancetype)deliveryWith:(id)data{

    DeliveryType * type = [[DeliveryType alloc] init];
    type.data = data;
    type.deliveryContent = @"";
    type.shippingName = @"";
    return type;
}

- (NSArray *) deliveryType{

    NSMutableArray * temp = [NSMutableArray array];
    
    BOOL selfDeliveryFlg = [self.data[@"selfDeliveryFlg"] boolValue];
    BOOL merchantDeliveryFlg = [self.data[@"merchantDeliveryFlg"] boolValue];
    BOOL expressDeliveryFlg = [self.data[@"expressDeliveryFlg"] boolValue];
    
    
  
    if (merchantDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"商家配送:配送费 %@元",self.data[@"merchantDeliveryFee"]],
                                @"price":@([self.data[@"merchantDeliveryFee"] floatValue]),
                                @"id":@"02"};
        [temp addObject:data];
    }
    if (expressDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"快递配送:配送费 %@元",self.data[@"expressDeliveryFee"]],
                                @"price":@([self.data[@"expressDeliveryFee"] floatValue]),
                                @"id":@"03"};
        [temp addObject:data];
}
    if (selfDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"自提地址:%@",self.data[@"ownDeliveryAddress"]],
                                @"price":@(.0f),
                                @"id":@"01"};
        [temp addObject:data];
    }
   
    
    return temp;
}

- (NSArray *) deliveryFreeType{
    
    NSMutableArray * temp = [NSMutableArray array];
    
    BOOL selfDeliveryFlg = [self.data[@"selfDeliveryFlg"] boolValue];
    BOOL merchantDeliveryFlg = [self.data[@"merchantDeliveryFlg"] boolValue];
    BOOL expressDeliveryFlg = [self.data[@"expressDeliveryFlg"] boolValue];
  
    if (merchantDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"商家配送:(免配送费)"],
                                @"price":@"0",
                                @"id":@"02"};
        [temp addObject:data];
    }
    if (expressDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"快递配送:(免配送费)"],
                                @"price":@"0",
                                @"id":@"03"};
        [temp addObject:data];
    }
    if (selfDeliveryFlg) {
        
        NSDictionary * data = @{@"content":[NSString stringWithFormat:@"自提地址:%@",self.data[@"ownDeliveryAddress"]],
                                @"price":@(.0f),
                                @"id":@"01"};
        [temp addObject:data];
    }
    return temp;
}
- (NSArray *)deliverySegmentDatas{

    NSMutableArray * temp = [NSMutableArray array];
    
    BOOL selfDeliveryFlg = [self.data[@"selfDeliveryFlg"] boolValue];
    BOOL merchantDeliveryFlg = [self.data[@"merchantDeliveryFlg"] boolValue];
    BOOL expressDeliveryFlg = [self.data[@"expressDeliveryFlg"] boolValue];
  
    if (merchantDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"商家配送:配送费 %@元",self.data[@"merchantDeliveryFee"]]];
    }
    if (expressDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"快递配送:配送费 %@元",self.data[@"expressDeliveryFee"]]];
    }
    if (selfDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"自提地址:%@",self.data[@"ownDeliveryAddress"]]];
    }
    return temp;
}

- (NSArray *)deliveryFreeSegmentDatas{
    
    NSMutableArray * temp = [NSMutableArray array];
    
    BOOL selfDeliveryFlg = [self.data[@"selfDeliveryFlg"] boolValue];
    BOOL merchantDeliveryFlg = [self.data[@"merchantDeliveryFlg"] boolValue];
    BOOL expressDeliveryFlg = [self.data[@"expressDeliveryFlg"] boolValue];
   
    if (merchantDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"商家配送:(免配送费)"]];
    }
    if (expressDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"快递配送:(免配送费)"]];
    }
    if (selfDeliveryFlg) {
        [temp addObject:[NSString stringWithFormat:@"自提地址:%@",self.data[@"ownDeliveryAddress"]]];
    }
    return temp;
}
@end
