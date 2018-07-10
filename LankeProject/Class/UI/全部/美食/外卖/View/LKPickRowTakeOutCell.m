//
//  LKPickRowTakeOutCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKPickRowTakeOutCell.h"

@implementation LKXXXXXSection

+ (instancetype)section:(id)data{

    LKXXXXXSection * section = [[LKXXXXXSection alloc] init];
    section.data = data;
    section.name = data[@"dishesName"];
    
    NSMutableArray * items = [NSMutableArray array];
    for (NSDictionary * itemData in data[@"dishes"]) {
        
        LKXXXXXItem * item = [LKXXXXXItem item:itemData];
        [items addObject:item];
    }
    section.items = items;
    return section;
}

@end
@implementation LKXXXXXItem

+ (instancetype) item:(id)data{

//    dishesPrice 	String 	菜品价格
//    couponPrice 	String 	菜品优惠过的价格
    
    LKXXXXXItem * item = [[LKXXXXXItem alloc] init];
    item.data = data;
    item.image = [NSURL URLWithString:data[@"dishesImageList"]];
    item.name = [NSString stringWithFormat:@"%@",data[@"dishesFoodName"]];
    item.price = [NSString stringWithFormat:@"￥ %.2f",[data[@"couponPrice"] floatValue]];
    item.couponPrice = [NSString stringWithFormat:@"%.2f",[data[@"dishesPrice"] floatValue]];
    item.count = [data[@"dishesNum"] integerValue];
    item.displayMinus = item.count > 0;
    return item;
}

@end
@interface LKPickRowTakeOutCell ()

@property (nonatomic ,strong) LocalhostImageView * dishesImageView;

@property (nonatomic ,strong) UILabel * dishesNameLabel;

@property (nonatomic ,strong) UILabel * dishesPriceLabel;

@property (nonatomic ,strong) UILabel * dishesCouponPriceLabel;

@property (nonatomic ,strong) UIView * dishesCouponPricelineView;

@property (nonatomic ,strong) UIView * lineView;
@end

@implementation LKPickRowTakeOutCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_dishesImageView) {
            _dishesImageView = [[LocalhostImageView alloc] init];
            _dishesImageView.contentMode = UIViewContentModeScaleAspectFill;
            _dishesImageView.layer.cornerRadius = 5.0f;
            _dishesImageView.layer.masksToBounds = YES;
            _dishesImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_dishesImageView];
            
        }
        if (!_buyButton) {
            _buyButton = [UnityLHClass masonryButton:nil imageStr:@"pick_to_shopping_car" font:13 color:BM_Color_Blue];
            [_buyButton addTarget:self action:@selector(buyButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            _buyButton.hidden = YES;
            [self.contentView addSubview:_buyButton];
            
        }
        if (!_dishesNameLabel) {
            _dishesNameLabel = [UnityLHClass masonryLabel:@"*****" font:14 color:[UIColor colorWithHexString:@"#333333"]];
            _dishesNameLabel.numberOfLines = 1;
            _dishesNameLabel.textAlignment = NSTextAlignmentLeft;
            _dishesNameLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_dishesNameLabel];
        }
        
        if (!_dishesPriceLabel) {
            _dishesPriceLabel = [UnityLHClass masonryLabel:@"$ 0.00" font:16 color:[UIColor colorWithHexString:@"#FF9525"]];
            _dishesPriceLabel.textAlignment = NSTextAlignmentLeft;
            _dishesPriceLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_dishesPriceLabel];
        }
        if (!_dishesCouponPriceLabel) {
            _dishesCouponPriceLabel = [UnityLHClass masonryLabel:@"0.00" font:12 color:BM_GRAY];
            _dishesCouponPriceLabel.textAlignment = NSTextAlignmentLeft;
            _dishesCouponPriceLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_dishesCouponPriceLabel];
        }
        if (!_dishesCouponPricelineView) {
            _dishesCouponPricelineView = [UIView new];
            _dishesCouponPricelineView.backgroundColor = BM_GRAY;
            [_dishesCouponPriceLabel addSubview:_dishesCouponPricelineView];
        }
        if (!_lineView) {
            _lineView = [UIView new];
            _lineView.backgroundColor = BM_Color_SeparatorColor;
            [self.contentView addSubview:_lineView];
        }
        
        _minusButton = [UnityLHClass masonryButton:nil imageStr:@"food_minus" font:0 color:nil];
        [_minusButton addTarget:self action:@selector(minusButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_minusButton];
        [_minusButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        
        _countButton = [UnityLHClass masonryButton:@"2" imageStr:nil font:17 color:[UIColor grayColor]];
        //[_countButton addTarget:self action:@selector(addButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_countButton];
        
        _addButton = [UnityLHClass masonryButton:nil imageStr:@"food_add" font:0 color:nil];
        [_addButton addTarget:self action:@selector(addButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
        [_addButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];

        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    [_dishesImageView mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 10;
        make.top.mas_equalTo(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-margin);
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(_dishesImageView.mas_height);
    }];
    
    [_dishesNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_dishesImageView.mas_top).mas_offset(5);
        make.left.mas_equalTo(_dishesImageView.mas_right).mas_offset(10);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [_dishesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_dishesImageView).mas_offset(-35);
        make.left.mas_equalTo(_dishesNameLabel.mas_left);
        make.right.mas_lessThanOrEqualTo(_buyButton.mas_left).mas_offset(-10);
    }];
    
    [_dishesCouponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_dishesPriceLabel.mas_centerY);
        make.left.mas_equalTo(_dishesPriceLabel.mas_right).offset(5);
    }];
    [_dishesCouponPricelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_dishesCouponPriceLabel.mas_centerY);
        make.width.mas_equalTo(_dishesCouponPriceLabel.mas_width);
        make.centerX.mas_equalTo(_dishesCouponPriceLabel.mas_centerX);
        make.height.mas_equalTo(1.0);
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(self.dishesImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.countButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.addButton.mas_left);
        make.width.mas_equalTo(self.addButton.mas_width);
        make.height.mas_equalTo(self.addButton.mas_height);
        make.bottom.mas_equalTo(self.addButton.mas_bottom);
    }];
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.countButton.mas_left);
        make.width.mas_equalTo(self.addButton.mas_width);
        make.height.mas_equalTo(self.addButton.mas_height);
        make.bottom.mas_equalTo(self.addButton.mas_bottom);
    }];
}


#pragma mark -
#pragma mark Action M

- (void) buyButtonDidPress:(UIButton *)button{

    if (self.bBuyDishesHandle) {
        self.bBuyDishesHandle(self);
    }
}

- (void) minusButtonDidPress:(UIButton *)button{

//    _item.count --;
    if (_item.count<1) {
        return;
    }
    if (self.bMinusDishesHandle) {
        self.bMinusDishesHandle(self);
    }
}

- (void) addButtonDidPress:(UIButton *)button{

    //_item.count ++;
    
    if (self.bBuyDishesHandle) {
        self.bBuyDishesHandle(self);
    }
}


#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"LKPickRowTakeOutCell";
}

- (void) configCellWithData_:(LKXXXXXItem *)item{

    _item = item;
    NSDictionary *data=item.data;
    [self.dishesImageView sd_setImageWithURL:_item.image placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.dishesNameLabel.text = _item.name;
    self.dishesPriceLabel.text = _item.price;
    self.dishesCouponPriceLabel.text = _item.couponPrice;
    if ([data[@"couponPrice"] floatValue]==[data[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }
    self.minusButton.hidden =
    self.countButton.hidden = _item.count <= 0;
    
    [self.countButton setTitle:[NSString stringWithFormat:@"%@",@(_item.count)] forState:UIControlStateNormal];
}

- (void) configCellWithData:(id)data{
   
    [self.dishesImageView sd_setImageWithURL:[NSURL URLWithString:data[@"dishesImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.dishesNameLabel.text = [NSString stringWithFormat:@"%@",data[@"dishesFoodName"]];
    self.dishesPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[data[@"dishesPrice"] floatValue]];
    if ([data[@"couponPrice"] floatValue]==[data[@"dishesPrice"] floatValue]) {
        self.dishesCouponPriceLabel.hidden=YES;
    }else{
        self.dishesCouponPriceLabel.hidden=NO;
    }
    
    self.minusButton.hidden =
    self.countButton.hidden = ![data[@"dishesNum"] boolValue];
    
    [self.countButton setTitle:[NSString stringWithFormat:@"%@",data[@"dishesNum"]] forState:UIControlStateNormal];
}

@end
