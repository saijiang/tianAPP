//
//  DataHander.h
//  CaCaXian
//
//  Created by Nancy on 13-4-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>	
#import "MBProgressHUD.h"




@interface DataHander : NSObject
{
    MBProgressHUD* mbProgressHud;
}

@property(nonatomic,strong)NSString* strUser;       //登陆账号
@property(nonatomic,strong)NSString* strPassd;      //登录密码

@property(nonatomic,strong)NSString* strUserId;     //用户Id
@property(nonatomic,strong)NSString* strCompany;
@property(nonatomic,strong)NSString* strDepartment;
@property(nonatomic,strong)NSString* headImgUrl;
@property(nonatomic,strong)NSString* strId;
@property(nonatomic,strong)NSString* strJob;
@property(nonatomic,strong)NSString* strNickname;
@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* strTelephone;
@property(nonatomic,strong)NSString*strGongsi;
@property(nonatomic,assign)BOOL isNeed;             //是否需要调用接口  返回首页





@property (nonatomic,strong)NSDictionary *cargoDicData;//订单--货品 字典

+(DataHander *)sharedDataHander;


-(void)showDlg;
-(void)hideDlg;

//取消请求
-(void)cancelRequest;
@end
