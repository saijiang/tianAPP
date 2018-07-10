//
//  PlanWeatherView.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PlanWeatherView.h"

#import "BMNetworkHandler.h"
#import "LocationManager.h"

@interface PlanWeatherView ()

@property (nonatomic ,strong) UIButton * locationButton;

@property (nonatomic ,strong) UILabel * maxTempLabel;
@property (nonatomic ,strong) UILabel * maxTempUnitLabel;

@property (nonatomic ,strong) UILabel * separatorLabel;

@property (nonatomic ,strong) UILabel * minTempLabel;
@property (nonatomic ,strong) UILabel * minTempStatusLabel;
@property (nonatomic ,strong) UILabel * minTempUnitLabel;

@property (nonatomic ,strong) UILabel * currentWeatherLabel;

@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

// 装所有的显示视图，做动画用
@property (nonatomic ,strong) NSMutableArray * views;

@property (nonatomic ,assign ,getter=isRequestWeatherInfo) BOOL requestWeatherInfo;
@end

@implementation PlanWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _requestWeatherInfo = NO;
        
        _views = [NSMutableArray array];
        
              
        UIImage * locationImage = [UIImage imageNamed:@"home_page_weather_location"];
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setTitle:@" 北京" forState:UIControlStateNormal];
        _locationButton.userInteractionEnabled = NO;
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_locationButton setTitleColor:BM_Color_GrayColor forState:UIControlStateNormal];
        [_locationButton setImage:locationImage forState:UIControlStateNormal];
        [self addSubview:_locationButton];
        
        CGFloat tempFontSize = 26;
        
        
        _maxTempLabel = [UnityLHClass masonryLabel:@"08" font:tempFontSize color:BM_Color_Blue];
        [self addSubview:_maxTempLabel];
        _maxTempLabel.font = [UIFont boldSystemFontOfSize:tempFontSize];
        
        _maxTempUnitLabel = [UnityLHClass masonryLabel:@"°" font:23 color:BM_Color_Blue];
        _maxTempUnitLabel.font = [UIFont boldSystemFontOfSize:23];
        _maxTempUnitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_maxTempUnitLabel];
        [_maxTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationButton.mas_left);
            make.top.mas_equalTo(_locationButton.mas_bottom).offset(10);
        }];
        //
        _separatorLabel = [UnityLHClass masonryLabel:@"-" font:16 color:BM_Color_Blue];
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
        
        _currentWeatherLabel = [UnityLHClass masonryLabel:@"不适宜户外锻炼" font:13 color:BM_Color_Blue];
        [self addSubview:_currentWeatherLabel];
        
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:
                              UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        [self addSubview:_activityIndicator];
        [self.views addObjectsFromArray:@[self.maxTempLabel,self.maxTempUnitLabel,self.separatorLabel,self.minTempLabel,self.minTempUnitLabel,self.minTempStatusLabel,self.locationButton,self.currentWeatherLabel]];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    [_currentWeatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_locationButton.mas_centerY);
        make.left.mas_equalTo(_locationButton.mas_right).offset(5);
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
    
    self.minTempStatusLabel.text = [NSString stringWithFormat:@"%@",weather_data[0][@"weather"]];
    
    _currentWeatherLabel.text=[NSString stringWithFormat:@"%@户外锻炼",data[@"results"][0][@"index"] [4][@"zs"]];
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
