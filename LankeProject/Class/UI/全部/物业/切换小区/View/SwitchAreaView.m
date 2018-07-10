//
//  SwitchAreaView.m
//  LankeProject
//
//  Created by itman on 17/5/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#define HTProvince @"HTProvince"
#define HTCity @"HTCity"
#define HTRegion @"HTRegion"

#import "SwitchAreaView.h"
#import "EHHorizontalSelectionView.h"
#import "ProvinceRegionManager.h"
#import "LocationManager.h"

@interface SwitchAreaView()<EHHorizontalSelectionViewProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  EHHorizontalSelectionView * segmentView;
@property (nonatomic ,strong)  NSMutableArray * segments;
@property (nonatomic ,strong)  NSMutableArray * addressArray;

@property (nonatomic ,strong)  UITableView * addressTableView;
@property (nonatomic ,strong)  District * region;

@property (nonatomic ,copy)    NSString *districtId;
@property (nonatomic ,copy)    NSString *districtName;

@end

@implementation SwitchAreaView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.segments=[[NSMutableArray alloc]init];
        self.addressArray=[[NSMutableArray alloc]init];
        self.region = [[District alloc] init];
        [self createUI];
        [self.region lkReloadData:^{
            [self reloadData];
        }];
        [self requestLocationData];
    }
    return self;
}

-(void)requestLocationData
{
    NSString *province=@"北京";
    NSString *city=@"北京";
    NSString *region=@"北京";
    if (DEF_PERSISTENT_GET_OBJECT(HTProvince)) {
        province=DEF_PERSISTENT_GET_OBJECT(HTProvince);
        city=DEF_PERSISTENT_GET_OBJECT(HTCity);
        region=DEF_PERSISTENT_GET_OBJECT(HTRegion);
        
    }
    
    NSDictionary * addressInfo = @{@"province":province,
                                   @"city":city,
                                   @"region":region};
    [self.region defaultSelectWithAddressInfo:addressInfo];
    [self selectAtIndex:0];
    [self reloadData];
      
}

-(void)reloadData
{

    [self.segments removeAllObjects];
    [self.segments addObjectsFromArray:[self currentAddressInfo]];
    [self.segmentView reloadData];
    
    [self.addressTableView reloadData];

    
}

-(void)createUI
{
    //顶部
    UIView *titleView=[[UIView alloc]init];
    [self addSubview:titleView];
    titleView.bottomlineWithColor=BM_Color_LineColor;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UILabel *titleLable=[UnityLHClass masonryLabel:@"所在地区" font:16.0 color:BM_BLACK];
    [titleView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(titleView);
    }];
    
    //所选地址
    UIView *centerView=[[UIView alloc]init];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.segments addObjectsFromArray:@[@"请选择",@"",@"",@"",]];
    self.segmentView = [[EHHorizontalSelectionView alloc] initWithFrame:CGRectZero];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    [self.segmentView registerCellWithClass:[EHHorizontalLineViewCell class]];
    self.segmentView.delegate = self;
    self.segmentView.tintColor = BM_Color_Blue;
    self.segmentView.normalTextColor = BM_BLACK;
    self.segmentView.selectTextColor = BM_Color_Blue;
    self.segmentView.font = [UIFont systemFontOfSize:16];
    self.segmentView.fontMedium = [UIFont systemFontOfSize:16];
    self.segmentView.maxDisplayCount = 4;
    self.segmentView.bottomlineWithColor=BM_Color_LineColor;
    [EHHorizontalLineViewCell updateColorHeight:3.f];
    [centerView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(centerView);
    }];
    
    //地址list
    UIView *bootomView=[[UIView alloc]init];
    [self addSubview:bootomView];
    [bootomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(centerView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.bounces=NO;
    [self addSubview:self.addressTableView];
    [self.addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bootomView);
    }];
    
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableView"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableView"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor=BM_BLACK;
    NSDictionary *data=self.addressArray[indexPath.row];
    NSString *regionName=data[@"regionName"];
    if ([self.segments[self.segmentView.selectedIndex] isEqualToString:regionName])
    {
        cell.textLabel.textColor=BM_Color_Blue;
    }
    cell.textLabel.text=regionName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self regionSelectAtIndex:self.segmentView.selectedIndex row:indexPath.row];

}

#pragma mark EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.segments.count;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return self.segments[index];
}

- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index
{
    [self selectAtIndex:index];
}

#pragma mark -
#pragma mark Address M
- (void) selectAtIndex:(NSInteger)index
{
    NSArray * data ;
    if (index == 0)
    {
        data = [self.region provinceInfo];
    }
    if (index == 1)
    {
        data = [self.region cityInfo];
    }
    if (index == 2)
    {
        data = [self.region regionInfo];
    }
    if (index == 3)
    {
        data = [self.region districtInfo];
    }
    [self.addressArray removeAllObjects];
    [self.addressArray addObjectsFromArray:data];
    [self reloadData];

}

- (void) regionSelectAtIndex:(NSInteger)index row:(NSInteger)row
{
    NSArray * data ;
    if (index == 0)
    {
        [self.region selectProvinceAtIdex:row];
        data = [self.region provinceInfo];
    }
    if (index == 1)
    {
        [self.region selectCityAtIdex:row];
        data = [self.region cityInfo];
    }
    if (index == 2)
    {
        [self.region selectRegionAtIdex:row];
        data = [self.region regionInfo];

    }
    if (index == 3)
    {
        [self.region selectDistrictAtIdex:row];
        data = [self.region districtInfo];
        NSDictionary *district=data[row];
        
        //保存本地把
        [KeychainManager setlocalDistrictState:YES];
        [KeychainManager setlocalDistrictId:district[@"regionId"]];
        [KeychainManager setlocalDistrictName:district[@"regionName"]];
        DEF_PERSISTENT_SET_OBJECT(self.segments[1], HTProvince);
        DEF_PERSISTENT_SET_OBJECT(self.segments[2], HTCity);
        DEF_PERSISTENT_SET_OBJECT(self.segments[3], HTRegion);
        [self sendObject:@"setlocalDistrict"];
        [self hideView];
    }
    [self.addressArray removeAllObjects];
    [self.addressArray addObjectsFromArray:data];

    [self reloadData];
}
//provinceId 	省Id
//cityId 	 	城市id
//countyId 	 	区id
//districtName 	小区名称
- (NSArray *) currentAddressInfo
{
    return @[[self.region currentProvince][@"regionName"],
             [self.region currentCity][@"regionName"],
             [self.region currentRegion][@"regionName"],
             [self.region currentDistrict][@"regionName"],
             ];
}
- (NSString *) currentProvinceID
{
    return [self.region currentProvince][@"regionId"];
}
- (NSString *) currentCityID
{
    return [self.region currentCity][@"regionId"];
}
- (NSString *) currentRegionID
{
    return [self.region currentRegion][@"regionId"];
}
- (NSString *) currentDistrictID
{
    return [self.region currentDistrict][@"regionId"];
}

@end
