//
//  MyHandRingViewController.m
//  LankeProject
//
//  Created by itman on 17/4/1.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MyHandRingViewController.h"
#import "HandRingHeaderView.h"
#import "LAKALABraceletManager.h"

@interface MyHandRingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *tableArray;
@property (nonatomic,strong) UITableView *tableCtrl;
@property (nonatomic,strong) HandRingHeaderView *headerView;

@end

@implementation MyHandRingViewController

- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableCtrl.backgroundColor=BM_CLEAR;
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        
    }
    return _tableCtrl;
}

-(void)getDeviceInfo
{

    if (![[LAKALABraceletManager sharedInstance] isConnected])
    {
        [self.headerView loadViewWithDataSource:nil];
        self.tableArray=nil;
        [self.tableCtrl reloadData];
        
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在获取设备信息"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
//        // 异步
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            LAKALABleDeviceInfo *data= [[LAKALABraceletManager sharedInstance] getDeviceInfo];
            [[LAKALABraceletManager sharedInstance]synchronizationInformation];
            
            NSString *appVer=[NSString stringWithFormat:@"%@",data.appVer];
            NSString *macAddress=[NSString stringWithFormat:@"%@",data.macAddress];
            NSString *deviceName=[NSString stringWithFormat:@"%@",data.deviceName];
            
            self.tableArray =       @[
                                      @{@"leftTitle":@"设备名称",@"rightTitle":deviceName},
                                      @{@"leftTitle":@"固件版本号",@"rightTitle":appVer},
                                      @{@"leftTitle":@"手环MAC地址",@"rightTitle":macAddress},
                                      
                                      ];
            

            // 回到主线程
           dispatch_async(dispatch_get_main_queue(), ^{
                [self.headerView loadViewWithDataSource:data];
                [self.tableCtrl reloadData];
               
               double delayInSeconds = 5.0;
               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
               dispatch_after(popTime, dispatch_get_main_queue(), ^{
                   view.alpha = 0;
                   [SVProgressHUD dismiss];
               });
           });
        });
       
        
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
    [self showNavBarCustomByTitle:@"我的手环"];
    [[LAKALABraceletManager sharedInstance] onInitDeviceWithBluetoothConnecteBlock:^(NSInteger status)
     {
         [self getDeviceInfo];
     }];
    
}
-(void)createView
{
    self.headerView = [[HandRingHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/2.0)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    
    [self.headerView receiveObject:^(id object) {
       //扫描蓝牙
        [self onInitDevice];
    }];
    // 初始化设备操作对象
    [self getDeviceInfo];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableArray)
    {
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return  self.tableArray.count;
    }
    else
    {
        return  1;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellID = @"cellID";
        BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.bottomlineWithColor=[UIColor groupTableViewBackgroundColor];
        }
        cell.textLabel.text=self.tableArray[indexPath.row][@"leftTitle"];
        cell.detailTextLabel.text=self.tableArray[indexPath.row][@"rightTitle"];
        return cell;
    }else
    {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            UILabel *outLB = [[UILabel alloc] init];
            outLB.text = @"解除绑定";
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

    if (indexPath.section==1)
    {
        [self onDeleteDevice];
    }
    
}
#pragma mark - UIAction
//搜索设备
- (void)onInitDevice
{
    if (![[LAKALABraceletManager sharedInstance] isConnected])
    {
        [[LAKALABraceletManager sharedInstance] onInitDevice];

    }
}
//删除设备
- (void)onDeleteDevice
{
    [self.headerView loadViewWithDataSource:nil];
    self.tableArray=nil;
    [self.tableCtrl reloadData];
//     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//         // 回到主线程
//    dispatch_async(dispatch_get_main_queue(), ^{
        [[LAKALABraceletManager sharedInstance] onDeleteDevice];
       
//     });
//
//    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
