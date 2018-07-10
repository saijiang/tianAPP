//
//  AfterSalesOrderCell.m
//  LankeProject
//
//  Created by itman on 17/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "AfterSalesOrderCell.h"

@implementation AfterSalesOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AfterSalesOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AfterSalesOrderCell"];
    if (!cell)
    {
        cell=[[AfterSalesOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AfterSalesOrderCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)createCell
{
    
    self.backgroundColor=BM_WHITE;
    LocalhostImageView *leftImage=[[LocalhostImageView alloc]init];
    leftImage.image=[UIImage imageNamed:@"mall_shop"];
    [self.contentView addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(15);
        make.width.and.height.mas_equalTo(15);
    }];
    
    self.merchantName=[UnityLHClass masonryLabel:@"成品果业" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.merchantName];
    [self.merchantName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftImage.mas_centerY);
        make.right.mas_equalTo(-100);
        make.left.mas_equalTo(leftImage.mas_right).offset(10);

    }];
    
    self.returnState=[UnityLHClass masonryLabel:@"退款完成" font:15.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.returnState];
    [self.returnState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftImage.mas_centerY);
        make.right.mas_equalTo(-5);
        
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftImage.mas_bottom).offset(15);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.order=[UnityLHClass masonryLabel:@"退货号：356625168415664" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.order];
    [self.order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(15);
        make.left.mas_equalTo(leftImage.mas_left);
    }];
    
    self.deleteOrder=[UnityLHClass masonryButton:@"  删除订单  " font:16.0 color:BM_WHITE];
    self.deleteOrder.backgroundColor=[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    self.deleteOrder.layer.masksToBounds=YES;
    self.deleteOrder.layer.cornerRadius=5;
    [self.contentView addSubview:self.deleteOrder];
    [self.deleteOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.returnState.mas_right);
        make.height.mas_equalTo(35);
    }];
    [self.deleteOrder handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self sendObject:self.deleteOrder.titleLabel.text];
     
    }];
    
    self.deleteTwoOrder=[UnityLHClass masonryButton:@"  填写快递单号  " font:16.0 color:BM_WHITE];
    self.deleteTwoOrder.backgroundColor=[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    self.deleteTwoOrder.layer.masksToBounds=YES;
    self.deleteTwoOrder.layer.cornerRadius=5;
    [self.contentView addSubview:self.deleteTwoOrder];
    [self.deleteTwoOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.deleteOrder.mas_left).offset(-15);
        make.height.mas_equalTo(35);
    }];
    [self.deleteTwoOrder handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self sendObject:self.deleteTwoOrder.titleLabel.text];
        
    }];

    
    UIView *goodView=[[UIView alloc]init];
    goodView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:goodView];
    [goodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.order.mas_bottom).offset(15);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    self.goodsImage=[[NetworkImageView alloc]init];
    self.goodsImage.image=[UIImage imageNamed:@"default_dishes"];
    self.goodsImage.backgroundColor=BM_WHITE;
    [goodView addSubview:self.goodsImage];
    [self.goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(self.goodsImage.mas_height);
    }];
    
    self.goodsName=[UnityLHClass masonryLabel:@"范思哲黑水晶之美" font:16.0 color:BM_BLACK];
    [goodView addSubview:self.goodsName];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImage.mas_top).offset(10);
        make.right.mas_equalTo(-50);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(15);
    }];
    
    self.goodsNum=[UnityLHClass masonryLabel:@"x2" font:13.0 color:BM_BLACK];
    [goodView addSubview:self.goodsNum];
    [self.goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.returnState.mas_right);
        make.centerY.mas_equalTo(self.goodsName.mas_centerY);
    }];
    
    UILabel *price=[UnityLHClass masonryLabel:@"退款金额：" font:13.0 color:BM_Color_GrayColor];
    [goodView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodsImage.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(15);
    }];

    self.orderRefund=[UnityLHClass masonryLabel:@"¥547.00" font:13.0 color:[UIColor colorWithRed:1.00 green:0.69 blue:0.38 alpha:1.00]];
    [goodView addSubview:self.orderRefund];
    [self.orderRefund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.returnState.mas_right);
        make.centerY.mas_equalTo(price.mas_centerY);
    }];

    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.deleteOrder.hidden=YES;
    self.deleteTwoOrder.hidden=YES;
    [self.deleteOrder setTitle:@"  删除订单  " forState:UIControlStateNormal];

    self.merchantName.text=dataSource[@"merchantName"];
    self.goodsName.text=dataSource[@"goodsName"];
    self.goodsNum.text=[NSString stringWithFormat:@"x%@",dataSource[@"goodsNum"]];
    self.orderRefund.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"orderRefund"] floatValue]];
    self.order.text = [NSString stringWithFormat:@"退货号：%@",dataSource[@"id"]];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
//    if ([dataSource[@"orderType"] integerValue]==2)
//    {
//        //orderType 	string 	订单类型：01、自营商城订单，02、一号店订单 、03：团购
//        self.merchantName.text=@"1号店";
//    }

    //    returnGoodsYhdFlg 	string 	退货退至一号店标志，0：货退至平台（通过APP退款） 1：货退至一号店
    //    applyState 	string 	审核状态（退货至平台，用此字段，状态:1：为待审核 2：为同意,3：为不同意）
    //    returnOrderYhdState 	string 	审核状态（退货至一号店，用此字段，状态：0：待审核 4：审核拒绝 12：审核通过 34：退货取消 27：退货完成)
    //    returnState 	String 	退款状态(1:退款中,2:退款成功,3:退款失败)
    if ([dataSource[@"returnGoodsYhdFlg"] integerValue]==1)
    {
        switch ([dataSource[@"returnOrderYhdState"] integerValue])
        {
            case 0:
            {
                self.returnState.text=@"审核中";
                self.deleteOrder.hidden=YES;
                self.deleteTwoOrder.hidden=YES;
                
            }
                break;
            case 27:
            {
                self.returnState.text=@"退货完成";
                
                if ([dataSource[@"returnState"] integerValue]==0)
                {
                    self.returnState.text=@"审核通过";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  填写快递单号  " forState:UIControlStateNormal];
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==1)
                {
                    self.returnState.text=@"退款中";
                    self.deleteOrder.hidden=YES;
                    self.deleteTwoOrder.hidden=YES;
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==2)
                {
                    self.returnState.text=@"退款成功";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  删除订单  " forState:UIControlStateNormal];
                    
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==3)
                {
                    self.returnState.text=@"退款失败";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  删除订单  " forState:UIControlStateNormal];
                    
                    
                }
                
                
            }
                break;
            case 12:
            {
                self.returnState.text=@"审核通过";
                self.deleteOrder.hidden=YES;
                self.deleteTwoOrder.hidden=YES;
//                [self.deleteOrder setTitle:@"  填写快递单号  " forState:UIControlStateNormal];
                
                
            }
                break;
            case 4:
            {
                self.returnState.text=@"审核不通过";
                self.deleteOrder.hidden=NO;
                self.deleteTwoOrder.hidden=YES;
            }
                break;
            case 34:
            {
                self.returnState.text=@"退货取消";
                self.deleteOrder.hidden=NO;
                self.deleteTwoOrder.hidden=YES;
            }
                break;
                
            default:
                break;
        }

    }
    else
    {
        switch ([dataSource[@"applyState"] integerValue])
        {
            case 1:
            {
                self.returnState.text=@"审核中";
                self.deleteOrder.hidden=YES;
                self.deleteTwoOrder.hidden=YES;
                
            }
                break;
            case 2:
            {
                if ([dataSource[@"returnState"] integerValue]==0)
                {
                    self.returnState.text=@"审核通过";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  填写快递单号  " forState:UIControlStateNormal];
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==1)
                {
                    self.returnState.text=@"退款中";
                    self.deleteOrder.hidden=YES;
                    self.deleteTwoOrder.hidden=YES;
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==2)
                {
                    self.returnState.text=@"退款成功";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  删除订单  " forState:UIControlStateNormal];
                    
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==3)
                {
                    self.returnState.text=@"退款失败";
                    self.deleteOrder.hidden=NO;
                    self.deleteTwoOrder.hidden=YES;
                    [self.deleteOrder setTitle:@"  删除订单  " forState:UIControlStateNormal];
                    
                    
                }
                
                
            }
                break;
            case 3:
            {
                self.returnState.text=@"审核不通过";
                self.deleteOrder.hidden=NO;
                self.deleteTwoOrder.hidden=YES;
            }
                break;
                
            default:
                break;
        }

    }
}

+(CGFloat)getCellWithDataSource:(id)dataSource
{
    float hight=250;
    
//    returnGoodsYhdFlg 	string 	退货退至一号店标志，0：货退至平台（通过APP退款） 1：货退至一号店
//    applyState 	string 	审核状态（退货至平台，用此字段，状态:1：为待审核 2：为同意,3：为不同意）
//    returnOrderYhdState 	string 	审核状态（退货至一号店，用此字段，状态：0：待审核 4：审核拒绝 12：审核通过 34：退货取消)
//    returnState 	String 	退款状态(1:退款中,2:退款成功,3:退款失败)
    if ([dataSource[@"returnGoodsYhdFlg"] integerValue]==1)
    {
        switch ([dataSource[@"returnOrderYhdState"] integerValue])
        {
            case 0:
            {
                hight=205;
                
            }
                break;
            case 12:
            {
              
                hight=205;
                
            }
                break;
            case 27:
            {
                if ([dataSource[@"returnState"] integerValue]==0)
                {
                    
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==1)
                {
                    hight=205;
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==2)
                {
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==3)
                {
                    
                }
                
                
            }
                break;
            case 4:
            {
               
            }
                break;
            case 34:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }
    else
    {
        switch ([dataSource[@"applyState"] integerValue])
        {
            case 1:
            {
                hight=205;
                
            }
                break;
            case 2:
            {
                if ([dataSource[@"returnState"] integerValue]==0)
                {
                    
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==1)
                {
                    
                    hight=205;
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==2)
                {
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==3)
                {
                    
                    
                }
                
                
            }
                break;
            case 3:
            {
                
            }
                break;
                
            default:
                break;
        }

    }
    
    return hight;
}

@end
