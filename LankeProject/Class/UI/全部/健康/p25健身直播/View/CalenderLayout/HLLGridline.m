//
//  HLLGridline.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLGridline.h"

@implementation HLLGridline_Gray

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return self;
}


@end

@implementation HLLGridline_White

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"d7d7d7"];
    }
    return self;
}


@end
