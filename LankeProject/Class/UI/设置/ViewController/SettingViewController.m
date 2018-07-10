//
//  SettingViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/21.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"

#import "FeedbackViewController.h"
#import "HelpWebViewController.h"
#import "VersionUpdateViewController.h"
#import "SwitchServerViewController.h"
#import "ChangeIconViewController.h"

#ifdef DEBUG

#define DEF_numberOfRowsInSection 6


#else

#define DEF_numberOfRowsInSection 5


#endif


@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * illInfoTableView;
@property (nonatomic ,strong) UIButton *exitButton;

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.exitButton.hidden=![KeychainManager islogin];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"设置"];
}

- (void) createUI{
    
    self.illInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.illInfoTableView.backgroundColor = [UIColor clearColor];
    self.illInfoTableView.delegate = self;
    self.illInfoTableView.dataSource = self;
    self.illInfoTableView.tableFooterView = [UIView new];
    self.illInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.illInfoTableView.showsVerticalScrollIndicator = NO;
    self.illInfoTableView.rowHeight = 45;
    [self addSubview:self.illInfoTableView];
    
    self.exitButton=[UnityLHClass masonryButton:@"退出登录" font:16.0 color:BM_WHITE];
    self.exitButton.backgroundColor=BM_Color_Blue;
    self.exitButton.layer.masksToBounds=YES;
    self.exitButton.layer.cornerRadius=5;
    [self.view addSubview:self.exitButton];
    self.exitButton.hidden=![KeychainManager islogin];
   [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(15);
       make.right.mas_equalTo(-15);
       make.height.mas_equalTo(45);
       make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
   }];
    [self.exitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self requestLogout];
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.illInfoTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return DEF_numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingCell * cell = [SettingCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 1:
        {
            [UnityLHClass callTel:@"010-68118800"];
        }
            break;
        case 2:
        {
            FeedbackViewController *feed=[[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:feed animated:YES];
        }
            break;
        case 3:
        {
            HelpWebViewController *help=[[HelpWebViewController alloc]init];
            [self.navigationController pushViewController:help animated:YES];
        }
            break;
        case 4:
        {
            VersionUpdateViewController *versionUpdate=[[VersionUpdateViewController alloc]init];
            [self.navigationController pushViewController:versionUpdate animated:YES];
        }
            break;
        case 5:
        {
            SwitchServerViewController *switchServer=[[SwitchServerViewController alloc]init];
            [self.navigationController pushViewController:switchServer animated:YES];
        }
            break;
        case 6:
        {
            ChangeIconViewController *changeIcon=[[ChangeIconViewController alloc]init];
            [self.navigationController pushViewController:changeIcon animated:YES];
        }
            break;
        default:
            break;
    }
}
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
