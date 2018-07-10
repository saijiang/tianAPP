//
//  LKBottomShelfView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKBottomShelfView.h"
#import "LKShelfItemView.h"

@interface LKBottomShelfView ()

@end
@implementation LKBottomShelfView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = BM_Color_GrayColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.3;
        
        _propertyItemView = [[LKShelfItemView alloc] init];
        _propertyItemView.tinColorForLogo = [UIColor colorWithHexString:@"#82BB45"];
        _propertyItemView.titleLabel.text = @"物业";
        _propertyItemView.detailLabel.text = @"服务报修，随叫随到";
        _propertyItemView.iconImageView.image = [UIImage imageNamed:@"home_page_service"];
        [self addSubview: _propertyItemView];
        
        _groupItemView = [[LKShelfItemView alloc] init];
        _groupItemView.tinColorForLogo = [UIColor colorWithHexString:@"#5EBE95"];
        _groupItemView.titleLabel.text = @"社区";
        _groupItemView.detailLabel.text = @"智慧圈子，轻松社交";
        _groupItemView.iconImageView.image = [UIImage imageNamed:@"home_page_group"];
        [self addSubview:_groupItemView];
        
     
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [_propertyItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [_groupItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(_propertyItemView.mas_top);
        make.width.mas_equalTo(self.propertyItemView.mas_width);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat margin_v = 15;
    
    CGPoint startPoint_v = CGPointMake(CGRectGetWidth(rect)/2 ,margin_v);
    CGPoint stopPoint_v = CGPointMake(CGRectGetWidth(rect)/2 ,CGRectGetHeight(rect) - margin_v);

    _drawLineWithContext(context, startPoint_v, stopPoint_v);
}

void _drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    
    CGContextStrokePath(context);
};


@end
