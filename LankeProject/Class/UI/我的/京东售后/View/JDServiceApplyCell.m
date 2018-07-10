//
//  JDServiceApplyCell.m
//  LankeProject
//
//  Created by fud on 2017/12/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceApplyCell.h"

@interface JDServiceApplyCell()



@property (nonatomic ,strong) LocalhostImageView * orderImageView;

@property (nonatomic ,strong) UILabel * orderNameLabel;

@property (nonatomic ,strong) UILabel * oneFoodNameLabel;


@property (nonatomic ,strong) UILabel * orderPriceLabel;

@property (nonatomic ,strong) UIButton * rightButton;

@end

@implementation JDServiceApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        UIView * topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:topLineView];
        
        if (!_orderImageView) {
            _orderImageView = [[LocalhostImageView alloc] init];
            _orderImageView.image = [UIImage imageNamed:@"default_dishes"];
            [self.contentView addSubview:_orderImageView];
        }
        if (!_orderNameLabel) {
            
            self.orderNameLabel = [UnityLHClass masonryLabel:@"" font:15 color:BM_Color_BlackColor];
            self.orderNameLabel.numberOfLines = 2;
            [self.contentView addSubview:self.orderNameLabel];
        }
        
        if (!_oneFoodNameLabel) {
            _oneFoodNameLabel = [UnityLHClass masonryLabel:@"" font:14 color:BM_Color_BlackColor];
            [self.contentView addSubview:_oneFoodNameLabel];
        }
        
        UIView * bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:bottomLineView];
        
        if (!_orderPriceLabel) {
            _orderPriceLabel = [UnityLHClass masonryLabel:@"该商品已超过售后期" font:14 color:BM_GRAY];
            [self.contentView addSubview:_orderPriceLabel];
        }
        
        
        
        if (!_rightButton) {
            _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
            _rightButton.layer.masksToBounds = YES;
            _rightButton.layer.cornerRadius = 5.0f;
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                [self sendObject:@"申请售后"];
            }];
            [self.contentView addSubview:_rightButton];
        }
        
        
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.top.mas_equalTo(0);
        }];
        [_orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(topLineView.mas_bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        [_orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(_orderImageView.mas_top).mas_offset(5);
            make.right.mas_equalTo(self.mas_right).offset(-10);
        }];
        
        
        
        [_oneFoodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_orderNameLabel.mas_left);
            make.bottom.mas_equalTo(_orderImageView.mas_bottom).offset(-5);
            make.right.mas_lessThanOrEqualTo(_orderNameLabel.mas_right);
        }];
        
        
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(topLineView.mas_height);
            make.right.mas_equalTo(_orderNameLabel.mas_right);
            make.top.mas_equalTo(_orderImageView.mas_bottom).mas_offset(10);
        }];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomLineView).mas_offset(10);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(_rightButton.mas_centerY);
            make.right.mas_equalTo(_rightButton.mas_left).offset(-10);
        }];
        
        
        
    }
    return self;
}


+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

#pragma mark --- 京东售后cell赋值
- (void) configJDServiceCellWithData:(id)data
{
    
    
    
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:data[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    
    
    //         0 不可售后 1可售后
    _rightButton.hidden = NO;
    if ([data[@"canAfterSellApply"] integerValue] == 1)
    {
        self.orderPriceLabel.hidden = YES;
        
        _rightButton.backgroundColor = BM_Color_Blue;
        _rightButton.enabled = YES;
        _rightButton.layer.borderWidth = 0.0;
        _rightButton.layer.borderColor = BM_Color_Blue.CGColor;
        [_rightButton setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [_rightButton setTitle:@"申请售后" forState:UIControlStateNormal];
        
    }
    else
    {
        self.orderPriceLabel.hidden = YES;
//        self.orderPriceLabel.text = @"该商品已超过售后期";
        _rightButton.enabled = NO;
        _rightButton.backgroundColor = BM_CLEAR;
        _rightButton.layer.borderWidth = 1.0;
        _rightButton.layer.borderColor = BM_Color_LineColor.CGColor;
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//             售后状态 01未完成 02已完成 03已取消
        if ([data[@"afterSellApplyState"] integerValue] == 1)
        {
            [_rightButton setTitle:@"售后申请中" forState:UIControlStateNormal];
        }
        else if ([data[@"afterSellApplyState"] integerValue] == 2)
        {
            [_rightButton setTitle:@"售后已完成" forState:UIControlStateNormal];
        }
        else if ([data[@"afterSellApplyState"] integerValue] == 3)
        {
            [_rightButton setTitle:@"售后已取消" forState:UIControlStateNormal];
        }
        else
        {
          //  [_rightButton setTitle:@"申请售后" forState:UIControlStateNormal];
            _rightButton.hidden=YES;
        }
        
    }
    
    self.orderNameLabel.text = data[@"name"];
    self.oneFoodNameLabel.text = [NSString stringWithFormat:@"数量：%ld",[data[@"num"] integerValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




@implementation JDServiceApplyHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH);
            make.height.mas_equalTo(10);
        }];
       
        
        if (!_orderNumberLabel) {
            _orderNumberLabel = [UnityLHClass masonryLabel:@"订单号：" font:15 color:BM_Color_BlackColor];
            [self addSubview:_orderNumberLabel];
        }
        
        if (!_orderDateLabel) {
//            2016/12/12 23:45:40
            _orderDateLabel = [UnityLHClass masonryLabel:@"" font:13 color:BM_Color_Placeholder];
            [self addSubview:_orderDateLabel];
        }
        
        [_orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(bgView.mas_bottom).offset(10);
        }];
        
        [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_orderNumberLabel.mas_left);
            make.top.mas_equalTo(_orderNumberLabel.mas_bottom).mas_offset(5);
        }];
    }
    return self;
}

-(void)configJDServiceApplyHeaderViewWithData:(id)data
{
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",data[@"jdOrderId"]];
    
    self.orderDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"createDate"]] stringformatterDate:@"YYYY/MM/dd HH:mm:ss"];
}

@end
