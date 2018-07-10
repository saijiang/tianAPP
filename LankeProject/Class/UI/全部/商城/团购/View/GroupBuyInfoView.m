//
//  GroupBuyInfoView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyInfoView.h"

@interface GroupBuyInfoView ()

@property (nonatomic ,strong) UILabel * goodsNameLabel;
@property (nonatomic ,strong) UILabel * goodsDetailLabel;
@property (nonatomic ,strong) UILabel * goodsPurchasingLabel;//限购
@property (nonatomic ,strong) UILabel * goodsPriceLabel;
@property (nonatomic ,strong) UILabel * goodsOriginalPriceLabel;
@property (nonatomic ,strong) UILabel * goodsSaleLabel;

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation GroupBuyInfoView

/** 添加子控件 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _goodsNameLabel = [UnityLHClass masonryLabel:@"**********" font:17 color:BM_Color_BlackColor];
        _goodsNameLabel.numberOfLines = 0;
        [self addSubview:_goodsNameLabel];
        
        _goodsDetailLabel = [UnityLHClass masonryLabel:@"**********" font:14 color:[UIColor colorWithHexString:@"777777"]];
        _goodsDetailLabel.numberOfLines = 0;
        [self addSubview:_goodsDetailLabel];
        
        _goodsPurchasingLabel = [UnityLHClass masonryLabel:@"限购" font:14 color:[UIColor colorWithHexString:@"#FF8B00"]];
        _goodsPurchasingLabel.hidden=YES;
        _goodsPurchasingLabel.numberOfLines = 1;
        [self addSubview:_goodsPurchasingLabel];
        _goodsPriceLabel = [UnityLHClass masonryLabel:@"￥100.00" font:16 color:[UIColor colorWithHexString:@"#FF8B00"]];
        [self addSubview:_goodsPriceLabel];
        
        _goodsOriginalPriceLabel = [UnityLHClass masonryLabel:@"￥300.00" font:15 color:[UIColor colorWithHexString:@"666666"]];
        _goodsOriginalPriceLabel.attributedText = [self originalAtt:@"300.00"];
        [self addSubview:_goodsOriginalPriceLabel];
        
        _goodsSaleLabel = [UnityLHClass masonryLabel:@"4折" font:15 color:[UIColor colorWithHexString:@"#FF8B00"]];
        [self addSubview:_goodsSaleLabel];
        
        _stepView = [LKStepView view];
        _stepView.minValue = 0;
        _stepView.maxValue = 100;// test max value for limit
        _stepView.value = 1;
        [self addSubview:_stepView];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BM_Color_SeparatorColor;
        [self addSubview:_lineView];
        
    }
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [_stepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
    }];
    
    [_goodsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.goodsNameLabel.mas_left);
        make.top.mas_equalTo(self.goodsNameLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.goodsNameLabel.mas_right);
    }];
    [_goodsPurchasingLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.goodsDetailLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.goodsNameLabel.mas_left);
    }];
    
    [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        make.top.mas_equalTo(self.goodsPurchasingLabel.mas_bottom).mas_offset(5);
        make.centerY.mas_equalTo(_stepView.mas_centerY);

        make.left.mas_equalTo(self.goodsNameLabel.mas_left);
    }];
    
    [_goodsOriginalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_stepView.mas_centerY);
        make.left.mas_equalTo(self.goodsPriceLabel.mas_right).mas_offset(10);
    }];
    
    [_goodsSaleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(_stepView.mas_centerY);
        make.left.mas_equalTo(self.goodsOriginalPriceLabel.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.stepView.mas_left).mas_offset(-10);
    }];
    
}

- (NSAttributedString *) originalAtt:(NSString *)price{

    NSString * displayText = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:displayText];
    [att addAttributes:@{NSStrikethroughStyleAttributeName:@(1),
                         NSStrokeColorAttributeName:[UIColor colorWithHexString:@"666666"]}
                 range:NSMakeRange(0, displayText.length - 0)];
    return att;
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void) config:(id)data
{
   
    
    NSInteger groupRule= [data[@"groupRule"] integerValue];
    if (groupRule==1) {
    _goodsNameLabel.text = [NSString stringWithFormat:@"【%@人成团】%@",data[@"groupNumber"],data[@"goodsName"]];
        
    }else if(groupRule == 2){
        _goodsNameLabel.text = [NSString stringWithFormat:@"【%@件成团】%@",data[@"groupGoodsNumber"],data[@"goodsName"]];
    }

    
  
    _goodsDetailLabel.text = data[@"goodsDescribe"];
    
    NSInteger isLimit= [data[@"isLimit"] integerValue];

    if (isLimit==0) {
        _goodsPurchasingLabel.hidden=YES;
        _stepView.minValue = 1;
        _stepView.maxValue = 100;// test max value for limit
        _stepView.value = 1;

    }else if (isLimit==1){
        _goodsPurchasingLabel.hidden=NO;
          _goodsPurchasingLabel.text=[NSString stringWithFormat:@"每人限购%@件",data[@"limitBuyNum"]];
        _stepView.minValue = 1;
        _stepView.maxValue = [data[@"limitBuyNum"] integerValue];// test max value for limit
        _stepView.value = 1;
    }
 
    _goodsPriceLabel.text=[NSString stringWithFormat:@"¥%.2f",[data[@"groupPrice"] floatValue]];;
    _goodsOriginalPriceLabel.attributedText = [self originalAtt:data[@"originalPrice"]];//[NSString stringWithFormat:@"¥%.2f",[data[@"groupPrice"] floatValue]];
    _goodsSaleLabel.text=[NSString stringWithFormat:@"%.1f折",[data[@"groupPrice"] floatValue]/[data[@"originalPrice"] floatValue]*10.0];
 
    CGFloat height;
    height += 10;
    height = [UnityLHClass getHeight:_goodsNameLabel.text wid:DEF_SCREEN_WIDTH - 30 font:17];
    height += 5;
    height += [UnityLHClass getHeight:_goodsDetailLabel.text wid:DEF_SCREEN_WIDTH - 30 font:14];
//    height += 45;
    height += 15;
    height += 5;
    height += 20;
    height += 15;
    
    height += 10;
    
    if (self.bHeightChangeHandle) {
        self.bHeightChangeHandle(height);
    }
    if ([data[@"isEndStatus"] integerValue]==1)// 结束
    {
        _stepView.minValue = 1;
        _stepView.maxValue = 100;// test max value for limit
        _stepView.value = 1;
    }
    else
    {
        _stepView.minValue = 0;
        _stepView.value = 1;
    }
}
+(CGFloat)height:(id)data
{
    NSInteger groupRule= [data[@"groupRule"] integerValue];
    NSString*str1=@"";
    if (groupRule==1) {
     str1 = [NSString stringWithFormat:@"【%@人成团】%@",data[@"groupNumber"],data[@"goodsName"]];
        
    }else if(groupRule == 2){
    str1 = [NSString stringWithFormat:@"【%@件成团】%@",data[@"groupGoodsNumber"],data[@"goodsName"]];
    }
    CGFloat height;
    height += 10;
    height = [UnityLHClass getHeight:str1 wid:DEF_SCREEN_WIDTH - 30 font:17];
    height += 5;
    height += [UnityLHClass getHeight:data[@"goodsDescribe"] wid:DEF_SCREEN_WIDTH - 30 font:14];
    //    height += 45;
    height += 15;
    height += 5;
    height += 20;
    height += 15;
    
    height += 10;
    
    
    return height;
}
@end
