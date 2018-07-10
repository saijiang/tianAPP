//
//  ErCodePayViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ErCodePayViewController.h"
#import "ErCodePayInputView.h"
#import "ErCodePayResultViewController.h"
#import "EntryPasswordPopupContentView.h"

@interface ErCodePayViewController ()

@property (nonatomic ,strong) UIView * privateContentView;
@property (nonatomic ,strong) LKNetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * desLabel;

@property (nonatomic ,strong) ErCodePayInputView * inputView;
@end

@implementation ErCodePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.inputView inputViewBecomeFirstResponder];
}

- (void)createUI{

    self.privateContentView = [UIView new];
    self.privateContentView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    [self addSubview:self.privateContentView];
    
    self.iconImageView = [[LKNetworkImageView alloc] init];
    self.iconImageView.placeholderImage = [UIImage imageNamed:@"detault_user_icon"];
    [self.iconImageView setImageURL:[NSURL URLWithString:self.payData[@"shopImage"]] complete:nil];
    self.iconImageView.layer.cornerRadius = 5.0f;
    self.iconImageView.layer.masksToBounds = YES;
    [self.privateContentView addSubview:self.iconImageView];
    
    NSString * name = [NSString stringWithFormat:@"向商户\"%@\"付款",self.payData[@"shopName"]];
    self.desLabel = [UnityLHClass masonryLabel:name font:14 color:[UIColor colorWithHexString:@"666666"]];
    self.desLabel.textAlignment = NSTextAlignmentCenter;
    [self.privateContentView addSubview:self.desLabel];
    
    LKWeakSelf
    self.inputView = [ErCodePayInputView view];
    self.inputView.bPayHandle = ^(){
        LKStrongSelf
        [_self requestPay];
        
    };
    [self.privateContentView addSubview:self.inputView];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.privateContentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(290);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.privateContentView.mas_right);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(80);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.desLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(15);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.privateContentView.mas_right);
        make.bottom.mas_equalTo(self.privateContentView.mas_bottom);
        make.height.mas_equalTo(170);
    }];
}


#pragma mark -
#pragma mark Navigation M

- (void) navigationToPayResult{
    
    // 跳转至付款结果界面
    ErCodePayResultViewController * vc = [[ErCodePayResultViewController alloc] init];
    vc.resultData = @{@"price":@(self.inputView.price),
                      @"name":self.payData[@"shopName"]};
    [self.navigationController pushViewController:vc animated:YES];
    
    [self removeSelfFromNavigationStack];
}

#pragma mark -
#pragma mark Network M

- (void) requestPay{
    
    [UserServices
     getWalletBalanceWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             if ([responseObject[@"data"][@"isPwd"] integerValue] == 0)
             {
                 // 0是设置密码
                 ModyPasswordViewController *password = [[ModyPasswordViewController alloc] init];
                 [self.navigationController pushViewController:password animated:YES];
             }
             else
             {
                 //钱包支付
                 EntryPasswordPopupContentView * popupContentView = [[EntryPasswordPopupContentView alloc] init];
                 popupContentView.bSureHandle = ^(NSString * password){
                     
                     [self requestPayWithPassword:password];
                 };
                 HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
                 [popupView show:YES];
                 
             }
         }
         else
         {
          

             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];

    
//    EntryPasswordPopupContentView * popupContentView = [[EntryPasswordPopupContentView alloc] init];
//    popupContentView.bSureHandle = ^(NSString * password){
//        
//        [self requestPayWithPassword:password];
//    };
//    HLLPopupView * popupView = [HLLPopupView alertInWindow:popupContentView];
//    [popupView show:YES];
}

- (void) requestPayWithPassword:(NSString *)password{
    
    NSString * merchantId = self.payData[@"shopId"];
    NSString * money = [NSString stringWithFormat:@"%.2f",self.inputView.price];
    
    // 输入密码接口
    [UserServices walletQrCodeWalletWithrUserId:[KeychainManager readUserId] merchantId:merchantId payMoney:money userPassword:password completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [self navigationToPayResult];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
