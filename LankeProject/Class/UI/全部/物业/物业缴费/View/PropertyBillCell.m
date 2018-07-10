//
//  PropertyBillCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyBillCell.h"
#import "PropertyBillModel.h"
@interface PropertyBillCell ()

@property (nonatomic ,strong) UILabel * billTitleLabel;
@property (nonatomic ,strong) UILabel * billPriceLabel;
@property (nonatomic ,strong) UIButton * checkButton;
@property (nonatomic ,strong) UIView * lineView;

@end

@implementation PropertyBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.billTitleLabel = [UnityLHClass masonryLabel:@"2016年8月水费账单" font:16 color:[UIColor colorWithHexString:@"#454545"]];
        [self.contentView addSubview:self.billTitleLabel];
        
        self.billPriceLabel = [UnityLHClass masonryLabel:@"50元" font:16 color:[UIColor colorWithHexString:@"#454545"]];
        self.billPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.billPriceLabel];
        
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkButton setImage:[UIImage imageNamed:@"no_choose"] forState:UIControlStateNormal];
        [self.checkButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [self.checkButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * sender) {
            [self sendObject:@"check"];
        }];
        [self.contentView addSubview:self.checkButton];
        
        self.lineView = [UIView lineView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.billTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.billPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.billTitleLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}


+ (NSString *) cellIdentifier{

    return @"PropertyBillCell";
}
-(void)loadCellWithDataSource:(PropertyBillModel *)dataSource
{
    self.checkButton.selected=dataSource.isSeleted;
    NSDictionary *data=dataSource.data;
    //billType 	String 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
    NSString *billType=@"水费";
    switch ([data[@"billType"] integerValue])
    {
        case 1:
        {
            billType=@"水费";
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
        }
            break;
            
        case 7:
        {
            billType=@"燃气费";
            
        }
            break;
            
            
        default:
            break;
    }
    
   // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy年MM月" andTimeString:data[@"billMonth"]];
   
    //2016年8月水费账单
    NSString*timeStr=@"";
    NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
    NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
    if (time2.length!=0) {
        
        if ([time1 isEqualToString:time2]) {
            
            timeStr=time1;
            
        }else{
            
           timeStr=[NSString stringWithFormat:@"%@~%@",time1,time2];
            
        }
    }else{
        
       timeStr=time1;
        
        
    }
    
    self.billTitleLabel.text=[NSString stringWithFormat:@"%@%@账单", timeStr,billType];
    self.billPriceLabel.text=[NSString stringWithFormat:@"%.2f元",[data[@"billAmount"] floatValue]];
}

- (void)configCellWithData:(id)data{
    
  
}
@end

@interface PropertyBillSingelCell ()

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation PropertyBillSingelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.billTitleLabel = [UnityLHClass masonryLabel:@"2016年8月水费账单" font:16 color:[UIColor colorWithHexString:@"#454545"]];
        [self.contentView addSubview:self.billTitleLabel];
        
        self.billDetailLabel = [UnityLHClass masonryLabel:@"50元" font:16 color:[UIColor colorWithHexString:@"#454545"]];
        self.billDetailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.billDetailLabel];
        
        self.lineView = [UIView lineView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.billTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.billDetailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.billTitleLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

+ (NSString *) cellIdentifier{
    
    return @"PropertyBillSingelCell";
}

- (void)configCellWithData:(id)data{
    
    self.billTitleLabel.text = [NSString stringWithFormat:@"%@",data[@"title"]];
    
    self.billDetailLabel.text = [NSString stringWithFormat:@"%@",data[@"detail"]];
    
}
@end
