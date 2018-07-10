//
//  ShoppingCarCell.m
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShoppingCarListCell.h"

@implementation ShoppingCarListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.leftBtn = [[UIButton alloc] init];
        [self.leftBtn setImage:[UIImage imageNamed:@"choose-off"] forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self.leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * sender) {
            self.leftBtn.selected = !sender.isSelected;
            
            if (self.bChooseHandle) {
                self.bChooseHandle(sender.isSelected);
            }
        }];
        
        [self addSubview:self.leftBtn];
        
        self.goodsImage = [[NetworkImageView alloc] init];
        self.goodsImage.image = [UIImage imageNamed:@"default_dishes"];
        self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.goodsImage];
        
        self.goodsTitle = [UnityLHClass masonryLabel:@"2017时尚杀手小号包" font:15.0 color:BM_BLACK];
        [self addSubview:self.goodsTitle];
        
        self.priceLB = [UnityLHClass masonryLabel:@"￥1699.0" font:14.0 color:[UIColor colorWithRed:0.99 green:0.6 blue:0.15 alpha:1]];
        [self addSubview:self.priceLB];
        
        //数量选择
        self.stepView = [LKStepView view];
        [self addSubview:self.stepView];
        
        //分割线
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [self addSubview:self.line];
        
        self.goodOriginalPrice=[UnityLHClass masonryLabel:@"" font:12.0 color:BM_GRAY];
        [self.contentView addSubview:self.goodOriginalPrice];
        self.goodOriginalPrice.hidden=YES;

        
        UIView *goodline=[[UIView alloc]init];
        goodline.backgroundColor=BM_GRAY;
        [self.goodOriginalPrice addSubview:goodline];
        [goodline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(self.goodOriginalPrice.mas_centerY);
        }];
        
    }
    return self;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(35);//.and.height
    }];
    
    [self.goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftBtn.mas_top);
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.centerY.mas_equalTo(self.leftBtn.mas_centerY);
        make.width.and.height.mas_equalTo(self.mas_height).multipliedBy(0.6);
    }];
    
    [self.goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImage.mas_top);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(10);
        make.height.offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(self.goodsTitle.mas_left);
        
    }];
    
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.priceLB.mas_bottom);
        make.width.offset(120);
        make.height.offset(25);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-0.7);
        make.height.offset(0.7);
    }];
    
    [self.goodOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLB.mas_bottom).offset(5);
        make.left.mas_equalTo(self.goodsTitle.mas_left);
    }];
    
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ChooseItem *)item{
    
    self.leftBtn.selected = item.isSelected;
    
    self.goodsTitle.text = item.item[@"goodsName"];
    self.stepView.value = item.count;
    [self.stepView.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)item.count] forState:UIControlStateNormal];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:item.item[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%.2f",[item.item[@"couponPrice"] floatValue]];
    self.goodOriginalPrice.text = [NSString stringWithFormat:@"￥%.2f",[item.item[@"salePrice"] floatValue]];
    if ([item.item[@"salePrice"] floatValue]==[item.item[@"couponPrice"] floatValue]||[item.item[@"salePrice"] floatValue]==0) {
        self.goodOriginalPrice.hidden=YES;
    }else{
        self.goodOriginalPrice.hidden=NO;
    }
}

- (void) configOneShopCellWithData:(ChooseItem *)item{
    
    self.leftBtn.selected = item.isSelected;
    self.goodsTitle.text = item.item[@"goodsName"];
    self.stepView.value = item.count;
    [self.stepView.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)item.count] forState:UIControlStateNormal];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:item.item[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%.2f",[item.item[@"marketPrice"] floatValue]];
  
}
- (void) configJDShopCellWithData:(ChooseItem *)item{
    
    self.leftBtn.selected = item.isSelected;
    self.goodsTitle.text = item.item[@"goodsName"];
    self.stepView.value = item.count;
    [self.stepView.valueButton setTitle:[NSString stringWithFormat:@"%ld",(long)item.count] forState:UIControlStateNormal];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:item.item[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%.2f",[item.item[@"zkPrice"] floatValue]];
    
}
+ (CGFloat)cellHeight{
    
    return 90;
}
@end
