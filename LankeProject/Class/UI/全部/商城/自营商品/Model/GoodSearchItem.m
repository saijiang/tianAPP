//
//  GoodSearchItem.m
//  LankeProject
//
//  Created by itman on 17/1/12.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GoodSearchItem.h"

@implementation GoodSearchItem

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.pageIndex=1;
        self.pageSize=10;
        
    }
    return self;
}

@end
