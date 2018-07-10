//
//  JDShopScreeningView.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopScreeningView.h"


@interface JDShopScreeningView()<ChooseNumberDelegate>

@property(nonatomic,strong)ChooseNumberView *chooseView;

@end

@implementation JDShopScreeningView

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
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void) configChooseNuberView
{
    NSArray * categoryName = @[@"销量",@"价格",@"筛选",];
    NSMutableArray *itemArr=[[NSMutableArray alloc]init];
    for (int i=0; i<categoryName.count; i++)
    {
        ChooseNumberItem *item=[[ChooseNumberItem alloc]init];
        item.title = categoryName[i];
        if (i<2)
        {
            item.image=[UIImage imageNamed:@"Mall_xiala"];
            item.seletedImage=[UIImage imageNamed:@"Mall_xiala-1"];
        }
        if (i==2)
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
            self.item.sort=nil;
            self.item.sales=@"desc";
            if (chooseButton.selected)
            {
                self.item.sales=@"asc";
            }
        }
            break;
            
        case 1:
        {
            //价格
            self.item.sales=nil;
            self.item.sort = @"desc";
            if (chooseButton.selected)
            {
                self.item.sort = @"asc";
            }
        }
            break;
            
        case 2:
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

- (void) clearFilterState
{
    [self.chooseView setChooseNumberViewIndex:0 chooseNumberItemSeleted:NO];
    [self.chooseView setChooseNumberViewIndex:1 chooseNumberItemSeleted:NO];
    [self.chooseView setChooseNumberViewIndex:2 chooseNumberItemSeleted:NO];
}

@end

@implementation JDShopSearchItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.productCname = @"不二";
        //self.sort = @"1";
        //self.priceFilter = @"";
        self.sales = @"asc";
    }
    return self;
}
- (void) clearFilter{
    
    
}
@end

