//
//  SubjectTeachingViewController.m
//  LankeProject
//
//  Created by itman on 2017/7/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SubjectTeachingViewController.h"
#import "SubjectTeachingListViewController.h"

@interface SubjectTeachingViewController ()<SwipeViewDelegate,SwipeViewDataSource>

@property(nonatomic,strong) UISegmentedControl *segment;
@property(nonatomic,strong) SwipeView *swipeView;
@property(nonatomic,strong) NSMutableArray *items;


@end

@implementation SubjectTeachingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createView];
}

-(void)createNav
{
    //先生成存放标题的数据
    NSArray *array = [NSArray arrayWithObjects:@"教学视频",@"教学资讯", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(0, 0, 120, 30);
    //根据内容定分段宽度
    segment.apportionsSegmentWidthsByContent = YES;
    //开始时默认选中下标(第一个下标默认是0)
    segment.selectedSegmentIndex = 0;
    //控件渲染色(也就是外观字体颜色)
    segment.tintColor = BM_Color_Blue;
    //添加到视图
    [self showNavBarCustomByView:segment];
    self.segment=segment;
    WeakSelf
    [segment handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
        [weakSelf.swipeView scrollToPage:segment.selectedSegmentIndex duration:0.1];
    }];
}

-(void)createView
{
    _swipeView=[[SwipeView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-DEF_NAVBARHEIGHT)];
    [self.view addSubview:_swipeView];
    _swipeView.pagingEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.wrapEnabled = NO;
    _swipeView.scrollEnabled = NO;
    _swipeView.bounces=NO;
    [self setupView];
}
#pragma mark - 配置swipeView视图

- (void)setupView
{
    SubjectTeachingListViewController *oneVC = [[SubjectTeachingListViewController alloc]init];
    oneVC.teachingType=@"01";
    [self addChildViewController:oneVC];
    
    SubjectTeachingListViewController *twoVC = [[SubjectTeachingListViewController alloc]init];
    twoVC.teachingType=@"02";
    [self addChildViewController:twoVC];
    
    self.items = [NSMutableArray arrayWithObjects:oneVC,twoVC, nil];
    
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
