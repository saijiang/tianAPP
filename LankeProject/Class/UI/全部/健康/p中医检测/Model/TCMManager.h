//
//  TCMManager.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllFunctionConfig.h"

@class TCMManager;
@protocol TCMManagerDelegate <NSObject>

@optional
- (void) tcmManager:(TCMManager *)manager forValid:(BOOL)valid;

@end

@interface TCMManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSString * type;// (01：平和质， 02：气虚质， 03：阳虚质 ，04：阴虚质 ，05：痰虚质， 06：湿热质， 07：血瘀质， 08：气虚质， 09：特禀质

@property (nonatomic ,weak) id<TCMManagerDelegate> delegate;
@property (nonatomic ,weak) UICollectionView * collectionView;

- (instancetype) initWithType:(NSString *)type;

- (void)config:(NSArray *)dataSource;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;
- (id) sectionObjectAtSection:(NSInteger)section;
- (id) itemObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void) selectItemAtIndexPath:(NSIndexPath *)indexPath;

- (id) result;
@end


@interface TCMSectionItem : NSObject
@property (nonatomic ,strong) id data;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,assign) NSInteger sumScore;

@property (nonatomic ,strong) NSArray * items;
@property (nonatomic ,assign) BOOL haveSelect;

- (void)configItemsForSelectIndex:(NSInteger)index;
@end

@interface TCMRowItem : NSObject

@property (nonatomic ,strong) NSString * display;
@property (nonatomic ,assign ,getter=isSelect) BOOL select;
@property (nonatomic ,assign) NSInteger score;

- (TCMRowItem *) config:(BOOL)select;

+ (instancetype) none;
+ (instancetype) little;
+ (instancetype) some;
+ (instancetype) often;
+ (instancetype) alway;
@end
