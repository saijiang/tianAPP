//
//  ChooseNumberView.h
//  LankeProject
//
//  Created by itman on 16/11/28.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseNumberItem,ChooseNumberView;

@protocol ChooseNumberDelegate <NSObject>

-(void)chooseNumberView:(ChooseNumberView *)chooseNumberView SeletedItem:(UIButton *)chooseButton didSeletedIndex:(NSInteger)index;

@end


@interface ChooseNumberView : UIView

@property(nonatomic,assign)id<ChooseNumberDelegate>delegate;

@property(nonatomic,strong)NSArray<ChooseNumberItem*> *itemArray;

-(void)setChooseNumberViewIndex:(NSInteger)index chooseNumberItemSeleted:(BOOL)seleted;

@end



@interface ChooseNumberItem : NSObject

@property (nonatomic ,strong) UIButton * button;

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *seletedImage;
@property(nonatomic,strong)UIColor *seletedColor;
@property(nonatomic,copy)NSString *title;


@end
