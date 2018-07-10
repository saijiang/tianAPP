//
//  HLLPickView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLLPickView;

@protocol HLLPickerDelegate <NSObject>

@optional

- (void) pickView:(nonnull HLLPickView *)pickerView didPickSectionAtSection:(NSInteger)section;
- (void) pickView:(nonnull HLLPickView *)pickerView didDepickSectionAtSection:(NSInteger)section;

- (void) pickView:(nonnull HLLPickView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (CGFloat) pickView:(nonnull HLLPickView *)pickView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@end

@protocol HLLPickerDataSource <NSObject>

@required

- (NSInteger)pickView:(nonnull HLLPickView *)pickView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInPickView:(nonnull HLLPickView *)pickView;

- (nonnull __kindof UITableViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForSectionAtSection:(NSInteger)section;
- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@optional

@end

@interface HLLPickView : UIView

@property (nonatomic ,assign) BOOL defaultSelectFirstSection;// default is YES

@property (nonatomic ,weak ,nullable) id<HLLPickerDelegate> delegate;
@property (nonatomic ,weak ,nullable) id<HLLPickerDataSource> dataSource;

- (nullable UIView *) sectionViewForSection:(NSInteger)section;
- (NSInteger) currentSelectSectionIndex;

- (void)registerClass:(nullable Class)cellClass forSectionReuseIdentifier:(nullable NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forRowReuseIdentifier:(nullable NSString *)identifier;

- (nullable __kindof UITableViewCell *) dequeueReusablePickSectionWithIdentifier:(nullable NSString *)identifier forSection:(NSInteger)section;
- (nullable __kindof UICollectionViewCell *) dequeueReusablePickRowWithIdentifier:(nullable NSString *)identifier forIndexPath:(nullable NSIndexPath *)indexPath;

- (void) reloadData;

//- (void) configPickViewWithData:(id)data;
@end
