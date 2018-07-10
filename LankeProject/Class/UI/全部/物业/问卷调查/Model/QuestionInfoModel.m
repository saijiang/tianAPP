//
//  QuestionInfoModel.m
//  LankeProject
//
//  Created by itman on 17/5/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "QuestionInfoModel.h"

@implementation QuestionSectionModel

+(QuestionSectionModel *)initWithDataSource:(id)dataSource
{
    
    QuestionSectionModel *model=[[QuestionSectionModel alloc]init];
    model.titleId=dataSource[@"titleId"];
    model.titleName=dataSource[@"titleName"];
    model.titleSort=dataSource[@"titleSort"];
    
    model.data=dataSource;
    CGFloat hight=[UnityLHClass getHeight:model.titleName wid:DEF_SCREEN_WIDTH-30 font:16.0]+20;
    model.sectionHight=hight;
    NSMutableArray *listQuestionOptionsArray=[[NSMutableArray alloc]init];
    for (NSDictionary *data in dataSource[@"listQuestionOptions"])
    {
        QuestionInfoModel *infoModel=[QuestionInfoModel initWithDataSource:data];
        infoModel.titleId=model.titleId;
        [listQuestionOptionsArray addObject:infoModel];
    }
    model.listQuestionOptions=listQuestionOptionsArray;

    return model;
}

@end

@implementation QuestionInfoModel

+(QuestionInfoModel*)initWithDataSource:(id)dataSource
{
    QuestionInfoModel *model=[[QuestionInfoModel alloc]init];
    model.seleted=NO;
    model.data=dataSource;
    model.optionsName=dataSource[@"optionsName"];
    model.optionsId=dataSource[@"optionsId"];
    CGFloat hight=[UnityLHClass getHeight:model.optionsName wid:DEF_SCREEN_WIDTH-30 font:14.0]+15;
    model.hight=hight;
    return model;
}

@end
