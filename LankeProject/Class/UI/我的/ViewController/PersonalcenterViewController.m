//
//  PersonalcenterViewController.m
//  LankeProject
//
//  Created by itman on 16/5/31.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "PersonalcenterViewController.h"
#import "PersonCenterCell.h"
#import "PersonCenterHeaderView.h"

#import "WalletViewController.h"
#import "MyTherapyViewController.h"
#import "AddressViewController.h"
#import "JDAddressViewController.h"

#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "ErCodeViewController.h"
#import "MyNewsViewController.h"
#import "MyCollectionViewController.h"
#import "AfterSalesOrderViewController.h"
#import "ShoppingCarListViewController.h"
#import "ErCodePayViewController.h"
#import "MyHandRingViewController.h"
#import "IntegralCenterViewController.h"
//发票
#import "JDInvoiceViewController.h"
//京东售后
#import "JDServiceViewController.h"

#import "SelfSupportCarViewController.h"

@interface PersonalcenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *tableArray;
@property (nonatomic,strong) UITableView *tableCtrl;
@property (nonatomic,strong) PersonCenterHeaderView *headerView;
@property (nonatomic,assign) BOOL isMessage;

@end
  
@implementation PersonalcenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.headerView getUserInfo];
    [self.headerView getWalletBalance];
    
    [self getMessage];

}

-(void)getMessage
{
    [UserServices
     getMessageCount:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            if ([responseObject[@"data"] integerValue]>0)
            {
                self.isMessage=YES;

            }else{
                self.isMessage=NO;

            }
            [self.tableCtrl reloadData];

        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self showNavBarCustomByTitle:[KeychainManager readUserName]];
    [self showRightBarButtonItemHUDByName:@"扫码支付"];
    [self initUI];
    
}

- (void)initUI
{
    self.headerView = [[PersonCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT*3/7 - 50)];
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
}
-(NSArray *)tableArray
{
    if (!_tableArray)
    {
        //赋值
        NSArray *colorArray = @[[UIColor colorWithRed:0.36 green:0.82 blue:0.76 alpha:1],
                                [UIColor colorWithRed:0.73 green:0.53 blue:0.66 alpha:1],
                                [UIColor colorWithRed:0.55 green:0.56 blue:0.98 alpha:1],
                                [UIColor colorWithRed:0.98 green:0.69 blue:0.41 alpha:1],
                                [UIColor colorWithRed:0.93 green:0.33 blue:0.66 alpha:1],
                                BM_Color_Blue,
                                BM_Color_GrayColor,
                                [UIColor colorWithRed:0.93 green:0.33 blue:0.66 alpha:1],
                                 [UIColor colorWithRed:0.55 green:0.56 blue:0.98 alpha:1],
                                [UIColor colorWithHexString:@"#D62BAE"],
                                 [UIColor colorWithRed:0.73 green:0.53 blue:0.66 alpha:1],
                                ];
        NSArray *titleArray = @[@"我的i币",@"我的疗养券",@"我的积分",@"我的收藏",@"我的收货地址",@"京东收货地址",@"我的消息",@"我的售后",@"京东退换售后",@"我的手环",@"我的购物车",];
        self.tableArray = @[
                               @{@"color":colorArray[0],@"title":titleArray[0]},
                               @{@"color":colorArray[1],@"title":titleArray[1]},
                               @{@"color":colorArray[2],@"title":titleArray[2]},
                               @{@"color":colorArray[3],@"title":titleArray[3]},
                               @{@"color":colorArray[4],@"title":titleArray[4]},
                               @{@"color":colorArray[5],@"title":titleArray[5]},
                               @{@"color":colorArray[6],@"title":titleArray[6]},
                               @{@"color":colorArray[7],@"title":titleArray[7]},
                                @{@"color":colorArray[8],@"title":titleArray[8]},
                                @{@"color":colorArray[9],@"title":titleArray[9]},
@{@"color":colorArray[10],@"title":titleArray[10]},
                            ];
    }
    return _tableArray;
}
/**
 *  重写tableCtrl的getter方法
 */
- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT*3/7 - 40, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT*4/7) style:UITableViewStyleGrouped];
        self.tableCtrl.backgroundColor=BM_CLEAR;
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        
    }
    return _tableCtrl;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.tableArray.count;
    }
    else
    {
        return [KeychainManager islogin] ? 1 : 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellID = @"cellID";
        PersonCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[PersonCenterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        [cell loadCellWithDataSource:self.tableArray[indexPath.row]];
        if (indexPath.row==6&&self.isMessage) {
            cell.redImage.hidden=NO;
        }else{
            cell.redImage.hidden=YES;

        }
        return cell;
    }else
    {
        static NSString *cellID = @"outcellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            UILabel *outLB = [[UILabel alloc] init];
            outLB.text = @"退出账号";
            outLB.font = BM_FONTSIZE(15.0);
            outLB.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            [cell addSubview:outLB];
            [outLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.mas_centerX);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    WalletViewController *wallet = [[WalletViewController alloc] init];
                    [self.navigationController pushViewController:wallet animated:YES];
                }];
            }
                break;
            case 1:{
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    MyTherapyViewController *wallet = [[MyTherapyViewController alloc] init];
                    [self.navigationController pushViewController:wallet animated:YES];
                }];
            }
                break;
            case 2:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    IntegralCenterViewController *collection = [[IntegralCenterViewController alloc] init];
                    collection.dataArray=self.headerView.dataDic;
                    [self.navigationController pushViewController:collection animated:YES];
                }];
                
            }
                break;
            case 3:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    MyCollectionViewController *collection = [[MyCollectionViewController alloc] init];
                    [self.navigationController pushViewController:collection animated:YES];
                }];

            }
                break;
            case 4:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    AddressViewController *address=[[AddressViewController alloc]init];
                    [self.navigationController pushViewController:address animated:YES];
                }];
            }
                break;
            case 5:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    JDAddressViewController *new=[[JDAddressViewController alloc]init];
                    [self.navigationController pushViewController:new animated:YES];
                }];
             
            }
                break;
            case 6:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    MyNewsViewController *new=[[MyNewsViewController alloc]init];
                    [self.navigationController pushViewController:new animated:YES];
                }];
                
            }
                break;
            case 7:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    AfterSalesOrderViewController *afterSalesOrder=[[AfterSalesOrderViewController alloc]init];
                    [self.navigationController pushViewController:afterSalesOrder animated:YES];
                }];
            }
                break;
            case 8:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                   //京东发票
//                    JDInvoiceViewController *vc = [[JDInvoiceViewController alloc] init];
                    //京东售后
                    JDServiceViewController *vc = [[JDServiceViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
                break;
            case 9:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
                    MyHandRingViewController *handRing=[[MyHandRingViewController alloc]init];
                    [self.navigationController pushViewController:handRing animated:YES];
                }];
            }
                break;
            case 10:
            {
                [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                    
//                    SelfSupportCarViewController *carList = [[SelfSupportCarViewController alloc] init];
//                    [self.navigationController pushViewController:carList animated:YES];
                    ShoppingCarListViewController *shopList=[[ShoppingCarListViewController alloc]init];
                    [self.navigationController pushViewController:shopList animated:YES];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
    
        [self requestLogout];
    }
}
//扫码支付
- (void)baseRightBtnAction:(UIButton *)btn
{
    
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        ErCodeViewController *erCode = [[ErCodeViewController alloc] init];
        [self.navigationController pushViewController:erCode animated:YES];
    }];
}

#pragma mark -
#pragma mark Network M
- (void) requestLogout{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * userId = [KeychainManager readUserId];
        [UserServices logouByUserId:userId completionBlock:^(int result, id responseObject) {
            if (result == 0)
            {
                [KeychainManager gotoLogin];
            }
            else
            {
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    });
    

}
@end
