//
//  ShoppingCarListViewController.m
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShoppingCarListViewController.h"
#import "SwipeView.h"
#import "ShopCarSliderView.h"
#import "UIView+MHCommon.h"

//1号店
#import "StoreOneCarViewController.h"
#import "StoreJDCarViewController.h"
//自营
#import "SelfSupportCarViewController.h"

@interface ShoppingCarListViewController ()<ShopCarSliderDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property (strong, nonatomic)  SwipeView *swipeView;
@property (strong, nonatomic)  ShopCarSliderView* sliderView;
@property (nonatomic, strong)  NSMutableArray *items;

@end

@implementation ShoppingCarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"购物车"];
    [self showBackBtnHUD];
    
    [self creatUI];
}

//布局结构
- (void)creatUI
{
    NSArray *typeArr=@[@"京东商品",@"自营商品"];
    _sliderView = [[ShopCarSliderView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH,45) withDataArr:typeArr];
    _sliderView.delegate=self;
    [_sliderView setSliderLineWidth:60];
    _sliderView.backgroundColor =  BM_WHITE;
    [self.view addSubview:_sliderView];
    
    _swipeView=[[SwipeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(_sliderView) + 6, DEF_SCREEN_WIDTH, DEF_HEIGHT(self.view)-DEF_HEIGHT(_sliderView)-DEF_NAVBARHEIGHT - 6)];
    [self.view addSubview:_swipeView];
    _swipeView.pagingEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.wrapEnabled = NO;
    _swipeView.bounces=NO;
    _swipeView.backgroundColor = BM_ORANGE;
    [self setUpView];
    
    [_swipeView reloadData];
    if (self.isZiYingShop)
    {
        [_sliderView setSelectedIndex:1];

    }
    else
    {
        [_sliderView setSelectedIndex:0];

    }
}

- (void)setUpView
{
//一号店
//    StoreOneCarViewController *oneVC = [[StoreOneCarViewController alloc]init];
//    [self addChildViewController:oneVC];
    
    StoreJDCarViewController *oneVC = [[StoreJDCarViewController alloc]init];
    [self addChildViewController:oneVC];
    
    SelfSupportCarViewController *twoVC = [[SelfSupportCarViewController alloc]init];
    [self addChildViewController:twoVC];
    
    self.items = [NSMutableArray arrayWithObjects:oneVC,twoVC, nil];
}


#pragma mark --   delegate

-(void)slidingScrollView:(ShopCarSliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index
{
    _swipeView.currentItemIndex = index;
    
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _items.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return [_items[index] view];
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    [_sliderView setSelectedIndex:_swipeView.currentItemIndex];
}

-(void)tapTitle
{
    _swipeView.currentItemIndex=0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
