//
//  UserInfoModle.h
//  MHProject
//
//  Created by 董駸 on 16/1/5.
//  Copyright © 2016年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel: NSObject <NSCoding>
{
    
}
//用户名
@property (nonatomic,strong) NSString *userName;

//手机号
@property (nonatomic,strong) NSString *mobile;

@end
