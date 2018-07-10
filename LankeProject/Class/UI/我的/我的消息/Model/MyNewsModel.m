//
//  MyNewsModel.m
//  LankeProject
//
//  Created by itman on 2017/6/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyNewsModel.h"

@implementation MyNewsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(instancetype)initMyNewsModelWithData:(id)data
{
    //readingFlg 	String 	状态（0：未读，1：已读）
    MyNewsModel *model=[[MyNewsModel alloc]init];
    model.data=data;
    model.title=data[@"title"];
    model.content=data[@"content"];
    model.sendTime=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd" andTimeString:data[@"sendTime"]];
    model.messageId=data[@"id"];
    if ([data[@"readingFlg"] integerValue]==1) {
        model.readingFlg=YES;
    }else{
        model.readingFlg=NO;

    }
    float hight=0;
    hight+=15;
    hight+=20;
    hight+=10;
    hight+=17;
    hight+=10;
    hight+=15;
    hight+=[UnityLHClass getHeight:data[@"content"] wid:DEF_SCREEN_WIDTH-30 font:15.0];
    model.hight=hight;
    return model;
    
}

@end
