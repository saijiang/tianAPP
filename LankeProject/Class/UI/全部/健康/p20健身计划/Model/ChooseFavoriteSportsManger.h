//
//  ChooseFavoriteSportsManger.h
//  LankeProject
//
//  Created by itman on 17/3/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllFunctionConfig.h"
#import "ChooseFavoriteSportsManger.h"
#import "HealthExamSecondViewController.h"
#import "HealthExamManager.h"

@interface ChooseFavoriteSportsManger : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,weak) UICollectionView * collectionView;

@property(nonatomic,strong)HealthInfo *info;

- (void)configWithDataSource:(DataSource *)dataSource;
- (void)updateDataSource:(id)data;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;
- (id) sectionObjectAtSection:(NSInteger)section;
- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void) selectItemAtIndexPath:(NSIndexPath *)indexPath;
- (id) result;
@end

