//
//  GroupBuyDetailViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyDetailViewController.h"
#import "LKShyNavigationBar.h"
#import "DishesDetailContentCell.h"
#import "GroupBuyBottomView.h"
#import "GroupBuyDetailHeaderView.h"
#import "GoodsDetailShopInfoSectionHeaderView.h"
#import "MallStoreDetailViewController.h"
#import "GroupBuyPayViewController.h"
#import "CommomNoCommentCell.h"
#import "DishesDetailCommentCell.h"

@interface GroupBuyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) GroupBuyDetailHeaderView * headerView;
@property (nonatomic ,strong) LKShyNavigationBar * shyNavigationBar;

@property (nonatomic ,strong) UITableView * goodsDetailTableView;
@property (nonatomic ,strong) GroupBuyBottomView * bottomView;

@property (nonatomic ,strong) DishesDetailContent * tempConetnt;

@property (nonatomic ,strong) NSDictionary * goodsDetailData;
@property (nonatomic ,strong) NSDictionary * goodsDetailCommentData;

@property (nonatomic ,assign) BOOL noComment;

@end

@implementation GroupBuyDetailViewController

- (BOOL)hidenNavigationBar{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tempConetnt = [[DishesDetailContent alloc] init];
    _noComment = YES;
    [self creatUI];
    
    [self requestGroupBuyGoodsDetail];
    
//    [self refresh];
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
    _shyNavigationBar.hasRightButton = NO;
    _shyNavigationBar.bBackButtonHandle = ^(){
        LKStrongSelf
        [_self.navigationController popViewControllerAnimated:YES];
    };
    [self addSubview:_shyNavigationBar];
    
    //
    self.bottomView = [GroupBuyBottomView view];
    self.bottomView.bRushHandle = ^(){
        LKStrongSelf
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            [_self navigationToBuy];
        }];
    };
    [self addSubview:self.bottomView];
}

- (UIView *) tableViewHeaderView{
    
    LKWeakSelf
    _headerView = [GroupBuyDetailHeaderView view];
    CGFloat hight=[GroupBuyDetailHeaderView height:self.goodsDetailData];
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, hight);
    _headerView.bHeightChangeHandle = ^(CGFloat height){
        LKStrongSelf
        _self.headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, height);
      
    };
    _headerView.bReachMaxValueHandle = ^(NSInteger maxValue){
        [UnityLHClass showHUDWithStringAndTime:@"达到最多购买个数限制"];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
       return  self.noComment ? 1 : self.responseDatas.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [DishesDetailContentCell cellHeightWithData:_tempConetnt];
    }
    if (indexPath.section == 1)
    {
        if (self.noComment)
        {
            return [CommomNoCommentCell cellHeight];
        }
        
        return [DishesDetailCommentCell cellHeightWithData:self.responseDatas[indexPath.row]];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // modif at 20170328: 2.团购详细页面 商城名字 进店按钮这块 删除（代码这块注释掉，不要直接物理删除）
        //return 0;
        return [GoodsDetailShopInfoSectionHeaderView height:self.goodsDetailData];
    }
    if (section == 1)
    {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        GoodsDetailShopInfoSectionHeaderView * shopInfoHeaderView = [GoodsDetailShopInfoSectionHeaderView view];
        [shopInfoHeaderView config:self.goodsDetailData];
        [shopInfoHeaderView hideViewGotoButton];
        shopInfoHeaderView.bGotoShopHandle = ^(){
            
            [self navigationToShopInfo];
        };
        // modif at 20170328: 2.团购详细页面 商城名字 进店按钮这块 删除（代码这块注释掉，不要直接物理删除）
        return shopInfoHeaderView;
    }
    return nil;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishesDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:[DishesDetailContentCell cellIdentifier] forIndexPath:indexPath];
    cell.displayLabel.text = @"商品详情";
    
    cell.content = _tempConetnt;
    [cell configCellForGroupDetail:self.goodsDetailData];
    cell.bCellHeightChangedBlock = ^(){
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [self.shyNavigationBar linearShyNavigationBarWithOffset:offset];
}


#pragma mark -
#pragma mark Navigation M

- (void) navigationToShopInfo{
    
    if (self.sourceViewController) {
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

- (void) navigationToBuy{
    
    // 跳转至抢购，其实就是下订单
    GroupBuyPayViewController * pay = [[GroupBuyPayViewController alloc] init];
    pay.payData = [self payData];
    pay.timeStr=self.goodsDetailData[@"groupOrderAutoCancelTime"];
    [self.navigationController pushViewController:pay animated:YES];
}

- (id) payData{
    
    NSDictionary * goodsData = @{@"image":[NSString stringWithFormat:@"%@",self.goodsDetailData[@"goodsImageList"]],// none
                                 @"name":[NSString stringWithFormat:@"%@",self.goodsDetailData[@"goodsName"]],
                                 @"price":[NSString stringWithFormat:@"%@",self.goodsDetailData[@"groupPrice"]],
                                 @"count":[NSString stringWithFormat:@"%ld",(long)self.headerView.currentGoodsCount],
                                 @"id":[NSString stringWithFormat:@"%@",self.goodsDetailData[@"goodsId"]]};
    NSDictionary * payData = @{@"goods":@[goodsData],
                               @"shopInfo":self.goodsDetailData
                                };
    return payData;
}
#pragma mark -
#pragma mark Network M

- (void) requestGroupBuyGoodsDetail{
    
    //自营商品详情接口
    [UserServices
     getGroupGoodsDetailWithGoodsId:self.goodsId
     completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            
            self.goodsDetailData = responseObject[@"data"];
            _shyNavigationBar.titleLabel.text = self.goodsDetailData[@"merchantName"];
            [self.headerView config:self.goodsDetailData];
            [self.bottomView config:self.goodsDetailData];
            self.tempConetnt.data = self.goodsDetailData;
            [self.goodsDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
