//
//  MallOrderConfirmAddressView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderConfirmAddressView.h"

@interface MallOrderConfirmAddressView ()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *address;

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UIImageView * arrowImageView;
@end

@implementation MallOrderConfirmAddressView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        
        LocalhostImageView *loaction=[[LocalhostImageView alloc]init];
        [self addSubview:loaction];
        loaction.image=[UIImage imageNamed:@"ding_dingwei"];
        [loaction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
        }];
        
        self.name=[UnityLHClass masonryLabel:@"收货人：" font:15.0 color:BM_BLACK];
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(15);
        }];
        
        self.phone=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.phone];
        [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-40);
            make.top.mas_equalTo(15);
        }];
        
        self.address=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_Color_GrayColor];
        [self addSubview:self.address];
        self.address.numberOfLines = 2;
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-40);
            make.left.mas_equalTo(loaction.mas_right).offset(10);
            make.top.mas_equalTo(self.name.mas_bottom).offset(10);
        }];
        
        self.arrowImageView = [[UIImageView alloc] init];
        self.arrowImageView.contentMode = UIViewContentModeCenter;
        self.arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        }];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"没有默认收货地址，去添加一个" font:17 color:BM_BLACK];
        self.displayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.displayLabel];
        [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(loaction.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.arrowImageView.mas_left);
        }];
        
        self.arrowImageView.hidden = NO;
        self.displayLabel.hidden = YES;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)didMoveToSuperview{

    [super didMoveToSuperview];
    
//    [self requestDefaultAddress];
//    [self requestJDDefaultAddress];
}

- (void) tapHandle:(UITapGestureRecognizer *)tapGesture{
    if (self.bTapAddressHandle) {
        self.bTapAddressHandle();
    }
}
- (void) updateAddressInfoWithData:(id)data{

    self.addressData = data;
    if (data[@"id"]) {
        
        self.name.text = [NSString stringWithFormat:@"%@",data[@"receiveName"]];
        self.phone.text = [NSString stringWithFormat:@"%@",data[@"receivePhone"]];
        self.address.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@",data[@"province"],data[@"city"],data[@"county"],data[@"areaInfo"],data[@"detailedAddress"]];
        self.addressId = data[@"id"];
    }
    
    self.phone.hidden =
    self.address.hidden =
    self.name.hidden = !data[@"id"];
    
//    self.arrowImageView.hidden = data[@"id"];
    self.displayLabel.hidden = data[@"id"];
    
    self.validAddress = data[@"id"];
}
- (void) updateJDAddressInfoWithData:(id)data{
    
    self.addressData = data;
    if (data[@"id"]) {
        
        self.name.text = [NSString stringWithFormat:@"%@",data[@"name"]];
        self.phone.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];
        self.address.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",data[@"provinceName"],data[@"cityName"],data[@"countyName"],data[@"townName"],data[@"address"]];
        self.addressId = data[@"id"];
    }
    
    self.phone.hidden =
    self.address.hidden =
    self.name.hidden = !data[@"id"];
    
    //    self.arrowImageView.hidden = data[@"id"];
    self.displayLabel.hidden = data[@"id"];
    
    self.validAddress = data[@"id"];
}
#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(id)data{
    
    
}


#pragma mark -
#pragma mark Network M

- (void) requestDefaultAddress{
    
    // 接口接口
    [UserServices getDefaultAddressListWithuserId:[KeychainManager readUserId] restaurantId:nil completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            id data = responseObject[@"data"];
            
            [self updateAddressInfoWithData:data];
            
            
            if (self.bFinishLoadAddressHandle) {
                self.bFinishLoadAddressHandle();
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
- (void) requestJDDefaultAddress{
    
    [UserServices getJDDefaultAddressListWithuserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            id data = responseObject[@"data"];
            
            [self updateJDAddressInfoWithData:data];
            
            
            if (self.bFinishLoadJDAddressHandle) {
                self.bFinishLoadJDAddressHandle();
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
