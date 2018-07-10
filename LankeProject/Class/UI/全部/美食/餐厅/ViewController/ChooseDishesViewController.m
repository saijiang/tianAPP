//
//  ChooseDishesViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ChooseDishesViewController.h"
#import "TakeOutDetailViewController.h"
#import "HLLPickView.h"
#import "HLLValuationBottomView.h"
#import "LKPickSectionCell.h"
#import "LKPickRowTakeOutCell.h"
#import "LKShoppingCarManager.h"
#import "ShoppingCarPopupContentView.h"
#import "ConfirmReserveViewController.h"
#import "TakeOutOrderViewController.h"

@interface ChooseDishesViewController ()<HLLPickerDelegate,HLLPickerDataSource,CAAnimationDelegate>
@property (nonatomic ,strong) ShoppingCarPopupContentView * popupConentView;

@property (nonatomic ,strong) CALayer * animationlayer;

@property (nonatomic ,strong) HLLPickView * takeoutListMenuView;

@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSMutableArray * pickItems;

@property (nonatomic ,strong) LKShoppingCarManager * shoppingCarManager;
@property (nonatomic ,assign) BOOL showShopCarView;

@end

@implementation ChooseDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.flag == 100)
    {
        self.title = @"点餐";
    }else
    {
        self.title = @"外卖";
    }
    _shoppingCarManager = [[LKShoppingCarManager alloc] init];
    
    _pickItems = [NSMutableArray array];
    
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self requestPickDishes];    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self requestAddToShoppingCarComplete:^(){
        
    }];
}
- (void) creatUI{
    
    self.takeoutListMenuView = [[HLLPickView alloc] init];
    self.takeoutListMenuView.backgroundColor = [UIColor clearColor];
    self.takeoutListMenuView.dataSource = self;
    self.takeoutListMenuView.delegate  =self;
    [self.takeoutListMenuView registerClass:[LKPickSectionCell class]
                  forSectionReuseIdentifier:[LKPickSectionCell cellIdentifier]];
    [self.takeoutListMenuView registerClass:[LKPickRowTakeOutCell class]
                      forRowReuseIdentifier:[LKPickRowTakeOutCell cellIdentifier]];
    [self addSubview:self.takeoutListMenuView];
    
    LKWeakSelf
    self.bottomView = [[HLLValuationBottomView alloc] init];
    self.bottomView.countLabel.hidden=YES;
    [self.bottomView.settleAccountsButton setTitle:@"去结算" forState:UIControlStateNormal];
    self.bottomView.bShoppingCarHandle = ^(){
        LKStrongSelf
        [_self navigationToShoppingCar];
    };
    
    self.bottomView.bSettleAccountsHandle = ^(){
        LKStrongSelf
        [_self navigationToPay];
    };
    
    [self addSubview:self.bottomView];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self.takeoutListMenuView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.top.mas_equalTo(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark -
#pragma mark HLLPickView M

- (NSInteger)pickView:(nonnull HLLPickView *)pickView numberOfRowsInSection:(NSInteger)section{
    
    if (self.pickItems.count) {
        
        LKXXXXXSection * section_ = self.pickItems[section];
        return section_.items.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInPickView:(nonnull HLLPickView *)pickView{
    
    return self.pickItems.count;
}

- (nonnull __kindof UITableViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    LKPickSectionCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[LKPickSectionCell cellIdentifier] forSection:section];
    
    if (self.pickItems.count) {
        
        LKXXXXXSection * section_ = self.pickItems[section];
        [cell config:section_.name];
    }

    return cell;
}
- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull HLLPickView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    LKPickRowTakeOutCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[LKPickRowTakeOutCell cellIdentifier] forIndexPath:indexPath];
    
    if (self.pickItems.count) {
        
        LKXXXXXSection * section_ = self.pickItems[indexPath.section];
        LKXXXXXItem * item_ = section_.items[indexPath.item];
        
        //[cell configCellWithData:itemObject];
        [cell configCellWithData_:item_];
        
        LKWeakSelf
        cell.bBuyDishesHandle = ^(LKPickRowTakeOutCell * _cell){
            
            item_.count ++;
            LKStrongSelf
            [_self requestAddDishesToShoppingCarWithData:item_.data fromCell:_cell];
            [pickerView reloadData];
        };
        cell.bMinusDishesHandle = ^(LKPickRowTakeOutCell * _cell){
            item_.count --;
            LKStrongSelf
            [_self requestMinusDishesToShoppingCarWithData:item_.data];
            [pickerView reloadData];
        };
    }

    return cell;
}

- (void) pickView:(nonnull HLLPickView *)pickerView didPickSectionAtSection:(NSInteger)section{
    
    NSLog(@"section :%ld",(long)section);
}

- (void) pickView:(nonnull HLLPickView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    LKXXXXXSection * section_ = self.pickItems[indexPath.section];
    LKXXXXXItem * item_ = section_.items[indexPath.item];
    [self navigationToTakeOutDetailWithData:item_.data];
}

#pragma mark -
#pragma mark Navigation M

- (void) navigationToTakeOutDetailWithData:(id)data{
    
    // 跳转至详情界面
    TakeOutDetailViewController * detail = [[TakeOutDetailViewController alloc] init];
    detail.dishesData = data;
    detail.hasShoppingCar = NO;
    detail.shoppingData = self.shoppingCarManager.currentShoppingCarInfo;
    detail.orderInfo = [self.shoppingCarManager shoppingCarOrderInfo];
    detail.restaurantData = self.restaurantData;
    detail.takeOutOrderInfo = [self.shoppingCarManager shoppingCarOrderInfo];
    detail.reservationInfo = self.reservationInfo;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void) navigationToPay{
    
    self.bottomView.shoppingCartButton.userInteractionEnabled = YES;

    if (self.showShopCarView) {
        
        [self.popupConentView closePopup];
        self.showShopCarView = NO;
    }
    

    // 跳转至结算付款界面
    [self requestAddToShoppingCarComplete:^(){
        
        if (self.reservation) {
            
            // 跳转至订单界面
            ConfirmReserveViewController * confirmViewCotroller = [[ConfirmReserveViewController alloc] init];
            confirmViewCotroller.restaurantData = self.restaurantData;
            confirmViewCotroller.reservationInfo = self.reservationInfo;
            confirmViewCotroller.orderInfo = [self.shoppingCarManager shoppingCarOrderInfo];
            [self.navigationController pushViewController:confirmViewCotroller animated:YES];
        }else{
        
            // 跳转至订单界面
            TakeOutOrderViewController * vc = [TakeOutOrderViewController new];
            
            vc.restaurantData = self.restaurantData;
            vc.takeOutOrderInfo = [self.shoppingCarManager shoppingCarOrderInfo];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void) navigationToShoppingCar{
    
    self.bottomView.shoppingCartButton.userInteractionEnabled = NO;
    self.showShopCarView = YES;
    self.bottomView.whiteViewForMargin.hidden = NO;
    
    // 跳转至购物车界面
    ShoppingCarPopupContentView * popupConentView = [[ShoppingCarPopupContentView alloc] init];
    popupConentView.shoppingCarManager = self.shoppingCarManager;
    popupConentView.bSureHandle = ^(id object){
        if ([object isEqualToString:@"delete"]||[object isEqualToString:@"change"])
        {
            self.showShopCarView = YES;
        }
        else
        {
            self.showShopCarView = NO;
        }
        

        self.bottomView.shoppingCartButton.userInteractionEnabled = YES;
//        self.bottomView.whiteViewForMargin.hidden = YES;//在此处先不隐藏，否则会显示父视图的表格

        // 更新底部视图的购物车信息
        [self.bottomView updateValuationBottomViewWithData:self.shoppingCarManager.currentShoppingCarInfo];
        [self.takeoutListMenuView reloadData];
        
    };
    //确认的时候更新购物车
    [popupConentView receiveObject:^(id object) {
        [self requestAddToShoppingCarComplete:^(){
            self.bottomView.whiteViewForMargin.hidden = YES;//防止空白部分遮住列表
            [self requestPickDishes];
        }];
    }];
    HLLPopupView * popupView = [HLLPopupView tipInWindow:popupConentView heightOffset:60];
    popupView.animationType = EPopupViewAnimationUpFromBottom;
    popupView.dimBackground = YES;
    [popupView show:YES];
    
    self.popupConentView = popupConentView;
}


#pragma mark -
#pragma mark Network M

- (void) requestPickDishes{
    
    [UserServices dishesListWithrRstaurantId:self.restaurantData[@"id"] userId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            [self.pickItems removeAllObjects];
            NSArray * data = responseObject[@"data"];

            NSMutableArray * sections = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary * sectionData in data) {
                LKXXXXXSection * section = [LKXXXXXSection section:sectionData];
                [sections addObject:section];
            }
            [self.pickItems addObjectsFromArray:sections];
            
            [self.takeoutListMenuView reloadData];
            
            //
            [self.shoppingCarManager configShoppingCarInfo:data];
            
            [self.bottomView updateValuationBottomViewWithData:self.shoppingCarManager.currentShoppingCarInfo];

        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}


- (void) requestAddToShoppingCarComplete:(void(^)())complete{
    
    NSString * cardList = [self.shoppingCarManager parseShoppingCarInfo];
    /*
     *  [
     
        ]  4个字符
     */
    if (cardList.length == 4)
    {
        // [UnityLHClass showHUDWithStringAndTime:@"未选择商品！"];
    }else
    {
        [UserServices addOrderCartWithrCardList:cardList userId:[KeychainManager readUserId] cartType:self.reservation ? @"01":@"02" restaurantId:self.restaurantData[@"id"] userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                
                if (complete) {
                    complete();
                }
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    }
}
- (void) requestAddDishesToShoppingCarWithData:(id)data fromCell:(LKPickRowTakeOutCell *)cell{
    
    LKWeakSelf
    [self.shoppingCarManager addGoods:data complete:^(id data) {
        LKStrongSelf
        [_self.bottomView updateValuationBottomViewWithData:data];
    }];
    
    [self animationFromView:cell.buyButton toView:self.bottomView.shoppingCartButton];
}


- (void) requestMinusDishesToShoppingCarWithData:(id)data{
    
    LKWeakSelf
    [self.shoppingCarManager minusGoods:data complete:^(id data) {
        LKStrongSelf
        [_self.bottomView updateValuationBottomViewWithData:data];
    }];
}

#pragma mark -
#pragma mark Animation M

- (void) animationFromView:(UIView *)fromView toView:(UIView *)toView{
    
    UIWindow * keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect fromRect = [fromView.superview convertRect:fromView.frame toView:keyWindow];
    CGPoint startpoint = CGPointMake(fromRect.origin.x+15, fromRect.origin.y+15);
    
    CGRect toRect = [toView.superview convertRect:toView.frame fromView:keyWindow];
    CGPoint endPoint = CGPointMake(toRect.origin.x+50, fabs(toRect.origin.y)+15);
    
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

@end
