//
//  MoreCommunityCell.h
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DBAPIManager.h"
@class MoreCommunityModel;
@interface MoreCommunityCell : BaseTableViewCell

-(void)loadMineCellWithDataSource:(id)dataSource;//我的社群

-(void)loadMangerCellWithDataSource:(id)dataSource;//社群管理


@end

@interface MoreCommunityModel : DBAPIManager

@property(nonatomic,copy)NSString *associationId;            //String 	社群id
@property(nonatomic,copy)NSString *associationTitle ;        //String 	社区名称
@property(nonatomic,copy)NSString *className;                //String 	分类名称
@property(nonatomic,copy)NSString *associationImage;         //String 	图片
@property(nonatomic,copy)NSString *associationDescription;   //String 	简介
@property(nonatomic,copy)NSString *userCount;                //String 	人数
@property(nonatomic,copy)NSString *isAdd;                    //String 	是否已加入社群（0未加入，1已加入）
@property(nonatomic,copy)NSString *displayFlg;//0：添加条款 ， 1：编辑条款
@property(nonatomic,copy)NSString *isApply;//是否显示申请列表按钮 （0：不显示， 1：显示）
@property(nonatomic,copy)NSString *associationProvision;//条款
@end
