//
//  PropertyPayHistoryHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayHistoryHeaderView.h"
#import "ChoosePopupContentView.h"
@interface PropertyPayHistoryHeaderView ()
{
    NSString *currentDate;
    UIView *topView;
}
@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) UILabel * categoryDisplayLabel;
@property (nonatomic ,strong) LocalhostImageView * arrowImageView;

@property (nonatomic ,strong) UIView * lineView;

@property (nonatomic ,strong) UILabel * timeDisplayLabel;
@property (nonatomic ,strong) UIView * sepView;


@end
@implementation PropertyPayHistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.categoryDisplayLabel = [UnityLHClass masonryLabel:@"分类" font:17 color:[UIColor blackColor]];
        [self.contentView addSubview:self.categoryDisplayLabel];
        
        self.categoryLabel = [UnityLHClass masonryLabel:@"全部" font:17 color:[UIColor colorWithHexString:@"454545"]];
        self.categoryLabel.textAlignment = NSTextAlignmentRight;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        self.categoryLabel.userInteractionEnabled = YES;
        [self.categoryLabel addGestureRecognizer:tap];
        [self.contentView addSubview:self.categoryLabel];
        
        self.arrowImageView = [[LocalhostImageView alloc] init];
        self.arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:self.arrowImageView];
        
        self.lineView = [UIView lineView];
        [self.contentView addSubview:self.lineView];
        
        self.timeDisplayLabel = [UnityLHClass masonryLabel:@"时间" font:17 color:[UIColor blackColor]];
        [self.contentView addSubview:self.timeDisplayLabel];
        
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy"];
        NSString *  startTimeOne=[dateformatter stringFromDate:senddate];
        NSString *  startTime=[NSString stringWithFormat:@"%@/01",startTimeOne];
        self.startTimeButton = [RightImageButton buttonWithType:UIButtonTypeCustom];
        self.startTimeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.startTimeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.startTimeButton setImage:[UIImage imageNamed:@"property_history_riqi"] forState:UIControlStateNormal];
        [self.startTimeButton setTitle:startTime forState:UIControlStateNormal];
        [self.startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.startTimeButton addTarget:self action:@selector(dateBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.startTimeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self createPickerType:@"1"];
        }];
        [self.contentView addSubview:self.startTimeButton];
        
        self.sepView = [UIView lineView];
        self.sepView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.sepView];
        
        NSDateFormatter  *dateformatterTwo=[[NSDateFormatter alloc] init];
        [dateformatterTwo setDateFormat:@"yyyy/MM"];
        NSString *  endTime=[dateformatterTwo stringFromDate:senddate];
        self.endTimeButton = [RightImageButton buttonWithType:UIButtonTypeCustom];
        self.endTimeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.endTimeButton setImage:[UIImage imageNamed:@"property_history_riqi"] forState:UIControlStateNormal];
        self.endTimeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.endTimeButton setTitle:endTime forState:UIControlStateNormal];
        [self.endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
//          [self.endTimeButton addTarget:self action:@selector(dateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.endTimeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self createPickerType:@"2"];
        }];
        [self.contentView addSubview:self.endTimeButton];
    }
    return self;
}
//-(void)dateBtn:(UIButton*)btn
//{
//    switch (btn.tag-100) {
//        case 1:
//            
//            break;
//        case 2:
//            
//            break;
//            
//        default:
//            break;
//    }
//}
- (void) tapHandle:(id)sender{
    if (self.bTypeHandle) {
        self.bTypeHandle();
    }
}

-(void)chooseStartTime
{
    WeakSelf
    ChoosePopupContentView * choosepopupContentView = [[ChoosePopupContentView alloc] initPopupViewWithType:ChoosePopupContentDateYYYYMMDD];
    choosepopupContentView.bSureHandle = ^(NSDate * data){
        NSString * date = [data stringForNormalDataFormatter:@"YYYY/MM"];
        [weakSelf.startTimeButton setTitle:date forState:UIControlStateNormal];
        if (weakSelf.bChooseStartHandle) {
            weakSelf.bChooseStartHandle();
        }
        [self sendObject:date];

    };
    HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
    [popupView show:YES];

}
-(void)chooseEndTime
{
    WeakSelf
    ChoosePopupContentView * choosepopupContentView = [[ChoosePopupContentView alloc] initPopupViewWithType:ChoosePopupContentDateYYYYMMDD];
    choosepopupContentView.bSureHandle = ^(NSDate * data){
        NSString * date = [data stringForNormalDataFormatter:@"YYYY/MM"];
        [weakSelf.endTimeButton setTitle:date forState:UIControlStateNormal];
        if (weakSelf.bChooseEndHandle) {
            weakSelf.bChooseEndHandle();
        }
        [self sendObject:date];
    };
    HLLPopupView * popupView = [HLLPopupView tipInWindow:choosepopupContentView];
    [popupView show:YES];

}

- (void)layoutSubviews{

    [super layoutSubviews];

    CGFloat height = (CGRectGetHeight(self.bounds) - 20) / 2;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
//    
    [self.categoryDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self.categoryDisplayLabel.mas_centerY);
    }];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(self.categoryDisplayLabel.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(self.categoryDisplayLabel.mas_bottom);
    }];
    
    [self.timeDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.categoryDisplayLabel.mas_left);
        make.top.mas_equalTo(self.categoryDisplayLabel.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.lineView.mas_right);
        make.centerY.mas_equalTo(self.timeDisplayLabel.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.timeDisplayLabel.mas_centerY);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.endTimeButton.mas_left).mas_offset(-10);
        make.width.mas_equalTo(30);
    }];
    
    [self.startTimeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.sepView.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.timeDisplayLabel.mas_centerY);
        make.width.mas_equalTo(self.endTimeButton.mas_width);
        make.height.mas_equalTo(self.endTimeButton.mas_height);
    }];
}
-(void)createPickerType:(NSString*)str{
    
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH , DEF_SCREEN_HEIGHT)];
    
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    topView.userInteractionEnabled=YES;
//    topView.hidden=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:topView];
    
    UIView*opView = [[UIView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT-246, DEF_SCREEN_WIDTH , 246)];
    opView.backgroundColor = [UIColor whiteColor];
    opView.alpha=1.0;
    [topView addSubview:opView];
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,40)];
    selectView.backgroundColor = [UIColor colorWithHexString:@"#4E98F5"];
    
    [opView addSubview:selectView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 50, 40);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-60, 0, 50, 40);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=[str integerValue];
    [selectView addSubview:rightBtn];
    
    FullTimeView *fullTimePicker = [[FullTimeView alloc]initWithFrame:CGRectMake(0, 30, DEF_SCREEN_WIDTH, 216)];
    fullTimePicker.curDate = [NSDate date];
    fullTimePicker.delegate = self;
    [opView addSubview:fullTimePicker];
}
#pragma mark-----日历选择器

#pragma mark------取消选择器
-(void)cancleBtnClick{
    topView.hidden=YES;
}
#pragma mark------确定
-(void)okBtnClick:(UIButton*)btn{
    topView.hidden=YES;
    switch (btn.tag) {
        case 1:{
            //获取当前时间
            if (currentDate==nil) {
                
            }else{
                
                [self.startTimeButton setTitle:currentDate forState:UIControlStateNormal];
                NSLog(@"%@",currentDate);
                
                
            }
            
            
            break;
        }
        case 2:{
            //获取当前时间
            if (currentDate==nil) {
                
            }else{
                
                [self.endTimeButton setTitle:currentDate forState:UIControlStateNormal];
                NSLog(@"%@",currentDate);
                
                
            }
            
            break;
        }

            
        default:
            break;
    }
     [self sendObject:currentDate];
    
}
#pragma mark - FinishPickView
- (void)didFinishPickView:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM";
    NSString *dateString = [fmt stringFromDate:date];
    currentDate = dateString;

}


#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{

    return [[self alloc] init];
}

@end
