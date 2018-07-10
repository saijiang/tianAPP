//
//  TakeOutDetailViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "TakeOutDetailViewController.h"
#import "LKShyNavigationBar.h"
#import "DishesDetailHeaderView.h"
#import "DishesDetailCommentHeaderView.h"
#import "DishesDetailContentCell.h"
#import "DishesDetailCommentCell.h"
#import "HLLValuationBottomView.h"
#import "TakeOutOrderViewController.h"
#import "AllCommentViewController.h"
#import "CommomNoCommentCell.h"
#import "ConfirmReserveViewController.h"
#import "GradePopupContentView.h"

@interface TakeOutDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) LKShyNavigationBar * shyNavigationBar;
@property (nonatomic ,strong) DishesDetailHeaderView * headerView;
@property (nonatomic ,strong) UITableView * dishesDetailTableView;

@property (nonatomic ,strong) HLLValuationBottomView * bottomView;

@property (nonatomic ,strong) NSDictionary * dishesDetailData;
@property (nonatomic ,strong) NSDictionary * dishesCommentData;
@property (nonatomic ,strong) NSArray * commentList;

@property (nonatomic ,assign) BOOL noComment;

@property (nonatomic ,strong) DishesDetailContent * tempConetnt;

@end

@implementation TakeOutDetailViewController

- (BOOL)hidenNavigationBar{
    
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _hasBottomView = YES;
        _hasShoppingCar = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tempConetnt = [[DishesDetailContent alloc] init];
    
    [self creatUI];
    
    [self requestData];
    
    [self requestEvaluationList];
}

- (void) creatUI{
    
    //
    _dishesDetailTableView = [[UITableView alloc] init];
    _dishesDetailTableView.dataSource = self;
    _dishesDetailTableView.delegate = self;
    _dishesDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    _dishesDetailTableView.tableFooterView = footerView;
    
    _dishesDetailTableView.tableHeaderView = [self tableViewHeaderView];
    
    _dishesDetailTableView.backgroundColor = [UIColor clearColor];
    [_dishesDetailTableView registerClass:[DishesDetailContentCell class]
                   forCellReuseIdentifier:[DishesDetailContentCell cellIdentifier]];
    [_dishesDetailTableView registerClass:[DishesDetailCommentCell class]
                   forCellReuseIdentifier:[DishesDetailCommentCell cellIdentifier]];
    [_dishesDetailTableView registerClass:[CommomNoCommentCell class]
                   forCellReuseIdentifier:[CommomNoCommentCell cellIdentifier]];
    
    [self addSubview:_dishesDetailTableView];

    //
    LKWeakSelf
    _shyNavigationBar = [[LKShyNavigationBar alloc] init];
    _shyNavigationBar.backgroundColor = [UIColor clearColor];
    _shyNavigationBar.offset = 64.0f;
    _shyNavigationBar.bBackButtonHandle = ^(){
        LKStrongSelf
        [_self.navigationController popViewControllerAnimated:YES];
    };
    
    [self addSubview:_shyNavigationBar];
    
    if (self.hasBottomView) {
        
        //
        self.bottomView = [[HLLValuationBottomView alloc] init];
        if (!self.hasShoppingCar) {
            [self.bottomView updateValuationBottomViewWithData:self.shoppingData];
            [self.bottomView updateBottomViewForHideShopingView];
        }
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
   // [self updateBottomViewSettleAccountsButton];

    
}
-(void)updateBottomViewSettleAccountsButton
{
    LKWeakSelf
    if (self.bottomView.price>[self.restaurantData[@"startSendMoney"] floatValue]) {
        
        self.bottomView.settleAccountsButton.enabled=YES;
        [self.bottomView.settleAccountsButton setTitle:@"去结算" forState:UIControlStateNormal];
        
        self.bottomView.bSettleAccountsHandle = ^(){
            
            LKStrongSelf
            [_self navigationToPay];
        };
        
        
    }else{
        
        self.bottomView.settleAccountsButton.enabled=NO;
        NSString*btnName=[NSString stringWithFormat:@"¥%@起送",self.restaurantData[@"startSendMoney"]];
        [self.bottomView.settleAccountsButton setTitle:btnName forState:UIControlStateNormal];
        
    }
}

- (UIView *) tableViewHeaderView{
    
    _headerView = [[DishesDetailHeaderView alloc] init];
    _headerView.wantGradeButton.hidden = YES;
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH+50);
    _headerView.bGradeButtonHandle = ^(){
        NSLog(@"++++++");
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            GradePopupContentView * gradContentView = [[GradePopupContentView alloc] init];
            gradContentView.bCommitButtonHandle = ^(NSString * content ,NSInteger value,PopupContentView *popupContentView){
                
            };
            HLLPopupView * popupView = [HLLPopupView tipInWindow:gradContentView];
            [popupView show:YES];
        }];
    };
    
    return _headerView;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [_dishesDetailTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        if (self.hasBottomView) {
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-10);
        }else{
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        }
        make.top.mas_equalTo(0);
    }];
    
    [_shyNavigationBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_dishesDetailTableView.mas_top);
        make.left.mas_equalTo(_dishesDetailTableView.mas_left);
        make.right.mas_equalTo(_dishesDetailTableView.mas_right);
        make.height.mas_equalTo(64);
    }];

    if (self.hasBottomView) {

        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(50);
        }];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    if (section == 0) {
//        return 1;
//    }else{
//        return self.noComment ? 1 : self.commentList.count;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return [DishesDetailContentCell cellHeightWithData:_tempConetnt];
//    if (indexPath.section == 0) {
//        
//        return [DishesDetailContentCell cellHeightWithData:_tempConetnt];
//    }
//    if (indexPath.section == 1) {
//        if (self.noComment) {
//            return [CommomNoCommentCell cellHeight];
//        }
//        return [DishesDetailCommentCell cellHeightWithData:self.commentList[indexPath.row]];
//    }
//    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 40;
//    }
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (section == 0) {
//        return nil;
//    }
////    LKWeakSelf
////    DishesDetailCommentHeaderView * commentHeaderView = [[DishesDetailCommentHeaderView alloc] init];
////    [commentHeaderView configCommentHeaderViewWithData:self.dishesCommentData];
////    commentHeaderView.bCommentHeaderTapHandle = ^(){
////        LKStrongSelf
////        [_self navigationToAllComment];
////    };
////    return commentHeaderView;
//}
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return .1;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
    
        DishesDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailContentCell cellIdentifier] forIndexPath:indexPath];
        
        cell.content = _tempConetnt;
        
        [cell configCellWithData:self.dishesDetailData];
        
        cell.bCellHeightChangedBlock = ^(){
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return cell;
//        
//    }else if (indexPath.section == 1){
//        
//        
//        if (self.noComment) {
//            
//            CommomNoCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[CommomNoCommentCell cellIdentifier] forIndexPath:indexPath];
//            
//            return cell;
//        }else{
//            DishesDetailCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailCommentCell cellIdentifier] forIndexPath:indexPath];
//            
//            [cell configCellWithData:self.commentList[indexPath.row]];
//            return cell;
//        }
//    }
//    return nil;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        return;
//    }
//    //
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [self.shyNavigationBar linearShyNavigationBarWithOffset:offset];
}


#pragma mark -
#pragma mark Navigation M

- (void) navigationToPay{
    
    if (self.reservationInfo)
    {
        // 预定信息
        ConfirmReserveViewController * detail = [[ConfirmReserveViewController alloc] init];
        detail.restaurantData = self.restaurantData;
        detail.reservationInfo = self.reservationInfo;//
        detail.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        // 跳转至订单界面
        TakeOutOrderViewController * vc = [TakeOutOrderViewController new];
        vc.restaurantData = self.restaurantData;
        vc.takeOutOrderInfo = self.takeOutOrderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) navigationToShoppingCar{
    
    // 跳转至购物车界面
    
}

- (void) navigationToAllComment{
    
    NSString * dishesId = [NSString stringWithFormat:@"%@",self.dishesData[@"dishesId"]];
    // 跳转至所有评论界面
    AllCommentViewController * allComment = [[AllCommentViewController alloc] init];
    allComment.dishesId = dishesId;
    [self.navigationController pushViewController:allComment animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void)requestData
{
    NSString * dishesId = [NSString stringWithFormat:@"%@",self.dishesData[@"dishesId"]];
    
    [UserServices getDishesDetailWithdishesId:dishesId
                              completionBlock:^(int result, id responseObject)
     {
         if ([responseObject[@"status"] integerValue] == 0){
             
             self.dishesDetailData = [[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
             
             self.shyNavigationBar.titleLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"restaurantName"]];
             
             [self.headerView configDetailHeaderViewWithData:self.dishesDetailData];
             
             [self.dishesDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:0];
         }else{
             
         }
     }];
}

- (void) requestEvaluationList{
    
    NSString * dishesId = [NSString stringWithFormat:@"%@",self.dishesData[@"dishesId"]];
    
    [UserServices evaluationListWithDishesId:dishesId pageIndex:@"1" pageSize:@"5" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            self.dishesCommentData = responseObject[@"data"];
            NSArray * list = responseObject[@"data"][@"list"];
            self.commentList = list;
            
//            self.noComment = list.count == 0;
//            
//            [self.dishesDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:0];
//            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
