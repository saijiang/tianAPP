//
//  MallHomepageViewController.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallHomepageViewController.h"
#import "MallSearchView.h"
#import "MallHeaderView.h"
#import "MallSectionHeaderView.h"
#import "MallSectionFooterView.h"
#import "MallgoodsCell.h"
#import "MallBulkGoodCell.h"
#import "MallHomeClassificationView.h"

#import "SelfSupportGoodsDetailViewController.h"
#import "NewSelfSupportGoodsDetailViewController.h"

#import "MallSearchViewController.h"
#import "NumberOneShopViewController.h"
#import "ProprietaryShopViewController.h"
#import "MallStoreListViewController.h"
#import "MallStoreDetailViewController.h"
//#import "NewMallStoreDetailViewController.h"
#import "AdvDetailViewController.h"
#import "GroupBuyListViewController.h"
#import "GroupBuyDetailViewController.h"
#import "CartNumView.h"
//购物车
#import "MallSearchClassificationViewController.h"
#import "ProprietaryShopViewController.h"
#import "ShoppingCarListViewController.h"
#import "SelfSupportCarViewController.h"
#import "JDShopListViewController.h"
#import "JDShopClassificationViewController.h"


@interface MallHomepageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *oneDataSource;
    NSMutableArray *twoDataSource;
    NSMutableArray *merchantSource;
    NSMutableArray *goodsClassFirstSource;
    NSMutableArray *merchant2Source;

}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CartNumView *cartNumView;
@end

@implementation MallHomepageViewController

-(void)getGoodsClassFirst
{
    if (!goodsClassFirstSource)
    {
        goodsClassFirstSource=[[NSMutableArray alloc]init];
        
    }
    [UserServices
     getGoodsClassFirstCompletionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [goodsClassFirstSource removeAllObjects];
            [goodsClassFirstSource addObjectsFromArray:responseObject[@"data"]];
            
            
            
            [self.collectionView reloadData];
        }
    }];
}

-(void)getMerchantInfo
{
    if (!merchantSource)
    {
        merchantSource=[[NSMutableArray alloc]init];

    }
    if (!merchant2Source)
    {
        merchant2Source=[[NSMutableArray alloc]init];
        
    }
    //默认加载21个 3页  第一个 所有 二个 团购 三个 1号店
    [UserServices
     getMerchantInfoWithMerchantName:@""
     pageIndex:@"1"
     pageSize:@"1000"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [merchantSource removeAllObjects];
             [merchant2Source removeAllObjects];

             [merchantSource addObjectsFromArray:responseObject[@"data"]];
             
             NSDictionary*dic=  @{@"icon":@"JDjdicon-1",
                                  @"name":@"京东",
                                  @"eName":@"SHOP JD",
                                  @"tag":@"01s",
                                  };
             [merchant2Source addObject:dic];
             for (NSDictionary*data in responseObject[@"data"]) {
                 NSDictionary *dataSourc= @{@"icon":[NSURL URLWithString:data[@"merchantLogo"]],
                                            @"name":data[@"merchantName"],
                                            @"eName":data[@"merchantName"],
                                            @"tag":data[@"merchantId"],
                                            };
                 [merchant2Source addObject:dataSourc];
             }
             
             [self.collectionView reloadData];
         }

    }];
}

-(void)getRecommendGoods
{
    if (!twoDataSource)
    {
        twoDataSource=[[NSMutableArray alloc]init];
    }
    
    [UserServices
     getRecommendGoodsWithgoodsName:@""
     goodsSales:@""
     isPrice:@""
     goodsComment:@""
     brandId:@""
     marketPrice:@""
     classOneId:@""
     classTwoId:@""
     classThridId:@""
     pageIndex:@"1"
     pageSize:@"8"
     type:@"0"
     merchantId:nil
     completionBlock:^(int result, id responseObject)
    {
         if (result==0)
         {
             [twoDataSource removeAllObjects];
             [twoDataSource addObjectsFromArray:responseObject[@"data"]];
             [self.collectionView reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }

    }];
}

-(void)getGroupGoods
{
    
    if (!oneDataSource)
    {
        oneDataSource=[[NSMutableArray alloc]init];
    }

    [UserServices
     getGroupGoodsWithFlag:@"01"
     pageIndex:@"1"
     pageSize:@"5"
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [oneDataSource removeAllObjects];
             [oneDataSource addObjectsFromArray:responseObject[@"data"]];
             [self.collectionView reloadData];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    if (self.cartNumView)
    {
        [self.cartNumView getGoodsCartNum];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTitleView];
    [self getMerchantInfo];
    [self getGoodsClassFirst];
    
    [self getGroupGoods];
    [self getRecommendGoods];

}

-(void)createTitleView
{

    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"jd_gouwuche_black"]];
    MallSearchView *searchView=[[MallSearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-120, 44)];
    searchView.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    [self showNavBarCustomByView:searchView];
    [searchView receiveObject:^(id object) {
        DEF_DEBUG(@"%@",object);
        MallSearchViewController *search=[[MallSearchViewController alloc]init];
        [self.navigationController pushViewController:search animated:YES];
    }];
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:^(){
    
    } normalHandle:^{
        
        self.cartNumView= [CartNumView CartNumView];

        [self.rightButton addSubview:self.cartNumView];
    }];

//        self.cartNumView.frame=CGRectMake(DEF_WIDTH(self.rightButton)-5, 10, DEF_HEIGHT(self.cartNumView), DEF_HEIGHT(self.cartNumView));
    [self.cartNumView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.rightButton.mas_top).mas_offset(-5);
        make.right.mas_equalTo(self.rightButton.mas_right).mas_offset(5);
        make.height.mas_equalTo(DEF_HEIGHT(self.cartNumView));
        make.width.mas_equalTo(DEF_HEIGHT(self.cartNumView));
    }];

}

-(void)createUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[MallHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"MallHeaderView"];
    
    [self.collectionView registerClass:[MallSectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"MallSectionHeaderView"];
    
    [self.collectionView registerClass:[MallSectionFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"MallSectionFooterView"];
    
    [self.collectionView registerClass:[MallBulkGoodCell class]
            forCellWithReuseIdentifier:@"MallBulkGoodCell"];
    
    [self.collectionView registerClass:[MallgoodsCell class]
            forCellWithReuseIdentifier:@"MallgoodsCell"];
    
    [self.collectionView registerClass:[MallHomeClassificationView class]
            forCellWithReuseIdentifier:@"MallHomeClassificationView"];
    
    __weak MallHomepageViewController *home=self;
    [self.collectionView addHeaderWithCallback:^{
        [home getMerchantInfo];
        [home getGoodsClassFirst];
        [home getRecommendGoods];
        [home getGroupGoods];
        [home.collectionView headerEndRefreshing];
    }];

}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else if (section==1)
    {
       // return 1;
         return oneDataSource.count;
    }
    else if (section==2)
    {
        //return oneDataSource.count;
        return 1;
    }
    return twoDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1)
    {
       // MallHomeClassificationView * cell = [collectionView //dequeueReusableCellWithReuseIdentifier:@"MallHomeClassificationView" forIndexPath:indexPath];
       // [cell loadCellWithDataSource:goodsClassFirstSource];
        
        
        
        //[cell receiveObject:^(id object) {
            // 所有分类
         //   NSDictionary *data=goodsClassFirstSource[[object integerValue]];
            
            
          //  GoodSearchItem *searchItem=[[GoodSearchItem alloc]init];
          //  searchItem.classOneName=data[@"classNameFirst"];
            
          //  searchItem.classTwoName=@"";
          //  searchItem.classOneId=data[@"id"];
         //   ProprietaryShopViewController *mallClass=[[ProprietaryShopViewController alloc]init];
         //   mallClass.searchItem=searchItem;
        //    [self.navigationController pushViewController:mallClass animated:YES];
       // }];
      //  return cell;
        
        
        MallBulkGoodCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallBulkGoodCell" forIndexPath:indexPath];
        cell.bHandle = ^(){
            [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                
                [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            }];
        };
        [cell loadCellWithDataSource:oneDataSource[indexPath.row]];
        return cell;
        
    }
    else if (indexPath.section==2)
    {
       // MallBulkGoodCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallBulkGoodCell" forIndexPath:indexPath];
       // cell.bHandle = ^(){
        //    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                
          //      [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
           // }];
     //   };
      //  [cell loadCellWithDataSource:oneDataSource[indexPath.row]];
      //  return cell;
        
        
        MallHomeClassificationView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallHomeClassificationView" forIndexPath:indexPath];
        [cell loadCellWithDataSource:goodsClassFirstSource];
        
        
        
        [cell receiveObject:^(id object) {
            // 所有分类
            NSDictionary *data=goodsClassFirstSource[[object integerValue]];
            
            
            GoodSearchItem *searchItem=[[GoodSearchItem alloc]init];
            searchItem.classOneName=data[@"classNameFirst"];
            
            searchItem.classTwoName=@"";
            searchItem.classOneId=data[@"id"];
            ProprietaryShopViewController *mallClass=[[ProprietaryShopViewController alloc]init];
            mallClass.searchItem=searchItem;
            [self.navigationController pushViewController:mallClass animated:YES];
        }];
        return cell;
    }
    else if (indexPath.section==3)
    {
        MallgoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallgoodsCell" forIndexPath:indexPath];
        [cell loadCellWithDataSource:twoDataSource[indexPath.row]];
        return cell;
    }
    
    return nil;
   
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section==0)
        {
            MallHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MallHeaderView" forIndexPath:indexPath];
            //添加京东
         
            [headerView loadClassificationViewWithDataSource:merchant2Source];
            [headerView receiveObject:^(id object)
             {
                DEF_DEBUG(@"广告位:%@",object);
                NSString * source = object[@"source"];
                if ([source  isEqual: @"01"])
                {// 外链
                    
                    AdvDetailViewController * detail = [[AdvDetailViewController alloc] init];
                    detail.advType = 3;
                    detail.title = object[@"advertName"];
                    detail.externalUrl = object[@"externalUrl"];
                    [self.navigationController pushViewController:detail animated:YES];
                    
                }
                else if ([source  isEqual: @"02"])
                {// 商品详情
                   SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
                 //   NewSelfSupportGoodsDetailViewController * detail = [[NewSelfSupportGoodsDetailViewController alloc] init];
                    detail.goodsId = object[@"goodsId"];
                    [self.navigationController pushViewController:detail animated:YES];
                }else if ([source  isEqual: @"03"])
                {// 商品详情
                
                    NSString *merchantId =object[@"merchantId"];
                    [self requestShopDetailWithmerchantId:merchantId];
                }
            } withIdentifier:@"广告位"];
            
            [headerView receiveObject:^(id object)
             {
                DEF_DEBUG(@"店铺:%@",object);
                if ([object integerValue]==0)
                {
                    // 所有列表：商品列表
                    MallStoreListViewController *shop=[[MallStoreListViewController alloc]init];
                    //shop.type=@"1";
                    [self.navigationController pushViewController:shop animated:YES];
                }
//                else if ([object integerValue]==1)
//                {
//                    // 团购列表
//                    GroupBuyListViewController *group=[[GroupBuyListViewController alloc]init];
//                    [self.navigationController pushViewController:group animated:YES];
//                }
                else if ([object integerValue]==1)
                {
//                     //JD商品列表
//                    JDShopListViewController *shop=[[JDShopListViewController alloc]init];
//                    [self.navigationController pushViewController:shop animated:YES];
                    
                    //JD商品分类
                    JDShopClassificationViewController *shopType=[[JDShopClassificationViewController alloc]init];
                   JDShopSearchItem*searchItem = [[JDShopSearchItem alloc] init];
                    searchItem.sales =@"";
                    searchItem.sort=@"";
                    shopType.searchItem=searchItem;
                    shopType.typeStr=@"HOME";
                    [self.navigationController pushViewController:shopType animated:YES];
                    
                }

                else
                {
////                    //前两个自己添加的固定数据
//                    MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
//                    detail.merchantId=merchantSource[[object integerValue]-2][@"merchantId"];
//                    [self.navigationController pushViewController:detail animated:YES];
//
                    NSString *merchantId = merchantSource[[object integerValue]-2][@"merchantId"];
                    [self requestShopDetailWithmerchantId:merchantId];
//                    //前两个自己添加的固定数据
//                    MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
//                    detail.merchantId=merchantSource[[object integerValue]-3][@"merchantId"];
//                    [self.navigationController pushViewController:detail animated:YES];

                    
                }
            } withIdentifier:@"分类"];
            return headerView;

        }
        else
        {
            
            MallSectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MallSectionHeaderView" forIndexPath:indexPath];
            [headerView loadMallforIndexPath:indexPath];
            [headerView receiveObject:^(id object) {
                DEF_DEBUG(@"查看全部:%@",object);
                if (indexPath.section==1)
                {
                    // 所有分类
                  //  MallSearchClassificationViewController *mallClass=//[[MallSearchClassificationViewController alloc]init];
                   // [self.navigationController pushViewController:mallClass animated:YES];
                    
                    // 所有列表：团购列表
                    GroupBuyListViewController *shop=[[GroupBuyListViewController alloc]init];
                    [self.navigationController pushViewController:shop animated:YES];
                }

                else if (indexPath.section==2)
                {
                    // 所有列表：团购列表
                    //GroupBuyListViewController *shop=[[GroupBuyListViewController alloc]init];
                   // [self.navigationController pushViewController:shop animated:YES];
                    
                    // 所有分类
                    MallSearchClassificationViewController *mallClass=[[MallSearchClassificationViewController alloc]init];
                    [self.navigationController pushViewController:mallClass animated:YES];
                }
                else if (indexPath.section==3)
                {
                    // 所有列表：商品推荐列表
                    GoodSearchItem *searchItem=[[GoodSearchItem alloc]init];
                    ProprietaryShopViewController *mallClass=[[ProprietaryShopViewController alloc]init];
                    mallClass.searchItem=searchItem;
                    [self.navigationController pushViewController:mallClass animated:YES];
                }

            }];
            return headerView;

        }
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        
        MallSectionFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MallSectionFooterView" forIndexPath:indexPath];
        //查看全部
        [footerView receiveObject:^(id object)
         {
            DEF_DEBUG(@"查看全部:%@",object);
             if (indexPath.section==2)
             {
                 // 所有列表：团购列表
                 GroupBuyListViewController *shop=[[GroupBuyListViewController alloc]init];
                 [self.navigationController pushViewController:shop animated:YES];
             }
             else if (indexPath.section==3)
             {
                 // 所有列表：商品推荐列表
                 ProprietaryShopViewController *shop=[[ProprietaryShopViewController alloc]init];
                 [self.navigationController pushViewController:shop animated:YES];
             }
           
            
        }];
        return footerView;
    }

    return nil;
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
    if (indexPath.section==1)
    {
        //return CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/4.0*3.0);
         return CGSizeMake(DEF_SCREEN_WIDTH, 140);
    }
    else if (indexPath.section==2)
    {
        //return CGSizeMake(DEF_SCREEN_WIDTH, 140);
          return CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/4.0*3.0);
    }
    else if(indexPath.section==3)
    {
        NSDictionary *dataSource=twoDataSource[indexPath.row];
        CGSize size=  [MallgoodsCell getCGSizeWithDataSource:dataSource];
        return size;
    }
    return CGSizeMake(0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    float width=DEF_SCREEN_WIDTH;
    float hight=40;
    if (section==0)
    {
        hight=[MallHeaderView getMallHeaderViewHightWithDataSource:merchantSource];
 
    }
    else if(section==1)
    {
        if (oneDataSource.count==0) {
            hight=0;
        }
    }
    return CGSizeMake(width, hight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    float width=DEF_SCREEN_WIDTH;
    float hight=0;
    return CGSizeMake(width, hight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        GroupBuyDetailViewController *detail=[[GroupBuyDetailViewController alloc]init];
        detail.goodsId=oneDataSource[indexPath.row][@"goodsId"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section==3)
    {
       SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
     //   NewSelfSupportGoodsDetailViewController * detail = [[NewSelfSupportGoodsDetailViewController alloc] init];
        detail.goodsId=twoDataSource[indexPath.row][@"goodsId"];
        [self.navigationController pushViewController:detail animated:YES];

    }
    
}

//购物车
-(void)baseRightBtnAction:(UIButton *)btn
{
    DEF_DEBUG(@"购物车");
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        ShoppingCarListViewController *carList = [[ShoppingCarListViewController alloc] init];
        [self.navigationController pushViewController:carList animated:YES];
//        SelfSupportCarViewController *carList = [[SelfSupportCarViewController alloc] init];
//        [self.navigationController pushViewController:carList animated:YES];
    }];
}

//2017.08.10---更改
- (void) requestShopDetailWithmerchantId:(NSString *)merchantId{
    
    [UserServices
     getMerchantDetailInfoWithUserId:[KeychainManager readUserId]
     merchantId:merchantId
     completionBlock:^(int result, id responseObject)
     {
         
         if (result == 0)
         {
             id data = responseObject[@"data"];
             
             //前两个自己添加的固定数据
             MallStoreDetailViewController * detail = [[MallStoreDetailViewController alloc] init];
//             detail.merchantId=merchantSource[[object integerValue]-3][@"merchantId"];
             detail.merchantId=merchantId;
             detail.webData = data;
             [self.navigationController pushViewController:detail animated:YES];
             

             

             
//             self.tempConetnt.data = data;
             
//             [self.collectionView reloadData];
//             
//             [self refresh];
         }
         else
         {
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
