//
//  StoreOneViewController.m
//  LankeProject
//
//  Created by Justin on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "StoreOneViewController.h"
#import "ShoppingCarListCell.h"

#import "ClearingCarBottomView.h"

#import "SideChooseManager.h"

#import "ShoppingCarListHeadView.h"
#import "ShoppingCarListFootView.h"


@interface StoreOneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableCtrl;

@property (nonatomic, strong) ClearingCarBottomView *bottomView;

@property (nonatomic, strong) SideChooseManager *sManager;

@end

@implementation StoreOneViewController

//接口查询
- (void)getRecommendGoods
{
    [UserServices getStoreCartListWithUserId:[KeychainManager readUserId]
                                    cartType:@"01" //01-自营 02-1号店
                             completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self.sManager configChooseManager:responseObject[@"data"]];
             
             //headArray
             [self.tableCtrl reloadData];
         }else
         {
             
         }
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sManager = [[SideChooseManager alloc] init];
    self.sManager.allowsFoldSectionView = NO;
    self.sManager.allowsMultipleSelection = YES;
    self.sManager.tableView = self.tableCtrl;
    
    [self creatUI];
    
    [self getRecommendGoods];
}

- (void)creatUI
{
    [self.view addSubview:self.tableCtrl];
    [self.view addSubview:self.bottomView];
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
        self.bottomView = [[ClearingCarBottomView alloc] initWithFrame:CGRectMake(0, DEF_BOTTOM(self.tableCtrl), DEF_SCREEN_WIDTH, 50)];
        
        //删除选中购物车
        self.bottomView.CShoppingCarDeleteHandle = ^(){
            
        };
        
        //去结算
        self.bottomView.CShoppingCarClearHandle = ^(){
            
        };
        
        
        self.bottomView.userInteractionEnabled = YES;
    }
    
    return _bottomView;
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
    
    cell.stepView.bStepValueChangeHandle = ^(NSInteger vaule ,BOOL puls){
        
        if (puls) {
            [self.sManager plusAtIndexPath:indexPath];
        }else{
            [self.sManager minusAtIndexPath:indexPath];
        }
    };
    [cell configCellWithData:[self.sManager itemObjectAtIndexPath:indexPath]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
