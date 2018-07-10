//
//  TCMManager.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "TCMManager.h"
#import "HealthExamSingleSelectCCell.h"
#import "HealthExamSectionHeaderReView.h"

@interface TCMManager ()

@property (nonatomic ,strong) NSMutableArray * datas;

@end

@implementation TCMManager

- (instancetype) initWithType:(NSString *)type{

    self = [super init];
    if (self) {
        _type = type;
        _datas = [NSMutableArray array];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)config:(NSArray *)dataSource{
    
    if (!dataSource) {
        
        [NSException raise:@"NULL NSArray"
                    format:@"You json file <%@.json> for dataSource is NULL",dataSource];
    }
    
    for (NSDictionary * sectionData in dataSource) {
        
        TCMSectionItem * sectionItem = [[TCMSectionItem alloc] init];
        sectionItem.data = sectionData;
        NSString *questionContent=sectionData[@"questionContent"];
        questionContent=[[questionContent componentsSeparatedByString:@"."] lastObject];
        questionContent=[NSString stringWithFormat:@"%@.%@",sectionData[@"questionNum"],questionContent];
        sectionItem.name =questionContent ;
        [sectionItem configItemsForSelectIndex:[sectionData[@"questionScore"] integerValue]];
        
        [self.datas addObject:sectionItem];
    }
    [self.collectionView reloadData];
    [self checkValid];

    
}

- (void)setCollectionView:(UICollectionView *)collectionView{

    _collectionView = collectionView;
    
    [self registReuseView];
}

- (void) registReuseView{
    
    [self.collectionView registerClass:[HealthExamSectionHeaderReView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[HealthExamSectionHeaderReView reuseIdentifier]];
    
    [self.collectionView registerClass:[HealthExamSectionFooterReView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[HealthExamSectionFooterReView reuseIdentifier]];
    
    [self.collectionView registerClass:[HealthExamSingleSelectCCell class]
            forCellWithReuseIdentifier:[HealthExamSingleSelectCCell cellIdentifier]];
}

#pragma mark -
#pragma mark API

- (id) result{
    
    NSMutableArray * listQuestion = [NSMutableArray array];
    for (TCMSectionItem * item in [self datas]) {
        
        NSDictionary * itemData = @{@"questionNum":item.data[@"questionNum"],
                                    @"questionContent":item.data[@"questionContent"],
                                    @"questionScore":[NSString stringWithFormat:@"%ld",(long)item.sumScore]};
        [listQuestion addObject:itemData];
    }
    
    NSArray * result = @[@{@"physicalType":self.type,
                           @"listQuestion":listQuestion}];
    
    return result;
    //return [result JSONFragment];
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

- (TCMSectionItem *) sectionObjectAtSection:(NSInteger)section{
    
    id data = self.datas[section];
    
    return data;
}

- (TCMRowItem *) itemObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self itemsAtSection:indexPath.section][indexPath.row];
}

- (NSArray *) itemsAtSection:(NSInteger)section{
    
    TCMSectionItem * data = [self sectionObjectAtSection:section];
    
    return data.items;
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
        
    TCMRowItem * data = [self itemObjectAtIndexPath:indexPath];
    
    HealthExamSingleSelectCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HealthExamSingleSelectCCell cellIdentifier] forIndexPath:indexPath];

    [cell configForTCM:data];
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        TCMSectionItem * sectionItem = [self sectionObjectAtSection:indexPath.section];
        HealthExamSectionHeaderReView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[HealthExamSectionHeaderReView reuseIdentifier] forIndexPath:indexPath];
        [headerView configForTCM:sectionItem.name];
        return headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        HealthExamSectionFooterReView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[HealthExamSectionFooterReView reuseIdentifier] forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
    return nil;
}
/*
 */

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    TCMSectionItem * sectionItem = [self sectionObjectAtSection:section];
    
    return [HealthExamSectionHeaderReView headerReferenceSizeForTCM:sectionItem.name];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(DEF_SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectItemAtIndexPath:indexPath];
}

- (void) selectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCMSectionItem * sectionItem = [self sectionObjectAtSection:indexPath.section];
    sectionItem.haveSelect = YES;
    
    for (NSInteger index = 0; index < sectionItem.items.count; index ++) {
        
        TCMRowItem * rowItem = sectionItem.items[index];
        rowItem.select = index == indexPath.item;
        if (index == indexPath.item) {
            sectionItem.sumScore = rowItem.score;
        }
    }
    [self checkValid];
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    [self.collectionView reloadSections:indexSet];
}

- (void) checkValid{

    BOOL valid = YES;
    for (TCMSectionItem * section in self.datas) {
        valid = valid && section.haveSelect;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tcmManager:forValid:)]) {
        [self.delegate tcmManager:self forValid:valid];
    }

}

@end

@implementation TCMSectionItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = @[[TCMRowItem none],
                       [TCMRowItem little],
                       [TCMRowItem some],
                       [TCMRowItem often],
                       [TCMRowItem alway]];
        self.haveSelect = NO;
    }
    return self;
}
- (void)configItemsForSelectIndex:(NSInteger)index{

    self.sumScore = index;
    
    self.haveSelect = index != 0;
    
    if (index != 0) {
        NSInteger idx = 0;
        index -= 1;
        for (TCMRowItem * item in self.items) {
            
            [item config:index == idx];
            idx ++;
        }
    }
}


@end
@implementation TCMRowItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _select = NO;
    }
    return self;
}

- (TCMRowItem *) config:(BOOL)select{

    self.select = select;
    return self;
}

/** im is lazy */
+ (instancetype) none{

    TCMRowItem * item = [[TCMRowItem alloc] init];
    item.score = 1;
    item.display = @"没有(根本不)";
    return item;
}
+ (instancetype) little{
    
    TCMRowItem * item = [[TCMRowItem alloc] init];
    item.score = 2;
    item.display = @"很少(有一点)";
    return item;
}
+ (instancetype) some{
    
    TCMRowItem * item = [[TCMRowItem alloc] init];
    item.score = 3;
    item.display = @"有时(有些)";
    return item;
}
+ (instancetype) often{
    
    TCMRowItem * item = [[TCMRowItem alloc] init];
    item.score = 4;
    item.display = @"经常(相当)";
    return item;
}
+ (instancetype) alway{
    
    TCMRowItem * item = [[TCMRowItem alloc] init];
    item.score = 5;
    item.display = @"总是(非常)";
    return item;
}
@end
