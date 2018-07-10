//
//  MyNewsModel.h
//  LankeProject
//
//  Created by itman on 2017/6/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNewsModel : NSObject

@property(nonatomic,strong)id data;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *sendTime;
@property(nonatomic,assign)BOOL readingFlg;
@property(nonatomic,copy)NSString *messageId;
@property(nonatomic,assign)CGFloat hight;

+(instancetype)initMyNewsModelWithData:(id)data;

@end
