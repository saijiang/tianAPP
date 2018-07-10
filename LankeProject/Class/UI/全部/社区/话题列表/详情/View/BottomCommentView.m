//
//  BottomCommentView.m
//  LankeProject
//
//  Created by itman on 16/10/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BottomCommentView.h"

@interface BottomCommentView()<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect kebRect;
    UITapGestureRecognizer *tapGesture;

}


@end

@implementation BottomCommentView

-(void)removeObserverNot
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [tapGesture setDelegate:self];
     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        UIButton *rightBtn=[[UIButton alloc]init];
        [self addSubview:rightBtn];
        rightBtn.backgroundColor=BM_Color_Blue;
        rightBtn.layer.cornerRadius=5;
        rightBtn.layer.masksToBounds=YES;
        rightBtn.titleLabel.font=BM_FONTSIZE(14.0);
        [rightBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(80);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(49-14);

        }];
        
        self.comment=[[JYZTextView alloc]initWithFrame:CGRectZero];
        self.comment.delegate=self;
        self.comment.backgroundColor=BM_WHITE;
        self.comment.font=BM_FONTSIZE(13.0);
        self.comment.textColor=BM_BLACK;
        self.comment.placeholderColor=[UIColor colorWithHexString:@"888888"];
        self.comment.placeholder=@"发表评论";
        self.comment.layer.masksToBounds=YES;
        self.comment.layer.cornerRadius=5;
        self.comment.layer.borderWidth=1;
        self.comment.tintColor = BM_Color_Blue;
        self.comment.layer.borderColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.90 alpha:1.00].CGColor;
        [self addSubview:self.comment];
        
        [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightBtn.mas_left).offset(-15);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        
        
       [rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
           if (self.comment.text.length>0)
           {
               if (self.comment.text.length>200)
               {
                   self.comment.text=[self.comment.text substringToIndex:200];
               }
//               if ([UnityLHClass stringContainsEmoji:self.comment.text])
//               {
//                   [UnityLHClass showHUDWithStringAndTime:@"个性签名只支持中英文,数字和符号"];
//                   return ;
//               }
               NSString *sendText=[self.comment.text stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
               [self sendObject:sendText];
               self.comment.text=nil;
               [self updateView];
               [self endEditing:NO];

           }
       }];
        

    }
    return self;
}


-(void)setUnEditorString:(NSString *)unEditorString
{
    _unEditorString=unEditorString;
    self.comment.placeholder=unEditorString;

}

- (void)textFieldChange
{
  
    [self updateView];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.window removeGestureRecognizer:tapGesture];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>200&&text.length>0)
    {
        textView.text=[textView.text substringToIndex:200];
        [UnityLHClass showHUDWithStringAndTime:@"字数不能超过200字"];
        return NO;
    }
    else if ([text isEqualToString:@"\n"])
    {
        textView.text=[NSString stringWithFormat:@"%@\r",textView.text];
        [self updateView];
        return NO;

    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{

    if (![KeychainManager islogin])
    {
        [KeychainManager gotoLogin];
        return;
    }
    [self.window addGestureRecognizer:tapGesture];

}

- (void)updateView
{
    
    static CGFloat maxHeight =60.0f;
    CGSize constraintSize = CGSizeMake(DEF_SCREEN_WIDTH-45-80, MAXFLOAT);
    CGSize size = [self.comment sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        self.comment.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        self.comment.scrollEnabled = NO;    // 不允许滚动
    }
    float hight=size.height +14;
    if (hight<DEF_TABBARHEIGHT)
    {
        hight=DEF_TABBARHEIGHT;
    }
    self.frame=CGRectMake(self.frame.origin.x, DEF_CONTENT-hight-kebRect.size.height, DEF_SCREEN_WIDTH, hight);

    

}
- (void)keyboardWillShow:(NSNotification *)note
{

    kebRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.frame=CGRectMake(self.frame.origin.x,DEF_CONTENT -kebRect.size.height-self.frame.size.height, DEF_SCREEN_WIDTH, self.frame.size.height);

    }];
   
    [self updateView];

}

- (void)keyboardWillHide:(NSNotification *)note
{
    float time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.frame=CGRectMake(self.frame.origin.x,DEF_CONTENT-self.frame.size.height, DEF_SCREEN_WIDTH, self.frame.size.height);

    }];

}

- (void)tapRecognized:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [gesture.view endEditing:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
