//
//  MyFoodOrderCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "MyFoodOrderCell.h"

@interface MyFoodOrderCell ()

@property (nonatomic ,strong) UILabel * orderNumberLabel;
@property (nonatomic ,strong) UILabel * orderDateLabel;
@property (nonatomic ,strong) UILabel * orderStatusLabel;

@property (nonatomic ,strong) LocalhostImageView * orderImageView;

@property (nonatomic ,strong) UILabel * orderNameLabel;
@property (nonatomic ,strong) UILabel * orderScheduleLabel;

@property (nonatomic ,strong) UILabel * oneFoodNameLabel;
@property (nonatomic ,strong) UILabel * oneFoodCountLabel;
@property (nonatomic ,strong) UILabel * twoFoodNameLabel;
@property (nonatomic ,strong) UILabel * twoFoodCountLabel;

@property (nonatomic ,strong) UILabel * orderPriceLabel;

@property (nonatomic ,strong) UIButton * leftButton;
@property (nonatomic ,strong) UIButton * rightButton;

@end
@implementation MyFoodOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_orderNumberLabel) {
            _orderNumberLabel = [UnityLHClass masonryLabel:@"订单号：1234463423" font:15 color:BM_Color_BlackColor];
            [self.contentView addSubview:_orderNumberLabel];
        }
        
        if (!_orderDateLabel) {
            _orderDateLabel = [UnityLHClass masonryLabel:@"2016/12/12 23:45:40" font:13 color:BM_Color_Placeholder];
            [self.contentView addSubview:_orderDateLabel];
        }
        
        if (!_orderStatusLabel) {
            _orderStatusLabel = [UnityLHClass masonryLabel:@"已完成" font:15 color:BM_Color_Blue];
            [self.contentView addSubview:_orderStatusLabel];
        }
        UIView * topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:topLineView];
        
        if (!_orderImageView) {
            _orderImageView = [[LocalhostImageView alloc] init];
            _orderImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_orderImageView];
        }
        if (!_orderNameLabel) {
            
            self.orderNameLabel = [UnityLHClass masonryLabel:@"董记黄焖鸡米饭" font:15 color:BM_Color_BlackColor];
            [self.contentView addSubview:self.orderNameLabel];
        }
        if (!_orderScheduleLabel) {
            _orderScheduleLabel = [UnityLHClass masonryLabel:@"2016/12/11 23:34 预定人数8人" font:13 color:BM_Color_Blue];
            [self.contentView addSubview:_orderScheduleLabel];
        }
        
        if (!_oneFoodNameLabel) {
            _oneFoodNameLabel = [UnityLHClass masonryLabel:@"黄焖鸡米饭黄焖鸡米饭黄焖鸡米饭黄焖鸡米饭黄焖鸡米饭" font:14 color:[UIColor colorWithHexString:@"#999999"]];
            [self.contentView addSubview:_oneFoodNameLabel];
        }
        if (!_oneFoodCountLabel) {
            _oneFoodCountLabel = [UnityLHClass masonryLabel:@"x3" font:14 color:[UIColor colorWithHexString:@"#999999"]];
            [self.contentView addSubview:_oneFoodCountLabel];
        }
        if (!_twoFoodNameLabel) {
            _twoFoodNameLabel = [UnityLHClass masonryLabel:@"米饭" font:14 color:[UIColor colorWithHexString:@"#999999"]];
            [self.contentView addSubview:_twoFoodNameLabel];
        }
        if (!_twoFoodCountLabel) {
            _twoFoodCountLabel = [UnityLHClass masonryLabel:@"x1" font:14 color:[UIColor colorWithHexString:@"#999999"]];
            [self.contentView addSubview:_twoFoodCountLabel];
        }
        
        UIView * bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:bottomLineView];
        
        if (!_orderPriceLabel) {
            _orderPriceLabel = [UnityLHClass masonryLabel:@"总价：￥123.00" font:14 color:BM_Color_BlackColor];
            [self.contentView addSubview:_orderPriceLabel];
        }
        
        
        if (!_leftButton) {
            _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
            _leftButton.layer.masksToBounds = YES;
            _leftButton.layer.cornerRadius = 5.0f;
            [_leftButton setTitle:@"去付款" forState:UIControlStateNormal];
            [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.contentView addSubview:_leftButton];
        }
        
        if (!_rightButton) {
            _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
            _rightButton.layer.masksToBounds = YES;
            _rightButton.layer.cornerRadius = 5.0f;
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.contentView addSubview:_rightButton];
        }
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_orderNumberLabel.mas_top);
        }];
        [_orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
        }];
        
        [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_orderNumberLabel.mas_left);
            make.top.mas_equalTo(_orderNumberLabel.mas_bottom).mas_offset(5);
        }];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.top.mas_equalTo(_orderDateLabel.mas_bottom).mas_offset(5);
        }];
        [_orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderNumberLabel.mas_left);
            make.top.mas_equalTo(topLineView.mas_bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        [_orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(_orderImageView.mas_top).mas_offset(5);
        }];
        
        [_orderScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_orderNameLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(_orderNameLabel.mas_left);
            make.right.mas_equalTo(_orderStatusLabel.mas_right);
            make.height.mas_equalTo(15);
        }];
        
        [_oneFoodCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_orderStatusLabel.mas_right);
            make.top.mas_equalTo(_oneFoodNameLabel.mas_top);
        }];
        
        [_twoFoodCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_orderStatusLabel.mas_right);
            make.top.mas_equalTo(_twoFoodNameLabel.mas_top);
        }];
        
        [_oneFoodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderNameLabel.mas_left);
            make.top.mas_equalTo(_orderScheduleLabel.mas_bottom).mas_equalTo(5);
            make.right.mas_lessThanOrEqualTo(_oneFoodCountLabel.mas_left).mas_offset(-10);
        }];
        
        [_twoFoodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_oneFoodNameLabel.mas_left);
            make.top.mas_equalTo(_oneFoodNameLabel.mas_bottom).mas_equalTo(5);
            make.right.mas_lessThanOrEqualTo(_twoFoodCountLabel.mas_left).mas_offset(-10);
        }];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderNumberLabel.mas_left);
            make.height.mas_equalTo(topLineView.mas_height);
            make.right.mas_equalTo(_orderStatusLabel.mas_right);
            make.top.mas_equalTo(_twoFoodNameLabel.mas_bottom).mas_offset(5);
        }];
        
        [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderNumberLabel.mas_left);
            make.centerY.mas_equalTo(_rightButton.mas_centerY);
        }];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomLineView).mas_offset(10);
//            make.right.mas_equalTo(_orderStatusLabel.mas_right);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_rightButton.mas_centerY);
            make.right.mas_equalTo(_rightButton.mas_left).mas_offset(-10);
            make.width.mas_equalTo(_rightButton.mas_width);
            make.height.mas_equalTo(_rightButton.mas_height);
        }];
    }
    return self;
}


+ (NSString *)cellIdentifier{

    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(FoodOrderStatusViewModel *)viewModel{

    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.data;
    
    if (viewModel.isTakeOut) {
        
        _orderScheduleLabel.hidden = YES;
        [_orderScheduleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        
        NSString * orderDate = [NSString stringWithFormat:@"%@ %@ 预定人数%@人",data[@"reserveDate"],data[@"reserveTime"],data[@"dinersNum"]];
        _orderScheduleLabel.text = orderDate;
        
        _orderScheduleLabel.hidden = NO;
        [_orderScheduleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
        }];
    }

    //
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",data[@"id"]];
    
    //
    self.orderDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"orderTime"]] stringformatterDate:@"YYYY/MM/dd HH:mm:ss"];
    
    //
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:data[@"restaurantImage"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    
    //
    self.orderNameLabel.text = data[@"restaurantName"];
    
    //
    //NSString * price = data[@"orderSum"];
    NSString * orderPrice = [NSString stringWithFormat:@"总价￥%.2f",[data[@"orderSum"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(2, orderPrice.length - 2)];
    self.orderPriceLabel.attributedText = attributedText;

    NSArray * temp = data[@"orderDishesList"];
    self.oneFoodCountLabel.hidden =
    self.oneFoodNameLabel.hidden = temp.count == 0;
    
    self.twoFoodNameLabel.hidden =
    self.twoFoodCountLabel.hidden = temp.count <= 1;
    
    if (temp.count > 0) {
     
        self.oneFoodNameLabel.text = temp[0][@"dishesName"];
        self.oneFoodCountLabel.text = [NSString stringWithFormat:@"x%@",temp[0][@"dishesNum"]];
     
        if (temp.count > 1) {
            self.twoFoodNameLabel.text = temp[1][@"dishesName"];
            self.twoFoodCountLabel.text = [NSString stringWithFormat:@"x%@",temp[1][@"dishesNum"]];
        }
    }
    
    
    [_rightButton removeHandlerForEvent:UIControlEventTouchUpInside];
    [_leftButton removeHandlerForEvent:UIControlEventTouchUpInside];
    
    {
        _orderStatusLabel.text = viewModel.orderStatus[@"title"];
        _orderStatusLabel.textColor = viewModel.orderStatus[@"color"];
    }
    
    {
        NSDictionary * rightHandle = viewModel.orderHandles[1];
        _rightButton.hidden = [rightHandle[@"hiden"] boolValue];
        [_rightButton setTitle:rightHandle[@"title"] forState:UIControlStateNormal];
        [_rightButton hll_setBackgroundImageWithColor:rightHandle[@"color"] forState:UIControlStateNormal];
        [_rightButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            [self sendObject:rightHandle[@"title"]];
        }];
        
        NSDictionary * leftHandle = viewModel.orderHandles[0];
        _leftButton.hidden = [leftHandle[@"hiden"] boolValue];
        [_leftButton setTitle:leftHandle[@"title"] forState:UIControlStateNormal];
        [_leftButton hll_setBackgroundImageWithColor:leftHandle[@"color"] forState:UIControlStateNormal];
        [_leftButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            [self sendObject:leftHandle[@"title"]];
        }];
    }
}

+ (CGFloat) cellHeightWithOrderType:(NSString *)orderType{

    if ([orderType isEqualToString:@"02"]) {
        return 190;
    }
    return 210;// 195
}


@end


