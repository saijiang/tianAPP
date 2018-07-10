//
//  JDShopClassificationViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopClassificationViewController.h"
#import "MallClassificationView.h"
#import "LKPickSectionCell.h"
#import "MallSearchGoodsCell.h"
#import "MallClassificationSectionView.h"
#import "JDShopListViewController.h"//京东列表
#import "CartNumView.h"
#import "ShoppingCarListViewController.h"//购物车
@interface JDShopClassificationViewController ()<MallClassificationViewDelegate,MallClassificationViewDataSource>

@property (nonatomic ,strong) MallClassificationView * classificationView;
@property (nonatomic ,strong) NSMutableArray * firstCategoryList;
@property (nonatomic ,strong) NSMutableArray * secondCategoryList;
@property (nonatomic ,strong) NSString * firstID;
@property(nonatomic,strong)CartNumView *cartNumView;


@end

@implementation JDShopClassificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cartNumView getGoodsCartNum];
    
}

//京东1级商品分类列表接口
-(void)getFirstCategoryList
{
    [UserServices getJDFirstCategoryListWithparentId:@"0" CompletionBlock:^(int result, id responseObject) {
        if (result==0)
        {
            [self.firstCategoryList addObjectsFromArray:responseObject[@"data"]];
            [self.classificationView reloadData];
            NSArray*idArray=[self.searchItem.categorySearchCode componentsSeparatedByString:@";"];
            if (idArray.count>1) {
                NSString*idStr=idArray[0];
                // [self getSecondCategoryListWithCategoryIdFirst:idStr];
                for (NSInteger i=0; i<self.firstCategoryList.count; i++) {
                    if ([self.firstCategoryList[i][@"catId"] isEqualToString:idStr]) {
                        [self.classificationView setSelectSectionIndex:i];
                        [self pickView:self.classificationView didPickSectionAtSection:i];
                        break;
                    }
                }
            }else{
                
                [self getSecondCategoryListWithCategoryIdFirst:self.firstCategoryList.firstObject[@"catId"]];
            }
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    //    [UserServices getFirstCategoryListCompletionBlock:^(int result, id responseObject) {
    //        if (result==0)
    //        {
    //            [self.firstCategoryList addObjectsFromArray:responseObject[@"data"]];
    //            [self.classificationView reloadData];
    //            [self getSecondCategoryListWithCategoryIdFirst:self.firstCategoryList.firstObject[@"categoryIdFirst"]];
    //        }
    //        else
    //        {
    //            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
    //        }
    //    }];
}
//京东2级以及3级商品分类列表接口
-(void)getSecondCategoryListWithCategoryIdFirst:(NSString *)categoryIdFirst
{
    [UserServices
     getJDSecondCategoryListWithparentId:categoryIdFirst
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.secondCategoryList removeAllObjects];
             [self.secondCategoryList addObjectsFromArray:responseObject[@"data"]];
             self.firstID=categoryIdFirst;
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
    // [self showNavBarCustomByTitle:@"京东商品分类"];
    [self createNav];
    [self creatUI];
    [self getFirstCategoryList];
}
- (void)createNav
{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(44, 0, 44, 44);
    
    [btn setImage:[UIImage imageNamed:@"jd_gouwuche_black"]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gouwucheBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat f = (44-20)/2;
    
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];
    [btn setEnlargeEdgeWithTop:10 right:5 bottom:5 left:5];
    
    self.rightButton = btn;
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBut;
    
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:^(){
        
    } normalHandle:^{
        
        self.cartNumView= [CartNumView CartNumView];
        [self.rightButton addSubview:self.cartNumView];
//        self.cartNumView.frame=CGRectMake(DEF_WIDTH(self.rightButton)-5, 10, DEF_HEIGHT(self.cartNumView), DEF_HEIGHT(self.cartNumView));
        [self.cartNumView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.rightButton.mas_top).mas_offset(-5);
            make.right.mas_equalTo(self.rightButton.mas_right).mas_offset(5);
            make.height.mas_equalTo(DEF_HEIGHT(self.cartNumView));
            make.width.mas_equalTo(DEF_HEIGHT(self.cartNumView));
        }];
    }];
    
    
    SearchView *search=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH-120, 44)];
//    SearchView *search=[[SearchView alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    search.searchFD.placeholder=@"查询京东商品";
    search.intrinsicContentSize = CGSizeMake(DEF_SCREEN_WIDTH-120, 44);
    [search receiveObject:^(id object) {
        JDShopListViewController*jdShop=[[JDShopListViewController alloc]init];
        self.searchItem.productCname = object;
        jdShop.isSearch=@"search";
        self.searchItem.sales = @"";
        self.searchItem.sort=@"";
        self.searchItem.categorySearchCode=nil;
        self.searchItem.typeName=@"";
        jdShop.searchItem=self.searchItem;
        [self.navigationController pushViewController:jdShop animated:YES];
    }];
    [self showNavBarCustomByView:search];

}
-(void)gouwucheBtnAction
{
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        //购物车
        ShoppingCarListViewController *list = [[ShoppingCarListViewController alloc] init];
        [self.navigationController pushViewController:list animated:YES];
    }];
}
-(void)baseBackBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
    NSArray *thirdList=self.secondCategoryList[section][@"list"];
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
    cell.sectionNameLabel.text=data[@"name"];
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSDictionary *data=self.secondCategoryList[indexPath.section][@"list"][indexPath.row];
    MallSearchGoodsCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[MallSearchGoodsCell cellIdentifier] forIndexPath:indexPath];
    cell.goodName.text=data[@"name"];
    [cell.goodIcon sd_setImageWithURL:[NSURL URLWithString:data[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"temp_food_photo"]];
    return cell;
}

-(UICollectionReusableView *)pickView:(__kindof MallClassificationView *)pickView viewForSupplementaryElementOfKind:(__kindof NSString *)kind atIndexPath:(__kindof NSIndexPath *)indexPath
{
    NSDictionary *data=self.secondCategoryList[indexPath.section];
    MallClassificationSectionView *section=[pickView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MallClassificationSectionView cellIdentifier] forIndexPath:indexPath];
    section.title.text=data[@"name"];
    return section;
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section
{
    
    [self getSecondCategoryListWithCategoryIdFirst:self.firstCategoryList[section][@"catId"]];
    
    //    self.searchItem.typeId=self.firstCategoryList[section][@"catId"];
    //    [self sendObject:@"reload"];
    
    
}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    NSDictionary *data=self.secondCategoryList[indexPath.section][@"list"][indexPath.row];
    NSString*idStr=[NSString stringWithFormat:@"%@;%@;%@", self.firstID,self.secondCategoryList[indexPath.section][@"catId"],data[@"catId"]];
    
    
    
    self.searchItem.categorySearchCode=idStr;
    
    //    [self.navigationController popViewControllerAnimated:YES];
    if ([self.typeStr isEqualToString:@"HOME"]) {
        JDShopListViewController*jdShop=[[JDShopListViewController alloc]init];
        jdShop.searchItem=self.searchItem;
        [self.navigationController pushViewController:jdShop animated:YES];
    }else{
        [self sendObject:@"reload"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


@end

