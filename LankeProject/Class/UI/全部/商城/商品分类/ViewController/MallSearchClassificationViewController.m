//
//  MallSearchInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchClassificationViewController.h"
#import "MallClassificationView.h"
#import "LKPickSectionCell.h"
#import "MallSearchGoodsCell.h"
#import "MallClassificationSectionView.h"

#import "ProprietaryShopViewController.h"

@interface MallSearchClassificationViewController ()<MallClassificationViewDelegate,MallClassificationViewDataSource>

@property (nonatomic ,strong) MallClassificationView * classificationView;
@property (nonatomic ,strong) NSMutableArray * pickItems;

@end

@implementation MallSearchClassificationViewController

-(void)getGoodsClassList
{
    [UserServices getGoodsClassListCompletionBlock:^(int result, id responseObject) {
        if (result==0)
        {
            [self.pickItems addObjectsFromArray:responseObject[@"data"]];
            [self.classificationView reloadData];
            [self.classificationView setSelectSectionIndex:self.seletedNum];

        }
    }];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _pickItems = [NSMutableArray array];
    [self showNavBarCustomByTitle:@"商品分类"];
    [self creatUI];
    [self getGoodsClassList];
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
    
    [self.classificationView configUICollectionViewFlowLayout:[self configFlowLayout]];
}
- (UICollectionViewFlowLayout *) configFlowLayout{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (DEF_SCREEN_WIDTH - 100-4*10)/3.0;
    CGFloat height = 100;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 40.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    return layout;
    
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
    if (self.pickItems.count==0)
    {
        return 0;
    }
    NSArray *sectionArr=self.pickItems[pickView.currentSelectSectionIndex][@"listClass"];
    return sectionArr.count;
}
//右侧分组行数row
- (NSInteger)pickView:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section
{
    if (self.pickItems.count==0)
    {
        return 0;
    }
    NSArray *sectionArr=self.pickItems[pickView.currentSelectSectionIndex][@"listClass"][section][@"listThridClass"];
    return sectionArr.count;
}
//左侧分组行数
- (NSInteger)numberOfSectionsInPickView:(nonnull MallClassificationView *)pickView
{
    
    return self.pickItems.count;
}

- (nonnull __kindof UITableViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    NSDictionary *data=self.pickItems[section];
    LKPickSectionCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[LKPickSectionCell cellIdentifier] forSection:section];
    [cell loadCellWithDataSource:data];
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSArray *sectionArr=self.pickItems[pickerView.currentSelectSectionIndex][@"listClass"][indexPath.section][@"listThridClass"];
    NSDictionary *data=sectionArr[indexPath.row];
    MallSearchGoodsCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[MallSearchGoodsCell cellIdentifier] forIndexPath:indexPath];
    [cell loadCellWithDataSource:data];
    return cell;
}

-(UICollectionReusableView *)pickView:(__kindof MallClassificationView *)pickView viewForSupplementaryElementOfKind:(__kindof NSString *)kind atIndexPath:(__kindof NSIndexPath *)indexPath
{

    NSDictionary *onedata=self.pickItems[pickView.currentSelectSectionIndex];
    NSDictionary *twodata=onedata[@"listClass"][indexPath.section];
    MallClassificationSectionView *section=[pickView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MallClassificationSectionView cellIdentifier] forIndexPath:indexPath];
    section.title.text=twodata[@"classNameSecond"];
    [section receiveObject:^(id object) {
        
        if (self.item)
        {
            self.item.classOneName=onedata[@"classNameFirst"];
            self.item.classOneId=onedata[@"classOneId"];
            self.item.classTwoName=twodata[@"classNameSecond"];
            self.item.classTwoId=twodata[@"classTwoId"];
            self.item.classThridId=nil;
            self.item.classNameThird=nil;
            [self sendObject:@"reload"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            GoodSearchItem *searchItem=[[GoodSearchItem alloc]init];
            ProprietaryShopViewController *proprietaryShop=[[ProprietaryShopViewController alloc]init];
            searchItem.classOneName=onedata[@"classNameFirst"];
            searchItem.classOneId=onedata[@"classOneId"];
            searchItem.classTwoName=twodata[@"classNameSecond"];
            searchItem.classTwoId=twodata[@"classTwoId"];
            proprietaryShop.searchItem=searchItem;
            [self.navigationController pushViewController:proprietaryShop animated:YES];
            
        }

    }];
    return section;
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section
{
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *onedata=self.pickItems[pickerView.currentSelectSectionIndex];
    NSDictionary *twodata=onedata[@"listClass"][indexPath.section];
    NSDictionary *threedata=twodata[@"listThridClass"][indexPath.row];
    if (self.item)
    {
        self.item.classOneName=onedata[@"classNameFirst"];
        self.item.classOneId=onedata[@"classOneId"];
        self.item.classTwoName=twodata[@"classNameSecond"];
        self.item.classTwoId=twodata[@"classTwoId"];
        self.item.classThridId=threedata[@"classThridId"];
        self.item.classNameThird=threedata[@"classNameThird"];
        [self sendObject:@"reload"];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        GoodSearchItem *searchItem=[[GoodSearchItem alloc]init];
        ProprietaryShopViewController *proprietaryShop=[[ProprietaryShopViewController alloc]init];
        searchItem.classOneName=onedata[@"classNameFirst"];
        searchItem.classOneId=onedata[@"classOneId"];
        searchItem.classTwoName=twodata[@"classNameSecond"];
        searchItem.classTwoId=twodata[@"classTwoId"];
        searchItem.classNameThird=threedata[@"classNameThird"];
        searchItem.classThridId=threedata[@"classThridId"];
        proprietaryShop.searchItem=searchItem;
        [self.navigationController pushViewController:proprietaryShop animated:YES];
        
    }
    
}

@end
