//
//  AllFunctionConfig.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AllFunctionConfig.h"
#import "AllFunctionCCell.h"
#import "AllFunctionReusableView.h"

@interface AllFunctionConfig ()

/** 用来装所有的数据，是经过转化过之后的数据 */
@property (nonatomic ,strong) NSMutableArray * datas;
@end

@implementation AllFunctionConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

#pragma mark -

#pragma mark 配置数据

- (void)configAllFunctionWithDataSource:(DataSource *)dataSource{

    [self registReuseView];
    
    NSArray * datas = [dataSource parseDataSource];
    
    if (!datas) {
        
        [NSException raise:@"NULL NSArray"
                    format:@"You json file <%@.json> for dataSource is NULL",dataSource.dataSourceName];
    }
    
    for (NSInteger section = 0; section < datas.count; section ++) {
        
        NSDictionary * data = datas[section];
        NSArray * items = data[@"items"];/// items is invented key
        NSMutableArray * tempRows = [NSMutableArray arrayWithCapacity:items.count];
        
        Section * sectionObject = [[Section alloc] init];
        sectionObject.section = data[@"section_name"];/// section_name is alse invented key
        sectionObject.sectionIndex = section;
        
        for (NSInteger row = 0; row < items.count; row ++) {
            
            Item * chooseItem = [[Item alloc] init];

            NSDictionary * tempData = [NSDictionary dictionaryWithDictionary:items[row]];
            chooseItem.item = tempData;
            chooseItem.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            [tempRows addObject:chooseItem];
        }
        
        NSDictionary * chooseData = @{@"section":sectionObject,
                                      @"rows":tempRows};
        [_datas addObject:chooseData];        
    }
    
    [self.collectionView reloadData];
}

- (void) registReuseView{
    
    [self.collectionView registerClass:[AllFunctionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[AllFunctionHeaderView reuseIdentifier]];
    
    [self.collectionView registerClass:[AllFunctionFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[AllFunctionFooterView reuseIdentifier]];
    
    [self.collectionView registerClass:[AllFunctionCCell class]
            forCellWithReuseIdentifier:[AllFunctionCCell cellIdentifier]];
    
}
#pragma mark DataSource M

- (NSInteger) numberOfSections{
    
    if (self.datas == nil) {
        return 0;
    }
    return self.datas.count;
}

- (NSInteger) numberOfItemsInSection:(NSInteger)section{
    
    return [self itemsAtSection:section].count;
}

- (id) sectionObjectAtSection:(NSInteger)section{
    
    return [self chooseSectionAtSection:section];
}

- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self chooseItemAtIndexPath:indexPath];
}

- (NSArray *) itemsAtSection:(NSInteger)section{
    
    NSDictionary * data = self.datas[section];
    
    return data[@"rows"];
}

- (Item *) chooseItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self itemsAtSection:indexPath.section][indexPath.row];
}


- (Section *) chooseSectionAtSection:(NSInteger )sectionIndex{
    
    NSDictionary * data = self.datas[sectionIndex];
    
    return data[@"section"];
}


#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AllFunctionCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AllFunctionCCell cellIdentifier] forIndexPath:indexPath];
    
    id item = [self itemObjectAtIndexPath:indexPath];
    [cell configCellWithData:item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        AllFunctionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[AllFunctionHeaderView reuseIdentifier] forIndexPath:indexPath];
        
        [headerView configureHeaderViewWithData:[self sectionObjectAtSection:indexPath.section]];
        return headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
        AllFunctionFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[AllFunctionFooterView reuseIdentifier] forIndexPath:indexPath];
        
        return footerView;
    }
    return nil;
}

@end

@implementation Item

@end

@implementation Section

@end

@implementation DataSource

+ (instancetype) dataSourceWithName:(NSString *)name{

    return [[DataSource alloc] initWithDataSourceName:name];
}
- (instancetype) initWithDataSourceName:(NSString *)name{

    self = [super init];
    if (self) {
        _dataSourceName = name;
    }
    return self;
}

- (NSArray *) parseDataSource{

    NSAssert(self.dataSourceName, @"You MUST set a nunull string of `dataSourceName`");
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataSourceName ofType:@"json"]];
    
    NSError * error = nil;
    
    NSArray * datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        return nil;
    }
    return datas;
}
@end
