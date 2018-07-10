//
//  WeeklyDishesViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "WeeklyDishesViewController.h"
#import "UIViewController+Page.h"
#import "WeeklyDishesCCell.h"
#import "LKSimpleCalendarView.h"
#import "DishesDetailViewController.h"
#import "EHHorizontalSelectionView.h"

@interface WeeklyDishesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,EHHorizontalSelectionViewProtocol>

@property (nonatomic ,strong) NSArray *collectionArray;;

@property (nonatomic ,strong) LKSimpleCalendarView * calendarView;

@property (nonatomic ,strong) UICollectionView * weeklyDishesCollectionView;

@property (nonatomic, strong) EHHorizontalSelectionView * orderSegmentView;
@property (nonatomic ,strong) NSArray * orderSegments;
@property (nonatomic ,copy) NSString *menuType;
@property (nonatomic ,copy) NSString *dateString;

@end

@implementation WeeklyDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"每周菜谱";
    [self creatUI];
}

- (void) creatUI{

    LKWeakSelf
    // 日历
    LKSimpleCalendarView * calendarView = [[LKSimpleCalendarView alloc] init];
    [self addSubview:calendarView];
    calendarView.bSimpleCalendarDidSelected = ^(NSInteger index ,NSString * formatter){
        LKStrongSelf
        _self.dateString=formatter;
        [_self networkRequestData];
    };
    self.calendarView = calendarView;
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(3);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    self.orderSegments = @[@"全部",@"早餐",@"中餐",@"晚餐",];
    self.orderSegmentView = [[EHHorizontalSelectionView alloc] initWithFrame:CGRectZero];
    self.orderSegmentView.backgroundColor = [UIColor whiteColor];
    [self.orderSegmentView registerCellWithClass:[EHHorizontalLineViewCell class]];
    self.orderSegmentView.delegate = self;
    self.orderSegmentView.tintColor = BM_Color_Blue;
    self.orderSegmentView.normalTextColor = BM_BLACK;
    self.orderSegmentView.selectTextColor = BM_Color_Blue;
    self.orderSegmentView.font = [UIFont systemFontOfSize:16];
    self.orderSegmentView.fontMedium = [UIFont systemFontOfSize:16];
    self.orderSegmentView.maxDisplayCount = 4;
    [EHHorizontalLineViewCell updateColorHeight:3.f];
    [self addSubview:self.orderSegmentView];
    [self.orderSegmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(calendarView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(50);
    }];
    
    
    // CollectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.weeklyDishesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.weeklyDishesCollectionView.backgroundColor = [UIColor clearColor];
    self.weeklyDishesCollectionView.alwaysBounceVertical = YES;
    self.weeklyDishesCollectionView.dataSource = self;
    self.weeklyDishesCollectionView.delegate = self;
    self.weeklyDishesCollectionView.emptyDataSetSource = self;
    [self.weeklyDishesCollectionView registerClass:[WeeklyDishesCCell class]
                        forCellWithReuseIdentifier:[WeeklyDishesCCell cellIdentifier]];
    [self addSubview:self.weeklyDishesCollectionView];
    [self.weeklyDishesCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.orderSegmentView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.calendarView.mas_left);
        make.right.mas_equalTo(self.calendarView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];

}

- (void) configFlowLayout:(UICollectionViewFlowLayout *)flowLayout{
    
    CGFloat width = (DEF_SCREEN_WIDTH - 2 * 10 - 2 * 5)/2;
    CGFloat height = width + 30;
    flowLayout.itemSize = CGSizeMake(width, height);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    flowLayout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
}

#pragma mark -
#pragma mark Collection M

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeeklyDishesCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WeeklyDishesCCell cellIdentifier] forIndexPath:indexPath];

    [cell configCellWithData:self.collectionArray[indexPath.row]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self navigationToDishesDetailWithIndex:indexPath.item];
}

#pragma mark -
#pragma mark EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.orderSegments.count;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.orderSegments[index];
}

- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index{
    if (index==0) {
        self.menuType=nil;
    }
    else{
        self.menuType=[NSString stringWithFormat:@"0%lu",(unsigned long)index];
    }
    [self networkRequestData];
}
#pragma mark -
#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -50);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}


#pragma mark -
#pragma mark Action M
- (void) navigationToDishesDetailWithIndex:(NSInteger)index
{
    // 跳转至菜品详情
    DishesDetailViewController * dishesDetail = [[DishesDetailViewController alloc] init];
    dishesDetail.dishesData = self.collectionArray[index];
    [self.navigationController pushViewController:dishesDetail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void)networkRequestData
{
    [UserServices getWeekMenuDetailWithMenuDate:self.dateString
                                   restaurantId:self.restaurantData[@"id"]
                                       menuType:self.menuType
                                completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             self.collectionArray =[NSArray arrayWithArray:responseObject[@"data"]];
             [self.weeklyDishesCollectionView reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

@end
