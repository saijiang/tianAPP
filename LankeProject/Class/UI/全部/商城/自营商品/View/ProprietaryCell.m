//
//  ProprietaryCell.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ProprietaryCell.h"

@implementation ProprietaryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ProprietaryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProprietaryCell"];
    if (!cell)
    {
        cell=[[ProprietaryCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProprietaryCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.goodIcon=[[NetworkImageView alloc]init];
    self.goodIcon.image=[UIImage imageNamed:@"default_dishes"];
    [self.contentView addSubview:self.goodIcon];
    [self.goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.goodIcon.mas_height);
    }];
    
    self.goodName=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    self.goodName.numberOfLines=1;
    [self.contentView addSubview:self.goodName];
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.goodIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.goodIcon.mas_top);
    }];
    
    self.goodlog=[UnityLHClass masonryButton:@"  " font:13.0 color:[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00]];

    [self.contentView addSubview:self.goodlog];
    self.goodlog.layer.masksToBounds=YES;
    self.goodlog.layer.cornerRadius=5;
    self.goodlog.layer.borderWidth=1;
    self.goodlog.layer.borderColor=[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00].CGColor;
    [self.goodlog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodName.mas_left);
        make.top.mas_equalTo(self.goodName.mas_bottom).offset(7);
        make.height.mas_equalTo(20);
    }];
    
    
    self.goodPrice=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:1.00 green:0.59 blue:0.00 alpha:1.00]];
    [self.contentView addSubview:self.goodPrice];
    [self.goodPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodName.mas_left);
        make.bottom.mas_equalTo(self.goodIcon.mas_bottom);
    }];
    
    self.goodOriginalPrice=[UnityLHClass masonryLabel:@"" font:12.0 color:BM_GRAY];
    [self.contentView addSubview:self.goodOriginalPrice];
    [self.goodOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodPrice.mas_right).offset(5);
        make.centerY.mas_equalTo(self.goodPrice.mas_centerY);
    }];
    
    UIView *goodline=[[UIView alloc]init];
    goodline.backgroundColor=BM_GRAY;
    [self.goodOriginalPrice addSubview:goodline];
    [goodline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.goodOriginalPrice.mas_centerY);
    }];

    
    self.goodBuy=[UnityLHClass masonryButton:@"" imageStr:@"Mall_gouwuche-2" font:13.0 color:BM_WHITE];
    [self.contentView addSubview:self.goodBuy];
    [self.goodBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.goodBuy addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.data=dataSource;
    [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.goodName.text=dataSource[@"goodsName"];
    self.goodPrice.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"couponPrice"] floatValue]];
    self.goodOriginalPrice.text=[NSString stringWithFormat:@"%.2f",[dataSource[@"salePrice"] floatValue]];
    if ([dataSource[@"couponPrice"] floatValue]==[dataSource[@"salePrice"] floatValue]) {
        self.goodOriginalPrice.hidden=YES;
    }else{
        self.goodOriginalPrice.hidden=NO;

    }
    CGFloat with=[UnityLHClass getWidth:dataSource[@"merchantName"] wid:20 font:13];
    [self.goodlog setTitle:dataSource[@"merchantName"] forState:UIControlStateNormal];
    [self.goodlog mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(with+20);
    }];
  
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

@end
