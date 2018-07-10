//
//  JDInvoicerContentView.h
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDInvoicerContentView : UIView

@property (nonatomic,strong) NSArray *dataArray;//发票内容数据

@property (nonatomic,strong) UILabel *contentLab;//发票内容

@property (nonatomic,strong) NSString *invoiceContentStr;//1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细

@property (nonatomic,strong) NSString *typeStr; //1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细

-(void)configViewWithData:(id)data;

@end
