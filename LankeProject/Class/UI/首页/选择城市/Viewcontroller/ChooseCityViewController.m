//
//  ChooseCityViewController.m
//  LankeProject
//
//  Created by itman on 17/2/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChooseCityViewController.h"

#import "CSStickyHeaderFlowLayout.h"

#import "ChooseCityCell.h"

#import "ChooseCityHeaderView.h"

@interface ChooseCityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;//字母检索表
    NSMutableArray *dataSource;//城市列表
}


@property(nonatomic,strong)UICollectionView *collectionView;


@end

@implementation ChooseCityViewController

-(void)getCityData
{
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"allCityConfig" ofType:@"json"]];
    NSError * error = nil;
    NSDictionary * data = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    dataSource=[[NSMutableArray alloc]initWithArray:data[@"data"]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCityData];
    
    [self showNavBarCustomByTitle:@"选择城市"];
    //创建城市列表
    [self createCollectionView];
    
    //创建字母选择表
    [self createTableView];
    
    
}

#pragma mark -------------------------------------   界面初始化    --------------------------------------------

- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 30, DEF_CONTENT) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BM_CLEAR;
    _tableView.tableFooterView = [UIView new];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
 
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(30);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
}
- (void)createCollectionView
{
    
    CSStickyHeaderFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.disableStickyHeaders = YES;
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_HEIGHT(self.view)) collectionViewLayout:layout];
    self.collectionView.backgroundColor=BM_WHITE;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical=YES;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView registerClass:[ChooseCityCell class]
            forCellWithReuseIdentifier:@"ChooseCityCell"];
    [self.collectionView registerClass:[ChooseCityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ChooseCityHeaderView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataSource[section][@"city"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCityCell *cell=(ChooseCityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseCityCell" forIndexPath:indexPath];
    [cell loadCityWithData:dataSource[indexPath.section][@"city"][indexPath.row]];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEF_SCREEN_WIDTH, 40);

}

#pragma mark---设置collectionView－referenceSizeForHeaderInSection高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 22.f);
    return headerReferenceSize;
}

#pragma mark---设置collectionView－ 高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    CGSize footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    return footerReferenceSize;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader)
    {
        
        ChooseCityHeaderView *view =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ChooseCityHeaderView" forIndexPath:indexPath];
        view.title.text=dataSource[indexPath.section][@"alphabet"];
        return view;

    }
    else
    {
        UICollectionReusableView *view =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        return view;
        
    }

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data= dataSource[indexPath.section][@"city"][indexPath.row];
    [self sendObject:data[@"cityName"]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  ------------------------------  UITableViewDelegate   ---------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = (DEF_CONTENT)/dataSource.count;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BM_CLEAR;
        UILabel *lable = [[UILabel alloc]init];
        lable.font = BM_FONTSIZE14;
        lable.textColor = BM_GRAY;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = 101010;
        [cell.contentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
    }
    
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:101010];
    label.text = [NSString stringWithFormat:@"%@",dataSource[indexPath.section][@"alphabet"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
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
