//
//  SearchView.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        UIImageView *baseimageView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"ding_sousuo"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)]];
        baseimageView.userInteractionEnabled=YES;
        [self addSubview:baseimageView];
        [baseimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(self.mas_width);
        }];
        
        LocalhostImageView *leftimageView=[[LocalhostImageView alloc]init];
        leftimageView.image=[UIImage imageNamed:@"ding_sousuoicon"];
        [baseimageView addSubview:leftimageView];
        [leftimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
        }];
        
        self.searchFD=[[UITextFieldInsets alloc]init];
        [baseimageView addSubview:self.searchFD];
        self.searchFD.font=BM_FONTSIZE(14.0);
        self.searchFD.textColor=BM_BLACK;
        self.searchFD.placeholder=@"输入商户名进行搜索";
        self.searchFD.placeHolderColor=BM_WHITE;
        self.searchFD.returnKeyType=UIReturnKeySearch;
        self.searchFD.delegate=self;
        [self.searchFD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(baseimageView.mas_right).offset(-20);
            make.left.mas_equalTo(leftimageView.mas_right).offset(10);

        }];
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.bSendTextFieldHandle) {
        self.bSendTextFieldHandle(textField.text);
    }
    if (textField.text.length>0)
    {
        [self sendObject:textField.text];
 
    }
    else
    {
        [self sendObject:@""];

    }
    return YES;
}




@end
