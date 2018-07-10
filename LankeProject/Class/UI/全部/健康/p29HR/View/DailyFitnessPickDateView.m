//
//  DailyFitnessPickDateView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "DailyFitnessPickDateView.h"
#import "ChooseDateView.h"
@interface DailyFitnessPickDateView ()


@end

@implementation DailyFitnessPickDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        _dateLabel = [UnityLHClass masonryLabel:locationString font:15 color:BM_BLACK];
        [self addSubview:self.dateLabel];
        
        _iconImageView = [[LocalhostImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"health_daily_fitness_calendar"];
        [self addSubview:self.iconImageView];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) tapHandle:(UITapGestureRecognizer *)gesture{
    
    ChooseDateView * chooseDate = [[ChooseDateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    chooseDate.resultBlock = ^(NSString * date){
        self.dateLabel.text=date;
        [self sendObject:self.dateLabel.text];
        

    };
    
    [chooseDate showDateSelectViewAtView:nil];
    NSString* string =self.dateLabel.text;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    [chooseDate scrollDateSelectViewWithDate:inputDate];
    

    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.dateLabel.centerY);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{

    return [[DailyFitnessPickDateView alloc] init];
}

@end
