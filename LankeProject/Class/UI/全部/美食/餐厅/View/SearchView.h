//
//  SearchView.h
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UITextFieldInsets *searchFD;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property (nonatomic ,copy) void (^bSendTextFieldHandle)(NSString *text);
@end
