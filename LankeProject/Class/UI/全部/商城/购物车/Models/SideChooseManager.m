//
//  SideChooseManager.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "SideChooseManager.h"

static NSString * const ChooseManagerDataSerializerSectionKey = @"ManagerSectionKey";
static NSString * const ChooseManagerDataSerializerItemsKey = @"ManagerItemsKey";

@interface SideChooseManager ()

@property (readwrite) NSMutableArray * datas;

/** 用来装选中row的index */
@property (readwrite) NSMutableArray <NSSet *>* selectedStatus;
@end

@implementation SideChooseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
        _selectedStatus = [NSMutableArray array];
        _allowsFoldSectionView = YES;
        _allowsMultipleSelection = NO;
        _allSelected = YES;
        _allowsFoldSectionRow=0;
    }
    return self;
}

#pragma mark -
#pragma mark API M
#pragma mark -

#pragma mark 配置数据

- (void) configChooseManager:(NSArray *)datas{
    
 
    [self.datas removeAllObjects];
    
    NSString * itemListKey, * itemCountKey, * itemPriceKey;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chooseManagerItemsListKey:)]) {
        itemListKey = [self.dataSource chooseManagerItemsListKey:self];
    }
    
    NSAssert(itemListKey, @"请实现`chooseManagerItemsListKey:`方法，以确定items数组");
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chooseManagerItemCountKey:)]) {
        itemCountKey = [self.dataSource chooseManagerItemCountKey:self];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chooseManagerItemPriceKey:)]) {
        itemPriceKey = [self.dataSource chooseManagerItemPriceKey:self];
    }
    
    for (NSInteger section = 0; section < datas.count; section ++) {
        NSDictionary * data = datas[section];
        NSArray * items = data[itemListKey];/// items is invented key
        NSMutableArray * tempItems = [NSMutableArray arrayWithCapacity:items.count];
        
        if (_selectedStatus.count<=section)
        {
            NSMutableSet * tempSelectedStatus = [NSMutableSet set];
            [_selectedStatus addObject:tempSelectedStatus];
        }
        NSSet * selectedStatusSet = _selectedStatus[section];
        
        ChooseSection * sectionObject = [ChooseSection sectionWith:data];
        sectionObject.fold = (selectedStatusSet.count == 0) && _allowsFoldSectionView;
        sectionObject.sectionIndex = section;
        sectionObject.allItemsSelected = (selectedStatusSet.count == items.count) && items.count;
        
        for (NSInteger item = 0; item < items.count; item ++)
        {
            ChooseItem * chooseItem = [ChooseItem itemWith:items[item]];
            
            chooseItem.count = itemCountKey ? [items[item][itemCountKey] integerValue]: 0;
            chooseItem.price = itemPriceKey ? [items[item][itemPriceKey] floatValue] : 0.0f;
            chooseItem.selected = [selectedStatusSet containsObject:@(item)];// 这里有可能是已经选过的
            chooseItem.indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            [tempItems addObject:chooseItem];
        }
        
        NSDictionary * chooseData = @{ChooseManagerDataSerializerSectionKey:sectionObject,
                                      ChooseManagerDataSerializerItemsKey:tempItems};
        [_datas addObject:chooseData];
        
        _allSelected = _allSelected && sectionObject.isAllItemsSelected;
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
    /** _datas like this
     
         [{'section':sectionObj,'items':[itemObj,itemObj...]}...]
     
        不论外边什么数据结构进来，都将他们转换成这样的形式
     */
}
- (void) configChooseManagerForDefaultSelectedItems:(NSArray <NSSet *>*)defaultSelectedItems{

    if (defaultSelectedItems) {
        
        [self.selectedStatus removeAllObjects];
        [self.selectedStatus addObjectsFromArray:defaultSelectedItems];
    }
}

#pragma mark 选择相关

- (void) selectAll:(BOOL)selected{
    
    for (NSInteger section = 0; section < [self numberOfSections]; section ++) {
        
        for (NSInteger item = 0; item < [self numberOfItemsInSection:section]; item ++) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            [self selectCellAtIndexPath:indexPath singleSelected:NO allSelected:selected];
        }
    }
}

- (void)selectAll:(BOOL)allSelected atSection:(NSInteger)sectionIndex{

    NSAssert(_allowsMultipleSelection, @"当前不允许多选，如需多选，请设置`_allowsMultipleSelection`属性为YES");
    
    NSArray * items = [self itemsAtSection:sectionIndex];
    
    for (NSInteger row = 0; row < items.count; row ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
        
        [self selectCellAtIndexPath:indexPath singleSelected:NO allSelected:allSelected];
    }
}

- (void) selectCellAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectCellAtIndexPath:indexPath singleSelected:YES allSelected:NO];
}

- (BOOL) allSelectedStatus{

    return _allSelected;
}

- (BOOL) allSelectedStatusAtSection:(NSInteger)section{

    ChooseSection * sectionObj = [self sectionObjectAtSection:section];
    return sectionObj.isAllItemsSelected;
}

#pragma mark 折叠相关

-(BOOL)foldSectionStatus:(NSInteger)sectionIndex
{
    ChooseSection * section = [self sectionObjectAtSection:sectionIndex];
    return section.fold;
}

- (void) foldSection:(NSInteger)sectionIndex{

    ChooseSection * section = [self sectionObjectAtSection:sectionIndex];
    section.fold = !section.isFold;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    }];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 状态的输出

- (void) clear{

    [self.selectedStatus removeAllObjects];
    for (NSInteger section = 0; section < self.datas.count; section ++) {
        
        NSArray * items = [self itemsAtSection:section];

        for (NSInteger index = 0; index < items.count; index ++) {
            
            ChooseItem * item = items[index];
            
            item.selected = NO;
        }
        
        NSMutableSet * tempSelectedStatus = [NSMutableSet set];
        [self.selectedStatus addObject:tempSelectedStatus];
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

- (NSArray <NSSet *>*)commit{
    
    NSArray * temp = [NSArray arrayWithArray:self.selectedStatus];
    
    [self.selectedStatus removeAllObjects];
    
    return temp;
}

#pragma mark DataSource M

- (NSInteger) numberOfSections{

    if (self.datas == nil) {
        return 0;
    }
    return self.datas.count;
}

- (NSInteger) numberOfItemsInSection:(NSInteger)section{

    if ([self foldStatusWithSection:section] && self.allowsFoldSectionView) {// 折叠起来
        if ([self itemsAtSection:section].count<_allowsFoldSectionRow) {
            return [self itemsAtSection:section].count;
        }
        return _allowsFoldSectionRow;
    }
    return [self itemsAtSection:section].count;
}

- (id) sectionObjectAtSection:(NSInteger)section{

    return [self chooseSectionAtSection:section];
}

- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self chooseItemAtIndexPath:indexPath];
}

#pragma mark Delete

- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray * items = [self itemsAtSection:indexPath.section];
    
    [items removeObjectAtIndex:indexPath.row];

    NSInteger index = indexPath.row;
    
    NSSet * set = self.selectedStatus[indexPath.section];
    NSMutableSet * tempSet = [NSMutableSet set];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSInteger row = [obj integerValue];
        if (row > index) {
            row --;
        }
        [tempSet addObject:@(row)];
    }];
    
    [self.selectedStatus replaceObjectAtIndex:indexPath.section withObject:tempSet];
    
    if (!items.count) {
        [self.datas removeObjectAtIndex:indexPath.section];
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }else{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }
}

- (void)deleteSelectedItems{

    NSInteger section = 0;
    
    NSMutableIndexSet * sectionsIndexSet = [NSMutableIndexSet indexSet];
    
    for (NSSet * set in self.selectedStatus) {
    
        NSMutableIndexSet * itemsIndexSet = [NSMutableIndexSet indexSet];
        
        [set enumerateObjectsUsingBlock:^(id obj, BOOL * _Nonnull stop) {
            
            NSInteger row = [obj integerValue];
            [itemsIndexSet addIndex:row];
        }];
        
        NSMutableArray * items = [self itemsAtSection:section];
        [items removeObjectsAtIndexes:itemsIndexSet];
        
        if (set.count) {
            [sectionsIndexSet addIndex:section];
        }
        
        section ++;
    }
    
    [self.datas removeObjectsAtIndexes:sectionsIndexSet];

    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseManagerDidSelelctedAll:)]) {
        [self.delegate chooseManagerDidSelelctedAll:_allSelected];
    }
    
    [self clear];
}

#pragma mark -
#pragma mark Private M
#pragma mark -

- (void) selectCellAtIndexPath:(NSIndexPath *)indexPath singleSelected:(BOOL)singleSelected allSelected:(BOOL)allSelected{

    NSArray * items = [self itemsAtSection:indexPath.section];
    ChooseSection * section = [self sectionObjectAtSection:indexPath.section];

    NSMutableSet * selectedSet = (NSMutableSet *)self.selectedStatus[indexPath.section];
    BOOL allSelectedStatus = YES;
    
    // 只修改当前section下的items
    for (NSInteger index = 0; index < items.count; index ++) {
        
        ChooseItem * item = items[index];
        void (^ bSingleSelectedSetHandle)(NSInteger,BOOL)
        = ^(NSInteger index,BOOL add){
            
            if (add) {
                [selectedSet addObject:@(index)];
            }else{
                if ([selectedSet containsObject:@(index)]) {
                    [selectedSet removeObject:@(index)];
                }
            }
        };
        void (^ bAllSelectedSetHandle)(NSInteger,BOOL)
        = ^(NSInteger items,BOOL allSelected){
            
            if (allSelected) {
                for (NSInteger row = 0; row < items; row ++) {
                    [selectedSet addObject:@(row)];
                }
            }else{
                [selectedSet removeAllObjects];
            }
        };
        if (!singleSelected) {
            item.selected = allSelected;
            bAllSelectedSetHandle(items.count,allSelected);
            allSelectedStatus = allSelected;
        }else{
        
            if (index == indexPath.row) {
                item.selected = !item.isSelected;
            }else if (!_allowsMultipleSelection) {
                item.selected = NO;
            }
            bSingleSelectedSetHandle(index,item.isSelected);
            allSelectedStatus = allSelectedStatus && item.isSelected;
        }
    }
    section.allItemsSelected = allSelectedStatus;
    
    [self updateAllSelectedStatusForSingleSelected];

    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    // 更新section的价格数据
    [self modifySectionPriceAtSection:indexPath.section];

    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseManagerDidSelelctedAll:atSection:)]) {
        [self.delegate chooseManagerDidSelelctedAll:section.isAllItemsSelected atSection:indexPath.section];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseManagerDidSelelctedAll:)]) {
        [self.delegate chooseManagerDidSelelctedAll:_allSelected];
    }
}

- (void) updateAllSelectedStatusForSingleSelected{
    
    _allSelected = YES;
    for (NSDictionary * data in self.datas) {
        ChooseSection * section = data[ChooseManagerDataSerializerSectionKey];
        _allSelected = _allSelected && section.isAllItemsSelected;
    }
}

- (__kindof NSArray *) itemsAtSection:(NSInteger)section{

    NSDictionary * data = self.datas[section];
    
    return data[ChooseManagerDataSerializerItemsKey];
}

- (BOOL) selectedStatusWithIndexPath:(NSIndexPath *)indexPath{

    ChooseItem * item = [self chooseItemAtIndexPath:indexPath];
    
    return item.isSelected;
}

- (ChooseItem *) chooseItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return [self itemsAtSection:indexPath.section][indexPath.row];
}

- (BOOL) foldStatusWithSection:(NSInteger)sectionIndex{
    
    ChooseSection * section = [self chooseSectionAtSection:sectionIndex];
    
    return section.isFold;
}

- (ChooseSection *) chooseSectionAtSection:(NSInteger )sectionIndex{
    
    NSDictionary * data = self.datas[sectionIndex];
    
    return data[ChooseManagerDataSerializerSectionKey];
}

#pragma mark -
#pragma mark Custom M
#pragma mark -

- (void) modifySectionPriceAtSection:(NSInteger)section{
    
    ChooseSection * sectionObj = [self sectionObjectAtSection:section];
    sectionObj.price = 0.0f;
    for (ChooseItem * item_ in [self itemsAtSection:section]) {
        
        CGFloat itemPriceSum = item_.price * item_.count;
        sectionObj.price += item_.isSelected ? itemPriceSum: 0.0f;
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) minusAtIndexPath:(NSIndexPath *)indexPath;
{
    ChooseItem * item = [self chooseItemAtIndexPath:indexPath];
    item.count--;
    
    [self modifySectionPriceAtSection:indexPath.section];
    
    if (item.isSelected && self.delegate && [self.delegate respondsToSelector:@selector(chooseManagerDidUpdateCellStatusAtIndexPath:)]) {
        
        [self.delegate chooseManagerDidUpdateCellStatusAtIndexPath:indexPath];
    }
}

- (void) plusAtIndexPath:(NSIndexPath *)indexPath;
{
    ChooseItem * item = [self chooseItemAtIndexPath:indexPath];
    item.count ++;
    
    [self modifySectionPriceAtSection:indexPath.section];
    
    if (item.isSelected && self.delegate && [self.delegate respondsToSelector:@selector(chooseManagerDidUpdateCellStatusAtIndexPath:)]) {
        
        [self.delegate chooseManagerDidUpdateCellStatusAtIndexPath:indexPath];
    }
}

@end

@implementation ChooseItem

+ (instancetype) itemWith:(id)data{

    ChooseItem * item = [[ChooseItem alloc] init];
    item.item = data;
    
    return item;
}

@end

@implementation ChooseSection

+ (instancetype)sectionWith:(id)data{

    ChooseSection * section = [[ChooseSection alloc] init];
    section.section = data;
    
    return section;
}
@end

