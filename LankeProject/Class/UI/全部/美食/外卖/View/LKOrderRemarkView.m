//
//  LKOrderRemarkView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKOrderRemarkView.h"

@interface LKOrderRemarkView ()<UITextViewDelegate>

@property (nonatomic ,strong) UILabel * displayLabel;

@end

@implementation LKOrderRemarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _displayLabel = [UnityLHClass masonryLabel:@"备注" font:15 color:BM_Color_BlackColor];
        [self addSubview:_displayLabel];
        
        _remarkTextView = [[JYZTextView alloc] init];
        _remarkTextView.font = [UIFont systemFontOfSize:15];
        _remarkTextView.placeHolderLabel.font = [UIFont systemFontOfSize:15];
        _remarkTextView.placeholder = @"内容不超过50个字";
        _remarkTextView.delegate = self;
        _remarkTextView.placeholderColor = [UIColor colorWithHexString:@"#999999"];
        _remarkTextView.maxLimit=50;
        [self addSubview:_remarkTextView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_displayLabel.mas_top).mas_offset(-8);
        make.left.mas_equalTo(_displayLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return textView.text.length <= 50;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self sendObject:textView.text];
}
@end
