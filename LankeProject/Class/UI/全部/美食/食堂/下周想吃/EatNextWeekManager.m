//
//  EatNextWeekManager.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/3.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "EatNextWeekManager.h"

@interface EatNextWeekManager ()

@property (nonatomic ,strong) NSMutableArray * weekItems;

@end

@implementation EatNextWeekManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _weekItems = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark API M

- (void)configPickView:(HLLPickView *)pickView{

    pickView.dataSource = self;
    pickView.delegate = self;
    
    self.pickView = pickView;
    
    [self.pickView registerClass:[LKPickSectionCell class]
       forSectionReuseIdentifier:[LKPickSectionCell cellIdentifier]];
    [self.pickView registerClass:[EatNexWeekCell class]
           forRowReuseIdentifier:[EatNexWeekCell cellIdentifier]];
}

- (void) configManagerWith:(NSArray *)data{

    [self.weekItems removeAllObjects];
    
    for (NSDictionary * sectionData in data) {
        
        EatNextWeekSection * sectionItem = [EatNextWeekSection sectionWithOriginalData:sectionData];
        
        [self.weekItems addObject:sectionItem];
    }
    
    [self.pickView reloadData];
}

- (NSInteger) numberOfSections{

    return self.weekItems.count;
}

- (id) sectionItemAtSection:(NSInteger)section{

    EatNextWeekSection * sectionItem = self.weekItems[section];
    
    return sectionItem.originalData;
}

- (NSInteger) numberOfRowsInSection:(NSInteger)section{

    if (self.weekItems.count) {
        
        EatNextWeekSection * sectionItem = self.weekItems[section];
        
        return sectionItem.rows.count;
    }
    return 0;
}
- (EatNextWeekRow *) rowItemAtIndexPath:(NSIndexPath *)indexPath{

    EatNextWeekSection * sectionItem = self.weekItems[indexPath.section];
    
    EatNextWeekRow * row = sectionItem.rows[indexPath.row];
    
    return row;
}

#pragma mark -
#pragma mark Private M

- (void) addWantEat:(EatNextWeekRow *)data{
    
    //
    [self requestWantDishesWithData:data.originalData completion:^{
        data.count += 1;
        data.want = YES;
        [self.pickView reloadData];
    }];
}

#pragma mark -
#pragma mark HLLPickView M

- (NSInteger)pickView:(nonnull HLLPickView *)pickView numberOfRowsInSection:(NSInteger)section{
    
    return [self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInPickView:(nonnull HLLPickView *)pickView{
    
    return [self numberOfSections];
}

- (nonnull __kindof UITableViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    LKPickSectionCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[LKPickSectionCell cellIdentifier] forSection:section];
    
    NSDictionary * sectionObject = [self sectionItemAtSection:section];
    
    [cell configCellWithData:sectionObject];
    
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    EatNexWeekCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[EatNexWeekCell cellIdentifier] forIndexPath:indexPath];
    
    EatNextWeekRow * itemObject = [self rowItemAtIndexPath:indexPath];
    
    [cell configCellWithData:itemObject];
    
    LKWeakSelf
    cell.wantEatDishesHandle = ^(){
        
        LKStrongSelf
        [_self addWantEat:itemObject];
    };
    
    return cell;
}

- (void) pickView:(nonnull HLLPickView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    EatNextWeekRow * rowObject = [self rowItemAtIndexPath:indexPath];
    
    if (self.bPickViewDidSelectItemWithDataHandle) {
        self.bPickViewDidSelectItemWithDataHandle(rowObject.originalData);
    }
}


#pragma mark -
#pragma mark Network M

- (void) requestWantDishesWithData:(id)data completion:(void(^)())completion{
    
    [UserServices saveWeekEatWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] dishesId:data[@"dishesId"] completionBlock:^(int result, id responseObject) {
        
        if (completion) {
            completion();
        }
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"想吃成功"];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end

@implementation EatNextWeekSection

- (instancetype) initSectionWithOriginalData:(id)originalData{

    self = [super init];
    if (self) {
        
        self.originalData = originalData;
        
        NSArray * rowDatas = originalData[@"listMenu"];
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:rowDatas.count];
        
        for (NSDictionary * rowData in rowDatas) {
            EatNextWeekRow * row = [EatNextWeekRow rowWithOriginalData:rowData];
            [temp addObject:row];
        }
        self.rows = temp;
    }
    return self;
}
+ (instancetype) sectionWithOriginalData:(id)originalData{
    
    EatNextWeekSection * item = [[EatNextWeekSection alloc] initSectionWithOriginalData:originalData];
    return item;
}
@end

@implementation EatNextWeekRow

- (instancetype) initRowWithOriginalData:(id)originalData{

    self = [super init];
    if (self) {
        self.originalData = originalData;
        self.want = [originalData[@"isExist"] boolValue];
        self.count = [originalData[@"count"] integerValue];
    }
    return self;
}
+ (instancetype) rowWithOriginalData:(id)originalData{
    
    EatNextWeekRow * item = [[EatNextWeekRow alloc] initRowWithOriginalData:originalData];
    return item;
}


@end
