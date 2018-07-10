//
//  LKWeatherView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//
#import "LKWeatherView.h"
#import "BMNetworkHandler.h"
#import "LocationManager.h"

@interface LKWeatherView ()

@property (nonatomic ,strong) UIButton * locationButton;
@property (nonatomic ,strong) UILabel * maxTempLabel;
//@property (nonatomic ,strong) UILabel * maxTempStatusLabel;
@property (nonatomic ,strong) UILabel * maxTempUnitLabel;

@property (nonatomic ,strong) UILabel * separatorLabel;
@property (nonatomic ,strong) UILabel * minTempLabel;
@property (nonatomic ,strong) UILabel * minTempStatusLabel;
@property (nonatomic ,strong) UILabel * minTempUnitLabel;

@property (nonatomic ,strong) UILabel * currentWeatherStatusLabel;
@property (nonatomic ,strong) UILabel * vehicleusetodayLabel;

@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

// 装所有的显示视图，做动画用
@property (nonatomic ,strong) NSMutableArray * views;

@property (nonatomic ,assign ,getter=isRequestWeatherInfo) BOOL requestWeatherInfo;
@end

@implementation LKWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        _requestWeatherInfo = NO;
        
        _views = [NSMutableArray array];
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = BM_Color_GrayColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.3;
        
        UIImage * locationImage = [UIImage imageNamed:@"home_page_weather_location"];
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setTitle:@" 北京" forState:UIControlStateNormal];
        _locationButton.userInteractionEnabled = NO;
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_locationButton setTitleColor:BM_Color_GrayColor forState:UIControlStateNormal];
        [_locationButton setImage:locationImage forState:UIControlStateNormal];
        [self addSubview:_locationButton];
        
        CGFloat tempFontSize = 26;
        
        
        UILabel *todayLabel = [UnityLHClass masonryLabel:@"今日天气:" font:13 color:BM_Color_GrayColor];
        todayLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:todayLabel];
        [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(_locationButton.mas_left);
        }];

    
        _maxTempLabel = [UnityLHClass masonryLabel:@"08" font:tempFontSize color:BM_Color_Blue];
        [self addSubview:_maxTempLabel];
        _maxTempLabel.font = [UIFont boldSystemFontOfSize:tempFontSize];
       
        _maxTempUnitLabel = [UnityLHClass masonryLabel:@"°" font:23 color:BM_Color_Blue];
        _maxTempUnitLabel.font = [UIFont boldSystemFontOfSize:23];
        _maxTempUnitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_maxTempUnitLabel];
        [_maxTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(todayLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(todayLabel.mas_centerY);
        }];
        //
        _separatorLabel = [UnityLHClass masonryLabel:@"~" font:16 color:BM_Color_Blue];
        [self addSubview:_separatorLabel];
        
        //
        _minTempLabel = [UnityLHClass masonryLabel:@"04" font:tempFontSize color:BM_Color_Blue];
        _minTempLabel.font = [UIFont boldSystemFontOfSize:tempFontSize];
        [self addSubview:_minTempLabel];
        
        _minTempUnitLabel = [UnityLHClass masonryLabel:@"°" font:23 color:BM_Color_Blue];
        _minTempUnitLabel.font = [UIFont boldSystemFontOfSize:23];
        _minTempUnitLabel.textAlignment = NSTextAlignmentCenter;
        _minTempUnitLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_minTempUnitLabel];
        
        _minTempStatusLabel = [UnityLHClass masonryLabel:@"多云" font:13 color:BM_Color_Blue];
        [self addSubview:_minTempStatusLabel];
        
        UILabel *currentWeatherStatusLabel = [UnityLHClass masonryLabel:@"空气质量:" font:13 color:BM_Color_GrayColor];
        currentWeatherStatusLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:currentWeatherStatusLabel];
        [currentWeatherStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.left.mas_equalTo(_locationButton.mas_left);
        }];

        _currentWeatherStatusLabel = [UnityLHClass masonryLabel:@"168度重度污染" font:13 color:BM_Color_Blue];
        _currentWeatherStatusLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_currentWeatherStatusLabel];
        [_currentWeatherStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(currentWeatherStatusLabel.mas_centerY);
            make.left.mas_equalTo(currentWeatherStatusLabel.mas_right).mas_offset(5);
        }];
        
        UILabel *vehicleusetodayLabel = [UnityLHClass masonryLabel:@"今日车辆限号:" font:13 color:BM_Color_GrayColor];
        vehicleusetodayLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:vehicleusetodayLabel];
        [vehicleusetodayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(currentWeatherStatusLabel.mas_centerY);
            make.left.mas_equalTo(_currentWeatherStatusLabel.mas_right).mas_offset(30);
        }];
        
        _vehicleusetodayLabel = [UnityLHClass masonryLabel:@"" font:13 color:[UIColor colorWithRed:0.95 green:0.64 blue:0.42 alpha:1.00]];
        _vehicleusetodayLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_vehicleusetodayLabel];
        [_vehicleusetodayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(vehicleusetodayLabel.mas_centerY);
            make.left.mas_equalTo(vehicleusetodayLabel.mas_right).mas_offset(5);
        }];
        
        
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:
                              UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        [self addSubview:_activityIndicator];
                
        [self.views addObjectsFromArray:@[self.maxTempLabel,self.maxTempUnitLabel,self.separatorLabel,self.minTempLabel,self.minTempUnitLabel,self.minTempStatusLabel,self.currentWeatherStatusLabel,self.locationButton]];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    
    [_maxTempUnitLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_maxTempLabel.mas_top).mas_offset(5);
        make.left.mas_equalTo(_maxTempLabel.mas_right);
        make.height.mas_equalTo(15);
    }];
    
    
    
    [_separatorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_maxTempLabel.mas_centerY);
        make.left.mas_equalTo(_maxTempUnitLabel.mas_right).mas_offset(10);
    }];
    
    {
        [_minTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_separatorLabel.mas_right).mas_offset(10);
            make.top.mas_equalTo(_maxTempLabel.mas_top);
        }];
        
        [_minTempUnitLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_maxTempUnitLabel.mas_top);
            make.left.mas_equalTo(_minTempLabel.mas_right);
            make.height.mas_equalTo(_maxTempUnitLabel.mas_height);
        }];
        
        [_minTempStatusLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_minTempLabel.mas_right);
            make.bottom.mas_equalTo(_maxTempLabel.mas_bottom).mas_offset(-5);
        }];
    }
   
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}

- (void) configWeatherViewWithData:(id)data{
 
    if ([data isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString * location = [NSString stringWithFormat:@" %@",data[@"results"][0][@"currentCity"]];
    [self.locationButton setTitle:location forState:UIControlStateNormal];
    
    NSArray * weather_data = data[@"results"][0][@"weather_data"];
    NSString * temperature = weather_data[0][@"temperature"];
    NSArray * tempArray = [temperature componentsSeparatedByString:@"~"];
    
    NSString * min = [tempArray lastObject];
    NSString * minTemp = [min substringToIndex:min.length - 1];
    minTemp = [minTemp substringFromIndex:1];
    
    self.maxTempLabel.text = [NSString stringWithFormat:@"%@",minTemp];
    self.minTempLabel.text = [NSString stringWithFormat:@"%@",tempArray[0]];
    
    [self formatterWeatherStatusWithPM:[data[@"results"][0][@"pm25"] floatValue]];
    
    self.minTempStatusLabel.text = [NSString stringWithFormat:@"%@ %@",weather_data[0][@"weather"],weather_data[0][@"wind"]];
    
    [self getLimitLicense];

}

-(void)getLimitLicense
{
    [UserServices getLimitLicenseWithCompletionBlock:^(int result, id responseObject) {
        if (result==0)
        {
            _vehicleusetodayLabel.text=[self getTheDayOfTheWeekByDataSource:responseObject[@"data"]];
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(NSString *)getTheDayOfTheWeekByDataSource:(id)data
{
    NSDate *inputDate=[NSDate date];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"SundayLimit", @"mondayLimit", @"tuesdayLimit", @"wednesdayLimit", @"thursdayLimit", @"fridayLimit", @"saturdayLimit", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *weekdaysUse= [weekdays objectAtIndex:theComponents.weekday];
    return data[weekdaysUse];
        
}
- (void) formatterWeatherStatusWithPM:(CGFloat)pm25{
    
    NSString * status;
    if(pm25 <= 50){
        status = @"优";
    }else if(pm25 <= 100){
        status = @"良";
    }else if(pm25 <= 150){
        status = @"轻度污染";
    }else if(pm25 <= 200){
        status = @"中度污染";
    }else if(pm25 <= 250){
        status = @"重度污染";
    } else{
        status = @"严重污染";
    }
    self.currentWeatherStatusLabel.text = [NSString stringWithFormat:@"%.0f %@",pm25,status];
}
- (void) show{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.views enumerateObjectsUsingBlock:^(UIView * view, NSUInteger index, BOOL * _Nonnull stop) {
            view.alpha = 1.0f;
        }];
    } completion:^(BOOL finished) {
        
        [self.activityIndicator stopAnimating];
    }];
}

- (void) hide{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.views enumerateObjectsUsingBlock:^(UIView * view, NSUInteger index, BOOL * _Nonnull stop) {
            view.alpha = .0f;
        }];
    } completion:^(BOOL finished) {
        
        [self.activityIndicator startAnimating];
    }];
}


#pragma mark -
#pragma mark Location && Weather

- (void) updateWeatherData{

//    if (self.isRequestWeatherInfo) {
//        return;
//    }
//    self.requestWeatherInfo = YES;
    [[LocationManager sharedLocationManager] startUserLocationServiceBlock:^(float lat,float lng){
    
        NSString * currentLocation = [NSString stringWithFormat:@"%.6f,%.6f",lng,lat];
        
        [self requestCurrentLocationWeatherData:currentLocation];
    }];
}

- (void) requestCurrentLocationWeatherData:(NSString *)currentLocation{

    //http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=rgH1wAGXVOcBVLoytf2REGXjMBXL8ye6&mcode=06:9D:3C:ED:7B:E3:8C:09:CE:C7:6F:86:65:C3:52:EB:9C:8E:FD:56;com.bm.bjhangtian

    NSMutableDictionary * params = [@{@"location":currentLocation,
                                      @"output":@"json",
                                      @"ak":HK_weather_ak,
                                      @"mcode":HK_weather_mcode
                                      } copy];
    
    [[BMNetworkHandler sharedInstance] conURL:HK_current_weather
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:NO
                                 successBlock:^(id returnData)
     {
         
         self.requestWeatherInfo = NO;
         [self configWeatherViewWithData:returnData];
     } failureBlock:^(NSError *error)
     {
         self.requestWeatherInfo = NO;
     }];
    
}

@end

/*
 if(Float.valueOf(result.results.get(0).pm25)<=50){
 temp="优";
 }else if(Float.valueOf(result.results.get(0).pm25)<=100){
 temp="良";
 }else if(Float.valueOf(result.results.get(0).pm25)<=150){
 temp="轻度污染";
 }else if(Float.valueOf(result.results.get(0).pm25)<=200){
 temp="中度污染";
 }else if(Float.valueOf(result.results.get(0).pm25)<=250){
 temp="重度污染";
 } else{
 temp="严重污染";
 }
 */
