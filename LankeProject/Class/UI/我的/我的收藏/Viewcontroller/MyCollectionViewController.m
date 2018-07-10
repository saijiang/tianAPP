//
//  MyCollectionViewController.m
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "GoodsCollectionViewController.h"
#import "ShopCollectViewController.h"
#import "HealthCollectionViewController.h"
#import "PostCollectionViewController.h"
#import "MessageCollectionViewController.h"
#import "JDGoodsCollectionViewController.h"
@interface MyCollectionViewController ()<SliderViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property(nonatomic,strong)SliderView *sliderView;
@property(nonatomic,strong)SwipeView *swipeView;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)UIScrollView *bgScrollView;


@end

@implementation MyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"我的收藏"];
}
-(void)createUI
{
       _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.frame = CGRectMake(0, 10, DEF_SCREEN_WIDTH,45); // frame中的size指UIScrollView的可视范围
      _bgScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH+100, 0);
      _bgScrollView.bounces = NO;
      _bgScrollView.showsHorizontalScrollIndicator = NO;
      _bgScrollView.backgroundColor = [UIColor grayColor];
         [self.view addSubview:_bgScrollView];
       NSArray *typeArr=@[@"商品",@"商铺",@"健康咨询",@"论坛帖子",@"社区头条",@"京东商品"];
      _sliderView = [[SliderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH+100,45) withDataArr:typeArr];
    _sliderView.delegate=self;
    [_sliderView setSliderLineWidth:60];
    _sliderView.backgroundColor=[UIColor whiteColor];
    [_bgScrollView addSubview:_sliderView];

    
    _swipeView=[[SwipeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(_bgScrollView)+10, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-DEF_NAVBARHEIGHT-DEF_HEIGHT(_bgScrollView)-20)];
    [self.view addSubview:_swipeView];
    _swipeView.pagingEnabled = YES;
    _swipeView.scrollEnabled=NO;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.wrapEnabled = NO;
    _swipeView.bounces=NO;
    [self setupView];
    [_swipeView reloadData];
    [_sliderView setSelectedIndex:0];
  
}

#pragma mark - 配置swipeView视图

- (void)setupView
{
   
    GoodsCollectionViewController *oneVC = [[GoodsCollectionViewController alloc]init];
    [self addChildViewController:oneVC];
    
    ShopCollectViewController *twoVC = [[ShopCollectViewController alloc]init];
    [self addChildViewController:twoVC];
    
    HealthCollectionViewController *threeVC = [[HealthCollectionViewController alloc]init];
    [self addChildViewController:threeVC];
    
    PostCollectionViewController *fourVC = [[PostCollectionViewController alloc]init];
    [self addChildViewController:fourVC];
    
    MessageCollectionViewController *fiveVC = [[MessageCollectionViewController alloc]init];
    [self addChildViewController:fiveVC];
    JDGoodsCollectionViewController *sixthVC = [[JDGoodsCollectionViewController alloc]init];
    [self addChildViewController:sixthVC];
    
    self.items = [NSMutableArray arrayWithObjects:oneVC,  twoVC, threeVC, fourVC, fiveVC,sixthVC, nil];
    
}
#pragma mark----SliderViewDelegate
-(void)slidingScrollView:(SliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index
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
