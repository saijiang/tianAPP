//
//  MallSearchInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "OneShopClassificationViewController.h"
#import "MallClassificationView.h"
#import "LKPickSectionCell.h"
#import "MallSearchGoodsCell.h"
#import "MallClassificationSectionView.h"

@interface OneShopClassificationViewController ()<MallClassificationViewDelegate,MallClassificationViewDataSource>

@property (nonatomic ,strong) MallClassificationView * classificationView;
@property (nonatomic ,strong) NSMutableArray * firstCategoryList;
@property (nonatomic ,strong) NSMutableArray * secondCategoryList;

@end

@implementation OneShopClassificationViewController

//1号店1级商品分类列表接口
-(void)getFirstCategoryList
{
    [UserServices getFirstCategoryListCompletionBlock:^(int result, id responseObject) {
        if (result==0)
        {
            [self.firstCategoryList addObjectsFromArray:responseObject[@"data"]];
            [self.classificationView reloadData];
            [self getSecondCategoryListWithCategoryIdFirst:self.firstCategoryList.firstObject[@"categoryIdFirst"]];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
//1号店2级以及3级商品分类列表接口
-(void)getSecondCategoryListWithCategoryIdFirst:(NSString *)categoryIdFirst
{
    [UserServices
     getSecondCategoryListWithCategoryIdFirst:categoryIdFirst
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self.secondCategoryList removeAllObjects];
            [self.secondCategoryList addObjectsFromArray:responseObject[@"data"]];
            [self.classificationView reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstCategoryList = [NSMutableArray array];
    _secondCategoryList = [NSMutableArray array];
    [self showNavBarCustomByTitle:@"一号店商品分类"];
    [self creatUI];
    [self getFirstCategoryList];
}
- (void)createNav
{
    SearchView *search=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-120, 44)];
    search.searchFD.placeholder=@"输入关键词进行搜索";
    search.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    [search receiveObject:^(id object) {
        
    }];
    [self showNavBarCustomByView:search];
    
}
- (void) creatUI
{
    
    self.classificationView = [[MallClassificationView alloc] init];
    self.classificationView.backgroundColor = [UIColor clearColor];
    self.classificationView.dataSource = self;
    self.classificationView.delegate = self;
    [self.classificationView registerClass:[LKPickSectionCell class]
                 forSectionReuseIdentifier:[LKPickSectionCell cellIdentifier]];
    [self.classificationView registerClass:[MallSearchGoodsCell class]
                     forRowReuseIdentifier:[MallSearchGoodsCell cellIdentifier]];
    [self.classificationView registerClass:[MallClassificationSectionView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:[MallClassificationSectionView cellIdentifier]];
    [self.view addSubview:self.classificationView];
    
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    [self.classificationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    
}
#pragma mark -
#pragma mark MallClassificationView M

//右侧分组行数section
-(NSInteger)pickViewNumberOfRowsInSection:(MallClassificationView *)pickView
{
    return self.secondCategoryList.count;
}
//右侧分组行数row
- (NSInteger)pickView:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section
{
    NSArray *thirdList=self.secondCategoryList[section][@"thirdList"];
    return thirdList.count;
}
//左侧分组行数
- (NSInteger)numberOfSectionsInPickView:(nonnull MallClassificationView *)pickView
{
    
    return self.firstCategoryList.count;
}

- (nonnull __kindof UITableViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    NSDictionary *data=self.firstCategoryList[section];
    LKPickSectionCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[LKPickSectionCell cellIdentifier] forSection:section];
    cell.sectionNameLabel.text=data[@"categoryNameFirst"];
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSDictionary *data=self.secondCategoryList[indexPath.section][@"thirdList"][indexPath.row];
    MallSearchGoodsCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[MallSearchGoodsCell cellIdentifier] forIndexPath:indexPath];
    cell.goodName.text=data[@"categoryNameThird"];
    [cell.goodIcon sd_setImageWithURL:[NSURL URLWithString:data[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"temp_food_photo"]];
    return cell;
}

-(UICollectionReusableView *)pickView:(__kindof MallClassificationView *)pickView viewForSupplementaryElementOfKind:(__kindof NSString *)kind atIndexPath:(__kindof NSIndexPath *)indexPath
{
    NSDictionary *data=self.secondCategoryList[indexPath.section];
    MallClassificationSectionView *section=[pickView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MallClassificationSectionView cellIdentifier] forIndexPath:indexPath];
    section.title.text=data[@"categoryNameSecond"];
    return section;
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section
{
    [self getSecondCategoryListWithCategoryIdFirst:self.firstCategoryList[section][@"categoryIdFirst"]];

}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *data=self.secondCategoryList[indexPath.section][@"thirdList"][indexPath.row];
    self.searchItem.categorySearchCode=data[@"categoryIdThird"];
    [self sendObject:@"reload"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
