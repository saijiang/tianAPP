//
//  JYZTextView.m
//  JYZTextView
//
//  Created by dbjyz on 16/2/1.
//  Copyright © 2016年 dbjyz. All rights reserved.
//


#import "JYZTextView.h"
#import "ZZLimitInputManager.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@implementation JYZTextView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setPlaceholder:@""];
        
        [self setPlaceholderColor:kTextBorderColor];

        self.placeholderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
        self.editable = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder{
    
    if (_placeholder != placeholder) {
        
        _placeholder = placeholder;
        
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
        
        [self setNeedsDisplay];
        
        
    }
    
}

- (void)textChanged:(NSNotification *)notification{
    
    if ([[self placeholder] length] == 0) {
        return;
    }
    
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
    
    else{
        
        [[self viewWithTag:999] setAlpha:0];
    }
    
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    if ([[self placeholder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if ([[self text] length] == 0 && [[self placeholder] length] >0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
    
}
-(void)setMaxLimit:(int)maxLimit
{
    _maxLimit=maxLimit;
    // 限制输入字符长度
    [ZZLimitInputManager limitInputView:self maxLength:_maxLimit];

}
@end
