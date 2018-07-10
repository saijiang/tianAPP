//
//  UITableView+DefaultView.m
//  LankeProject
//
//  Created by itman on 16/10/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "UITableView+DefaultView.h"
#import "objc/runtime.h"

@implementation UITableView (DefaultView)


-(void)setTableDefaultView:(UIView *)tableDefaultView
{
    objc_setAssociatedObject(self, @selector(tableDefaultView), tableDefaultView, OBJC_ASSOCIATION_ASSIGN);
    tableDefaultView.hidden=YES;
    [self addSubview:self.tableDefaultView];
    
}

-(UIView *)tableDefaultView
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
