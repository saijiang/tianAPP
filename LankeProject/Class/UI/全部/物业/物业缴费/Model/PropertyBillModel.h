//
//  PropertyBillModel.h
//  LankeProject
//
//  Created by itman on 17/5/12.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyBillModel : NSObject

@property(nonatomic,assign)BOOL isSeleted;
@property(nonatomic,strong)id data;

@property(nonatomic,assign)NSString *billId;//缴费Id
@property(nonatomic,assign)NSString *billMonth;// 	缴费时间
@property(nonatomic,assign)NSString *billType;// 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
@property(nonatomic,assign)NSString *billAmount;// 	账单金额

+(PropertyBillModel*)initWithDataSource:(id)dataSource;

@end
