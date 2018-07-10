//
//  QuestionInfoModel.h
//  LankeProject
//
//  Created by itman on 17/5/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionInfoModel;
@interface QuestionSectionModel : NSObject

+(QuestionSectionModel *)initWithDataSource:(id)dataSource;

@property(nonatomic,strong)id data;

@property(nonatomic,assign)CGFloat sectionHight;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSString *titleId;
@property(nonatomic,assign)NSString *titleName;
@property(nonatomic,assign)NSString *titleSort;
@property(nonatomic,strong)NSArray  *listQuestionOptions;

@end

@interface QuestionInfoModel : NSObject

+(QuestionInfoModel*)initWithDataSource:(id)dataSource;

@property(nonatomic,strong)id data;
@property(nonatomic,assign)BOOL seleted;//是否选中
@property(nonatomic,assign)CGFloat hight;

@property(nonatomic,assign)NSString *titleId;
@property(nonatomic,assign)NSString *optionsId;
@property(nonatomic,assign)NSString *optionsName;



@end
