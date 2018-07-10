//
//  SwitchServerViewController.m
//  LankeProject
//
//  Created by itman on 17/5/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SwitchServerViewController.h"
#import "SwitchServerManager.h"
@interface SwitchServerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * serverTableView;
@property(nonatomic,strong)UIView * serverHeaderView;

@end

@implementation SwitchServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"切换服务器"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override 重载父类的方法
- (void) createUI
{
    [self addSubview:self.serverTableView];
    self.serverTableView.tableHeaderView=self.serverHeaderView;
}

#pragma mark - Intial Methods 初始化的方法

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    [self.serverTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


#pragma mark - Target Methods 点击事件或通知事件

-(void)addServerUrlWithServerUrl:(NSString *)url
{
    [[SwitchServerManager sharedInstance] addServerUrlWithServerUrl:url];
    [self.serverTableView reloadData];
}

#pragma mark - delegate Delegate的事件

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    NSArray *data=[[SwitchServerManager sharedInstance]getServerUrlDataSource];
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *data=[[SwitchServerManager sharedInstance]getServerUrlDataSource];
    BaseTableViewCell * cell = [BaseTableViewCell cellWithTableView:tableView];
    NSString *url=data[indexPath.row];
    cell.textLabel.text=url;
    cell.textLabel.textColor=BM_BLACK;
    if ([url isEqualToString:[[SwitchServerManager sharedInstance]getCurrentServer]]) {
        cell.textLabel.textColor=BM_Color_Blue;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data=[[SwitchServerManager sharedInstance]getServerUrlDataSource];
    NSString *url= data[indexPath.row];
    NSString *message=[NSString stringWithFormat:@"确认切换到服务器\n%@",url];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [[SwitchServerManager sharedInstance]setCurrentServer:url];
            [UnityLHClass showAlertView:@"服务器切换成功"];
            [tableView reloadData];
            if ([KeychainManager islogin])
            {
                //重新登录账号
                [UserServices loginWithUserAccount:[UserInfo_Preferences sharedInstance].loginInfo userPassword:[KeychainManager readPassword] registrationId:[JPUSHService registrationID] completionBlock:^(int result, id responseObject) {
                    
                    if (result == 0)
                    {
                        id data = responseObject[@"data"];
                        //同步账号信息
                        [UserServices getUserInfoWithuserId:data[@"userId"] completionBlock:^(int result, id responseObject) {
                        }];
                        
                    }else
                    {
                    }
                }];
            }

        }
    }];
}

#pragma mark - Setter Getter Methods 所有的property使用懒加载，并将setter或getter放在底部

-(UIView *)serverHeaderView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 60)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UITextField *field=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, DEF_SCREEN_WIDTH-90, 40)];
    field.placeholder=@"http://";
    field.borderStyle=UITextBorderStyleRoundedRect;
    field.font=[UIFont systemFontOfSize:14.0];
    [view addSubview:field];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(DEF_RIGHT(field)+10, DEF_TOP(field), 60, DEF_HEIGHT(field))];
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=10;
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:BM_WHITE forState:UIControlStateNormal];
    button.backgroundColor=BM_Color_Blue;
    [view addSubview:button];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self addServerUrlWithServerUrl:field.text];
    }];
    return view;
}

-(UITableView *)serverTableView
{
    if (!_serverTableView)
    {
        _serverTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _serverTableView.backgroundColor = [UIColor clearColor];
        _serverTableView.delegate = self;
        _serverTableView.dataSource = self;
        _serverTableView.tableFooterView = [UIView new];
        _serverTableView.showsVerticalScrollIndicator = NO;
        _serverTableView.rowHeight = 45;
    }
    return _serverTableView;
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
