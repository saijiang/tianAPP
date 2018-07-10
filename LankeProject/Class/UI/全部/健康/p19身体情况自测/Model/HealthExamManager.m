//
//  HealthExamManager.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamManager.h"
#import "HealthExamSingleSelectCCell.h"
#import "HealthExamSectionHeaderReView.h"

@interface HealthExamManager ()

@property (nonatomic ,strong) NSMutableArray * datas;

@end

@implementation HealthExamManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)configAllFunctionWithDataSource:(DataSource *)dataSource{
    
    [self registReuseView];
    
    NSArray * datas = [dataSource parseDataSource];
    
    if (!datas) {
        
        [NSException raise:@"NULL NSArray"
                    format:@"You json file <%@.json> for dataSource is NULL",dataSource.dataSourceName];
    }
    
    for (NSDictionary * sectionData in datas) {
    
        ExamSectionItem * sectionItem = [[ExamSectionItem alloc] init];
        sectionItem.data = sectionData;
        
        NSMutableArray * items = [NSMutableArray array];
        for (NSDictionary * rowData in sectionData[@"items"]) {
            
            ExamRowItem * rowItem = [[ExamRowItem alloc] init];
            rowItem.data = rowData;
            rowItem.select = [rowData[@"select"] boolValue];
            [items addObject:rowItem];
        }
        sectionItem.items = items;
        
        [self.datas addObject:sectionItem];
    }
    
    [self.collectionView reloadData];
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

    NSMutableArray * sectionSet = [NSMutableArray array];
    
    for (NSInteger section = 0; section < [self numberOfSections]; section ++) {
        
        NSMutableArray * rowSet = [NSMutableArray array];
        for (NSInteger row = 0; row < [self numberOfItemsInSection:section]; row ++) {
            ExamRowItem * itemObj = [self itemObjectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [rowSet addObject:[NSNumber numberWithBool:@(itemObj.isSelect)]];
        }
        [sectionSet addObject:rowSet];
    }
    return sectionSet;
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

- (ExamSectionItem *) sectionObjectAtSection:(NSInteger)section{
    
    id data = self.datas[section];
    
    return data;
}

- (ExamRowItem *) itemObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self itemsAtSection:indexPath.section][indexPath.row];
}

- (NSArray *) itemsAtSection:(NSInteger)section{
    
    ExamSectionItem * data = [self sectionObjectAtSection:section];
    
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
    
    ExamSectionItem  * sectionItem = [self sectionObjectAtSection:indexPath.section];
    BOOL multiselect = [sectionItem.data[@"multiselect"] boolValue];
    
    id data = [self itemObjectAtIndexPath:indexPath];
    
    HealthExamSingleSelectCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HealthExamSingleSelectCCell cellIdentifier] forIndexPath:indexPath];
    if (multiselect) {
        
        cell.selectImageView.image = [UIImage imageNamed:@"no_choose"];
        cell.selectImageView.highlightedImage = [UIImage imageNamed:@"choose"];
    }else{
        
        cell.selectImageView.image = [UIImage imageNamed:@"circle_choose_off"];
        cell.selectImageView.highlightedImage = [UIImage imageNamed:@"circle_choose_on"];
    }
    [cell configCellWithData:data];
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        ExamSectionItem * sectionItem = [self sectionObjectAtSection:indexPath.section];
        HealthExamSectionHeaderReView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[HealthExamSectionHeaderReView reuseIdentifier] forIndexPath:indexPath];
        [headerView config:sectionItem.data];
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

    ExamSectionItem * sectionItem = [self sectionObjectAtSection:section];
    
    return [HealthExamSectionHeaderReView headerReferenceSizeWithData:sectionItem.data];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(DEF_SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self selectItemAtIndexPath:indexPath];
}

- (void) selectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self saveBodySelfCheckAtIndexPath:indexPath];
    
    if (indexPath.section != 2) {
        
        if (indexPath.section == 0 && indexPath.row == 5)
        {
            if ([self.info.noDiseaseFlg integerValue] == 1)
            {
                if ([self.info.diabetesFlg integerValue] == 1 || [self.info.heartDiseaseFlg integerValue] == 1 || [self.info.hypertensionFlg integerValue] == 1 || [self.info.hypopiesiaFlg integerValue] == 1 || [self.info.glucopeniaFlg integerValue] == 1)
                {
                    [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                    self.info.noDiseaseFlg = @"0";
                    ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                    multiRowData.select = NO;
                    [self.collectionView reloadData];
                    return;
                }
            }
        }
        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
        multiRowData.select = !multiRowData.isSelect;
        
    }else{
        
        ExamSectionItem * sectionItem = [self sectionObjectAtSection:indexPath.section];
        for (NSInteger index = 0; index < sectionItem.items.count; index ++) {
        
            ExamRowItem * rowItem = sectionItem.items[index];
            rowItem.select = index == indexPath.item;
        }
    }
    
    [self.collectionView reloadData];
}

-(void)saveBodySelfCheckAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if ([self.info.diabetesFlg integerValue]==0)
                {
                    if ([self.info.noDiseaseFlg integerValue] == 1)
                    {
                        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                        multiRowData.select = !multiRowData.select;
                        self.info.diabetesFlg = @"0";
                    }
                    else
                    {
                        self.info.diabetesFlg=@"1";
                    }
                    
                    
                }
                else
                {
                    self.info.diabetesFlg=@"0";
                    
                }
            }
                break;
            case 1:
            {
                if ([self.info.heartDiseaseFlg integerValue]==0)
                {
                    if ([self.info.noDiseaseFlg integerValue] == 1)
                    {
                        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                        multiRowData.select = !multiRowData.select;
                        self.info.heartDiseaseFlg = @"0";
                    }
                    else
                    {
                        self.info.heartDiseaseFlg=@"1";
                    }
                    
                    
                }
                else
                {
                    self.info.heartDiseaseFlg=@"0";
                }
                
            }
                break;
            case 2:
            {
                if ([self.info.hypertensionFlg integerValue]==0)
                {
                    
                    
                    if ([self.info.noDiseaseFlg integerValue] == 1)
                    {
                        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                        multiRowData.select = !multiRowData.select;
                        self.info.hypertensionFlg = @"0";
                    }
                    else
                    {
                        self.info.hypertensionFlg=@"1";
                    }
                    
                }
                else
                {
                    self.info.hypertensionFlg=@"0";
                }
                
            }
                break;
            case 3:
            {
                if ([self.info.hypopiesiaFlg integerValue]==0)
                {
                    
                    if ([self.info.noDiseaseFlg integerValue] == 1)
                    {
                        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                        multiRowData.select = !multiRowData.select;
                        self.info.hypopiesiaFlg = @"0";
                    }
                    else
                    {
                        self.info.hypopiesiaFlg=@"1";
                    }
                }
                else
                {
                    self.info.hypopiesiaFlg=@"0";
                }
                
            }
                break;
            case 4:
            {
                if ([self.info.glucopeniaFlg integerValue]==0)
                {
                    
                    if ([self.info.noDiseaseFlg integerValue] == 1)
                    {
                        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
                        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
                        multiRowData.select = !multiRowData.select;
                        self.info.glucopeniaFlg = @"0";
                    }
                    else
                    {
                        self.info.glucopeniaFlg=@"1";
                    }
                    
                }
                else
                {
                    self.info.glucopeniaFlg=@"0";
                }
                
            }
                break;
            case 5:
            {
                if ([self.info.noDiseaseFlg integerValue]==0)
                {
                    
                    self.info.noDiseaseFlg=@"1";

                }
                else
                {
                    self.info.noDiseaseFlg=@"0";
                }
                
            }
                break;
            default:
                break;
        }

    }
    else if (indexPath.section==1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if ([self.info.walkFlg integerValue]==0)
                {
                    self.info.walkFlg=@"1";
                    
                }
                else
                {
                    self.info.walkFlg=@"0";
                }
            }
                break;
            case 1:
            {
                if ([self.info.joggingFlg integerValue]==0)
                {
                    self.info.joggingFlg=@"1";
                    
                }
                else
                {
                    self.info.joggingFlg=@"0";
                }
                
            }
                break;
            case 2:
            {
                if ([self.info.swimmingFlg integerValue]==0)
                {
                    self.info.swimmingFlg=@"1";
                    
                }
                else
                {
                    self.info.swimmingFlg=@"0";
                }
                
            }
                break;
            case 3:
            {
                if ([self.info.trackFlg integerValue]==0)
                {
                    self.info.trackFlg=@"1";
                    
                }
                else
                {
                    self.info.trackFlg=@"0";
                }
                
            }
                break;
            case 4:
            {
                if ([self.info.basketballFlg integerValue]==0)
                {
                    self.info.basketballFlg=@"1";
                    
                }
                else
                {
                    self.info.basketballFlg=@"0";
                }
                
            }
                break;
            case 5:
            {
                if ([self.info.bicycleFlg integerValue]==0)
                {
                    self.info.bicycleFlg=@"1";
                    
                }
                else
                {
                    self.info.bicycleFlg=@"0";
                }
                
            }
                break;
            case 6:
            {
                if ([self.info.ridingHorseFlg integerValue]==0)
                {
                    self.info.ridingHorseFlg=@"1";
                    
                }
                else
                {
                    self.info.ridingHorseFlg=@"0";
                }
            }
                break;
            case 7:
            {
                if ([self.info.badmintonFlg integerValue]==0)
                {
                    self.info.badmintonFlg=@"1";
                    
                }
                else
                {
                    self.info.badmintonFlg=@"0";
                }
                
            }
                break;
            case 8:
            {
                if ([self.info.golfFlg integerValue]==0)
                {
                    self.info.golfFlg=@"1";
                    
                }
                else
                {
                    self.info.golfFlg=@"0";
                }
                
            }
                break;
            case 9:
            {
                if ([self.info.footballFlg integerValue]==0)
                {
                    self.info.footballFlg=@"1";
                    
                }
                else
                {
                    self.info.footballFlg=@"0";
                }
                
            }
                break;
            case 10:
            {
                if ([self.info.jumpFlg integerValue]==0)
                {
                    self.info.jumpFlg=@"1";
                    
                }
                else
                {
                    self.info.jumpFlg=@"0";
                }
                
            }
                break;
            case 11:
            {
                if ([self.info.squashFlg integerValue]==0)
                {
                    self.info.squashFlg=@"1";
                    
                }
                else
                {
                    self.info.squashFlg=@"0";
                }
                
            }
                break;

            case 12:
            {
                if ([self.info.tennisFlg integerValue]==0)
                {
                    self.info.tennisFlg=@"1";
                    
                }
                else
                {
                    self.info.tennisFlg=@"0";
                }
            }
                break;
            case 13:
            {
                if ([self.info.tableTennisFlg integerValue]==0)
                {
                    self.info.tableTennisFlg=@"1";
                    
                }
                else
                {
                    self.info.tableTennisFlg=@"0";
                }
                
            }
                break;
            case 14:
            {
                if ([self.info.volleyballFlg integerValue]==0)
                {
                    self.info.volleyballFlg=@"1";
                    
                }
                else
                {
                    self.info.volleyballFlg=@"0";
                }
                
            }
                break;
           
            default:
                break;
        }

    }
    else if (indexPath.section==2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                self.info.sportsRate=@"01";

            }
                break;
            case 1:
            {
                self.info.sportsRate=@"02";

            }
                break;
            case 2:
            {
                self.info.sportsRate=@"03";

            }
                break;
            case 3:
            {
                self.info.sportsRate=@"04";

            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark --- 选择了无疾病,其他选项就不可选
-(void)checkNoDiseaseFlgWithIndex:(NSIndexPath *)indexPath
{
    //选择了无疾病,其他选项就不可选
    /*
     self.info.diabetesFlg=@"0";
     self.info.heartDiseaseFlg=@"0";
     self.info.hypertensionFlg=@"0";
     self.info.hypopiesiaFlg=@"0";
     self.info.glucopeniaFlg=@"0";
     */
    
    if ([self.info.noDiseaseFlg integerValue] == 1)
    {
        [UnityLHClass showAlertView:@"选择项相互矛盾，请确认后再选择"];
        ExamRowItem * multiRowData = [self itemObjectAtIndexPath:indexPath];
        multiRowData.select = YES;
        
        self.info.diabetesFlg=@"0";
        self.info.heartDiseaseFlg=@"0";
        self.info.hypertensionFlg=@"0";
        self.info.hypopiesiaFlg=@"0";
        self.info.glucopeniaFlg=@"0";
        
        [self.collectionView reloadData];
        
        return;
    }
    

}


@end

@implementation ExamSectionItem

@end
@implementation ExamRowItem

@end
