//
//  NewSelfSupportGoodsDetailViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/9/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "NewSelfSupportGoodsDetailViewController.h"

#import "LKShyNavigationBar.h"
#import "GoodsDetailHeaderView.h"
#import "GoodsDetailBottomView.h"

#import "DishesDetailContentCell.h"

#import "DishesDetailCommentCell.h"
#import "CommomNoCommentCell.h"
#import "DishesDetailCommentHeaderView.h"
#import "AllCommentViewController.h"
#import "GoodsDetailShopInfoSectionHeaderView.h"
#import "MallStoreDetailViewController.h"
#import "MallOrderConfirmViewController.h"
#import "UIViewController+Page.h"
//购物车
#import "ShoppingCarListViewController.h"
#import "SelfSupportCarViewController.h"
#import "CartNumView.h"

@interface NewSelfSupportGoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CAAnimationDelegate>

@property (nonatomic ,strong) GoodsDetailHeaderView * headerView;
@property (nonatomic ,strong) LKShyNavigationBar * shyNavigationBar;
@property(nonatomic,strong)CartNumView *cartNumView;

@property (nonatomic ,strong) UITableView * goodsDetailTableView;
@property (nonatomic ,strong) GoodsDetailBottomView * bottomView;

//@property (nonatomic ,strong) DishesDetailContent * tempConetnt;

@property (nonatomic ,strong) NSDictionary * goodsDetailData;
@property (nonatomic ,strong) NSDictionary * goodsDetailCommentData;

@property (nonatomic ,assign) BOOL noComment;
@property (nonatomic ,strong) CALayer *animationlayer;

@end

@implementation NewSelfSupportGoodsDetailViewController

- (BOOL)hidenNavigationBar{
    
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.cartNumView)
    {
        [self.cartNumView getGoodsCartNum];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _tempConetnt = [[DishesDetailContent alloc] init];
    _noComment = YES;
    [self creatUI];
    
    [self requestSelfSupportGoodsDetail];
    
    [self refresh];
}

- (void) creatUI{
    
    //
    _goodsDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
            
            SelfSupportCarViewController * cartList = [[SelfSupportCarViewController alloc] init];
//            cartList.isZiYingShop=YES;
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
        [_self navigationToOrderConfirm];
    };
    __block NewSelfSupportGoodsDetailViewController *manager = self;
    self.bottomView.bAddToShopCartHandle = ^(){
        //此处加入购物车
        
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            [manager requestAddToCart];
        }];
    };
    [self addSubview:self.bottomView];
}

- (UIView *) tableViewHeaderView{
    
    LKWeakSelf
    _headerView = [GoodsDetailHeaderView view];
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH + 100+140);
    _headerView.selfSupport = YES;
    _headerView.stepView.bReachMaxValueHandle = ^(NSInteger maxValue){
        [UnityLHClass showHUDWithStringAndTime:@"达到最多购买个数限制"];
    };
    _headerView.stepView.bStepValueChangeHandle = ^(NSInteger vaule,BOOL plus){
        LKStrongSelf
        [_self.bottomView enableButton:vaule > 0];
    };
    
 //   _headerView.shopInfoHeaderView.bGotoShopHandle = ^(){
        
  //      LKStrongSelf
   //     [_self navigationToShopInfo];
   // };
    
   // _headerView.bCellHeightChangedBlock = ^(){
      //  LKStrongSelf
    //    _self.headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH+100+[_self./headerView getHeight]);
   //     _self.goodsDetailTableView.tableHeaderView = _self.headerView;
//    };
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.noComment ? 1 : self.responseDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.noComment)
    {
        return [CommomNoCommentCell cellHeight];
    }
    return [DishesDetailCommentCell cellHeightWithData:self.responseDatas[indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
    {
        
        GoodsDetailShopInfoSectionHeaderView * shopInfoHeaderView = [GoodsDetailShopInfoSectionHeaderView view];
        [shopInfoHeaderView config:self.goodsDetailData];
        shopInfoHeaderView.bGotoShopHandle = ^(){
            
            [self navigationToShopInfo];
        };
        return shopInfoHeaderView;
    }
    
    LKWeakSelf
    DishesDetailCommentHeaderView * commentHeaderView = [[DishesDetailCommentHeaderView alloc] init];
    [commentHeaderView configCommentHeaderViewWithData:self.goodsDetailCommentData];
    [commentHeaderView configEvalScoresHeaderViewWithData:self.goodsDetailData];
    
    commentHeaderView.bCommentHeaderTapHandle = ^(){
        LKStrongSelf
        [_self navigationToAllComment];
    };
    return commentHeaderView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        DishesDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailContentCell cellIdentifier] forIndexPath:indexPath];
        cell.displayLabel.text = @"商品详情";
       // cell.content = _tempConetnt;
        [cell configCellForGoodsDetail:self.goodsDetailData];
                cell.bCellHeightChangedBlock = ^(){
        
                   [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
               };
        
        return cell;
        
    }else if (indexPath.section == 1)
    {
        
        
    }
   // return nil;
    
    if (self.noComment) {
        
        CommomNoCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[CommomNoCommentCell cellIdentifier] forIndexPath:indexPath];
        
        return cell;
    }else{
        DishesDetailCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailCommentCell cellIdentifier] forIndexPath:indexPath];
        
        [cell configCellWithData:self.responseDatas[indexPath.row]];
        return cell;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [self.shyNavigationBar linearShyNavigationBarWithOffset:offset];
}

- (NSArray *) formatterOrderData{
    
    NSMutableArray * datas = [NSMutableArray array];
    
    NSArray * listGoods = @[@{@"cartId":@"",
                              @"goodsId":NSStringWithData(self.goodsDetailData[@"goodsId"]),
                              @"goodsImageList":self.goodsDetailData[@"goodsImageList"],
                              @"goodsName":self.goodsDetailData[@"goodsName"],
                              @"goodsNum":NSStringWithData(@(self.headerView.stepView.value)),
                              @"marketPrice":NSStringWithData(self.goodsDetailData[@"marketPrice"]),
                              @"salePrice":NSStringWithData(self.goodsDetailData[@"salePrice"]),
                              @"couponPrice":NSStringWithData(self.goodsDetailData[@"couponPrice"]),
                              @"status":NSStringWithData(self.goodsDetailData[@"status"])}];
    
    NSDictionary * data = @{@"expressDeliveryFee":NSStringWithData(self.goodsDetailData[@"expressDeliveryFee"]),
                            @"expressDeliveryFlg":NSStringWithData(self.goodsDetailData[@"expressDeliveryFlg"]),
                            @"listGoods":listGoods,
                            @"merchantDeliveryFee":NSStringWithData(self.goodsDetailData[@"merchantDeliveryFee"]),
                            @"merchantDeliveryFlg":NSStringWithData(self.goodsDetailData[@"merchantDeliveryFlg"]),
                            @"merchantId":NSStringWithData(self.goodsDetailData[@"merchantId"]),
                            @"merchantName":NSStringWithData(self.goodsDetailData[@"merchantName"]),
                            @"ownDeliveryAddress":NSStringWithData(self.goodsDetailData[@"ownDeliveryAddress"]),
                            @"selfDeliveryFlg":NSStringWithData(self.goodsDetailData[@"selfDeliveryFlg"])};
    [datas addObject:data];
    
    return datas;
}

#pragma mark -
#pragma mark Navigation M

- (void) navigationToAllComment{
    
    NSString * dishesId = [NSString stringWithFormat:@"%@",self.goodsDetailData[@"dishesId"]];
    // 跳转至所有评论界面
    AllCommentViewController * allComment = [[AllCommentViewController alloc] init];
    allComment.dishesId = dishesId;
    [self.navigationController pushViewController:allComment animated:YES];
}

- (void) navigationToShopInfo{
    
    if (self.isSorce) {
        // 返回 店铺详情界面
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        // 跳转 店铺详情界面
        MallStoreDetailViewController * shopInfo = [[MallStoreDetailViewController alloc] init];
        shopInfo.merchantId = self.goodsDetailData[@"merchantId"];
        shopInfo.sourceGoodsId = self.goodsDetailData[@"goodsId"];
        [self.navigationController pushViewController:shopInfo animated:YES];
    }
}

- (void) navigationToOrderConfirm{
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        // 跳转至订单确定界面
        MallOrderConfirmViewController * orderConfirm = [[MallOrderConfirmViewController alloc] init];
        orderConfirm.orderType = @"03";
        orderConfirm.cartGoodsInfo = [self formatterOrderData];
        [self.navigationController pushViewController:orderConfirm animated:YES];
    }];
}


#pragma mark -
#pragma mark Network M

- (void) requestSelfSupportGoodsDetail{
    
    //自营商品详情接口
    [UserServices goodsGetGoodsDetailWithUserId:[KeychainManager readUserId] goodsId:self.goodsId completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            self.goodsDetailData = responseObject[@"data"];
            _shyNavigationBar.titleLabel.text = self.goodsDetailData[@"merchantName"];
            [self.headerView config:self.goodsDetailData];
            
//            self.tempConetnt.data = self.goodsDetailData;
            
            [self.goodsDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
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
    [UserServices addGoodsInShopCarListWithGoodsId:self.goodsDetailData[@"goodsId"]
                                            userId:[KeychainManager readUserId]
                                        merchantId:self.goodsDetailData[@"merchantId"]
                                          goodsNum:@(self.headerView.currentGoodsCount)
                                          cartType:@"01"
                                          userName:[KeychainManager readUserName]
                                       productType:@""
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
- (void) initiateNetworkListRequest{
    
    //商品评价接口
    [UserServices goodsGetGoodsEvaluationWithGoodsId:self.goodsId pageIndex:@"1" pageSize:@"5" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            self.goodsDetailCommentData = responseObject[@"data"];
            NSArray * data = responseObject[@"data"][@"list"];
            self.noComment = data.count == 0;
            [self didFinishRequestWithData:data handleForListView:self.goodsDetailTableView];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
