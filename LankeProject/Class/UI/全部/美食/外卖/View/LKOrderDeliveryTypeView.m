//
//  LKOrderDeliveryTypeView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKOrderDeliveryTypeView.h"

#define kMarginWithLineView 45

@interface LKOrderDeliveryTypeView ()


@property (nonatomic ,strong) UIButton * typeOfSelfButton;

@property (nonatomic ,strong) UILabel * currentAddressLabel;

@property (nonatomic ,strong) UILabel * pickAddressNameLabel;
@property (nonatomic ,strong) UILabel * pickAddressPhoneNumberLabel;
@property (nonatomic ,strong) UILabel * pickAddressLabel;

@property (nonatomic ,strong) UILabel * defaultPickAddressLabel;



@property (nonatomic ,strong) LocalhostImageView * arrowImageView;

@end

@implementation LKOrderDeliveryTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.typeOfSelfTake = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UnityLHClass masonryLabel:@"送货方式" font:17 color:BM_Color_BlackColor];
        
        [self addSubview:_titleLabel];
        _titleLabelTwo = [UnityLHClass masonryLabel:@"(免运费)" font:17 color:BM_RED];
        _titleLabelTwo.hidden=YES;
        [self addSubview:_titleLabelTwo];
        
        _typeOfSelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeOfSelfButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_typeOfSelfButton setTitle:@"  自提" forState:UIControlStateNormal];
        _typeOfSelfButton.selected = YES;
        [_typeOfSelfButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
        [_typeOfSelfButton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [_typeOfSelfButton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [_typeOfSelfButton addTarget:self action:@selector(selfTypeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_typeOfSelfButton];
        
        
        
        _typeOfHomeDeliveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeOfHomeDeliveryButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_typeOfHomeDeliveryButton setTitle:@"  送货上门" forState:UIControlStateNormal];
            [_typeOfHomeDeliveryButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];

        [_typeOfHomeDeliveryButton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [_typeOfHomeDeliveryButton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [_typeOfHomeDeliveryButton addTarget:self action:@selector(homeDeliveryTypeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_typeOfHomeDeliveryButton];
        
        _currentAddressLabel = [UnityLHClass masonryLabel:@"上海市虹口区广济路838号" font:15 color:BM_Color_BlackColor];
        _currentAddressLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_currentAddressLabel];
        
        _displayLabel = [UnityLHClass masonryLabel:@"送餐费" font:15 color:BM_Color_BlackColor];
        [self addSubview:_displayLabel];
        
        _orderPriceLabel = [UnityLHClass masonryLabel:@"5元" font:15 color:BM_Color_BlackColor];
        [self addSubview:_orderPriceLabel];
        
        _pickAddressNameLabel = [UnityLHClass masonryLabel:@"何方" font:13 color:BM_Color_BlackColor];
        [self addSubview:_pickAddressNameLabel];
        
        _pickAddressPhoneNumberLabel = [UnityLHClass masonryLabel:@"158686958578" font:13 color:BM_Color_BlackColor];
        [self addSubview:_pickAddressPhoneNumberLabel];
        
        _pickAddressLabel = [UnityLHClass masonryLabel:@"上海市宝山区人民路78号" font:13 color:BM_Color_BlackColor];
        [self addSubview:_pickAddressLabel];
        
        _defaultPickAddressLabel = [UnityLHClass masonryLabel:@"请选择地址" font:13 color:BM_Color_BlackColor];
        _defaultPickAddressLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_defaultPickAddressLabel];
        
        _arrowImageView = [[LocalhostImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self addSubview:_arrowImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
        
        
        self.shadowView=[[UIView alloc]init];
        self.shadowView.backgroundColor=BM_GRAY;
        self.shadowView.alpha=0.2;
        self.shadowView.userInteractionEnabled=NO;
        [self addSubview:self.shadowView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kMarginWithLineView);
    }];
    [_titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_titleLabel.mas_right).mas_offset(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kMarginWithLineView);
    }];
    
    [_currentAddressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.height.mas_equalTo(_titleLabel.mas_height);
        make.left.mas_equalTo(80);
    }];
    
    [_typeOfSelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(_titleLabel.mas_height);
    }];
    [_typeOfHomeDeliveryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_typeOfSelfButton.mas_left);
        make.top.mas_equalTo(_typeOfSelfButton.mas_bottom);
        make.height.mas_equalTo(_typeOfSelfButton.mas_height);
    }];
    
    [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_currentAddressLabel.mas_bottom);
        make.right.mas_equalTo(_currentAddressLabel.mas_right);
        make.height.mas_equalTo(_titleLabel);
    }];
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_orderPriceLabel.mas_left).mas_offset(-5);
        make.top.mas_equalTo(_orderPriceLabel.mas_top);
        make.height.mas_equalTo(_orderPriceLabel.mas_height);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(_currentAddressLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
        make.centerY.mas_equalTo(_pickAddressLabel.mas_centerY).mas_offset(-15);
    }];
    [_pickAddressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_typeOfHomeDeliveryButton.mas_bottom);
    }];
    [_pickAddressPhoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_pickAddressNameLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(_pickAddressNameLabel.mas_top);
        make.height.mas_equalTo(_pickAddressNameLabel.mas_height);
        make.right.mas_lessThanOrEqualTo(_arrowImageView.mas_left).mas_offset(-5);
    }];
    [_pickAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_pickAddressNameLabel.mas_left);
        make.top.mas_equalTo(_pickAddressNameLabel.mas_bottom);
        make.height.mas_equalTo(_pickAddressNameLabel.mas_height);
        make.right.mas_equalTo(self.arrowImageView.mas_left).mas_offset(-10);
    }];
    
    [_defaultPickAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_typeOfHomeDeliveryButton.mas_bottom);
        make.left.mas_equalTo(_pickAddressLabel.mas_left);
        make.right.mas_equalTo(_arrowImageView.mas_left);
        make.bottom.mas_equalTo(_pickAddressLabel.mas_bottom);
    }];
    
    [  self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(92);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat margin_h = 20;

    CGPoint startPoint_h_1 = CGPointMake(0, kMarginWithLineView);
    CGPoint stopPoint_h_1 = CGPointMake(CGRectGetWidth(rect),kMarginWithLineView);
    
    CGPoint startPoint_h_2 = CGPointMake(margin_h, kMarginWithLineView * 2);
    CGPoint stopPoint_h_2 = CGPointMake(CGRectGetWidth(rect) - margin_h,kMarginWithLineView * 2);
    
    hll_Order_drawLineWithContext(context, startPoint_h_1, stopPoint_h_1);
    hll_Order_drawLineWithContext(context, startPoint_h_2, stopPoint_h_2);
}

void hll_Order_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    CGContextStrokePath(context);
};

- (void) tapHandle:(UITapGestureRecognizer *)tap{
    
    
    
    CGPoint point = [tap locationInView:tap.view];
    
    CGFloat top = 3 * kMarginWithLineView;
    
    CGRect rect = CGRectMake(0, top, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - top);
    if (CGRectContainsPoint(rect, point)) {
        
        if (self.bOrderDeliveryTypeChooseAddressHandle) {
            self.bOrderDeliveryTypeChooseAddressHandle();
            
            
        }
    }
}


#pragma mark -
#pragma mark API

-(void) configDeliveyTypeForGroupBuyWithData:(id)data{

    self.orderPriceLabel.text = [NSString stringWithFormat:@"%@元",data[@"expressDeliveryFee"]];
    self.currentAddressLabel.text = [NSString stringWithFormat:@"%@",data[@"ownDeliveryAddress"]];
}

-(void) configDeliveyTypeWithData:(id)data{
    
    self.orderPriceLabel.text = [NSString stringWithFormat:@"%@元",data[@"takeOutFee"]];
    self.currentAddressLabel.text = [NSString stringWithFormat:@"%@",data[@"takeOutAddress"]];
}

- (void) updateAddressInfoWithData:(id)data{

    self.pickAddressNameLabel.text = [NSString stringWithFormat:@"%@",data[@"receiveName"]];
    self.pickAddressPhoneNumberLabel.text = [NSString stringWithFormat:@"%@",data[@"receivePhone"]];
    self.pickAddressLabel.text = [NSString stringWithFormat:@"%@ %@",data[@"areaInfo"],data[@"detailedAddress"]];
    self.addressId = data[@"id"];

    self.defaultPickAddressLabel.hidden = data[@"id"];
}

#pragma mark -
#pragma mark Action M

- (void) selfTypeButtonHandle:(UIButton *)button{
    
    self.typeOfSelfButton.selected = YES;
    self.typeOfHomeDeliveryButton.selected = NO;
    
    self.typeOfSelfTake = YES;
    
    if (self.bOrderDeliveryTypeChooseTypeHandle) {
        self.bOrderDeliveryTypeChooseTypeHandle(YES);
    }
}

- (void) homeDeliveryTypeButtonHandle:(UIButton *)button{
    
    self.typeOfSelfButton.selected = NO;
    self.typeOfHomeDeliveryButton.selected = YES;
    
    self.typeOfSelfTake = NO;
    
    if (self.bOrderDeliveryTypeChooseTypeHandle) {
        self.bOrderDeliveryTypeChooseTypeHandle(NO);
    }
}
@end
