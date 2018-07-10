//
//  MallSearchInfoViewController.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallSearchInfoViewController.h"
#import "MallClassificationView.h"
#import "LKPickSectionCell.h"
#import "MallSearchGoodsCell.h"
#import "MallClassificationSectionView.h"


@interface MallSearchInfoViewController ()<MallClassificationViewDelegate,MallClassificationViewDataSource>
@property (nonatomic ,strong) MallClassificationView * classificationView;
@property (nonatomic ,strong) NSMutableArray * pickItems;
@end

@implementation MallSearchInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _pickItems = [NSMutableArray array];
    [self createNav];
    [self creatUI];
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
    self.classificationView.delegate  =self;
    
    [self.classificationView registerClass:[LKPickSectionCell class]
                  forSectionReuseIdentifier:[LKPickSectionCell cellIdentifier]];
    
    [self.classificationView registerClass:[MallSearchGoodsCell class]
                      forRowReuseIdentifier:[MallSearchGoodsCell cellIdentifier]];
    
    [self.classificationView registerClass:[MallClassificationSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MallClassificationSectionView cellIdentifier]];
    
    
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

-(NSInteger)pickViewNumberOfRowsInSection:(MallClassificationView *)pickView
{
    return 3;
}
- (NSInteger)pickView:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (NSInteger)numberOfSectionsInPickView:(nonnull MallClassificationView *)pickView
{
    
    return 5;
}

- (nonnull __kindof UITableViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    LKPickSectionCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[LKPickSectionCell cellIdentifier] forSection:section];
    [cell loadCellWithDataSource:nil];
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    MallSearchGoodsCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[MallSearchGoodsCell cellIdentifier] forIndexPath:indexPath];
    [cell loadCellWithDataSource:nil];
    return cell;
}

-(UICollectionReusableView *)pickView:(__kindof MallClassificationView *)pickView viewForSupplementaryElementOfKind:(__kindof NSString *)kind atIndexPath:(__kindof NSIndexPath *)indexPath
{
    MallClassificationSectionView *section=[pickView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MallClassificationSectionView cellIdentifier] forIndexPath:indexPath];
    section.title.text=@"进口食品";
    return section;
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section
{
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    

    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
