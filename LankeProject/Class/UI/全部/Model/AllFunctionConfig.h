//
//  AllFunctionConfig.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataSource;
@interface AllFunctionConfig : NSObject<UICollectionViewDataSource>

@property (nonatomic ,weak) UICollectionView * collectionView;

- (void) configAllFunctionWithDataSource:(DataSource *)dataSource;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;
- (id) sectionObjectAtSection:(NSInteger)section;
- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath;

@end

/** Section对象 */
@interface Section : NSObject

@property (nonatomic ,strong) id section;
@property (nonatomic ,assign) NSInteger sectionIndex;
@end

/** item对象 */
@interface Item : NSObject

@property (nonatomic ,strong) id item;
@property (nonatomic ,strong) NSIndexPath * indexPath;

@end

/** json数据源对象 */
@interface DataSource : NSObject

@property (nonatomic ,strong) NSString * dataSourceName;

+ (instancetype) dataSourceWithName:(NSString *)name;
- (instancetype) initWithDataSourceName:(NSString *)name;

- (NSArray *) parseDataSource;

@end
