//
//  HRDailFitDDHeaderView.m
//  LankeProject
//
//  Created by admin on 2017/10/25.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HRDailFitDDHeaderView.h"

@implementation HRDailFitDDHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#67B0D9"];
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    
    
    
    NSArray*nameArray=@[@"时间",@"心率"];
    for (int i=0; i<nameArray.count; i++) {
        UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH/2*i, 0, DEF_SCREEN_WIDTH/2, 50)];
        lable.text=nameArray[i];
        lable.font=[UIFont systemFontOfSize:16];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=BM_WHITE;
        [self addSubview:lable];
    }
}

@end
