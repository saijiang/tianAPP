//
//  JDShopListCell.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopListCell.h"

@implementation JDShopListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    JDShopListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JDShopListCell"];
    if (!cell)
    {
        cell=[[JDShopListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JDShopListCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.goodIcon=[[NetworkImageView alloc]init];
    self.goodIcon.image=[UIImage imageNamed:@" "];
    [self.contentView addSubview:self.goodIcon];
    [self.goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.goodIcon.mas_height);
    }];
    
    self.isBuy=[UnityLHClass masonryButton:@"库存不足" font:12.0 color:BM_WHITE];
    [self.goodIcon addSubview:self.isBuy];
    self.isBuy.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.3];
    [self.isBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        
    }];
    
    self.goodName=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    self.goodName.numberOfLines = 2;
    [self.contentView addSubview:self.goodName];
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.goodIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.goodIcon.mas_top);
    }];
    
    self.goodlog=[[LocalhostImageView alloc]init];
    self.goodlog.image=[UIImage imageNamed:@""];
    [self.contentView addSubview:self.goodlog];
    [self.goodlog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodName.mas_left);
        make.top.mas_equalTo(self.goodName.mas_bottom).offset(7);
        make.height.mas_equalTo(20);
    }];
    
    self.goodNum=[UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00]];
    [self.contentView addSubview:self.goodNum];
    [self.goodNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.goodIcon.mas_right).offset(10);

        //make.left.mas_equalTo(self.goodlog.mas_right).offset(3);
        make.centerY.mas_equalTo(self.goodlog.mas_centerY);
    }];
    
    self.goodPrice=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:1.00 green:0.59 blue:0.00 alpha:1.00]];
    [self.contentView addSubview:self.goodPrice];
    [self.goodPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(self.goodName.mas_left);
        make.bottom.mas_equalTo(self.goodIcon.mas_bottom);
    }];
    
    self.goodBuy=[UnityLHClass masonryButton:@"" imageStr:@"" font:13.0 color:BM_WHITE];
    [self.goodBuy setBackgroundImage:[UIImage imageNamed:@"Mall_gouwuche-2"] forState:UIControlStateNormal];
    [self.goodBuy addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.goodBuy setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.contentView addSubview:self.goodBuy];
    [self.goodBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(25, 20));
    }];
    
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
   [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.goodName.text = dataSource[@"name"];
    
   self.goodNum.text = [NSString stringWithFormat:@"商品编号：%@",dataSource[@"sku"]];
    self.goodPrice.text = [NSString stringWithFormat:@"￥%.2f",[dataSource[@"zkPrice"] floatValue]];
    if ([dataSource[@"stockState"] integerValue]==34||[dataSource[@"state"] integerValue]==0) {
        self.isBuy.hidden=NO;
        self.goodBuy.hidden=YES;
    }else{
        self.isBuy.hidden=YES;
        self.goodBuy.hidden=NO;
        
    }

}


-(void)addGoods
{
    if ([KeychainManager islogin])
    {
        [UserServices addGoodsInShopCarListWithGoodsId:self.data[@"sku"]
                                                userId:[KeychainManager readUserId]
                                            merchantId:nil
                                              goodsNum:@"1"
                                              cartType:@"03"
                                              userName:[KeychainManager readUserName]
                                           productType:nil
                                       completionBlock:^(int result, id responseObject)
         {
             if (result == 0)
             {
                 [UnityLHClass showHUDWithStringAndTime:@"添加购物车成功!"];
                 [self sendObject:@"reload"];
             }else
             {
                 //                 [self sendObject:@"查看详情"];
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
    }else
    {
        [KeychainManager gotoLogin];
    }
}

@end
