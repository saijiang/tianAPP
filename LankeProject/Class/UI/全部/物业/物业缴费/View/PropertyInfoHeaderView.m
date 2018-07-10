//
//  PropertyInfoHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyInfoHeaderView.h"
#import "MyPropertyInfoViewController.h"

@implementation PropertyInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.nameDisplayLabel = [UnityLHClass masonryLabel:@"业主" font:17 color:[UIColor blackColor]];
        [self.contentView addSubview:self.nameDisplayLabel];
        
        self.nameLabel = [UnityLHClass masonryLabel:@"张大成" font:16 color:[UIColor colorWithHexString:@"666666"]];
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
        
        self.addressDisplayLabel = [UnityLHClass masonryLabel:@"房产信息" font:17 color:[UIColor blackColor]];
        [self.contentView addSubview:self.addressDisplayLabel];
        
        self.addressLabel = [UnityLHClass masonryLabel:@"北京市世纪城9栋302号" font:16 color:[UIColor colorWithHexString:@"666666"]];
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.numberOfLines=0;
        [self.contentView addSubview:self.addressLabel];
        
        self.arrowImageView = [[LocalhostImageView alloc] init];
        self.arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:self.arrowImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapHandle:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [self config:nil];
    }
    return self;
}

- (void) tapHandle:(UITapGestureRecognizer *)tapGesture{
    //选择物业资料
    MyPropertyInfoViewController *myProperty=[[MyPropertyInfoViewController alloc]init];
    myProperty.isSeletedProperty=YES;
    [self.topViewController.navigationController pushViewController:myProperty animated:YES];
    [myProperty receiveObject:^(id object)
    {
        NSDictionary *data=object;
        NSString *districtName=[NSString stringWithFormat:@"%@%@%@%@%@号%@室",data[@"provinceName"],data[@"cityName"],data[@"countyName"],data[@"districtAddress"],data[@"buildingNum"],data[@"roomNum"]];
        self.addressLabel.text=districtName;
        self.nameLabel.text=data[@"userName"];

        if (self.bChooseOtherInfoHandle) {
            self.bChooseOtherInfoHandle(data[@"roomId"]);
        }
    }];
   
}
- (void)layoutSubviews{

    [super layoutSubviews];
 
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
    [self.nameDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.nameDisplayLabel.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-40);
    }];
    
    [self.addressDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameDisplayLabel.mas_left);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(70);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.addressDisplayLabel.mas_right);
        make.right.mas_equalTo(self.nameLabel.mas_right);
//        make.bottom.mas_equalTo(self.addressDisplayLabel.mas_bottom);
        
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data
{
    NSString *districtName=[KeychainManager readDistrictAddress];
    self.addressLabel.text=districtName;
    self.nameLabel.text=[KeychainManager readUserName];
    
}

@end

@implementation PropertyInfoSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"您有以下账单待缴" font:17 color:[UIColor blackColor]];
        self.displayLabel.numberOfLines=0;
//        self.displayLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:self.displayLabel];
        
        self.lineView = [UIView lineView];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    NSString *districtName=[KeychainManager readDistrictAddress];
    self.displayLabel.text=districtName;
    
}
@end

@implementation PropertyInfoFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.callOnButton = [[LKBottomButton alloc] init];
        [self.callOnButton setTitle:@"电话咨询" forState:UIControlStateNormal];
        [self.callOnButton hll_setBackgroundImageWithColor:[UIColor colorWithHexString:@"#FBB95A"]
                                                  forState:UIControlStateNormal];
        [self.callOnButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bCallOnHandle) {
                self.bCallOnHandle();
            }
        }];
        [self addSubview:self.callOnButton];
        
        self.payButton = [[LKBottomButton alloc] init];
        [self.payButton setTitle:@"去缴费" forState:UIControlStateNormal];
        [self.payButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.bGotoPayHandle) {
                self.bGotoPayHandle();
            }
            [self sendObject:@"bGotoPayHandle"];
        }];
        [self addSubview:self.payButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat margin = 15;
    CGFloat width = (CGRectGetWidth(self.bounds) - 3 * margin) / 2;
    [self.callOnButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(width);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.callOnButton.mas_right).mas_offset(margin);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(width);
    }];
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    
}
@end
