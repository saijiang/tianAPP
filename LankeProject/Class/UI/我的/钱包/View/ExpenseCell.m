//
//  ExpenseCell.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ExpenseCell.h"

@implementation ExpenseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.nameLB = [UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithHexString:@"#666666"]];
        self.nameLB.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLB];
        
        self.timeLB = [UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithHexString:@"#666666"]];
        self.timeLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLB];
        
        self.priceLB = [UnityLHClass masonryLabel:@"" font:14.0 color:[UIColor colorWithRed:0.56 green:0.88 blue:0.65 alpha:1]];
        self.priceLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.priceLB];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self addSubview:self.line];
        
        
        [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.3);
            make.left.mas_offset(5);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
            make.left.mas_equalTo(self.nameLB.mas_right);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.3);
            make.right.offset(0);
            make.height.mas_equalTo(self.mas_height);
        }];

        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.left.offset(5);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.offset(0.8);
        }];
    
    }
    
    return self;
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.nameLB.text = dataSource[@"consumeItem"];
    self.timeLB.text = [[NSString stringWithFormat:@"%@",dataSource[@"consumeTime"]] stringformatterDate:@"yyyy-MM-dd HH:mm"];
    self.priceLB.text = [NSString stringWithFormat:@"%.2f",[dataSource[@"consumeMoney"] floatValue]];
}
//加载的疗养券
-(void)loadThearyCellWithDataSource:(id)dataSource
{
    self.nameLB.text = dataSource[@"batch"];
    self.timeLB.text = dataSource[@"end_date"];
//    self.timeLB.text = [[NSString stringWithFormat:@"%@",dataSource[@"consumeTime"]] stringformatterDate:@"yyyy-MM-dd HH:mm"];
    self.priceLB.text = [NSString stringWithFormat:@"%.2f",[dataSource[@"balance"] floatValue]];
}
//疗养券消费状况
-(void)loadThearyCellUserDetailsWithDataSource:(id)dataSource{
    self.nameLB.text = dataSource[@"item"];
    self.timeLB.text = dataSource[@"date"];
    self.priceLB.text = [NSString stringWithFormat:@"%.2f",[dataSource[@"money"] floatValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
