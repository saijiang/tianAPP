//
//  JDShopGoodsDetailViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDShopGoodsDetailViewController.h"
#import "LKShyNavigationBar.h"
#import "GoodsDetailHeaderView.h"
#import "GoodsDetailBottomView.h"
#import "DishesDetailContentCell.h"
#import "JDShopOrderConfirmViewController.h"
#import "ShoppingCarListViewController.h"
#import "DishesDetailCommentCell.h"
#import "CommomNoCommentCell.h"
#import "UIViewController+Page.h"
#import "DishesDetailCommentHeaderView.h"
#import "AllCommentViewController.h"
#import "AddressViewController.h"
#import "JDAddressViewController.h"
#import "CartNumView.h"

@interface JDShopGoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CAAnimationDelegate>

@property (nonatomic ,strong) GoodsDetailHeaderView * headerView;
@property (nonatomic ,strong) LKShyNavigationBar * shyNavigationBar;
@property(nonatomic,strong)CartNumView *cartNumView;

@property (nonatomic ,strong) UITableView * goodsDetailTableView;
@property (nonatomic ,strong) GoodsDetailBottomView * bottomView;

@property (nonatomic ,strong) DishesDetailContent * tempConetnt;

@property (nonatomic ,strong) NSDictionary * goodsDetailData;
@property (nonatomic ,strong) NSDictionary * goodsDetailCommentData;
@property (nonatomic ,strong) NSDictionary * addressDic;

@property (nonatomic ,assign) BOOL noComment;
@property (nonatomic ,assign) BOOL hasDefaultAddress;

@property (nonatomic ,strong) id addressID;

@property (nonatomic ,strong) CALayer *animationlayer;



@end

@implementation JDShopGoodsDetailViewController

- (BOOL)hidenNavigationBar{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tempConetnt = [[DishesDetailContent alloc] init];
    
    [self creatUI];
    
    [self requestStoreOneDetailInfo];
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self requestDefaultAddress];
    if (self.cartNumView)
    {
        [self.cartNumView getGoodsCartNum];
    }
    
}

- (void) creatUI{
    
    //
    _goodsDetailTableView = [[UITableView alloc] init];
    _goodsDetailTableView.dataSource = self;
    _goodsDetailTableView.delegate = self;
    _goodsDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    _goodsDetailTableView.tableFooterView = footerView;
    _goodsDetailTableView.tableHeaderView = [self tableViewHeaderView];
    _goodsDetailTableView.backgroundColor = [UIColor clearColor];
    [_goodsDetailTableView registerClass:[DishesDetailContentCell class]
                  forCellReuseIdentifier:[DishesDetailContentCell cellIdentifier]];
    [_goodsDetailTableView registerClass:[DishesDetailCommentCell class]
                  forCellReuseIdentifier:[DishesDetailCommentCell cellIdentifier]];
    [_goodsDetailTableView registerClass:[CommomNoCommentCell class]
                  forCellReuseIdentifier:[CommomNoCommentCell cellIdentifier]];
    [self addSubview:_goodsDetailTableView];
    
    
    //
    LKWeakSelf
    _shyNavigationBar = [[LKShyNavigationBar alloc] init];
    _shyNavigationBar.backgroundColor = [UIColor clearColor];
    _shyNavigationBar.offset = 64.0f;
    _shyNavigationBar.hasRightButton = YES;
    UIImage * cartImage = [UIImage imageNamed:@"Mall_gouwuche-1"];
    [_shyNavigationBar.rightButton setImage:[cartImage tintedGradientImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_shyNavigationBar.rightButton setImage:cartImage forState:UIControlStateSelected];
    _shyNavigationBar.bBackButtonHandle = ^(){
        LKStrongSelf
        [_self.navigationController popViewControllerAnimated:YES];
    };
    _shyNavigationBar.bRightButtonHandle = ^(){
        LKStrongSelf
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            ShoppingCarListViewController * cartList = [[ShoppingCarListViewController alloc] init];
            [_self.navigationController pushViewController:cartList animated:YES];
        }];
    };
    [self addSubview:_shyNavigationBar];
    self.cartNumView= [CartNumView CartNumView];
    [_shyNavigationBar.rightButton addSubview:self.cartNumView];
    self.cartNumView.frame=CGRectMake(20, 5, DEF_HEIGHT(self.cartNumView), DEF_HEIGHT(self.cartNumView));
    //

    self.bottomView = [GoodsDetailBottomView view];
    [self.bottomView enableButton:YES];
    self.bottomView.bImmediatelyBuyHandle = ^(){
        LKStrongSelf
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            [_self navigationToOrderConfirm];
        }];
    };
    self.bottomView.bAddToShopCartHandle = ^(){
        LKStrongSelf
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            [_self requestAddToCart];
        }];
    };
    [self addSubview:self.bottomView];
}

- (UIView *) tableViewHeaderView{
    
    LKWeakSelf
    _headerView = [GoodsDetailHeaderView view];

//    _headerView.selfSupport = NO;
    _headerView.isTypeShop=@"JD";
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH + 160);
    _headerView.stepView.bReachMaxValueHandle = ^(NSInteger maxValue){
        [UnityLHClass showHUDWithStringAndTime:@"达到最多购买个数限制"];
    };
    _headerView.stepView.bStepValueChangeHandle = ^(NSInteger vaule ,BOOL plus){
        LKStrongSelf
        CGFloat num;
      
        
        if ([self.goodsDetailData[@"stockState"] integerValue]==34||[self.goodsDetailData[@"state"] integerValue]==0) {
            
            //[_self.bottomView enableButton:NO];
            num=0;
            
        }else{
            num=vaule;

//            [_self.bottomView enableButton:YES];
        }
        _self.bottomView.addToShopCartButton.enabled = num > 0;
        _self.bottomView.ImmediatelyBuyButton.enabled = num > 0;
    };
    return _headerView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [_goodsDetailTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [_shyNavigationBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_goodsDetailTableView.mas_top);
        make.left.mas_equalTo(_goodsDetailTableView.mas_left);
        make.right.mas_equalTo(_goodsDetailTableView.mas_right);
        make.height.mas_equalTo(64);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.noComment ? 1 : self.responseDatas.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [DishesDetailContentCell cellHeightWithData:_tempConetnt];
    }
    if (indexPath.section == 1) {
        if (self.noComment) {
            return [CommomNoCommentCell cellHeight];
        }
        return [DishesDetailCommentCell cellHeightWithData:self.responseDatas[indexPath.row]];
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        LKWeakSelf
        DishesDetailCommentHeaderView * commentHeaderView = [[DishesDetailCommentHeaderView alloc] init];
        [commentHeaderView configJDCommentHeaderViewWithData:self.goodsDetailCommentData];
        [commentHeaderView configEvalScoresHeaderViewWithData:self.goodsDetailData];
        commentHeaderView.bCommentHeaderTapHandle = ^(){
            LKStrongSelf
            [_self navigationToAllComment];
        };
        return commentHeaderView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DishesDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailContentCell cellIdentifier] forIndexPath:indexPath];
        cell.displayLabel.text = @"商品详情";
        cell.content = _tempConetnt;
        [cell configCellForStoreJDDetail:self.goodsDetailData];
        cell.bCellHeightChangedBlock = ^(){
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }else if (indexPath.section == 1){
        
        if (self.noComment) {
            
            CommomNoCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[CommomNoCommentCell cellIdentifier] forIndexPath:indexPath];
            
            return cell;
        }else{
            DishesDetailCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailCommentCell cellIdentifier] forIndexPath:indexPath];
            
            [cell configCellWithData:self.responseDatas[indexPath.row]];
            return cell;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [self.shyNavigationBar linearShyNavigationBarWithOffset:offset];
}

#pragma mark -
#pragma mark Navigation M

- (void) navigationToOrderConfirm{
    
    if (!_hasDefaultAddress) {
        [self showTipMessage:@"您还没设置默认收货地址,去添加一个？" cancel:nil handle:^{
            JDAddressViewController * address = [[JDAddressViewController alloc] init];
            [self.navigationController pushViewController:address animated:YES];
        }];
        return;
    }
    [self requestDefaultPriceAddress];
}

#pragma mark--- 查看所有评论
- (void) navigationToAllComment{
    
    NSString * dishesId = [NSString stringWithFormat:@"%@",self.goodsDetailData[@"sku"]];
    // 跳转至所有评论界面
    AllCommentViewController * allComment = [[AllCommentViewController alloc] init];
    allComment.isJD = YES;
    allComment.dishesId = dishesId;
    [self.navigationController pushViewController:allComment animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void) requestStoreOneDetailInfo{
    
     // 京东商品详情接口
    NSString*sku=@"";
    if (self.listGoodsInfo[@"goodsId"]) {
        sku=self.listGoodsInfo[@"goodsId"];
    }else
    {
          sku=self.listGoodsInfo[@"sku"];
    }
    
    
    [UserServices getJDProductDetailInfoWithUserId:[KeychainManager readUserId]  sku:sku imageSize:@"n0" completionBlock:^(int result, id responseObject) {
        if (result == 0) {
            id data = responseObject[@"data"];
            
            self.goodsDetailData = data;
            [self.headerView configForStoreJDWith:self.goodsDetailData];
            self.tempConetnt.data = self.goodsDetailData;
            _shyNavigationBar.titleLabel.text = @"京东";
            [self.goodsDetailTableView reloadData];
            
            if ([self.goodsDetailData[@"stockState"] integerValue]==34||[self.goodsDetailData[@"state"] integerValue]==0) {
                
                [self.bottomView enableButton:NO];
                
            }else{
                
                [self.bottomView enableButton:YES];
                
            }
            
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }

    }];
    
//    // 一号店商品详情接口
//    [UserServices getProductDetailInfoWithUserId:[KeychainManager readUserId] productId:self.listGoodsInfo[@"productId"] productType:self.listGoodsInfo[@"productType"] completionBlock:^(int result, id responseObject) {
//        
//        if (result == 0) {
//            id data = responseObject[@"data"];
//            
//            self.goodsDetailData = data;
//            [self.headerView configForStoreOneWith:self.goodsDetailData];
//            self.tempConetnt.data = self.goodsDetailData;
//            _shyNavigationBar.titleLabel.text = @"一号店";
//            [self.goodsDetailTableView reloadData];
//            if ([self.goodsDetailData[@"isStock"] integerValue]==1) {
//                [self.bottomView enableButton:YES];
//                
//            }else{
//                [self.bottomView enableButton:NO];
//            }
//            
//            
//        }else{
//            // error handle here
//            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//        }
//    }];
}
- (void) animationFromView:(UIView *)fromView toView:(UIView *)toView
{
    
    UIWindow * keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect fromRect = [fromView.superview convertRect:fromView.frame toView:keyWindow];
    CGPoint startpoint = CGPointMake(fromRect.origin.x+15, fromRect.origin.y+15);
    CGPoint endPoint = CGPointMake(DEF_SCREEN_WIDTH-30, 20);
    
    if (!self.animationlayer)
    {
        self.animationlayer = [CALayer layer];
        self.animationlayer.contents = (__bridge id)[UIImage imageWithColor:BM_Color_Blue].CGImage;
        self.animationlayer.contentsGravity = kCAGravityResizeAspectFill;
        self.animationlayer.bounds = CGRectMake(0, 0, 10, 10);
        [self.animationlayer setCornerRadius:CGRectGetHeight([self.animationlayer bounds]) / 2];
        self.animationlayer.masksToBounds = YES;
        [keyWindow.layer addSublayer:self.animationlayer];
    }
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, startpoint.x,startpoint.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, (endPoint.x+startpoint.x)/2.0, startpoint.y, endPoint.x, endPoint.y);
    bounceAnimation.path = thePath;
    bounceAnimation.delegate = self;
    bounceAnimation.duration = 0.7;
    [self.animationlayer addAnimation:bounceAnimation forKey:@"move"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.animationlayer removeFromSuperlayer];
    self.animationlayer = nil;
}

- (void) requestAddToCart{
    
    [self animationFromView:_bottomView.addToShopCartButton toView:self.rightButton];
    
    [UserServices addGoodsInShopCarListWithGoodsId:self.goodsDetailData[@"sku"]
                                            userId:[KeychainManager readUserId]
                                        merchantId:nil
                                          goodsNum:@(self.headerView.currentGoodsCount)
                                          cartType:@"03"
                                          userName:[KeychainManager readUserName]
                                       productType:nil// 填商品类型，`0-普通商品`、`1-系列商品`
                                   completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             [UnityLHClass showHUDWithStringAndTime:@"添加购物车成功!"];
         }else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}
- (void) requestDefaultAddress{
    
    [UserServices getJDDefaultAddressListWithuserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            if (![responseObject[@"data"] isKindOfClass:[NSString class]]) {
                
            
            switch ([responseObject[@"data"][@"isDefault"] integerValue]) {
                case 0:{
                    
                    self.hasDefaultAddress = NO;

                }
                    
                    break;
                case 1:
                {
                    self.hasDefaultAddress = YES;

                }
                    break;
                    
                default:
                    break;
            }
            
            self.addressID = responseObject[@"data"][@"id"];
            id data = responseObject[@"data"];
            self.addressDic = data;
            }
        }else{

        }
    }];
}

- (void) requestDefaultPriceAddress{
    
    [UserServices getJDPostFeeWithsku:[self formatterJDShopOrderList] province:self.addressDic[@"province"] city:self.addressDic[@"city"]  county:self.addressDic[@"county"]  completionBlock:^(int result, id responseObject) {
        if (result == 0) {
            
            // 跳转至订单确定界面
            JDShopOrderConfirmViewController * orderConfirm = [[JDShopOrderConfirmViewController alloc] init];
            orderConfirm.cartGoodsInfo = [self formatterJDShopOrderData];
            [self.navigationController pushViewController:orderConfirm animated:YES];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    
    

}

- (NSString *) formatterJDShopOrderList{
    

    
    NSMutableArray * orderList = [NSMutableArray array];

    NSMutableArray * listGoods = [NSMutableArray array];
    
    [listGoods addObject:@{@"cartId": NSStringWithData(@""),
                           @"goodsId": NSStringWithData(@""),
                           @"goodsName": @"",
                           @"marketPrice": @"",
                           @"goodsNum": [NSString stringWithFormat:@"%ld",(long)[self.headerView currentGoodsCount]],
                           @"productType":NSStringWithData(@"")}];
    NSDictionary * order = @{@"shippingName":@"03",
                             @"listGoods":listGoods,
                             @"skuId": NSStringWithData(self.goodsDetailData[@"sku"]),
                             @"num": [NSString stringWithFormat:@"%ld",(long)[self.headerView currentGoodsCount]]
                             };
    [orderList addObject:order];
    
    NSString * jsonOrderList =  [JsonManager jsonWithDict:orderList];
    
    return jsonOrderList;
}

#pragma mark --- 商品评价接口
- (void) initiateNetworkListRequest{
    
    // 京东商品详情接口
    NSString*sku=@"";
    if (self.listGoodsInfo[@"goodsId"]) {
        sku=self.listGoodsInfo[@"goodsId"];
    }else
    {
        sku=self.listGoodsInfo[@"sku"];
    }
    
    [UserServices jdGoodsEvaluateGoodsEvaluationListWithGoodsId:sku
                                                      pageIndex:@"1"
                                                       pageSize:@"5"
                                                completionBlock:^(int result, id responseObject)
     {
         if (result == 0) {
             
             self.goodsDetailCommentData = responseObject[@"data"];
             NSArray * data = responseObject[@"data"][@"result"];
             self.noComment = data.count == 0;
             if (data.count > 0)
             {
                 [self didFinishRequestWithData:data handleForListView:self.goodsDetailTableView];
             }
             
         }
         else
         {
             // [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
    
}

- (NSArray *) formatterJDShopOrderData{
    
    
    
    NSMutableArray * datas = [NSMutableArray array];
    
    NSArray * listGoods = @[@{@"cartId":@"",
                              @"goodsId":NSStringWithData(self.goodsDetailData[@"sku"]),
                              @"goodsImageList":NSStringWithData(self.goodsDetailData[@"imagePath"]),//
                              @"goodsName":NSStringWithData(self.goodsDetailData[@"name"]),
                              @"goodsNum":NSStringWithData(@(self.headerView.stepView.value)),
                              @"marketPrice":NSStringWithData(self.goodsDetailData[@"zkPrice"]),
                              @"productType":NSStringWithData(self.goodsDetailData[@"productType"])}];//
    
    NSDictionary * data = @{@"JD":@"1",
                            @"expressDeliveryFee":NSStringWithData(self.goodsDetailData[@"expressDeliveryFee"]),
                            @"expressDeliveryFlg":@"1",
                            @"listGoods":listGoods,
                            @"merchantDeliveryFee":NSStringWithData(self.goodsDetailData[@"merchantDeliveryFee"]),
                            @"merchantDeliveryFlg":NSStringWithData(self.goodsDetailData[@"merchantDeliveryFlg"]),
                            @"merchantId":NSStringWithData(self.goodsDetailData[@"merchantId"]),
                            @"merchantName":@"JD",
                            @"ownDeliveryAddress":NSStringWithData(self.goodsDetailData[@"ownDeliveryAddress"]),
                            @"selfDeliveryFlg":NSStringWithData(self.goodsDetailData[@"selfDeliveryFlg"])};
    [datas addObject:data];
    
    return datas;
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
