//
//  ChooseNumberView.m
//  LankeProject
//
//  Created by itman on 16/11/28.
//  Copyright © 2016年 张涛. All rights reserved.
//


#import "ChooseNumberView.h"

@interface ChooseNumberView ()


@end

@implementation ChooseNumberView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_CLEAR;

    }
    return self;
}
-(void)setItemArray:(NSArray<ChooseNumberItem *> *)itemArray
{
    _itemArray=itemArray;
    [self createItem];
}

-(void)autoresizingFrame
{
    UIView *lastSpaceView       = [UIView new];
    lastSpaceView.backgroundColor = [UIColor clearColor];
    [self addSubview:lastSpaceView];
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.and.top.and.bottom.equalTo(self);
    }];
    
    for (NSUInteger i = 0; i < self.itemArray.count; i++)
    {
        UIButton *itemView = [self viewWithTag:1314+i];
        [self addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(lastSpaceView.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *spaceView         = [UIView new];
        spaceView.backgroundColor = [UIColor clearColor];
        [self addSubview:spaceView];
        
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView.mas_right).with.priorityHigh(); // 降低优先级，防止宽度不够出现约束冲突
            make.top.and.bottom.equalTo(self);
            make.width.equalTo(lastSpaceView.mas_width);
        }];
        
        lastSpaceView = spaceView;
    }
    
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.right.equalTo(self.mas_right);
    }];
    
}

-(void)createItem
{
    for (int i=0; i<self.itemArray.count; i++)
    {
        ChooseNumberItem *itemData=self.itemArray[i];
        UIButton *item=[[UIButton alloc]init];
        item.titleLabel.font=BM_FONTSIZE(14.0);
        [self addSubview:item];
        item.tag=1314+i;
        
        [item setTitle:itemData.title forState:UIControlStateNormal];
        [item setTitle:itemData.title forState:UIControlStateSelected];
        [item setImage:itemData.image forState:UIControlStateNormal];
        [item setImage:itemData.seletedImage forState:UIControlStateSelected];
        [item setTitleColor:BM_BLACK forState:UIControlStateNormal];
        if (itemData.seletedColor) {
            [item setTitleColor:itemData.seletedColor forState:UIControlStateSelected];
        }else{
            [item setTitleColor:BM_BLACK forState:UIControlStateSelected];
        }

        CGFloat imageWidth = item.imageView.image.size.width+1;
        CGFloat labelWidth = [itemData.title sizeWithAttributes:@{NSFontAttributeName:item.titleLabel.font}].width+1;
        item.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth, 0.0, imageWidth);
        item.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
                
        [item handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(chooseNumberView:SeletedItem:didSeletedIndex:)])
            {
                item.selected=!item.selected;
                [self.delegate chooseNumberView:self SeletedItem:item didSeletedIndex:item.tag-1314];
            }
        }];
        itemData.button = item;
    }
    
    [self autoresizingFrame];
}

-(void)setChooseNumberViewIndex:(NSInteger)index chooseNumberItemSeleted:(BOOL)seleted
{
    UIButton *itemView = [self viewWithTag:1314+index];
    itemView.selected=seleted;
}


@end

@implementation ChooseNumberItem

- (void)setTitle:(NSString *)title{

    _title = title;
    
    if (self.button) {
        
        [self.button setTitle:title forState:UIControlStateNormal];
        [self.button setTitle:title forState:UIControlStateSelected];
        
        CGFloat imageWidth = self.button.imageView.image.size.width+1;
        CGFloat labelWidth = [title sizeWithAttributes:@{NSFontAttributeName:self.button.titleLabel.font}].width+1;
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth, 0.0, imageWidth);
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        
        [self.button sizeToFit];
        [self.button layoutIfNeeded];
    }
}

@end
