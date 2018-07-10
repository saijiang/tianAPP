//
//  BottomCommentView.h
//  LankeProject
//
//  Created by itman on 16/10/17.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYZTextView.h"

@interface BottomCommentView : UIView

-(void)removeObserverNot;
@property(nonatomic,copy)NSString *unEditorString;
@property(nonatomic,strong)JYZTextView *comment;

@end
