//
//  DiningRoomViewContoller.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningRoomViewContoller.h"
//cell
#import "DiningRoomCell.h"

#import "DiningDetailViewController.h"
#import "LocationManager.h"
#import "LKSegmentView.h"
#import "ProvinceRegionManager.h"
#import "LKRestaurantSectionView.h"
#import "ChooseAddressPopupContentView.h"

static NSString *DiningRoomCellID = @"DiningRoomCell";

@interface DiningRoomViewContoller()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *tableArray;
}
@property (nonatomic ,strong) Region * region;
@property (nonatomic ,strong) LKSegmentView * segmentView;
@property (nonatomic ,strong) LKRestaurantSectionView * headerView;

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic ,assign) BOOL defaultLoadAddressInfo;

@end

@implementation DiningRoomViewContoller


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        tableArray = [[NSMutableArray alloc] init];
        
        self.region = [[Region alloc] init];
        
        self.defaultLoadAddressInfo = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"职工餐厅列表";
    self.contentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];

    [self segmentPrivaseView];
    
    [self initUI];
    self.collectionView.hidden = YES;
    [self requestData];
}

#pragma mark ----------------------------------     界面初始化     ----------------------------------------

- (void) segmentPrivaseView{
    
    LKWeakSelf
    LKSegmentView * segmentView = [[LKSegmentView alloc] init];
    segmentView.normalImage = [UIImage imageNamed:@"ding_xiala"];
    segmentView.selectImage = [UIImage imageNamed:@"ding_xiala"];
    [segmentView configSegmentViewWithItems:[self currentAddressInfo]];
    segmentView.bSegmentViewDidSelectedItem = ^(NSInteger index){
        
        [self selectAtIndex:index complete:^(NSArray *data, NSInteger defaultSelectIndex) {
            
            NSString * title;
            if (index == 0) {
                title = @"选择省份";
            }
            if (index == 1) {
                title = @"选择城市";
            }
            if (index == 2) {
                title = @"选择区";
            }
            ChooseAddressPopupContentView * choosepopupContentView = [[ChooseAddressPopupContentView alloc] init];
            choosepopupContentView.toolView.titleLabel.text = title;
            [choosepopupContentView configChooseViewWithData:data withTitleKey:@"regionName"];
            LKStrongSelf
            choosepopupContentView.bSureHandle = ^(id data , NSInteger row){
                self.defaultLoadAddressInfo = NO;

                [self regionSelectAtIndex:index row:row];
                
                [self.segmentView updateSegmentViewWithItems:[self currentAddressInfo]];
                
                [self requestData];
            };
            HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
            popupView.animationType = EPopupViewAnimationUpFromBottom;
            popupView.dimBackground=YES;
            [popupView show:YES];
        }];
    };
    [self addSubview:segmentView];
    self.segmentView = segmentView;
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
}

-(void)initUI
{
    CSStickyHeaderFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.disableStickyHeaders = YES;
    //表
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, DEF_BOTTOM(self.headerView), DEF_SCREEN_WIDTH, DEF_CONTENT-DEF_HEIGHT(self.headerView)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = BM_CLEAR;
    self.collectionView.alwaysBounceVertical=YES;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView registerClass:[DiningRoomCell class] forCellWithReuseIdentifier:DiningRoomCellID];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.segmentView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.segmentView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


#pragma mark -
#pragma mark Address M


- (void) selectAtIndex:(NSInteger)index complete:(void(^)(NSArray * data,NSInteger defaultSelectIndex))bCompleteHandle{
    
    NSInteger defaultSelectIndex = 0;
    
    NSArray * data ;
    if (index == 0) {
        data = [self.region provinceInfo];
        defaultSelectIndex = self.region.selectProvinceIndex;
    }
    if (index == 1) {
        data = [self.region cityInfo];
        defaultSelectIndex = self.region.selectCityIndex;
    }
    if (index == 2) {
        data = [self.region regionInfo];
        defaultSelectIndex = self.region.selectRegionIndex;
    }
    if (bCompleteHandle) {
        bCompleteHandle(data,defaultSelectIndex);
    }
}

- (void) regionSelectAtIndex:(NSInteger)index row:(NSInteger)row{
    
    if (index == 0) {
        [self.region selectProvinceAtIdex:row];
    }
    if (index == 1) {
        [self.region selectCityAtIdex:row];
    }
    if (index == 2) {
        [self.region selectRegionAtIdex:row];
    }
}
- (NSArray *) currentAddressInfo{
    
    return @[[self.region currentProvince][@"regionName"],
             [self.region currentCity][@"regionName"],
             [self.region currentRegion][@"regionName"]];
}

- (NSString *) currentProvinceID{
    
    return [self.region currentProvince][@"regionId"];
}
- (NSString *) currentCityID{
    
    return [self.region currentCity][@"regionId"];
}
- (NSString *) currentRegionID{
    
    return [self.region currentRegion][@"regionId"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DiningRoomCell *cell=(DiningRoomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:DiningRoomCellID forIndexPath:indexPath];
    [cell loadDiningRoomCellWithDataSource:tableArray[indexPath.row]];
    
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
    
    return UIEdgeInsetsMake(0, 0, 0, 0); ;
}
#pragma mark---设置collectionView－referenceSizeForHeaderInSection高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}

#pragma mark---设置collectionView－referenceSizeForFooterInSection高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
    
    return footerReferenceSize;
}

#pragma mark - Reset Layout
#pragma mark---设置collectionView－CellHight高度
- (CGSize) resetItemSizeWithLayout:(CSStickyHeaderFlowLayout *)layout atIndexPath:(NSIndexPath *)indexPath
{
    
    float width = DEF_SCREEN_WIDTH;
    float height = (DEF_SCREEN_WIDTH-30)/2.0+60;
    return CGSizeMake(width, height);
}
#pragma mark---设置collectionView－Cell分间线
- (CGFloat) resetMinimumLineSpacingWithLayout:(CSStickyHeaderFlowLayout *)layout atSection:(NSInteger)section{
    
    CGFloat minimumLineSpacing = 0.0f;
    return minimumLineSpacing;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiningDetailViewController *detail = [[DiningDetailViewController alloc]init];
    detail.restaurantData = tableArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void)requestData
{
    [[LocationManager sharedLocationManager] startUserLocationServiceBlock:^(float lat, float lon) {
        
        [UserServices getBackPasswordWithRestaurantType:@"01"
                                    restaurantLongitude:[NSString stringWithFormat:@"%f",lon]
                                     restaurantLatitude:[NSString stringWithFormat:@"%f",lat]
                                             provinceId:[self currentProvinceID]
                                                 cityId:[self currentCityID]
                                             districtId:[self currentRegionID]
                                         restaurantName:@""
                                        restaurantClass:@""
                                              pageIndex:@"1"
                                               pageSize:@"10"
                                        completionBlock:^(int result, id responseObject)
         {
             
             if (self.defaultLoadAddressInfo) {
                 return ;
             }
             if ([responseObject[@"status"] integerValue] == 0)
             {
                 
                 [tableArray removeAllObjects];
                 
                 [tableArray addObjectsFromArray:responseObject[@"data"]];
                 
                 [self.collectionView reloadData];
             }else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
             self.collectionView.hidden = NO;
         }];
    }];
    
    [LocationManager sharedLocationManager].bGeoResultHandle = ^(NSDictionary * data){
        
        if (self.defaultLoadAddressInfo) {
        
            [self.region defaultSelectWithAddressInfo:data];
            
            [self.segmentView updateSegmentViewWithItems:[self currentAddressInfo]];
            
            [self requestData];
        }
        self.defaultLoadAddressInfo = NO;
    };

}
@end
