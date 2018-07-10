//
//  ShoppingCarCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ShoppingCarCell.h"
#import "HLLStepByStep.h"
#import "LKShoppingCarManager.h"

@interface ShoppingCarCell ()

@property (nonatomic ,strong) UILabel * nameLable;

@property (nonatomic ,strong) HLLStepByStep * countView;

@property (nonatomic ,strong) UILabel * priceLable;

@property (nonatomic ,strong) UIButton * deleteButton;

@end


@implementation ShoppingCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLable = [UnityLHClass masonryLabel:@"******" font:16 color:BM_Color_BlackColor];
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLable];
        
        LKWeakSelf
        self.countView = [[HLLStepByStep alloc] init];
        self.countView.limitStep=NO;
        self.countView.handle = ^(NSInteger current,BOOL add){
            LKStrongSelf
            if (_self.bCountChangeHandle) {
                _self.bCountChangeHandle(add);
            }
        };

        self.countView.backgroundColor = [UIColor whiteColor];
        self.countView.layer.cornerRadius = 5.0f;
        self.countView.layer.masksToBounds = YES;
        self.countView.layer.borderColor = BM_Color_Blue.CGColor;
        self.countView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        [self.contentView addSubview:self.countView];
        
        self.priceLable = [UnityLHClass masonryLabel:@"￥0.00" font:16 color:BM_Color_BlackColor];
        self.priceLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.priceLable];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.layer.masksToBounds = YES;
        [self.deleteButton addTarget:self action:@selector(deleteButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setImage:[UIImage imageNamed:@"shopping_delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    [self.countView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(self.countView.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.countView.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.deleteButton.mas_left).mas_offset(-5);
    }];
}

- (void) deleteButtonHandle:(UIButton *)button{

    if (self.bDeleteHandle) {
        self.bDeleteHandle();
    }
}

#pragma mark -
#pragma mark LKCellProtocol

- (void)configCellWithData:(LKGoodsItem *)item{

    CGFloat price = item.count * [item.goodsInfo[@"couponPrice"] floatValue];
    
    [self.countView configureMinCount:1 currentCount:item.count maxCount:MAXFLOAT];
    self.nameLable.text = [NSString stringWithFormat:@"%@",item.goodsInfo[@"dishesFoodName"]];
    self.priceLable.text = [NSString stringWithFormat:@"￥%.2f",price];
}

+ (NSString *)cellIdentifier{
    
    return @"ShoppingCarCell";
}

+ (CGFloat) cellHeight{
    
    return 60;
}

@end
