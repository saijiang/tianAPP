//
//  HealthExamManager.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllFunctionConfig.h"
#import "HealthExamSecondViewController.h"

@interface HealthExamManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,weak) UICollectionView * collectionView;

@property(nonatomic,strong)HealthInfo *info;

- (void)configAllFunctionWithDataSource:(DataSource *)dataSource;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;
- (id) sectionObjectAtSection:(NSInteger)section;
- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void) selectItemAtIndexPath:(NSIndexPath *)indexPath;

- (id) result;
@end


@interface ExamSectionItem : NSObject
@property (nonatomic ,strong) id data;
@property (nonatomic ,strong) NSArray * items;
@end

@interface ExamRowItem : NSObject

@property (nonatomic ,strong) id data;
@property (nonatomic ,assign ,getter=isSelect) BOOL select;
@end
