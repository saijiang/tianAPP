//
//  SymptomsSelfTestViewController.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SymptomsSelfTestViewController.h"
#import "HumanBodyViewController.h"
#import "SymptomListViewController.h"

@interface SymptomsSelfTestViewController ()<SwipeViewDelegate,SwipeViewDataSource,SliderViewDelegate>
@property (nonatomic , strong)  SliderView* sliderView;
@property (nonatomic , strong)  SwipeView *swipeView;
@property (nonatomic , strong)  NSMutableArray *items;
@end

@implementation SymptomsSelfTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"症状自测"];
}
- (void)createUI
{
    
    NSArray *segmentItems = @[@"人体图",@"症状列表"];
    _sliderView = [[SliderView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH ,45) withDataArr:segmentItems];
    _sliderView.delegate=self;
    _sliderView.backgroundColor = BM_WHITE;
    [self addSubview:_sliderView];
    
    _swipeView=[[SwipeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(_sliderView)+10, DEF_SCREEN_WIDTH, DEF_CONTENT-DEF_BOTTOM(_sliderView)-10)];
    [self addSubview:_swipeView];
    _swipeView.pagingEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.wrapEnabled = NO;
    _swipeView.bounces=NO;
    [self setupView];
    [_swipeView reloadData];
    
}
#pragma mark - 配置swipeView视图

- (void)setupView
{
    
    HumanBodyViewController *oneVC = [[HumanBodyViewController alloc]init];
    [self addChildViewController:oneVC];
   
    SymptomListViewController *twoVC = [[SymptomListViewController alloc]init];
    [self addChildViewController:twoVC];

    self.items = [NSMutableArray arrayWithObjects:oneVC,twoVC,nil];
    
    [oneVC receiveObject:^(id object) {
        self.swipeView.currentPage=1;
        [twoVC setSelectSection:object];
    }];
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

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    [self.sliderView setSelectedIndex:swipeView.currentPage];
}
#pragma mark----SliderViewDelegate
-(void)slidingScrollView:(SliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index
{
    _swipeView.currentPage=index;
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
