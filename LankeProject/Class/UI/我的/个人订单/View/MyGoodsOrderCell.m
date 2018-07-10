//
//  MyGoodsOrderCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyGoodsOrderCell.h"
#import "LKBottomButton.h"

@interface MyGoodsOrderCell ()

@property (nonatomic ,strong) UILabel * orderNumberLabel;
@property (nonatomic ,strong) UILabel * orderDateLabel;
@property (nonatomic ,strong) UILabel * orderStatusLabel;

@property (nonatomic ,strong) UIView * topLineView;

@property (nonatomic ,strong) UIView * goodsImageContentView;
@property (nonatomic ,strong) UIImageView * arrowImageView;

@property (nonatomic ,strong) UIView * bottomLineView;

@property (nonatomic ,strong) UILabel * orderPriceLabel;

@property (nonatomic ,strong) LKBottomButton * leftOrderHandleButton;
@property (nonatomic ,strong) LKBottomButton * rightOrderHandleButton;

@property (nonatomic ,strong) NetworkImageView * oneIconImageView;
@property (nonatomic ,strong) NetworkImageView * twoIconImageView;
@property (nonatomic ,strong) NetworkImageView * threeIconImageView;
@property (nonatomic ,strong) NetworkImageView * fourIconImageView;

@property (nonatomic ,strong) NSArray <NetworkImageView *>* iconImageViews;

@end

@implementation MyGoodsOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.orderNumberLabel = [UnityLHClass masonryLabel:@"订单号" font:15 color:BM_BLACK];
        [self.contentView addSubview:self.orderNumberLabel];
        
        self.orderDateLabel = [UnityLHClass masonryLabel:@"2017/1/1" font:13 color:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:self.orderDateLabel];
        
        self.orderStatusLabel = [UnityLHClass masonryLabel:@"已取消" font:15 color:BM_Color_Blue];
        [self.contentView addSubview:self.orderStatusLabel];
        
        self.topLineView = [UIView lineView];
        [self.contentView addSubview:self.topLineView];
        
        self.goodsImageContentView = [[UIView alloc] init];
        self.goodsImageContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.goodsImageContentView];
        
        self.arrowImageView = [[UIImageView alloc] init];
        self.arrowImageView.image = [[UIImage imageNamed:@"right_arrow"] tintedGradientImageWithColor:BM_Color_Blue];
        self.arrowImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.arrowImageView];
        
        self.bottomLineView = [UIView lineView];
        [self.contentView addSubview:self.bottomLineView];
        
        self.orderPriceLabel = [UnityLHClass masonryLabel:@"订单金额 ￥1213.00" font:14 color:BM_BLACK];
        [self.contentView addSubview:self.orderPriceLabel];
        
        self.leftOrderHandleButton = [LKBottomButton buttonForOrder];
        [self.contentView addSubview:self.leftOrderHandleButton];
        
        self.rightOrderHandleButton = [LKBottomButton buttonForOrder];
        [self.contentView addSubview:self.rightOrderHandleButton];
        
        self.oneIconImageView = [[NetworkImageView alloc] init];
        self.oneIconImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.goodsImageContentView addSubview:self.oneIconImageView];
        
        self.twoIconImageView = [[NetworkImageView alloc] init];
        self.twoIconImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.goodsImageContentView addSubview:self.twoIconImageView];
        
        self.threeIconImageView = [[NetworkImageView alloc] init];
        self.threeIconImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.goodsImageContentView addSubview:self.threeIconImageView];
        
        self.fourIconImageView = [[NetworkImageView alloc] init];
        self.fourIconImageView.image = [UIImage imageNamed:@"default_dishes"];
        [self.goodsImageContentView addSubview:self.fourIconImageView];
        
        self.iconImageViews = @[self.oneIconImageView,
                                self.twoIconImageView,
                                self.threeIconImageView,
                                self.fourIconImageView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    CGFloat iconImageMargin = 10;
    
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
    }];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.orderStatusLabel.mas_top);
        make.right.mas_lessThanOrEqualTo(self.orderStatusLabel.mas_left).mas_offset(-10);
    }];
    
    [self.orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.orderNumberLabel.mas_left);
        make.top.mas_equalTo(self.orderNumberLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.orderDateLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    NSInteger index = 0;
    for (UIView * view in self.iconImageViews) {
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(view.superview.mas_top);
            make.bottom.mas_equalTo(view.superview.mas_bottom);
            if (index == 0) {
                make.left.mas_equalTo(0);
            }else{
                UIView * frontView = self.iconImageViews[index - 1];
                make.left.mas_equalTo(frontView.mas_right).mas_offset(iconImageMargin);
            }
            make.width.mas_equalTo(view.mas_height);
        }];
        index ++;
    }
    
    [self.goodsImageContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.topLineView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.orderDateLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-30);
        // left: 15 right:30 width: DEF_WIDTH - left - right
        // iconImageViewHeight = (width - 3 * margin) / 4
        CGFloat width = DEF_SCREEN_WIDTH - 15 - 30;
        CGFloat x = (width - 3 * 10) / 4;
        make.height.mas_equalTo(x);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.goodsImageContentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(9, 15));
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_orderNumberLabel.mas_left);
        make.height.mas_equalTo(self.topLineView.mas_height);
        make.right.mas_equalTo(_orderStatusLabel.mas_right);
        make.top.mas_equalTo(self.goodsImageContentView.mas_bottom).mas_offset(10);
    }];
    
    [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_orderNumberLabel.mas_left);
        make.centerY.mas_equalTo(self.rightOrderHandleButton.mas_centerY);
    }];
    
    [self.rightOrderHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLineView).mas_offset(10);
        make.right.mas_equalTo(_orderStatusLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    [self.leftOrderHandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rightOrderHandleButton.mas_centerY);
        make.right.mas_equalTo(self.rightOrderHandleButton.mas_left).mas_offset(-10);
        make.width.mas_equalTo(self.rightOrderHandleButton.mas_width);
        make.height.mas_equalTo(self.rightOrderHandleButton.mas_height);
    }];
}

- (void) configIconImageWithList:(NSArray *)list{

    NSInteger index = 0;
    for (NetworkImageView * imageView in self.iconImageViews) {
        
        if (index < list.count) {
            
            NSDictionary * data = list[index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:data[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
        }
        
        imageView.hidden = index >= list.count;
        
        index ++;
    }
}

- (void) configOrderHandleWithHandleItems:(NSArray *)items{
    
    
    switch (items.count) {
        case 0:
        {
            
        }
            
            break;
        case 1:
        {
            GoodsOrderHandleItem * leftItem = items[0];
            
            self.rightOrderHandleButton.hidden = leftItem.hide;
            [self.rightOrderHandleButton setTitle:leftItem.handleTitle forState:UIControlStateNormal];
            self.rightOrderHandleButton.layer.borderColor = leftItem.handleBorderColor.CGColor;
            [self.rightOrderHandleButton hll_setBackgroundImageWithColor:leftItem.handleBackgroundColor forState:UIControlStateNormal];
            [self.rightOrderHandleButton setTitleColor:leftItem.handleTitleTextColor forState:UIControlStateNormal];
            
            [self.rightOrderHandleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                [self sendObject:leftItem.handleTitle];
            }];

        }
            
            break;
        case 2:
        {
            
            [self.rightOrderHandleButton removeHandlerForEvent:UIControlEventTouchUpInside];
            [self.leftOrderHandleButton removeHandlerForEvent:UIControlEventTouchUpInside];
            
            GoodsOrderHandleItem * rightItem = items[1];
            
            self.rightOrderHandleButton.hidden = rightItem.hide;
            [self.rightOrderHandleButton setTitle:rightItem.handleTitle forState:UIControlStateNormal];
            self.rightOrderHandleButton.layer.borderColor = rightItem.handleBorderColor.CGColor;
            [self.rightOrderHandleButton hll_setBackgroundImageWithColor:rightItem.handleBackgroundColor forState:UIControlStateNormal];
            [self.rightOrderHandleButton setTitleColor:rightItem.handleTitleTextColor forState:UIControlStateNormal];
            
            GoodsOrderHandleItem * leftItem = items[0];
            
            self.leftOrderHandleButton.hidden = leftItem.hide;
            [self.leftOrderHandleButton setTitle:leftItem.handleTitle forState:UIControlStateNormal];
            self.leftOrderHandleButton.layer.borderColor = leftItem.handleBorderColor.CGColor;
            [self.leftOrderHandleButton hll_setBackgroundImageWithColor:leftItem.handleBackgroundColor forState:UIControlStateNormal];
            [self.leftOrderHandleButton setTitleColor:leftItem.handleTitleTextColor forState:UIControlStateNormal];
            
            [self.rightOrderHandleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                [self sendObject:rightItem.handleTitle];
            }];
            
            [self.leftOrderHandleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                [self sendObject:leftItem.handleTitle];
            }];

        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configOneNumberShopCellWithData:(GoodsOrderStatusViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.orderData;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",data[@"orderCode"]];
    self.orderDateLabel.text = [data[@"orderCreateTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    self.orderStatusLabel.text = viewModel.orderStatus;
    self.orderStatusLabel.textColor = viewModel.orderStatusColor;
    
    NSString * orderPrice = [NSString stringWithFormat:@"订单金额￥%.2f",[data[@"orderAmount"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(4, orderPrice.length - 4)];
    self.orderPriceLabel.attributedText = attributedText;
    
    NSArray *list=data[@"picList"];
    NSInteger index = 0;
    for (NetworkImageView * imageView in self.iconImageViews) {
        
        if (index < list.count) {
            
            NSString * imageUrl = list[index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
        }
        
        imageView.hidden = index >= list.count;
        
        index ++;
    }
    
    self.leftOrderHandleButton.hidden =
    self.rightOrderHandleButton.hidden =!viewModel.hasOrderHandle;
    [self configOrderHandleWithHandleItems:viewModel.orderHandles];
}
//京东订单赋值
- (void) configJDShopCellWithData:(GoodsOrderStatusViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.orderData;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",data[@"jdOrderId"]];
    self.orderDateLabel.text=[UnityLHClass getCurrentTimeWithType:@"yyyy/MM/dd HH:mm" andTimeString:data[@"createDate"]];

    
    self.orderStatusLabel.text = viewModel.orderStatus;
    self.orderStatusLabel.textColor = viewModel.orderStatusColor;
    
    NSString * orderPrice = [NSString stringWithFormat:@"订单金额￥%.2f",[data[@"zkOrderPrice"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(4, orderPrice.length - 4)];
    self.orderPriceLabel.attributedText = attributedText;
    NSArray *list = data[@"zkJdOrderItemMapList"];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < list.count; i++)
    {
        [temp addObject:list[i][@"imagePath"]];
    }

    NSInteger index = 0;
    for (NetworkImageView * imageView in self.iconImageViews) {
        
        if (index < temp.count) {
            
            NSString * imageUrl = temp[index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
        }
        
        imageView.hidden = index >= temp.count;
        
        index ++;
    }
    
    self.leftOrderHandleButton.hidden =
    self.rightOrderHandleButton.hidden =!viewModel.hasOrderHandle;
    [self configOrderHandleWithHandleItems:viewModel.orderHandles];
}
- (void) configCellWithData:(GoodsOrderStatusViewModel *)viewModel{
    
    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.orderData;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",data[@"orderCode"]];
    self.orderDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"addTime"]] stringformatterDate:@"YYYY/MM/dd HH:mm:ss"];
    
    self.orderStatusLabel.text = viewModel.orderStatus;
    self.orderStatusLabel.textColor = viewModel.orderStatusColor;
    
    NSString * orderPrice = [NSString stringWithFormat:@"订单金额￥%.2f",[data[@"orderAmount"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(4, orderPrice.length - 4)];
    self.orderPriceLabel.attributedText = attributedText;
    
    [self configIconImageWithList:data[@"listGoods"]];
    
    self.leftOrderHandleButton.hidden =
    self.rightOrderHandleButton.hidden =!viewModel.hasOrderHandle;
    
    [self configOrderHandleWithHandleItems:viewModel.orderHandles];
}
- (void) configGroupCellWithData:(GoodsOrderStatusViewModel *)viewModel{
    
    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.orderData;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",data[@"orderCode"]];
    self.orderDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"addTime"]] stringformatterDate:@"YYYY/MM/dd HH:mm:ss"];
    
    self.orderStatusLabel.text = viewModel.orderStatus;
    self.orderStatusLabel.textColor = viewModel.orderStatusColor;
    
    NSString * orderPrice = [NSString stringWithFormat:@"订单金额￥%.2f",[data[@"orderAmount"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(4, orderPrice.length - 4)];
    self.orderPriceLabel.attributedText = attributedText;
    
    NSArray *list=@[data[@"goodsImageList"]];
    NSInteger index = 0;
    for (NetworkImageView * imageView in self.iconImageViews)
    {
        
        if (index < list.count)
        {
            NSString * data = list[index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
        }
        
        imageView.hidden = index >= list.count;
        index ++;
    }
    
    self.leftOrderHandleButton.hidden =
    self.rightOrderHandleButton.hidden =!viewModel.hasOrderHandle;
    
    [self configOrderHandleWithHandleItems:viewModel.orderHandles];
}

#pragma mark -- 售后申请cell赋值
- (void) configJDServiceCellWithData:(GoodsOrderStatusViewModel *)viewModel{
    
    self.viewModel = viewModel;
    
    NSDictionary * data = viewModel.orderData;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",data[@"orderCode"]];
    self.orderDateLabel.text = [[NSString stringWithFormat:@"%@",data[@"addTime"]] stringformatterDate:@"YYYY/MM/dd HH:mm:ss"];
    
    self.orderStatusLabel.text = viewModel.orderStatus;
    self.orderStatusLabel.textColor = viewModel.orderStatusColor;
    
    NSString * orderPrice = [NSString stringWithFormat:@"订单金额￥%.2f",[data[@"orderAmount"] floatValue]];
    NSDictionary * options = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFB478"],
                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [attributedText addAttributes:options
                            range:NSMakeRange(4, orderPrice.length - 4)];
    self.orderPriceLabel.attributedText = attributedText;
    
    [self configIconImageWithList:data[@"listGoods"]];
    
    self.leftOrderHandleButton.hidden =
    self.rightOrderHandleButton.hidden =!viewModel.hasOrderHandle;
    
    [self configOrderHandleWithHandleItems:viewModel.orderHandles];
}

+ (CGFloat)cellHeightWithData:(GoodsOrderStatusViewModel *)viewModel{

    return viewModel.cellHeight;
}

@end
