//
//  InvoiceTypeView.h
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InvoiceType) {
    
    FapType  = 0,//发票类型
    AfterSellServiceType     = 1,//售后服务类型
    AfterSellPackageType  = 2,//包装描述
    AfterSellPickwareType    = 3,//取件方式
};

@interface InvoiceTypeView : UIView

@property (nonatomic,strong)UILabel *typeTitleLab;//发票类型title

@property (nonatomic,strong)NSString *typeStr;//发票类型


@property (nonatomic,strong)UILabel *noticeLable;

@property (nonatomic,copy)NSString *jdOrderId;//京东订单号
@property (nonatomic,copy)NSString *skuId;//京东商品编号
@property (nonatomic,assign)InvoiceType type;

@property (nonatomic,strong)NSArray *dataArray;

#pragma mark --- 服务类型
-(void)getCustomerExpectCompRequest;

#pragma mark --- 返回京东方式
-(void)getWareReturnJdCompRequest;

@end
