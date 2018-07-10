//
//  ReservationNoteView.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ReservationNoteView.h"

@implementation ReservationNoteView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.leftTitle=[UnityLHClass masonryLabel:@"备注" font:14.0 color:BM_BLACK];
        [self addSubview:self.leftTitle];
        [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(18);
            make.width.mas_equalTo(90);
        }];
        
        self.textView=[[JYZTextView alloc]init];
        self.textView.placeholder=@"可填写附加要求，我们会尽量安排";
        self.textView.font=BM_FONTSIZE(14.0);
        self.textView.textColor=BM_BLACK;
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.leftTitle.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.bTextChangeValueHandle) {
        self.bTextChangeValueHandle(textView.text);
    }
    return YES;
}
@end
