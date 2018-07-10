//
//  PropertyHomeContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyHomeContentView.h"


@interface PropertyHomeContentView()

@property (nonatomic ,strong) NSMutableArray * items;

@end

@implementation PropertyHomeContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.items = [NSMutableArray array];
        NSArray * titles = @[@"社区头条",@"物业报修",@"便民服务",@"有话要说",@"物业缴费",@"问卷调查",@"我的物业资料"];
        NSArray * images = @[[UIImage imageNamed:@"property_home_toutiao"],
                             [UIImage imageNamed:@"property_home_baoxiu"],
                             [UIImage imageNamed:@"property_home_bianmin"],
                             [UIImage imageNamed:@"property_home_youhuayaoshuo"],
                             [UIImage imageNamed:@"property_home_jiaofei"],
                             [UIImage imageNamed:@"property_home_diaocha"],
                             [UIImage imageNamed:@"property_home_wuyeziliao"]];
        for (NSInteger index = 0; index < 7 ; index ++) {
            
            TopImageButton * itemButton = [[TopImageButton alloc] init];
            itemButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [itemButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            itemButton.tag = 1010 + index;
            [itemButton setTitle:titles[index] forState:UIControlStateNormal];
            [itemButton setImage:images[index] forState:UIControlStateNormal];
            [itemButton addTarget:self action:@selector(itemButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemButton];
            [self.items addObject:itemButton];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds)/3;
    CGFloat height = CGRectGetHeight(self.bounds)/3;
    
    NSInteger index = 0;
    for (UIView * item in self.items) {
        
        [item mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.left.mas_equalTo((index % 3) * width);
            make.top.mas_equalTo((index / 3) * height);
        }];
        index ++;
    }
}



- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(rect)/3;
    CGFloat height = CGRectGetHeight(rect)/3;
    CGFloat height_v = 40;
    
    CGFloat margin_v = 15;
    
    for (NSInteger index = 0; index < 4; index ++) {
        
        CGPoint startPoint_v = CGPointMake(width * (index%2 + 1),margin_v + height * (index/2));
        CGPoint stopPoint_v = CGPointMake(width * (index%2 + 1) ,height_v + margin_v+ height * (index/2));
        home_drawLineWithContext(context, startPoint_v, stopPoint_v);

        CGPoint startPoint_h = CGPointMake(0,height * (index%2 + 1));
        CGPoint stopPoint_h = CGPointMake(CGRectGetWidth(rect),height * (index%2 + 1));
        if (index == 1 || index == 0) {
            
            home_drawLineWithContext(context, startPoint_h, stopPoint_h);
        }
    }
}

void home_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    
    CGContextStrokePath(context);
};

- (void) itemButtonHandle:(UIButton *)button{
    
    if (self.bSelectItemHandle) {
        self.bSelectItemHandle(button.tag - 1010);
    }
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    
}
@end
