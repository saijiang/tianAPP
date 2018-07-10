//
//  HealthExamEvaluateView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamEvaluateView.h"

@interface HealthExamEvaluateView ()

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UILabel * contentLabel;
@property (nonatomic ,strong) UILabel * displayInfoLabel;
@property (nonatomic ,strong) UIButton * foldButton;

@end

@implementation HealthExamEvaluateView

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"评析" font:15 color:BM_Color_BlackColor];
        self.displayLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.displayLabel];
        

        self.displayInfoLabel = [UnityLHClass masonryLabel:@"" font:14 color:BM_BLACK];
        self.displayInfoLabel.numberOfLines=3;
        [self addSubview:self.displayInfoLabel];
        
        self.foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.foldButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * sender) {
            if (self.bFoldButtonHandle) {
                self.bFoldButtonHandle(sender.isSelected);
            }
            sender.selected = !sender.isSelected;
            self.displayInfoLabel.numberOfLines=3;
            if (sender.selected) {
                self.displayInfoLabel.numberOfLines=0;

            }
            [self layoutIfNeeded];
        }];
        [self.foldButton setImage:[UIImage imageNamed:@"health_result_down_arrow"] forState:UIControlStateNormal];
        [self.foldButton setImage:[UIImage imageNamed:@"health_result_up_arrow"] forState:UIControlStateSelected];
        [self addSubview:self.foldButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.mas_equalTo(30);
//        make.top.mas_equalTo(30);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-30);
//        make.bottom.mas_equalTo(self.mas_bottom);
//    }];
    [self.displayInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.displayLabel.mas_bottom);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);

    }];
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.displayLabel.mas_centerY);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.displayLabel.mas_top).offset(-10);
        make.bottom.mas_equalTo(self.displayInfoLabel.mas_bottom).offset(10);

    }];
}

- (void)config:(id)data{

//    content 	String 	自测评析（没有疾病时返回）
//    diabetes 	String 	自测评析（患糖尿病时返回）
//    heartDisease 	String 	自测评析（患心脏病时返回）
//    hypertension 	String 	自测评析（患高血压时返回）
//    hypopiesia 	String 	自测评析（患低血压时返回）
//    glucopenia 	String 	自测评析（患低血糖时返回）
    NSString *content=@"";
    if (data[@"content"])
    {
        content=data[@"content"];
    }
    NSString *diabetes=@"";
    if (data[@"diabetes"])
    {
        diabetes=@"\n糖尿病";
        diabetes=[diabetes stringByAppendingString:@"\n"];
        diabetes=[diabetes stringByAppendingString:data[@"diabetes"]];
        diabetes=[diabetes stringByAppendingString:@"\n"];


    }
    NSString *heartDisease=@"";
    if (data[@"heartDisease"])
    {
        heartDisease=@"\n心脏病";
        heartDisease=[heartDisease stringByAppendingString:@"\n"];
        heartDisease=[heartDisease stringByAppendingString:data[@"heartDisease"]];
        heartDisease=[heartDisease stringByAppendingString:@"\n"];

    }
    NSString *hypertension=@"";
    if (data[@"hypertension"])
    {
        hypertension=@"\n高血压";
        hypertension=[hypertension stringByAppendingString:@"\n"];
        hypertension=[hypertension stringByAppendingString:data[@"hypertension"]];
        hypertension=[hypertension stringByAppendingString:@"\n"];

    }
    NSString *hypopiesia=@"";
    if (data[@"hypopiesia"])
    {
        hypopiesia=@"\n低血压";
        hypopiesia=[hypopiesia stringByAppendingString:@"\n"];
        hypopiesia=[hypopiesia stringByAppendingString:data[@"hypopiesia"]];
        hypopiesia=[hypopiesia stringByAppendingString:@"\n"];

    }
    NSString *glucopenia=@"";
    if (data[@"glucopenia"])
    {
        glucopenia=@"\n低血糖";
        glucopenia=[glucopenia stringByAppendingString:@"\n"];
        glucopenia=[glucopenia stringByAppendingString:data[@"glucopenia"]];
        glucopenia=[glucopenia stringByAppendingString:@"\n"];

    }
    self.displayInfoLabel.text=[NSString stringWithFormat:@"%@%@%@%@%@%@",content,diabetes,heartDisease,hypertension,hypopiesia,glucopenia];
    
    NSString * displayInfoLabelString = self.displayInfoLabel.text;
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:displayInfoLabelString];
    [att addAttributes:@{NSForegroundColorAttributeName:BM_BLACK,NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} range:[displayInfoLabelString rangeOfString:@"\n糖尿病\n"]];
    [att addAttributes:@{NSForegroundColorAttributeName:BM_BLACK,NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} range:[displayInfoLabelString rangeOfString:@"\n心脏病\n"]];
    [att addAttributes:@{NSForegroundColorAttributeName:BM_BLACK,NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} range:[displayInfoLabelString rangeOfString:@"\n高血压\n"]];
    [att addAttributes:@{NSForegroundColorAttributeName:BM_BLACK,NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} range:[displayInfoLabelString rangeOfString:@"\n低血压\n"]];
    [att addAttributes:@{NSForegroundColorAttributeName:BM_BLACK,NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} range:[displayInfoLabelString rangeOfString:@"\n低血糖\n"]];
    self.displayInfoLabel.attributedText = att;
}
@end
