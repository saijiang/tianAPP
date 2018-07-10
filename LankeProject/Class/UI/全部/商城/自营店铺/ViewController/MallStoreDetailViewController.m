//
//  MallStoreDetailViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallStoreDetailViewController.h"
#import "MallShopInfoHeaderView.h"
#import "MallShopInfoDetailCCell.h"
#import "MallgoodsCell.h"
#import "SelfSupportGoodsDetailViewController.h"
#import "NewSelfSupportGoodsDetailViewController.h"
#import "UIViewController+Page.h"
#import "MallSearchView.h"

#import "ProprietaryShopViewController.h"

@interface MallStoreDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    MallShopInfoHeaderView * headerView;
}

@property (nonatomic ,strong) MallShopInfoDetailContent * tempConetnt;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,assign) NSInteger type;

@end

@implementation MallStoreDetailViewController



-(void)viewWillAppear:(BOOL)animated
{
    if (KAPPDELEGATE.topView) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:12306] removeFromSuperview];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"店铺详情";
    
    _tempConetnt = [[MallShopInfoDetailContent alloc] init];
    [self requestShopDetail];


}

-(void)createUI
{
    
    SearchView *searchView=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-44*3, 44)];
    searchView.searchFD.placeholder = @"检索店铺内商品";
    //searchView.searchFD.textAlignment=NSTextAlignmentCenter;
 
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view.mas_left).offset(60);
        make.right.mas_equalTo(self.view.mas_right).offset(-60);
        make.height.mas_equalTo(44);

    }];
//    [ searchView.searchFD mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(searchView);
//        make.right.mas_equalTo(-20);
//        make.left.mas_equalTo(10);
//        
//    }];
    [searchView receiveObject:^(id object) {
        searchView.searchFD.text=nil;
        ProprietaryShopViewController *searchControll=[[ProprietaryShopViewController alloc]init];
        searchControll.merchantId=self.merchantId;
        searchControll.goodsName=object;
        [self.navigationController pushViewController:searchControll animated:YES];
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(searchView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);

    }];
     [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView registerClass:[MallShopInfoHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"MallShopInfoHeaderView"];
    
    [self.collectionView registerClass:[MallShopInfoOptionsFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"MallShopInfoOptionsFooterView"];
    
    //[self.collectionView registerClass:[MallShopInfoDetailCCell class]
          //  forCellWithReuseIdentifier:[MallShopInfoDetailCCell cellIdentifier]];
    [self.collectionView registerClass:[MallShopInfoDetailCCell class]
            forCellWithReuseIdentifier:[MallShopInfoDetailCCell cellIdentifier]];
    
    [self.collectionView registerClass:[MallgoodsCell class]
            forCellWithReuseIdentifier:[MallgoodsCell cellIdentifier]];
    
    
    LKWeakSelf
    [self.collectionView addHeaderWithCallback:^{
        
        LKStrongSelf
        [_self refresh];
    }];
    [self.collectionView addFooterWithCallback:^{
        
        LKStrongSelf
        [_self loadMore];
    }];
    
    self.type=1;
  
 
    [self refresh];


  



}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.responseDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
       MallShopInfoDetailCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MallShopInfoDetailCCell cellIdentifier] forIndexPath:indexPath];
        [cell configCellForShopDetail:self.webData];
        cell.dataSource = self.webData;
        cell.content = self.tempConetnt;
        
            cell.bCellHeightChangedBlock = ^(){
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.50/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                });

            };
//
        return cell;
    }
    if (indexPath.section == 1)
    {
        MallgoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MallgoodsCell cellIdentifier] forIndexPath:indexPath];
        [cell loadCellWithDataSource:self.responseDatas[indexPath.row]];
        
       
        return cell;
    }
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (kind == UICollectionElementKindSectionHeader)
        {
            if (!headerView)
            {
                headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MallShopInfoHeaderView" forIndexPath:indexPath];
                if (!headerView.finishLoadBannerImage) {
                    [headerView config:self.webData];
                    
                }
            }
            
            
            return headerView;
        }
        if (kind == UICollectionElementKindSectionFooter)
        {
            
            MallShopInfoOptionsFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MallShopInfoOptionsFooterView" forIndexPath:indexPath];
                [footerView receiveObject:^(id object) {
                DEF_DEBUG(@"%@",object);
                self.type=[object integerValue];
                [self refresh];
            }];
            return footerView;
        }
    }
    return nil;
}
#pragma mark UICollectionViewLayoutDelegate
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 1 ? 10 : 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 1 ? 10 : 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSDictionary *dataSource=self.responseDatas[indexPath.row];
        CGSize size=  [MallgoodsCell getCGSizeWithDataSource:dataSource];
        return size;
    }
   return CGSizeMake(DEF_SCREEN_WIDTH, [MallShopInfoDetailCCell cellHeightWithData:_tempConetnt]);
   //return CGSizeMake(DEF_SCREEN_WIDTH, [MallShopInfoDetailCCell getCellHeightWithData:self.webData]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {

        return CGSizeMake(DEF_SCREEN_WIDTH, [MallShopInfoHeaderView height]);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {

        return CGSizeMake(DEF_SCREEN_WIDTH, [MallShopInfoOptionsFooterView height]);
    }
    return CGSizeZero;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        DEF_DEBUG(@"商品详情:%@",indexPath);
        NSString * goodsId = self.responseDatas[indexPath.row][@"goodsId"];
        
        if ([goodsId isEqualToString:self.sourceGoodsId]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        
            SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
//            NewSelfSupportGoodsDetailViewController * detail = [[NewSelfSupportGoodsDetailViewController alloc] init];
            detail.goodsId = goodsId;
//            detail.sourceViewController = self;
            detail.isSorce = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

- (void) requestShopDetail{
    
//    [UserServices
//     getMerchantDetailInfoWithUserId:[KeychainManager readUserId]
//     merchantId:self.merchantId
//     completionBlock:^(int result, id responseObject)
//     {
//       
//        if (result == 0)
//        {
//            id data = responseObject[@"data"];
//            
//            self.tempConetnt.data = data;
//            
//            [self.collectionView reloadData];
//            
//            [self refresh];
//        }
//        else
//        {
//            // error handle here
//            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//        }
//    }];
    
//    self.tempConetnt.data = self.webData;
//    
//    [self.collectionView reloadData];
    
//    [self refresh];
}

- (void) initiateNetworkListRequest
{
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageIndex];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)self.pageItem.pageSize];
    [UserServices
     getGoodsOurMainWithMerchantId:self.merchantId
     pageIndex:pageIndex
     pageSize:pageSize
     type:self.type
     completionBlock:^(int result, id responseObject)
    {
       
        if (result == 0)
        {
            NSArray * data = responseObject[@"data"];
//            [self didFinishRequestWithData:data handleForListView:self.collectionView];
            
            [self responseDataList:data];
            if (self.pageItem.isRefresh)
            {
                [self.collectionView headerEndRefreshing];
            }
            else
            {
                
                if (!self.pageItem.canLoadMore)
                {
                    [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
                }
                [self.collectionView footerEndRefreshing];
            }
            // 针对 10.0 以上的iOS系统进行处理
          //[self.collectionView reloadData];
            
         
          
           
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue >= 10.0) {
                // 针对 10.0 以上的iOS系统进行处理
                [UIView performWithoutAnimation:^{

                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                    
                }];
            } else {
                
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadData];
                }];

            }
        
            //[self.collectionView reloadData];

         
     
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(void)baseBackBtnAction:(UIButton *)btn
{
    [self cleanCacheAndCookie];
  
    MallShopInfoDetailCCell * cell = (MallShopInfoDetailCCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];//一句话就能获取到点击cell的frame，十分好用，同样适用于tableView。
    [cell.conentWebView loadHTMLString:@"" baseURL:nil];
    cell.conentWebView=nil;



    [self.view removeAllSubviews];
    
    [self.navigationController popViewControllerAnimated:YES];

}
/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
- (void)viewDidUnload
{
    // 被release的对象必须是在 viewDidLoad中能重新创建的对象
    // For example:
    self.tempConetnt = nil;
    self.collectionView = nil;
    self.webData = nil;
    
    [super viewDidUnload];
}
@end
