//
//  MallClassificationView.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallClassificationView;

@protocol MallClassificationViewDelegate <NSObject>

@optional

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section;
- (void) pickView:(nonnull MallClassificationView *)pickerView didDepickSectionAtSection:(NSInteger)section;

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (CGFloat) pickView:(nonnull MallClassificationView *)pickView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;


@end

@protocol MallClassificationViewDataSource <NSObject>

@required

-(NSInteger)pickViewNumberOfRowsInSection:(nonnull MallClassificationView *)pickView;

- (NSInteger)pickView:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)numberOfSectionsInPickViewHight:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInPickView:(nonnull MallClassificationView *)pickView;

-(nonnull __kindof UICollectionReusableView*)pickView:(nonnull __kindof MallClassificationView *)pickView viewForSupplementaryElementOfKind:(nonnull __kindof NSString *)kind atIndexPath:(nonnull __kindof NSIndexPath *)indexPath;

- (nonnull __kindof UITableViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForSectionAtSection:(NSInteger)section;

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@optional

@end

@interface MallClassificationView : UIView

@property (nonatomic ,assign) BOOL defaultSelectFirstSection;// default is YES

@property (nonatomic ,weak) id<MallClassificationViewDelegate> delegate;
@property (nonatomic ,weak) id<MallClassificationViewDataSource> dataSource;

- (void) configUICollectionViewFlowLayout:(UICollectionViewFlowLayout *)layout;

- (nullable UIView *) sectionViewForSection:(NSInteger)section;

- (void)registerClass:(nullable Class)cellClass forSectionReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forRowReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(nullable Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (__kindof UITableViewCell *) dequeueReusablePickSectionWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;

- (__kindof UICollectionViewCell *) dequeueReusablePickRowWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (__kindof UICollectionReusableView *) dequeueReusableSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void) setSelectSectionIndex:(NSInteger)index;

- (NSInteger) currentSelectSectionIndex;

- (void) reloadData;

@end

