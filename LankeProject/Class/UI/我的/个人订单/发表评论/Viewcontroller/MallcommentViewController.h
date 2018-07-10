//
//  MallcommentViewController.h
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface MallcommentViewController : BaseViewController

@property(nonatomic,strong)NSArray *tableArray;
@property(nonatomic,copy)NSString *orderCode;
@property(nonatomic,copy)NSString *merchantId;
@property(nonatomic,copy)NSString *merchantName;

@property (nonatomic,assign)BOOL isJD;

@end
