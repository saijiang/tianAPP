//
//  SideChooseManager.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SideChooseManager;
@protocol SideChooseManagerDelegate <NSObject>

@optional;

/** 内部选择item导致所有的item被选中 */
- (void) chooseManagerDidSelelctedAll:(BOOL)allSelected;

/** 内部点击item导致该section处于全选状态 */
- (void) chooseManagerDidSelelctedAll:(BOOL)allSelected atSection:(NSInteger)section;

/** 更新cell内部的状态，比如，商品的数量 */
- (void) chooseManagerDidUpdateCellStatusAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol SideChooseManagerDataSource <NSObject>

@required;

- (NSString *) chooseManagerItemsListKey:(SideChooseManager *)manager;

@optional;

/** 购物车中单个商品的个数 */
- (NSString *) chooseManagerItemCountKey:(SideChooseManager *)manager;
/** 购物车中单个商品的价格key */
- (NSString *) chooseManagerItemPriceKey:(SideChooseManager *)manager;

@end

@interface SideChooseManager : NSObject
{
    BOOL _allSelected;
    BOOL _allowsFoldSectionView;
    BOOL _allowsMultipleSelection;
}

/** 用来装所有的数据，是经过转化过之后的数据 */
@property (nonatomic ,strong ,readonly) NSMutableArray * datas;

@property (nonatomic ,strong ,readonly) NSMutableArray <NSSet *>* selectedStatus;

@property (nonatomic ,weak) id<SideChooseManagerDelegate> delegate;
@property (nonatomic ,weak) id<SideChooseManagerDataSource> dataSource;

@property (nonatomic ,weak) UITableView * tableView;
@property (nonatomic ,weak) UICollectionView * collectionView;

@property (nonatomic ,assign) NSInteger allowsFoldSectionRow;// default is 0

@property (nonatomic ,assign) BOOL allowsMultipleSelection;// default is NO
@property (nonatomic ,assign) BOOL allowsFoldSectionView;// default is YES

- (void) configChooseManager:(id)data;
/** 设置默认的选中项，必须在`-configChooseManager:`方法前调用 */
- (void) configChooseManagerForDefaultSelectedItems:(NSArray <NSSet *>*)defaultSelectedItems;

#pragma mark -
#pragma mark Select

- (void) selectAll:(BOOL)selected;

/** 外部点击sectionView的操作，用于全选整个section下的item */
- (void) selectAll:(BOOL)allSelected atSection:(NSInteger)sectionIndex;

/** 外部选中item的操作 */
- (void) selectCellAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL) allSelectedStatus;
- (BOOL) allSelectedStatusAtSection:(NSInteger)section;

/** 清空选中 */
- (void) clear;
/** 目前只返回选中 item 的index */
- (NSArray <NSSet *>*) commit;

#pragma mark -
#pragma mark Fold

/** 外部点击section的操作，用作折叠或者展开 */
- (void) foldSection:(NSInteger)section;
-(BOOL)foldSectionStatus:(NSInteger)sectionIndex;

#pragma mark -
#pragma mark DataSource

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;
- (id) sectionObjectAtSection:(NSInteger)section;
- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -
#pragma mark Delete

// 在itemObj的个数为0的时候删除itemObj，并且保持其他itemObj的选中状态
- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (void) deleteSelectedItems;

#pragma mark -
#pragma mark Custom M

- (void) minusAtIndexPath:(NSIndexPath *)indexPath;
- (void) plusAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ChooseSection : NSObject

@property (nonatomic ,strong) id section;
@property (nonatomic ,assign) NSInteger sectionIndex;
@property (nonatomic ,assign ,getter=isFold) BOOL fold;

@property (nonatomic ,assign ,getter=isAllItemsSelected) BOOL allItemsSelected;

@property (assign) CGFloat price;//当前section的总价格

+ (instancetype) sectionWith:(id)data;
@end


@interface ChooseItem : NSObject

@property (nonatomic ,strong) id item;
@property (nonatomic ,strong) NSIndexPath * indexPath;

@property (nonatomic ,assign ,getter=isSelected) BOOL selected;

@property (nonatomic ,assign) NSInteger count;
@property (assign) CGFloat price;//当前item的价格

+ (instancetype) itemWith:(id)data;
@end
