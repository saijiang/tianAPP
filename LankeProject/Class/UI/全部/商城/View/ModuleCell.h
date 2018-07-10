//
//  ModuleCell.h
//  DDXGProject
//
//  Created by itman on 16/1/22.
//  Copyright (c) 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModuleCell;
@protocol ModuleCellDelegate <NSObject>

- (void) moduleCell : (ModuleCell*) ModuleCell didSelectIndex : (NSInteger) index;

@end


@interface ModuleCell : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *dataSource;
    UICollectionViewFlowLayout * layout;
    MyPageControlView *page;
}

@property(nonatomic,assign)id<ModuleCellDelegate>delegate;
-(void)loadCellWithDataSource:(NSArray *)data;

@end

typedef void(^didSelectItemAtIndexPath)(NSInteger indexPathrow);

@interface ModelCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *dataSource;
    UICollectionViewFlowLayout * layout;
}
@property(nonatomic,strong)didSelectItemAtIndexPath didSelectItemAtIndexPathBlock;
-(void)loadCellWithDataSource:(NSArray *)data;
-(void)didSelectItemAtIndexPathBlock:(didSelectItemAtIndexPath)selectItemAtIndexPathBlock;
@end

