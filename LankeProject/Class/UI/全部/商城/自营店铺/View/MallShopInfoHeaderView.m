//
//  MallShopInfoHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallShopInfoHeaderView.h"

@interface MallShopInfoHeaderView ()

@property (nonatomic ,strong) NetworkImageView * backgroundImageView;
@property (nonatomic ,strong) NetworkImageView * shopIconImageView;

@property (nonatomic ,strong) UIButton * collectButton;

@property (nonatomic ,strong) UILabel * shopNameLabel;
@property (nonatomic ,strong) UILabel * shopCountLabel;

@property (nonatomic ,strong) id shopInfoData;



@property (nonatomic ,assign) NSInteger fansCount;
@end

@implementation MallShopInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.clipsToBounds = YES;
        self.fansCount = 0;
        
        self.backgroundImageView = [[NetworkImageView alloc] initWithImage:[UIImage imageNamed:@"default_restaurant"]];
//        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.backgroundImageView.image = [UIImage imageNamed:@"default_restaurant"];
        [self addSubview:self.backgroundImageView];
        self.shopIconImageView = [[NetworkImageView alloc] initWithImage:[UIImage imageNamed:@"temp_logo"]];
        self.shopIconImageView.clipsToBounds = YES;
//        self.shopIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.shopIconImageView.backgroundColor = [UIColor whiteColor];
//        self.shopIconImageView.image = [UIImage imageNamed:@"temp_logo"];
        [self addSubview:self.shopIconImageView];
        
        UIColor * textColor = [UIColor colorWithWhite:1 alpha:1.];
        self.shopNameLabel = [UnityLHClass masonryLabel:@"美好家居" font:19 color:textColor];
        [self addSubview:self.shopNameLabel];
        
        self.shopCountLabel = [UnityLHClass masonryLabel:@"关注人数：7.0万" font:14 color:textColor];
        [self addSubview:self.shopCountLabel];
        
        //UIImage * image = [UIImage imageNamed:@"mall_shop_detail_collect_normal"];
        //image.size = CGSizeMake(20, 20);
        
        self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.collectButton setImage:[UIImage imageNamed:@"mall_shop_detail_collect_normal"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"mall_shop_detail_collect_select"] forState:UIControlStateSelected];
//        [self.collectButton hll_setBackgroundImageWithColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
//        self.collectButton.layer.cornerRadius = 2.0f;
//        self.collectButton.layer.masksToBounds = YES;
        [self.collectButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton * sender) {
            
            [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                
                if (sender.isSelected) {
                    [self requestCancelCollect];
                }else{
                    [self requestCollect];
                }
            }];
        }];
        [self addSubview:self.collectButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shopIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.mas_equalTo(self.shopIconImageView.mas_top).mas_offset(-2);
        make.right.mas_lessThanOrEqualTo(self.mas_right).mas_offset(-10);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.shopIconImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.shopIconImageView.mas_top);
        make.right.mas_equalTo(self.collectButton.mas_left).mas_offset(-10);
    }];
    [self.shopCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.shopNameLabel.mas_left);
        make.bottom.mas_equalTo(self.shopIconImageView.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
}
#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    self.shopInfoData = data;
    
    self.shopNameLabel.text = data[@"merchantName"];
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"merchantLogo"]]
                              placeholderImage:[UIImage imageNamed:@"temp_logo"]];
    self.shopCountLabel.text = [NSString stringWithFormat:@"关注人数:%@",data[@"concernedNum"]];
    self.fansCount = [data[@"concernedNum"] integerValue];
    
    self.collectButton.selected = [data[@"isCollect"] integerValue] >= 1;
    
    if (!self.finishLoadBannerImage) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:data[@"merchantPageImage"]]];
    }
}

+ (CGFloat)height{
    
    return DEF_SCREEN_WIDTH/2.0;
}

#pragma mark -
#pragma mark Network M

- (void) requestCollect{
    
    [UserServices collectionHeadlthAdviceWithUserId:[KeychainManager readUserId] itemsId:self.shopInfoData[@"merchantId"] collectType:@"05" userName:[KeychainManager readUserName]  completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];
            self.collectButton.selected = YES;
            self.fansCount ++;
            self.shopCountLabel.text = [NSString stringWithFormat:@"关注人数:%ld",(long)self.fansCount];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
        
    }];
}

- (void) requestCancelCollect{
    
    [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:self.shopInfoData[@"merchantId"] collectType:@"05" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
            self.collectButton.selected = NO;
            self.fansCount --;
            self.shopCountLabel.text = [NSString stringWithFormat:@"关注人数:%ld",(long)self.fansCount];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end


@implementation MallShopInfoFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *scanAll= [UnityLHClass masonryButton:@"本店主打" font:15.0 color:BM_BLACK];
        [self addSubview:scanAll];
        [scanAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView *leftImage=[[UIImageView alloc]init];
        leftImage.image=[UIImage imageNamed:@"Mall_biaotibg"];
        [self addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(scanAll.mas_left).offset(-3);
            make.centerY.mas_equalTo(scanAll.mas_centerY);
        }];
        
        UIImageView *rightImage=[[UIImageView alloc]init];
        rightImage.image=[UIImage imageNamed:@"Mall_biaotibg"];
        [self addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scanAll.mas_right).offset(3);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(scanAll.mas_centerY);
        }];
        self.titleButton = scanAll;
    }
    return self;
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

+ (CGFloat)height{
    
    return 40;
}
@end

@implementation MallShopInfoOptionsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.sliderView=[[SliderView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, DEF_HEIGHT(self)-20) withDataArr:@[@"本店主打",@"本店商品",]];
        self.sliderView.delegate=self;
        [self.sliderView setSelectedIndex:1];
        [self addSubview:self.sliderView];
       
    }
    return self;
}

-(void)slidingScrollView:(SliderView *)SlidingScrollView didSeletedIndex:(NSInteger)index
{
    [self sendObject:@(index)];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view
{
    
    return [[self alloc] init];
}

+ (CGFloat)height{
    
    return 60;
}
@end

