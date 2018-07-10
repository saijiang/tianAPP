//
//  PropertyBillModel.m
//  LankeProject
//
//  Created by itman on 17/5/12.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyBillModel.h"

@implementation PropertyBillModel

+(PropertyBillModel*)initWithDataSource:(id)dataSource
{
    PropertyBillModel *model=[[PropertyBillModel alloc]init];
    model.data=dataSource;
    model.isSeleted=YES;
    model.billId=dataSource[@"id"];
    model.billType=dataSource[@"billType"];
    model.billMonth=dataSource[@"billMonth"];
    model.billAmount=dataSource[@"billAmount"];
  
    return model;
}

@end
