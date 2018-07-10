//
//  ChooseAddressPopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChooseAddressPopupContentView.h"

@interface ChooseAddressPopupContentView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *commonPickerView;

@property (nonatomic ,strong) NSArray * commomDatas;
@property (nonatomic ,strong) id commomSelectData;

@property (nonatomic, copy) NSString *key;

@property (nonatomic ,assign) NSInteger selectIndex;

@end

@implementation ChooseAddressPopupContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectIndex = 0;
        
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
        self.toolView.cancelButton.hidden=NO;

        self.commonPickerView = [[UIPickerView alloc] init];
        self.commonPickerView.backgroundColor = [UIColor whiteColor];
        self.commonPickerView.delegate = self;
        [self addSubview:self.commonPickerView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.commonPickerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.toolView.mas_bottom);
        make.left.mas_equalTo(self.toolView.mas_left);
        make.right.mas_equalTo(self.toolView.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

}
- (void) configChooseViewWithData:(NSArray *)data withTitleKey:(NSString *)key{
    
    self.commomDatas = data;
    self.key = key;
    [self.commonPickerView reloadAllComponents];
    
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.commomDatas.count;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    id source = self.commomDatas[row];
    NSString *str = nil;
    if ([source isKindOfClass:[NSDictionary class]])
    {
        str = source[self.key];
    }
    else
    {
        str = source;
    }
    
    return str;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.commomSelectData = self.commomDatas[row];
    
    self.selectIndex = row;
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    id source = self.commomDatas[row];
    NSString *str = nil;
    if ([source isKindOfClass:[NSDictionary class]])
    {
        str = source[self.key];
    }
    else
    {
        str = source;
    }
    
    UILabel * cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:16];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.text = str;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    cityLabel.frame = CGRectMake(0, 0, screenWidth, 30);
    
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
    
    if (self.bSureHandle) {
        self.bSureHandle(self.commomSelectData,self.selectIndex);
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
// YES：点击空的区域可以hide
- (BOOL)isAlert
{
    return YES;
}

@end
