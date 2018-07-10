//
//  GridTableViewCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GridTableViewCell.h"
#import "UIView+AutoLayoutSupport.h"

@interface GridTableViewCell ()

@property (nonatomic ,weak) IBOutlet UIView * lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gridLabelWidthConstrint;

@end

@implementation GridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = BM_WHITE;
        self.gridNumber = 5;
        self.bottomlineWithColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];

    }
    return self;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    self.lineViewHeightConstraint.constant = 1.0/[UIScreen mainScreen].scale;
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    // bug here :不知道什么原因，会多出来在nib中设置的视图宽度。。。wtf
    // 7p手机显示两个：width=207，nib中是83，但是展示到屏幕上就是290
    // 暂时使用硬编码减去多余的吧
    CGFloat width = self.contentView.bounds.size.width/self.gridNumber;
    self.gridLabelWidthConstrint.constant = width - DEF_SCREEN_WIDTH/5;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (UINib *) nib{

    return [UINib nibWithNibName:[self cellIdentifier] bundle:nil];
}

+ (NSString *) cellIdentifier{

    return NSStringFromClass([self class]);
}

+ (CGFloat) cellHeight{

    return 50.0f;
}

#pragma mark -
#pragma mark GridConfigProtocol

// 按照依左边的使用来显示右边多余的label
- (void) setupSpecialForTwoGrid{
    
    self.gridNumber = 2;
    [self.grid3Label ADKHideViewWidth];
    [self.grid4Label ADKHideViewWidth];
    [self.grid5Label ADKHideViewWidth];
}

- (void) setupSpecialForThreeGrid{

    self.gridNumber = 3;
    [self.grid4Label ADKHideViewWidth];
    [self.grid5Label ADKHideViewWidth];
}

// 历史健身数据
- (void) configFitnessHistory:(id)data{
    
    [self setupSpecialForTwoGrid];
  
    self.grid1Label.text = data[@"fitnessDate"];
    self.grid2Label.text = [NSString stringWithFormat:@"%@千卡",data[@"consumeCalories"]];
    
    
}

// 单位人员患病情况
- (void) configEmployeeIllInfo:(id)data{

    [self setupSpecialForThreeGrid];
    
    self.grid3Label.textColor = [UIColor colorWithRed:1.00 green:0.69 blue:0.08 alpha:1.00];
    
    NSString * type = @"";
    if ([data[@"bodyInfoType"]  isEqual: @"01"]) {
        type = @"糖尿病";
    }
    if ([data[@"bodyInfoType"]  isEqual: @"02"]) {
        type = @"心脏病";
    }
    if ([data[@"bodyInfoType"]  isEqual: @"03"]) {
        type = @"高血压";
    }
    if ([data[@"bodyInfoType"]  isEqual: @"04"]) {
        type = @"低血压";
    }
    if ([data[@"bodyInfoType"]  isEqual: @"05"]) {
        type = @"低血糖";
    }
    self.grid1Label.text = type;//@"糖尿病";
    self.grid2Label.text = data[@"bodyInfoNum"];//@"110";
    self.grid3Label.text = data[@"bodyInfoScale"];//@"100%";
}

// 查看当前健身计划明细
- (void) configFitnessPlanDetail:(id)data{

    [self setupSpecialForThreeGrid];
    
    self.grid3Label.textColor = [UIColor colorWithRed:1.00 green:0.69 blue:0.08 alpha:1.00];
    
    self.grid1Label.text = data[@"fitnessDate"];//@"2016.11.3";
    self.grid2Label.text = [NSString stringWithFormat:@"%@千卡",data[@"consumeCalories"]];//@"110千卡";
    self.grid3Label.text = data[@"todayCompletePer"];//@"90%";
}

// 查看手动添加运动明细
- (void) configAddSportFitnessPlanDetail:(id)data{
    
    [self setupSpecialForThreeGrid];
    self.grid3Label.textColor = self.grid1Label.textColor;
    self.grid1Label.text = [self sportsNameWithKey:data[@"sportsName"]];
    self.grid2Label.text = [NSString stringWithFormat:@"%@分钟",data[@"sportsTime"]];
    self.grid3Label.text = [NSString stringWithFormat:@"%@千卡",data[@"sportsCalorie"]];
}

-(NSString*)sportsNameWithKey:(NSString *)key
{
    // sportsName 	String 	运动项目 01：散步 02：慢跑 03：游泳 04：田径:05：篮球 06：自行车 07：骑马 08：羽毛球 09：高尔夫 10：足球 11：跳绳 12：壁球 13：网球 14：乒乓球 15：排球
    NSDictionary *sportsNameDic=@{
                                  @"01":@"散步",
                                  @"02":@"慢跑",
                                  @"03":@"游泳",
                                  @"04":@"田径",
                                  @"05":@"篮球",
                                  @"06":@"自行车",
                                  @"07":@"骑马",
                                  @"08":@"滑冰",
                                  @"09":@"高尔夫",
                                  @"10":@"足球",
                                  @"11":@"跳绳",
                                  @"12":@"壁球",
                                  @"13":@"网球",
                                  @"14":@"乒乓球",
                                  @"15":@"排球",
                                  };
    
    return sportsNameDic[key];
    
}


// 每日健身情况
- (void) configDailyFitness:(id)data{

    self.gridNumber = 5;
    self.grid5Label.textColor = [UIColor colorWithRed:1.00 green:0.69 blue:0.08 alpha:1.00];
    self.grid1Label.text = data[@"userName"];//@"张九";
    self.grid2Label.text = @"-";//@"0920";
    if ([data[@"employeeNum"] length]>0) {
        self.grid2Label.text = data[@"employeeNum"];//@"0920";

    }
    self.grid3Label.text = data[@"consumeCalories"];//@"230";
    self.grid4Label.text = data[@"targetCalories"];//@"110";
    self.grid5Label.text = data[@"todayCompletePer"];//@"90%";

}

// 患病明细
- (void) configIllDetail:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = data[@"userName"];//@"张九";
    self.grid2Label.text = @"-";//@"0920";
    if ([data[@"employeeNum"] length]>0) {
        self.grid2Label.text = [NSString stringWithFormat:@"工号%@",data[@"employeeNum"]];//@"工号00920";
        
    }

    self.grid3Label.text = data[@"mobileNum"];//@"1776234347";
}

- (void)configTCM:(id)data{

    [self setupSpecialForThreeGrid];
    self.grid3Label.textColor = [UIColor colorWithRed:1.00 green:0.69 blue:0.08 alpha:1.00];

    NSString * type = @"";
    if ([data[@"physicalType"]  isEqual: @"01"]) {
        type = @"平和质";
    }
    if ([data[@"physicalType"]  isEqual: @"02"]) {
        type = @"气虚质";
    }
    if ([data[@"physicalType"]  isEqual: @"03"]) {
        type = @"阳虚质";
    }
    if ([data[@"physicalType"]  isEqual: @"04"]) {
        type = @"阴虚质";
    }
    if ([data[@"physicalType"]  isEqual: @"05"]) {
        type = @"痰虚质";
    }
    if ([data[@"physicalType"]  isEqual: @"06"]) {
        type = @"湿热质";
    }
    if ([data[@"physicalType"]  isEqual: @"07"]) {
        type = @"血瘀质";
    }
    if ([data[@"physicalType"]  isEqual: @"08"]) {
        type = @"气虚质";
    }
    if ([data[@"physicalType"]  isEqual: @"09"]) {
        type = @"特禀质";
    }
    self.grid1Label.text = type;
    self.grid2Label.text = data[@"physicalNum"];
    self.grid3Label.text = data[@"physicalScale"];
}

@end
