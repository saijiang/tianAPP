//
//  JDInvoiceDetailCell.m
//  LankeProject
//
//  Created by zhounan on 2018/1/15.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "JDInvoiceDetailCell.h"
@interface JDInvoiceDetailCell()

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UILabel *invoiceNumLable;
@property(nonatomic,strong)UILabel *timeLable;
@end

@implementation JDInvoiceDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    JDInvoiceDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JDInvoiceDetailCell"];
    if (!cell)
    {
        cell=[[JDInvoiceDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JDInvoiceDetailCell"];
//        cell.backgroundColor=[UIColor colorWithHexString:@"#F5F5F5"];
        cell.backgroundColor=BM_WHITE;
    }
    return cell;
    
}

-(void)createCell
{
    self.invoiceNumLable=[UnityLHClass masonryLabel:@"" font:15 color:BM_BLACK];
    self.invoiceNumLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.invoiceNumLable];
    [self.invoiceNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);

    }];
    
    self.timeLable=[UnityLHClass masonryLabel:@"" font:13 color:BM_Color_GrayColor];
    self.timeLable.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invoiceNumLable.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);

       // make.bottom.mas_equalTo(-11);
    }];
    
    UIView*lineView=[[UIView alloc]init];
    lineView.backgroundColor=BM_Color_LineColor;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLable.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(DEF_SCREEN_WIDTH, 1));
    }];
}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.invoiceNumLable.text=[NSString  stringWithFormat:@"发票号:%@",dataSource[@"ivcNo"]];
    self.timeLable.text=[NSString  stringWithFormat:@"%@",dataSource[@"invoiceTime"]];

}
@end
