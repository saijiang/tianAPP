//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
}

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize datasource=_datasource;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;


-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle withDelegate:(id <HZAreaPickerDelegate>)delegate andDatasource:(id <HZAreaPickerDatasource>)datasource
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    self.frame=CGRectMake(0, self.frame.origin.y, DEF_SCREEN_WIDTH, 260);
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 20)];
    title.text=@"选择地址";
    title.textAlignment=NSTextAlignmentCenter;
    [self addSubview:title];
    if (self)
    {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.datasource = datasource;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        provinces =[self.datasource areaPickerData:self];
        cities = [[provinces objectAtIndex:0] objectForKey:@"listCity"];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"areaName"];
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
        {
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"areaName"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"listArea"];
            if (areas.count > 0)
            {
                self.locate.district = [areas objectAtIndex:0][@"areaName"];
            }
            else
            {
                self.locate.district = @"";
            }
            
        }
    }
        
    return self;
    
}


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
            {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        switch (component)
        {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"areaName"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"areaName"];
                break;
            case 2:
                if ([areas count] > 0)
                {
                    return [areas objectAtIndex:row][@"areaName"];
                    break;
                }
            default:
                return  @"";
                break;
        }
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        switch (component)
        {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"listCity"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"listArea"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"areaName"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"areaName"];
                self.locate.stateId = [[provinces objectAtIndex:row] objectForKey:@"areaId"];
                self.locate.cityId = [[cities objectAtIndex:0] objectForKey:@"areaId"];
                
                if ([areas count] > 0)
                {
                    self.locate.district = [areas objectAtIndex:0][@"areaName"];
                    self.locate.districtId = [[areas objectAtIndex:0] objectForKey:@"areaId"];
                }
                else
                {
                    self.locate.district = @"";
                    self.locate.districtId = @"";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"listArea"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"areaName"];
                self.locate.cityId = [[cities objectAtIndex:0] objectForKey:@"areaId"];
                if ([areas count] > 0)
                {
                    self.locate.district = [areas objectAtIndex:0][@"areaName"];
                    self.locate.districtId = [[areas objectAtIndex:0] objectForKey:@"areaId"];

                }
                else
                {
                    self.locate.district = @"";
                    self.locate.districtId = @"";
                }
                break;
            case 2:
                if ([areas count] > 0)
                {
                    self.locate.district = [areas objectAtIndex:row][@"areaName"];
                    self.locate.districtId = [[areas objectAtIndex:row] objectForKey:@"areaId"];

                }
                else
                {
                    self.locate.district = @"";
                    self.locate.districtId = @"";
                }
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)])
    {
        [self.delegate pickerDidChaneStatus:self];
    }

}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    UIView *baseView=[[UIView alloc]initWithFrame:[AppDelegate appDelegate].window.window.bounds];
    baseView.tag=1111;
    baseView.userInteractionEnabled = YES;
    baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [[AppDelegate appDelegate].window addSubview:baseView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPicker)];
    [baseView addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [baseView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         UIView *baseView=(UIView *)[[AppDelegate appDelegate].window viewWithTag:1111];
                         if (baseView)
                         {
                             [baseView removeFromSuperview];
                         }
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
