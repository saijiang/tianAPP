//
//  InvoiceHeaderView.h
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceHeaderView : UIView

@property (nonatomic,strong)LeftImageBtn *personBtn;//个人
@property (nonatomic,strong)LeftImageBtn *companyBtn;//单位

@property (nonatomic,strong)UITextField *nameTf;//单位名称
@property (nonatomic,strong)UITextField *numberTf;//税号

//赋值
-(void)configViewWithData:(id)data;


@end
