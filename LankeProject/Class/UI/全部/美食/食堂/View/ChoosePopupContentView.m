//
//  ChoosePopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ChoosePopupContentView.h"

@interface ChoosePopupContentView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *commonPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic ,assign) ChoosePopupViewType type;

@property (nonatomic ,strong) NSArray * commomDatas;
@property (nonatomic ,strong) id commomSelectData;

@end

@implementation ChoosePopupContentView

- (instancetype)initPopupViewWithType:(ChoosePopupViewType)type{

    self = [super init];
    
    if (self) {
        
        _type = type;
        
        LKWeakSelf
        self.toolView = [[LKToolView alloc] init];
        self.toolView.bSureHandle = ^(){
            LKStrongSelf
            [_self sureButtonHandle];
        };
        self.toolView.bCancelHandle = ^(){
            LKStrongSelf
            [_self cancelButtonHandle];
        };
        [self addSubview:self.toolView];
        
        if (self.type == ChoosePopupContentCommom) {
            
            self.commonPickerView = [[UIPickerView alloc] init];
            self.commonPickerView.backgroundColor = [UIColor whiteColor];
            self.commonPickerView.delegate = self;
            [self addSubview:self.commonPickerView];
            self.toolView.titleLabel.text = @"选择人数";
        }else if (self.type == ChoosePopupContentDateYYYYMMDD){
            
            self.datePickerView = [[UIDatePicker alloc] init];
            self.datePickerView.timeZone = [NSTimeZone localTimeZone];
            self.datePickerView.maximumDate = [NSDate date];
            self.datePickerView.datePickerMode = UIDatePickerModeDate;
            self.datePickerView.backgroundColor = [UIColor whiteColor];
            [self.datePickerView addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.datePickerView];
            self.toolView.titleLabel.text = @"时间";
        }else {
            
            self.datePickerView = [[UIDatePicker alloc] init];
            self.datePickerView.timeZone = [NSTimeZone localTimeZone];
            self.datePickerView.minimumDate = [NSDate date];
            self.datePickerView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000];
            self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            self.datePickerView.backgroundColor = [UIColor whiteColor];
            self.datePickerView.minuteInterval = 30;
            [self.datePickerView addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.datePickerView];
            self.toolView.titleLabel.text = @"时间";
        }
    }
    return self;
}

- (void)didMoveToSuperview{

    [super didMoveToSuperview];
    [self selectedDate:self.datePickerView];
    //[self.datePickerView setDate:[NSDate date] animated:YES];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    if (self.type == ChoosePopupContentCommom) {
        [self.commonPickerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.toolView.mas_bottom);
            make.left.mas_equalTo(self.toolView.mas_left);
            make.right.mas_equalTo(self.toolView.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }else{
    
        [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.toolView.mas_bottom);
            make.left.mas_equalTo(self.toolView.mas_left);
            make.right.mas_equalTo(self.toolView.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
}
- (void) configChooseViewWithData:(NSArray *)data{

    if (self.type == ChoosePopupContentCommom) {
        self.commomDatas = data;
        [self.commonPickerView reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.commomDatas.count;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.commomDatas[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.commomSelectData = self.commomDatas[row];
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel * cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:16];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.text = self.commomDatas[row];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    cityLabel.frame = CGRectMake(0, 0, screenWidth / 3, 30);
    
    return cityLabel;
}


#pragma mark -
#pragma mark Action M

- (void) cancelButtonHandle{
    
    if (self.bCancelHandle) {
        self.bCancelHandle();
    }
    
    [self closePopup];
}

- (void) sureButtonHandle{
    
    if ((!self.commomSelectData) && self.type == ChoosePopupContentDate) {
        self.commomSelectData = [NSDate date];
    }
    
    if ((!self.commomSelectData) && self.type == ChoosePopupContentCommom) {
        self.commomSelectData = self.commomDatas[0];
    }
    
    if (self.bSureHandle) {
        self.bSureHandle(self.commomSelectData);
    }
    [self closePopup];
}

- (void) selectedDate:(UIDatePicker *)datePicker{

    self.commomSelectData = datePicker.date;
}

#pragma mark -
#pragma mark PopupContentViewDelegate

- (CGRect)showRect{
    
    CGFloat height = 0.0f;
    height += 50;
    height += 216;
    
    return CGRectMake(0, (DEF_SCREEN_HEIGHT - height), DEF_SCREEN_WIDTH, height);
}

@end
