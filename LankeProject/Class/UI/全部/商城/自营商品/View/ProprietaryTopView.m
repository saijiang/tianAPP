//
//  ProprietaryTopView.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ProprietaryTopView.h"

@interface ProprietaryTopView()<ChooseNumberDelegate>

@property(nonatomic,strong)ChooseNumberView *chooseView;

@end

@implementation ProprietaryTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        self.chooseView=[[ChooseNumberView alloc]init];
        self.chooseView.backgroundColor=BM_WHITE;
        self.chooseView.delegate=self;
        [self configChooseNuberView];
        [self addSubview:self.chooseView];
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void) configChooseNuberView
{
    NSArray * categoryName = @[@"销量",@"价格",@"好评",@"筛选",];
    NSMutableArray *itemArr=[[NSMutableArray alloc]init];
    for (int i=0; i<categoryName.count; i++)
    {
        ChooseNumberItem *item=[[ChooseNumberItem alloc]init];
        item.title = categoryName[i];
        if (i<3)
        {
            item.image=[UIImage imageNamed:@"Mall_xiala"];
            item.seletedImage=[UIImage imageNamed:@"Mall_xiala-1"];
        }
        if (i==3)
        {
            item.image=[UIImage imageNamed:@"Mall_shaixuan"];
            item.seletedImage=[UIImage imageNamed:@"Mall_shaixuan-1"];
            item.seletedColor = BM_Color_Blue;
        }
        [itemArr addObject:item];
    }
    self.chooseView.itemArray=itemArr;
}

-(void)chooseNumberView:(ChooseNumberView *)chooseNumberView SeletedItem:(UIButton *)chooseButton didSeletedIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            //销量
            self.item.goodsSales=@"0";
            self.item.isPrice=nil;
            self.item.goodsComment=nil;
            if (chooseButton.selected)
            {
                 self.item.goodsSales=@"1";
            }
        }
            break;
            
        case 1:
        {
            //价格
            self.item.goodsSales=nil;
            self.item.isPrice=@"0";
            self.item.goodsComment=nil;
            if (chooseButton.selected)
            {
                self.item.isPrice=@"1";
            }
        }
            break;

            
        case 2:
        {
           //好评
            self.item.goodsSales=nil;
            self.item.isPrice=nil;
            self.item.goodsComment=@"0";
            if (chooseButton.selected)
            {
                self.item.goodsComment=@"1";
            }
        }
            break;
        case 3:
        {
            //帅选
            if (self.bSelectFilterHandle) {
                self.bSelectFilterHandle();
                return;
            }
        }
            break;

            
        default:
            break;
    }
    [self sendObject:@"reloadData"];
}

- (void) clearFilterState{
    
    [self.chooseView setChooseNumberViewIndex:3 chooseNumberItemSeleted:NO];
}
@end
