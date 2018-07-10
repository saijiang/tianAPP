//
//  RepastViewController.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RepastViewController.h"


//cell
#import "RepastCustomCell.h"
//广告详情页
#import "AdvDetailViewController.h"
//食堂列表
#import "DiningRoomViewContoller.h"
//周边餐厅
#import "RestaurantListViewController.h"

static NSString *RepastCustomCellID = @"RepastCustomCell";

@interface RepastViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CommonHeaderViewDelegate>
{
    CommonHeaderView *bannerView;
    NSMutableArray *bannerArray;//轮播图数组
    NSMutableArray *tableArray;
}

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation RepastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"餐饮";
    self.contentView.backgroundColor = BM_WHITE;
    NSArray *testArr = @[@{@"title":@"职工餐厅",@"image":@"repest-0"},@{@"title":@"周边餐厅",@"image":@"repest-1"}];
    bannerArray = [[NSMutableArray alloc]init];
    tableArray = [[NSMutableArray alloc]init];
    [tableArray addObjectsFromArray:testArr];
    
    [self initUI];
    
    [self requestRestaurantAdvertList];
}

#pragma mark ----------------------------------     界面初始化     ----------------------------------------
-(void)initUI
{
    //轮播图
    bannerView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/2)];
    bannerView.delegate = self;
    [bannerView configureBannerViewWithImageData:bannerArray];
    [self addSubview:bannerView];
    
    
    CSStickyHeaderFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.disableStickyHeaders = YES;
    //表
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, DEF_BOTTOM(bannerView)+20, DEF_SCREEN_WIDTH, DEF_CONTENT-DEF_HEIGHT(bannerView)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = BM_WHITE;
    self.collectionView.alwaysBounceVertical=YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView registerClass:[RepastCustomCell class] forCellWithReuseIdentifier:RepastCustomCellID];
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RepastCustomCell *cell=(RepastCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RepastCustomCellID forIndexPath:indexPath];
    [cell loadRepastCustomCellWithDataSource:tableArray[indexPath.row]];
    
    return cell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        CSStickyHeaderFlowLayout * customLayout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
        
        return  [self resetItemSizeWithLayout:customLayout
                                  atIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    if ([collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        CSStickyHeaderFlowLayout * customLayout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
        
        return  [self resetMinimumLineSpacingWithLayout:customLayout
                                              atSection:section];
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark---设置collectionView－Cell间隔
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10); ;
}
#pragma mark---设置collectionView－referenceSizeForHeaderInSection高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}

#pragma mark---设置collectionView－referenceSizeForFooterInSection高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 5.0f);
    
    return footerReferenceSize;
}
#pragma mark - Reset Layout
#pragma mark---设置collectionView－CellHight高度
- (CGSize) resetItemSizeWithLayout:(CSStickyHeaderFlowLayout *)layout atIndexPath:(NSIndexPath *)indexPath
{
    
    float width = (DEF_SCREEN_WIDTH-30)/2;
    
    return CGSizeMake(width, width);
}
#pragma mark---设置collectionView－Cell分间线
- (CGFloat) resetMinimumLineSpacingWithLayout:(CSStickyHeaderFlowLayout *)layout atSection:(NSInteger)section{
    
    CGFloat minimumLineSpacing = 10.0f;
    return minimumLineSpacing;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"餐饮cell--- %ld",indexPath.row);
    if (indexPath.row == 0)
    {
        DiningRoomViewContoller *ding = [[DiningRoomViewContoller alloc]init];
        [self.navigationController pushViewController:ding animated:YES];
    }
    else
    {
        RestaurantListViewController *restaurat = [[RestaurantListViewController alloc]init];
        [self.navigationController pushViewController:restaurat animated:YES];
    }
    
}

#pragma mark - CommonHeaderViewDelegate
-(void)commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index
{
    NSLog(@"---首页推荐--顶部轮播图点击");
    AdvDetailViewController *detail = [[AdvDetailViewController alloc]init];
    detail.data = bannerArray[index];
    if ([bannerArray[index][@"source"]  isEqual: @"02"]) {
        
        detail.advType = 2;
    }
    if([bannerArray[index][@"source"]  isEqual: @"01"]){
        
        detail.advType = 3;
        detail.externalUrl = bannerArray[index][@"externalUrl"];
    }
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void) requestRestaurantAdvertList{
    
    [UserServices advertListCompletionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            
            NSArray * bannerData = responseObject[@"data"];
            [bannerArray removeAllObjects];
            [bannerArray addObjectsFromArray:bannerData];
            [bannerView confiBannerViewWithImageData:bannerArray
                                          fotKeyPath:@"advertImage"];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
