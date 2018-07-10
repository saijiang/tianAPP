//
//  AddressCell.m
//  LankeProject
//
//  Created by Justin on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "JDAddressCell.h"

@implementation JDAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.userName = [UnityLHClass masonryLabel:@"航天小新" font:16.0 color:BM_Color_BlackColor];
        [self.contentView addSubview:self.userName];
        
        self.phoneLB = [UnityLHClass masonryLabel:@"18726452893" font:16.0 color:BM_Color_BlackColor];
        self.phoneLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.phoneLB];
        
        self.addressLB = [UnityLHClass masonryLabel:@"北京市 朝阳区 百子湾西里403 金海国际 百子湾西里403 " font:15.0 color:BM_Color_BlackColor];
        self.addressLB.numberOfLines=0;
        [self.contentView addSubview:self.addressLB];
        
        self.lineImage = [[UIImageView alloc] init];
        self.lineImage.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        [self.contentView addSubview:self.lineImage];
        
        
        self.chooseBtn = [[UIButton alloc] init];
        self.chooseBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [self.chooseBtn setTitle:@" 设为默认" forState:UIControlStateNormal];
        [self.chooseBtn setTitle:@" 默认地址" forState:UIControlStateSelected];
        [self.chooseBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1] forState:UIControlStateNormal];
        [self.chooseBtn setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
        
        [self.chooseBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
           
            [self setDefaultAddress];
                
        }];
        
        [self.contentView addSubview:self.chooseBtn];
        
        
        
        self.modBtn = [[UIButton alloc] init];
        [self.modBtn setImage:[UIImage imageNamed:@"UserCenter-Mody"] forState:UIControlStateNormal];
        [self.modBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        self.modBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [self.modBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1] forState:UIControlStateNormal];
        [self.contentView addSubview:self.modBtn];
        [self.modBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            [self sendObject:@"1"];
        }];
        
        self.deleteBtn = [[UIButton alloc] init];
        [self.deleteBtn setImage:[UIImage imageNamed:@"UserCenter-Delete"] forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = BM_FONTSIZE(14.0);
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self deleteAddress];
        }];
        
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(24);
        }];
        
        [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.top.mas_equalTo(self.userName.mas_top);
            make.left.mas_equalTo(self.userName.mas_right).offset(10);
        }];
        
        [self.addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userName.mas_left);
            make.top.mas_equalTo(self.userName.mas_bottom).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        }];
        
        [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-30);
            make.left.mas_equalTo(self.userName.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.height.offset(0.8);
        }];
        
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userName.mas_left);
            make.top.mas_equalTo(self.lineImage.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.lineImage.mas_right);
            make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
        }];
        
        [self.modBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.deleteBtn.mas_left).mas_offset(-20);
            make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
        }];
    }
    return self;
}


-(void)loadCellWithDataSource:(id)dataSource
{
    
    self.data=dataSource;
    self.userName.text=dataSource[@"name"];
    self.phoneLB.text=dataSource[@"mobile"];
    self.addressLB.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",dataSource[@"provinceName"],dataSource[@"cityName"],dataSource[@"countyName"],dataSource[@"townName"],dataSource[@"address"]];
    
    if ([dataSource[@"isDefault"] integerValue]==1)
    {
        self.chooseBtn.selected=YES;
    }
    else
    {
        self.chooseBtn.selected=NO;
        
    }
}


-(void)setDefaultAddress
{
   
    
    [UserServices
     setJDDefaultAddressWithuserId:[KeychainManager readUserId]
     addressId:self.data[@"id"]
     completionBlock:^(int result, id responseObject) {
         if (result==0)
         {
             [self sendObject:@"0"];
         }
     }];
}

-(void)deleteAddress
{
    [UserServices
     JDdeleteAddressWithaddressId:self.data[@"id"]
     completionBlock:^(int result, id responseObject) {
         if (result==0)
         {
             [self sendObject:@"2"];
             
         }
     }];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
