//
//  FitAddSportView.m
//  LankeProject
//
//  Created by itman on 2017/7/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitAddSportView.h"
#import "LKToolView.h"

@interface FitAddSportView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong) LKToolView * toolView;
@property (strong, nonatomic) UIPickerView *commonPickerView;

@property (nonatomic ,strong) NSArray * sportsNameDatas;
@property (nonatomic ,strong) NSArray * sportsTimeDatas;

@property (nonatomic ,copy) NSString * sportsTime;
@property (nonatomic ,copy) NSString * sportsId;


@end

@implementation FitAddSportView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        self.sportsNameDatas=@[@{@"sportsName":@"散步",@"id":@"01"},
                               @{@"sportsName":@"慢跑",@"id":@"02"},
                               @{@"sportsName":@"游泳",@"id":@"03"},
                               @{@"sportsName":@"田径",@"id":@"04"},
                               @{@"sportsName":@"篮球",@"id":@"05"},
                               @{@"sportsName":@"自行车",@"id":@"06"},
                               @{@"sportsName":@"骑马",@"id":@"07"},
                               @{@"sportsName":@"羽毛球 ",@"id":@"08"},
                               @{@"sportsName":@"高尔夫",@"id":@"09"},
                               @{@"sportsName":@"足球",@"id":@"10"},
                               @{@"sportsName":@"跳绳",@"id":@"11"},
                               @{@"sportsName":@"壁球",@"id":@"12"},
                               @{@"sportsName":@"网球",@"id":@"13"},
                               @{@"sportsName":@"乒乓球",@"id":@"14"},
                               @{@"sportsName":@"排球",@"id":@"15"},
                               ];
        self.sportsTimeDatas=@[@"15",@"30",@"45",@"60",@"75",@"90",];

        self.sportsId=self.sportsNameDatas.firstObject[@"id"];
        self.sportsTime=self.sportsTimeDatas.firstObject;

        LKWeakSelf
        self.toolView = [[LKToolView alloc] init];
        self.toolView.titleLabel.text=@"添加运动";
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
#pragma mark -
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        return self.sportsNameDatas.count;
    }
    return self.sportsTimeDatas.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component==0)
    {
        return self.sportsNameDatas[row][@"sportsName"];
    }
    else
    {
        return [NSString stringWithFormat:@"%@分钟",self.sportsTimeDatas[row]];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        self.sportsId= self.sportsNameDatas[row][@"id"];
    }
    else
    {
        self.sportsTime= self.sportsTimeDatas[row];
    }
}

#pragma mark Action M

- (void) cancelButtonHandle
{
    [self hideView];
}
- (void) sureButtonHandle
{
    [UserServices
     insertSportsPlanWithUserId:[KeychainManager readUserId]
     userName:[KeychainManager readUserName]
     fitnessPlanId:self.data[@"id"]
     sportsName:self.sportsId
     sportsTime:self.sportsTime
     targetCalorie:self.data[@"targetCalorie"]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0) {
            [self sendObject:@"reload"];
        }
        else{
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    [self hideView];

}


@end
