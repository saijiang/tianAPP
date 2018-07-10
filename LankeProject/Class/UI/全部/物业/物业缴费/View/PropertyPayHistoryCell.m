//
//  PropertyPayHistoryCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPayHistoryCell.h"

@interface PropertyPayHistoryCell ()

@property (nonatomic ,strong) UILabel * oneLabel;

@property (nonatomic ,strong) UILabel * twoLabel;
@property (nonatomic ,strong) UILabel * threeLabel;
@property (nonatomic ,strong) UILabel * fourLabel;

@property (nonatomic ,strong) UIView * lineView;
@end

@implementation PropertyPayHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.oneLabel = [UnityLHClass masonryLabel:@"" font:16 color:[UIColor colorWithHexString:@"454545"]];
        [self.contentView addSubview:self.oneLabel];
        self.oneLabel.numberOfLines = 2;
        
//        self.twoLabel = [UnityLHClass masonryLabel:@"" font:16 color:[UIColor colorWithHexString:@"454545"]];
//        self.twoLabel.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:self.twoLabel];
        
        self.threeLabel = [UnityLHClass masonryLabel:@"" font:16 color:[UIColor colorWithHexString:@"454545"]];
        self.threeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.threeLabel];
        
        self.fourLabel = [UnityLHClass masonryLabel:@"" font:16 color:[UIColor colorWithHexString:@"454545"]];
        [self.contentView addSubview:self.fourLabel];
        self.fourLabel.textAlignment = NSTextAlignmentRight;
        
        self.lineView = [UIView lineView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat width1=[UnityLHClass getWidth:@"2017.10~~2017.10" wid:30 font:16];
    
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(width1);
    }];
    
//    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.mas_equalTo(self.oneLabel.mas_right);
//        make.centerY.mas_equalTo(self.oneLabel.mas_centerY);
//        make.width.mas_equalTo(70);
//    }];
    
    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.oneLabel.mas_right);
        make.centerY.mas_equalTo(self.oneLabel.mas_centerY);
        make.width.mas_equalTo(140);
    }];
    
    [self.fourLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.threeLabel.mas_right);
        make.centerY.mas_equalTo(self.oneLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}


+ (NSString *) cellIdentifier{
    
    return @"PropertyBillCell";
}

- (void)configCellWithData:(id)data{
    //billType 	String 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
    NSString *billType=@"水费";
    NSString * useNum=@"  ";
    switch ([data[@"billType"] integerValue])
    {
        case 1:
        {
            billType=@"水费";
//            useNum=[data[@"useNum"] stringByAppendingString:@"吨"];
        }
            break;
        case 2:
        {
            billType=@"网费/电话费";
        }
            break;
            
        case 3:
        {
            billType=@"停车费";
            
        }
            break;
            
        case 4:
        {
            billType=@"供暖费";
            
        }
            break;
            
        case 5:
        {
            billType=@"物业费";
            
        }
            break;
            
        case 6:
        {
            billType=@"生活热水费";
//            useNum=[data[@"useNum"] stringByAppendingString:@"吨"];

        }
            break;
            
        case 7:
        {
            billType=@"燃气费";
//            useNum=[data[@"useNum"] stringByAppendingString:@"立方"];

            
        }
            break;
            
            
        default:
            break;
    }

   // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy年MM月" andTimeString:data[@"billMonth"]];
    NSString*time=@"";
    NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
    NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
    if (time2.length!=0) {
        
        if ([time1 isEqualToString:time2]) {
            
            time=time1;
            
        }else{
            
            time=[NSString stringWithFormat:@"%@~%@",time1,time2];
            
        }
    }else{
        
        time=time1;
        
        
    }
    //2016年8月水费账单
    self.oneLabel.text=[NSString stringWithFormat:@"%@\n%@账单",time,billType];
//    self.twoLabel.text=useNum;
    self.threeLabel.text=[NSString stringWithFormat:@"%.2f元",[data[@"billAmount"] floatValue]];
    NSString *billPayTime=[UnityLHClass getCurrentTimeWithType:@"yyyy/MM/dd" andTimeString:data[@"billPayTime"]];
    self.fourLabel.text=billPayTime;
    
}

+ (CGFloat) cellHeightWithData:(id)data{

    return 50.0f;
}
@end
