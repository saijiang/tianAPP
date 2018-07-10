//
//  ChooseDateView.m
//  LankeProject
//
//  Created by Youngrocky on 16/6/24.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ChooseDateView.h"


@interface ChooseDateView ()

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (strong ,nonatomic) NSString *dateString;

@property (strong,nonatomic) UIView *contentView;

@end

@implementation ChooseDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundViewHidenTimeSelectView:)];
        self.backgroundView = [[UIView alloc] initWithFrame:frame];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        [self.backgroundView addGestureRecognizer:tapGesture];
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
        
        CGFloat height = 216.0f;
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _contentView.frame = CGRectMake(0, frame.size.height - height - 50, frame.size.width, height +50);
        [self.backgroundView addSubview:_contentView];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"取消";
        titleLabel.font = BM_FONTSIZE(15);
        titleLabel.frame = CGRectMake(20, 0, 40, 50);
        [_contentView addSubview:titleLabel];
        
        UILabel * saveLabel = [[UILabel alloc] init];
        saveLabel.text = @"保存";
        saveLabel.font = BM_FONTSIZE(15);
        saveLabel.textColor = BM_Color_Blue;
        saveLabel.frame = CGRectMake(DEF_SCREEN_WIDTH-40, 0, 40, 50);
        [_contentView addSubview:saveLabel];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(0, 0, 80, 50);
        [cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
         {
             [self tapBackgroundViewHidenTimeSelectView:nil];
             
         }];
        [_contentView addSubview:cancleBtn];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - 80, 0, 80, 50);
        [saveBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
         {
             
             if (self.resultBlock)
             {
                 self.resultBlock(_dateString);
             }
             [self tapBackgroundViewHidenTimeSelectView:nil];
             
         }];
        [_contentView addSubview:saveBtn];
        
        
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, _contentView.width, _contentView.height - titleLabel.height)];
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        self.datePickerView.backgroundColor = [UIColor whiteColor];
        self.datePickerView.timeZone = [NSTimeZone localTimeZone];
        [self.datePickerView addTarget:self action:@selector(datePickerViewDidSelectedHandle:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.datePickerView];
        
        
    }
    return self;
}

#pragma mark - API

- (void) showDateSelectViewAtView:(UIView *)view{
    
    if (view != nil) {
        [view addSubview:self];
    }
    else{
        [KAPPDELEGATE.window addSubview:self];
    }
    
    self.backgroundView.alpha = 0;
    CGRect frame = self.datePickerView.frame;
    frame.origin.y = DEF_SCREEN_HEIGHT;
    self.datePickerView.frame = frame;
    
    frame.origin.y = DEF_SCREEN_HEIGHT - 216;
    
    [UIView animateWithDuration:.25 animations:^{
        self.datePickerView.frame = frame;
        self.backgroundView.alpha = 1;
    }];
    
    [self datePickerViewDidSelectedHandle:self.datePickerView];

}

- (void) scrollDateSelectViewWithDate:(NSDate *)date{
    
    [self.datePickerView setDate:date animated:YES];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * selectData = [dateFormatter stringFromDate:date];
    _dateString = selectData;
}

#pragma mark - Method

- (IBAction)tapBackgroundViewHidenTimeSelectView:(UITapGestureRecognizer *)sender {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 216.0+50.0);
        self.datePickerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 216);
    } completion:^(BOOL finished) {
        self.backgroundView = nil;
        self.datePickerView = nil;
        [self removeFromSuperview];
        
    }];
    
}

- (void) datePickerViewDidSelectedHandle:(UIDatePicker *)datePicker{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * selectData = [dateFormatter stringFromDate:datePicker.date];
    _dateString = selectData;

}
@end
