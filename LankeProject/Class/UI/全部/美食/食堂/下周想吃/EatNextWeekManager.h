//
//  EatNextWeekManager.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLPickView.h"
#import "LKPickSectionCell.h"
#import "EatNexWeekCell.h"

@class EatNextWeekRow,EatNextWeekSection;

@interface EatNextWeekManager : NSObject<HLLPickerDelegate,HLLPickerDataSource>

@property (nonatomic ,assign) HLLPickView * pickView;
@property (nonatomic ,copy) void (^bPickViewDidSelectItemWithDataHandle)(id data);

- (void) configPickView:(HLLPickView *)pickView;

- (void) configManagerWith:(id)data;

- (NSInteger) numberOfSections;
- (id) sectionItemAtSection:(NSInteger)section;

- (NSInteger) numberOfRowsInSection:(NSInteger)section;
- (EatNextWeekRow *) rowItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface EatNextWeekSection : NSObject

@property (nonatomic ,strong) id originalData;

@property (nonatomic ,strong) NSArray * rows;

- (instancetype) initSectionWithOriginalData:(id)originalData;
+ (instancetype) sectionWithOriginalData:(id)originalData;

@end

@interface EatNextWeekRow : NSObject

@property (nonatomic ,strong) id originalData;

@property (nonatomic ,assign) NSInteger count;
@property (nonatomic ,assign ,getter=isWant) BOOL want;

- (instancetype) initRowWithOriginalData:(id)originalData;
+ (instancetype) rowWithOriginalData:(id)originalData;

@end
