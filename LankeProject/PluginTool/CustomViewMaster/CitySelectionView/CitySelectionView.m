//
//  CitySelectionView.m
//  LankeProject
//
//  Created by itman on 16/12/20.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "CitySelectionView.h"
#import "ProvinceRegionManager.h"

@interface  CitySelectionView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)  UIView *backgroundView;

@property (strong, nonatomic)  UIPickerView *cityPickerView;

@property (strong ,nonatomic) NSString *dateString;

@property (strong,nonatomic)   UIView *contentView;

@property (nonatomic ,strong) NSArray * CityList;
@property (nonatomic ,strong) NSMutableArray * cities;
@property (nonatomic ,strong) NSMutableArray * areas;
@property (nonatomic ,strong) NSString * stateName ,* cityName ,*areaName, *regionId;//省 市 区 ID

@end

@implementation CitySelectionView


-(NSArray *)CityList
{
    if (!_CityList)
    {
        _CityList = [[ProvinceRegionManager sharedRegionManager] provinceRegionInfo];
    }
    return _CityList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
         _cities = [NSMutableArray array];
         _areas = [NSMutableArray array];
         _stateName = _cityName = _regionId= @" ";
         self.backgroundColor = [UIColor clearColor];
         self.backgroundView = [[UIView alloc] initWithFrame:frame];
         UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundViewHidenCitySelectView:)];
         [self.backgroundView addGestureRecognizer:tap];
         self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
         [self addSubview:self.backgroundView];
         [self sendSubviewToBack:self.backgroundView];
         
         CGFloat height = 216.0f;
         _contentView = [[UIView alloc] init];
         _contentView.backgroundColor = [UIColor whiteColor];
         _contentView.frame = CGRectMake(0, frame.size.height - height - 50, frame.size.width, height +50);
         [self addSubview:_contentView];
         
         UILabel * titleLabel = [[UILabel alloc] init];
         titleLabel.text = @"取消";
         titleLabel.font = BM_FONTSIZE(15);
         titleLabel.frame = CGRectMake(20, 0, 40, 50);
         [_contentView addSubview:titleLabel];
         
         UILabel * saveLabel = [[UILabel alloc] init];
         saveLabel.text = @"保存";
         saveLabel.font = BM_FONTSIZE(15);
         saveLabel.frame = CGRectMake(DEF_SCREEN_WIDTH-40, 0, 40, 50);
         [_contentView addSubview:saveLabel];
         
         UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         cancleBtn.frame = CGRectMake(0, 0, 80, 50);
         [cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
          {
              [self tapBackgroundViewHidenCitySelectView:nil];
              
          }];
         [_contentView addSubview:cancleBtn];
         
         UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         saveBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - 80, 0, 80, 50);
         [saveBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
          {
              
              if (self.resultBlock)
              {
                  self.resultBlock(@{@"stateName":self.stateName,
                                     @"cityName":self.cityName,
                                     @"areasName":self.areaName,
                                     @"regionId":self.regionId});
              }
              [self tapBackgroundViewHidenCitySelectView:nil];
              
          }];
         [_contentView addSubview:saveBtn];
         
         self.cityPickerView = [[UIPickerView alloc] init];
         self.cityPickerView.frame = CGRectMake(0, 50, DEF_SCREEN_WIDTH, 216);
         self.cityPickerView.backgroundColor = [UIColor whiteColor];
         self.cityPickerView.dataSource = self;
         self.cityPickerView.delegate = self;
         [_contentView addSubview:self.cityPickerView];
        
        [self scrollToCityLocationWithCityInfo:@""];

    }
    return self;
}
#pragma mark - API

+ (instancetype) loadWithNib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"CitySelectView" owner:self options:nil] firstObject];
}

- (void) showCitySelectViewAtView:(UIView *)view{
    
    if (view != nil)
    {
        [view addSubview:self];
    }
    else
    {
        [KAPPDELEGATE.window addSubview:self];
    }
    self.contentView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT, self.frame.size.width, self.contentView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT - self.contentView.frame.size.height, self.frame.size.width, self.contentView.frame.size.height);
    }];
}

- (void)scrollToCityLocationWithCityInfo:(NSString *)cityInfo{
    
    
    NSInteger stateIndex=0;
    for (NSInteger index = 0; index < self.CityList.count; index ++)
    {
        NSDictionary * stateDictionary = self.CityList[index];
        if ([cityInfo rangeOfString:stateDictionary[@"regionName"]].location!=NSNotFound)
        {
            stateIndex = index;

        }
    }
    self.stateName=self.CityList[stateIndex][@"regionName"];


    [self.cities removeAllObjects];
    [self.cities addObjectsFromArray:[self componentTwoRowDataWithComponentOneIndex:stateIndex]];
    NSInteger cityIndex=0;
    for (NSInteger index = 0; index < self.cities.count; index ++)
    {
        NSDictionary * cityDictionary = self.cities[index];
        if ([cityInfo rangeOfString:cityDictionary[@"regionName"]].location!=NSNotFound)
        {
            cityIndex = index;

        }
    }
    self.cityName=self.cities[cityIndex][@"regionName"];

    
    [self.areas removeAllObjects];
    [self.areas addObjectsFromArray:[self componentThreeRowDataWithComponentTwoIndex:cityIndex]];
    NSInteger areaIndex=0;
    for (NSInteger index = 0; index < self.areas.count; index ++)
    {
        NSDictionary * cityDictionary = self.areas[index];
        if ([cityInfo rangeOfString:cityDictionary[@"regionName"]].location!=NSNotFound)
        {
            areaIndex = index;
           
        }
    }
    self.areaName=self.areas[areaIndex][@"regionName"];
    self.regionId=self.areas[areaIndex][@"regionId"];
    
    
    [self.cityPickerView reloadAllComponents];
    [self.cityPickerView selectRow:stateIndex inComponent:0 animated:YES];
    [self.cityPickerView selectRow:cityIndex inComponent:1 animated:YES];
    [self.cityPickerView selectRow:areaIndex inComponent:2 animated:YES];

}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0)
    {
        return self.CityList.count;
    }
    if (component == 1)
    {
        return self.cities.count;
    }
    if (component == 2)
    {
        return self.areas.count;
    }
    return 0;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0)
    {// 四川
        
        NSDictionary * state = self.CityList[row];
        NSString * stateName = [state objectForKey:@"regionName"];
        return stateName;
    }
    if (component == 1)
    {// 攀枝花
        
        NSDictionary * city = self.cities[row];
        NSString * cityName = [city objectForKey:@"regionName"];
        return cityName;
    }
    if (component == 2)
    {// 西区
        
        NSString * areaName = self.areas[row][@"regionName"];
        return areaName;
    }
    return @"City";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0)
    {
        
        [self reloadComponentTwoAtIndex:row];
    }
    if (component == 1)
    {
        
        [self reloadComponentThreeAtIndex:row];
    }
    
    if (component == 0)
    {
        // 四川
        self.stateName=self.CityList[row][@"regionName"];
        self.cityName=self.cities[0][@"regionName"];
        self.areaName=self.areas[0][@"regionName"];
        self.regionId=self.areas[0][@"regionId"];
        
    }
    if (component == 1)
    {// 攀枝花
        
        self.cityName=self.cities[row][@"regionName"];
        self.areaName=self.areas[0][@"regionName"];
        self.regionId=self.areas[0][@"regionId"];
    }
    if (component == 2)
    {// 西区
        
        self.areaName=self.areas[row][@"regionName"];
        self.regionId=self.areas[row][@"regionId"];
    }

    
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel * cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:15];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    cityLabel.frame = CGRectMake(0, 0, screenWidth / 3, 30);
    
    return cityLabel;
}
#pragma mark - Method
- (IBAction)tapBackgroundViewHidenCitySelectView:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 216.0+50.0);
        self.cityPickerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 216);
    } completion:^(BOOL finished) {
        self.backgroundView = nil;
        self.cityPickerView = nil;
        [self removeFromSuperview];
        
    }];
    
}

// 根据第一个component进行第二个的component数据更新，河南省->郑州市
- (NSArray *) componentTwoRowDataWithComponentOneIndex:(NSInteger)index{
    
    NSDictionary * state = self.CityList[index];
    
    NSArray * cities = [state objectForKey:@"cityList"];
    
    return cities;
}

// 根据第一个component进行第二个的component数据更新，郑州市->二七区
- (NSArray *) componentThreeRowDataWithComponentTwoIndex:(NSInteger)index{
    
    NSDictionary * city = self.cities[index];
    
    NSArray * areas = [city objectForKey:@"areaList"];
    
    return areas;
}

// 当拨动第一列的时候，更新第二列以及第三列的数据
- (void) reloadComponentTwoAtIndex:(NSInteger)index{
    
    if (self.cities && self.cities.count > 0)
    {
        [self.cities removeAllObjects];
    }
    [self.cities addObjectsFromArray:[self componentTwoRowDataWithComponentOneIndex:index]];
    [self.cityPickerView reloadComponent:1];
    [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
    [self reloadComponentThreeAtIndex:0];
    
    
}

// 当拨动第二列的时候，更新第三列的数据
- (void) reloadComponentThreeAtIndex:(NSInteger)index{
    
    if (self.areas && self.areas.count > 0)
    {
        [self.areas removeAllObjects];
    }
    [self.areas addObjectsFromArray:[self componentThreeRowDataWithComponentTwoIndex:index]];
    [self.cityPickerView reloadComponent:2];
    [self.cityPickerView selectRow:0 inComponent:2 animated:YES];
   
    
}
- (void) citySelectLocation:(CitySelectedResult)resultBlock
{
    self.resultBlock=[resultBlock copy];
}

@end
