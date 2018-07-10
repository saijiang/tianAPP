//
//  StoreOneCarViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "StoreOneCarViewController.h"
#import "ShoppingCarListCell.h"
#import "SideChooseManager.h"
#import "ClearingCarBottomView.h"
#import "DQAlertViewController.h"
#import "ShoppingCarListHeadView.h"
#import "ShoppingCarListFootView.h"
#import "NumberOneShopOrderConfirmViewController.h"
#import "AddressViewController.h"

@interface StoreOneCarViewController ()<UITableViewDelegate,UITableViewDataSource,SideChooseManagerDelegate,SideChooseManagerDataSource>

@property (nonatomic ,assign) BOOL needRefreshCartList;

@property (nonatomic ,strong) SideChooseManager * sManager;

@property (nonatomic, strong) UITableView *tableCtrl;

@property (nonatomic, strong) ClearingCarBottomView *bottomView;
@property (nonatomic ,assign) BOOL hasDefaultAddress;
@property (nonatomic ,strong) id addressID;
@end

@implementation StoreOneCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sManager = [[SideChooseManager alloc] init];
    self.sManager.delegate = self;
    self.sManager.dataSource = self;
    self.sManager.allowsFoldSectionView = NO;
    self.sManager.allowsMultipleSelection = YES;
    self.sManager.tableView = self.tableCtrl;
    
    [self creatUI];

    [self requestGoodsList];

    [self requestDefaultAddress];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

-(UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT -60 - 50) style:UITableViewStylePlain];
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.separatorStyle = 0;
        self.tableCtrl.backgroundColor = BM_CLEAR;
        self.tableCtrl.sectionFooterHeight = 10;
        [self.tableCtrl registerClass:[ShoppingCarListCell class]
               forCellReuseIdentifier:[ShoppingCarListCell cellIdentifier]];
        
        [self.tableCtrl registerClass:[ShoppingCarListFootView class]
   forHeaderFooterViewReuseIdentifier:[ShoppingCarListFootView cellIdentifier]];
        
        [self.tableCtrl registerClass:[ShoppingCarListHeadView class]
   forHeaderFooterViewReuseIdentifier:[ShoppingCarListHeadView cellIdentifier]];
    }
    
    return _tableCtrl;
}

#pragma mark - 结算行
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        LKWeakSelf
        self.bottomView = [[ClearingCarBottomView alloc] initWithFrame:CGRectMake(0, DEF_BOTTOM(self.tableCtrl), DEF_SCREEN_WIDTH, 50)];
        self.bottomView.userInteractionEnabled = YES;
        self.bottomView.CShoppingCarChooseAllHandle = ^(BOOL isSelected){
            LKStrongSelf
            [_self.sManager selectAll:isSelected];
        };
        self.bottomView.CShoppingCarDeleteHandle = ^(){
            LKStrongSelf
            DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定删除选中的商品？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
                if (buttonIndex) {// delete
                    NSString * cartId = [_self formatterOneShopGoodsId];
                    [_self.sManager clear];
                    [_self requestDeleteGoodsForCartId:cartId];
                }
            }];
            [alert showAlert:_self];
        };
        self.bottomView.CShoppingCarClearHandle = ^(){
            
            LKStrongSelf
            if (!_self.hasDefaultAddress) {
                [_self showTipMessage:@"您还没设置默认收货地址,去添加一个？" cancel:nil handle:^{
                    AddressViewController * address = [[AddressViewController alloc] init];
                    address.bSelectAddressHandle = ^(id addressData){
                        [_self requestDefaultAddress];
                    };
                    [_self.navigationController pushViewController:address animated:YES];
                }];
                return;
            }
            [_self requestDefaultPriceAddress];
            
        };
    }
    
    return _bottomView;
}


- (void)creatUI
{
    [self.view addSubview:self.tableCtrl];
    [self.view addSubview:self.bottomView];
}

- (void) updateBottomViewPrice{
    
    CGFloat cartSumPrice = 0.0f;
    
    NSInteger section = 0;
    
    for (NSSet * set in [self.sManager selectedStatus]) {
        
        if (set.count) {
            ChooseSection * sectionObj = [self.sManager sectionObjectAtSection:section];
            cartSumPrice += sectionObj.price;
        }
        section ++;
    }
    
    [self.bottomView disEnable:cartSumPrice != 0];

    if (cartSumPrice == 0) {
        self.bottomView.allChooseBtn.selected = NO;
    }
    
    self.bottomView.priceValue.text = [NSString stringWithFormat:@"￥%.2f",cartSumPrice];
    
    self.bottomView.hidden=NO;
    if ([self.sManager numberOfSections]==0) {
        self.bottomView.hidden=YES;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sManager numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sManager numberOfItemsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarListCell *cell=[tableView dequeueReusableCellWithIdentifier:[ShoppingCarListCell cellIdentifier] forIndexPath:indexPath];
    
    cell.bChooseHandle = ^(BOOL isSelected){
        
        [self.sManager selectCellAtIndexPath:indexPath];
    };
    cell.stepView.bReachMinValueHandle = ^(NSInteger minValue){
        [self reachMinValueHandleAtIndexPath:indexPath];
    };
    cell.stepView.bStepValueChangeHandle = ^(NSInteger value ,BOOL plus){
        
        [self requestGoodsUpdateCountAtIndexPath:indexPath puls:plus value:value];
    };
    [cell configOneShopCellWithData:[self.sManager itemObjectAtIndexPath:indexPath]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShoppingCarListCell cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ChooseSection *sectionObj = [self.sManager sectionObjectAtSection:section];
    
    return [ShoppingCarListHeadView cellHeightWithData:sectionObj];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingCarListHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ShoppingCarListHeadView cellIdentifier]];
    
    ChooseSection *sectionObj = [self.sManager sectionObjectAtSection:section];
    [headView configCellWithData:sectionObj];
    
    //block
    headView.HShoppingCarHeadChooseHandle = ^(UIButton *sender){
        [self.sManager selectAll:!sender.isSelected atSection:section];
    };
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [ShoppingCarListFootView cellHeight];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    ShoppingCarListFootView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ShoppingCarListFootView cellIdentifier]];
    
    ChooseSection *sectionObj = [self.sManager sectionObjectAtSection:section];
    [footView configCellWithData:sectionObj];
    
    return footView;
}

- (void) reachMinValueHandleAtIndexPath:(NSIndexPath *)indexPath{
    
    DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"确定删除该商品？" buttons:@[@"取消",@"确定"] afterDismiss:^(NSInteger buttonIndex) {
        if (buttonIndex) {// delete
            // 在请求删除成功之后删除，失败再加回去
            [self.sManager clear];
            
            [self requestDeleteGoodsForItemAtIndexPath:indexPath];
        }else{
            [self requestGoodsUpdateCountAtIndexPath:indexPath puls:YES value:1];
        }
    }];
    [alert showAlert:self];
}

#pragma mark -
#pragma mark SideChooseManagerDelegate
/** 内部选择item导致所有的item被选中 */
- (void) chooseManagerDidSelelctedAll:(BOOL)allSelected{
    
    self.bottomView.allChooseBtn.selected = allSelected;
    
    [self updateBottomViewPrice];
}

- (void)chooseManagerDidUpdateCellStatusAtIndexPath:(NSIndexPath *)indexPath{
    
    [self updateBottomViewPrice];
}

#pragma mark -
#pragma mark SideChooseManagerDataSource

- (NSString *) chooseManagerItemsListKey:(SideChooseManager *)manager{

    return @"listGoods";
}
- (NSString *)chooseManagerItemCountKey:(SideChooseManager *)manager{
    
    return @"goodsNum";
}

- (NSString *)chooseManagerItemPriceKey:(SideChooseManager *)manager{
    
    return @"marketPrice";
}

#pragma mark -
#pragma mark Network M

- (void)requestGoodsList
{
    [UserServices getStoreCartListWithUserId:[KeychainManager readUserId]
                                    cartType:@"02" //01-自营 02-1号店
                             completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             
             id data = responseObject[@"data"];
             
             [self.sManager configChooseManager:data];
             
             [self updateBottomViewPrice];
         }else{
             // error handle here
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

- (void) requestGoodsUpdateCountAtIndexPath:(NSIndexPath *)indexPath puls:(BOOL)plus value:(NSInteger)value{
    
    ChooseItem * itemObj = [self.sManager itemObjectAtIndexPath:indexPath];
    
    [UserServices updateGoodsCartWithCartId:itemObj.item[@"cartId"] goodsNum:@(value) completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            if (plus) {
                [self.sManager plusAtIndexPath:indexPath];
            }else{
                [self.sManager minusAtIndexPath:indexPath];
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            
            [self.tableCtrl reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void) requestDeleteGoodsForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseItem * item = [self.sManager itemObjectAtIndexPath:indexPath];
    
    NSString * cartId = item.item[@"cartId"];
    
    [self requestDeleteGoodsForCartId:cartId];
}

- (void) requestDeleteGoodsForCartId:(NSString *)cartId{
    
    [UserServices delGoodsCartWithCartId:cartId completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            //[UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            [self requestGoodsList];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestDefaultPriceAddress{
    
    NSString * jsonOrderList =  [JsonManager jsonWithDict:[self formatterOneShopOrderData]];

    [UserServices getPostFeeWithaddressId:self.addressID orderList:jsonOrderList completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            // 跳转至订单确定界面
            NumberOneShopOrderConfirmViewController * confirm = [[NumberOneShopOrderConfirmViewController alloc] init];
            confirm.cartGoodsInfo = [self formatterOneShopOrderData];
            confirm.bOrderDidCommitFinishHandle = ^(){
                self.needRefreshCartList = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:DEFN_AddGoodsCart object:nil];
            };
            [self.navigationController pushViewController:confirm animated:YES];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestDefaultAddress{
    
    [UserServices getDefaultAddressListWithuserId:[KeychainManager readUserId] restaurantId:nil completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            self.hasDefaultAddress = [responseObject[@"data"] allObjects].count;
            self.addressID = responseObject[@"data"][@"id"];

        }
    }];
}

- (NSString *) formatterOneShopGoodsId{
    
    NSMutableString * goodsIds = [NSMutableString string];
    
    NSInteger section = 0;
    for (NSSet * set in [self.sManager commit]) {
        
        [set enumerateObjectsUsingBlock:^(id obj, BOOL * _Nonnull stop) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:section];
            ChooseItem * item = [self.sManager itemObjectAtIndexPath:indexPath];
            [goodsIds appendFormat:@"%@,",item.item[@"cartId"]];
        }];
        section ++;
    }
    
    return [goodsIds substringToIndex:goodsIds.length - 1];
}

- (NSArray *) formatterOneShopOrderData{
    
    NSMutableArray * datas = [NSMutableArray array];
    
    NSInteger section = 0;
    NSSet * set = [self.sManager selectedStatus][section];
    
    ChooseSection * sectionObj = [self.sManager sectionObjectAtSection:section];
    NSDictionary * sectionData = [NSDictionary dictionaryWithDictionary:sectionObj.section];
    
    NSMutableArray * listGoods = [NSMutableArray array];
    
    [set enumerateObjectsUsingBlock:^(id obj, BOOL * _Nonnull stop) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:section];
        ChooseItem * item = [self.sManager itemObjectAtIndexPath:indexPath];
        
        NSDictionary * data = item.item;
        
        NSDictionary * goods = @{@"cartId":NSStringWithData(data[@"cartId"]),
                                 @"goodsId":NSStringWithData(data[@"goodsId"]),
                                 @"goodsImageList":NSStringWithData(data[@"goodsImageList"]),
                                 @"goodsName":NSStringWithData(data[@"goodsName"]),
                                 @"goodsNum":@(item.count),
                                 @"marketPrice":NSStringWithData(data[@"marketPrice"]),
                                 @"productType":@""};//none
        
        [listGoods addObject:goods];
    }];
    
    
    NSDictionary * data = @{@"oneShop":@"1",
                            @"expressDeliveryFee":NSStringWithData(sectionData[@"expressDeliveryFee"]),
                            @"expressDeliveryFlg":@"1",
                            @"listGoods":listGoods,
                            @"merchantDeliveryFee":NSStringWithData(sectionData[@"merchantDeliveryFee"]),
                            @"merchantDeliveryFlg":NSStringWithData(sectionData[@"merchantDeliveryFlg"]),
                            @"merchantId":NSStringWithData(sectionData[@"merchantId"]),
                            @"merchantName":@"一号店",
                            @"ownDeliveryAddress":NSStringWithData(sectionData[@"ownDeliveryAddress"]),
                            @"selfDeliveryFlg":NSStringWithData(sectionData[@"selfDeliveryFlg"])};
    [datas addObject:data];
    
    
    
    return datas;
}

@end
