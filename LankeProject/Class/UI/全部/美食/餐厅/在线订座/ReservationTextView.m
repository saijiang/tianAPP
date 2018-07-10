//
//  ReservationTextView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationTextView.h"

@implementation ReservationTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.leftTitle=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        [self addSubview:self.leftTitle];
        [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        
        self.textField=[[UITextField alloc]init];
        self.textField.font=BM_FONTSIZE(14.0);
        self.textField.textColor = [UIColor colorWithHexString:@"999999"];
        [self.textField setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];

        [self addSubview:self.textField];
        [self.textField addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.leftTitle.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *line=[[UIView alloc]init];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftTitle.mas_left);
            make.right.mas_equalTo(self.textField.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

- (void) textFieldDidChangeValue:(UITextField *)textField{
    
    if (self.bTextChangeValueHandle) {
        self.bTextChangeValueHandle(textField.text);
    }
}
@end
