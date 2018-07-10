//
//  GroupBuyListViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//


#import "GroupBuyListViewController.h"
#import "MallBulkGoodCell.h"
#import "GroupBuyDetailViewController.h"
#import "UIViewController+Page.h"

@interface GroupBuyListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource>
{
    NSMutableArray *currentDataSource;
    NSMutableArray *dataSource;
    int pageIndex;

}

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation GroupBuyListViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (KAPPDELEGATE.topView) {
       [[[UIApplication sharedApplication].keyWindow viewWithTag:12306] removeFromSuperview];
    }
    
}
-(void)getGroupGoods
{
   
    
    [UserServices
     getGroupGoodsWithFlag:nil
     pageIndex:[NSString stringWithFormat:@"%d",pageIndex]
     pageSize:@"10"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [currentDataSource removeAllObjects];
             if (pageIndex==1)
             {
                 [dataSource removeAllObjects];
             }
             [currentDataSource addObjectsFromArray:responseObject[@"data"]];
             [dataSource addObjectsFromArray:currentDataSource];
             [self.collectionView reloadData];
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
    
    [self showNavBarCustomByTitle:@"团购列表"];
    pageIndex=1,
    dataSource=[[NSMutableArray alloc]init];
    currentDataSource=[[NSMutableArray alloc]init];

    [self getGroupGoods];
}

-(void)createUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.emptyDataSetSource=self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.top.mas_equalTo(10);

    }];
    
    [self.collectionView registerClass:[MallBulkGoodCell class]
            forCellWithReuseIdentifier:@"MallBulkGoodCell"];
    __weak GroupBuyListViewController *week=self;
    [self.collectionView addHeaderWithCallback:^{
        pageIndex=1;
        [week getGroupGoods];
        [week.collectionView headerEndRefreshing];
    }];
    [self.collectionView addFooterWithCallback:^{
        if (currentDataSource.count<10)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
        }
        else
        {
            pageIndex++;
            [week getGroupGoods];
        }
        [week.collectionView footerEndRefreshing];

    }];
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MallBulkGoodCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallBulkGoodCell" forIndexPath:indexPath];
    [cell loadCellWithDataSource:dataSource[indexPath.row]];
    cell.bHandle = ^(){
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }];
    };
    return cell;
    
}
#pragma mark UICollectionViewLayoutDelegate
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEF_SCREEN_WIDTH, 140);
    
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupBuyDetailViewController *detail=[[GroupBuyDetailViewController alloc]init];
    detail.goodsId = dataSource[indexPath.row][@"goodsId"];
    [self.navigationController pushViewController:detail animated:YES];
   
}

#pragma mark -
#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -50);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无商品";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
