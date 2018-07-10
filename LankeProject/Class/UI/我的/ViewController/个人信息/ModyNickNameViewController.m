//
//  ModyNickNameViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ModyNickNameViewController.h"
#import "LKBottomButton.h"


@interface ModyNickNameViewController ()
{
    UITextField *modTF;
}

@end

@implementation ModyNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarCustomByTitle:@"修改昵称"];
    
    UIView *downView = [[UIView alloc] init];
    downView.backgroundColor = BM_WHITE;
    [self.view addSubview:downView];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.height.offset(55);
    }];
    
    UIImageView *modImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    modImage.image = [UIImage imageNamed:@"UserCenter-ModNick"];
    modTF = [[UITextField alloc] init];
    modTF.leftView=modImage;
    modTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    modTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    modTF.placeholder = @"请输入昵称";
    modTF.font = BM_FONTSIZE(14.0);
    [downView addSubview:modTF];

    [modTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(downView.mas_centerY);
        make.left.mas_equalTo(downView.mas_left).offset(15);
        make.right.mas_equalTo(downView.mas_right).mas_offset(-10);
        make.height.offset(40);
    }];
    
    
    //确认
    LKBottomButton *sureBtn = [[LKBottomButton alloc] init];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = BM_FONTSIZE(16.0);
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.offset(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(downView.mas_bottom).offset(20);
    }];
    
}

- (void)sureBtnAction:(UIButton *)sender
{
    if (modTF.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:modTF.placeholder];
        return;
    }
    [UserServices
     updateNickNameWithuserId:[KeychainManager readUserId]
     nickName:modTF.text
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
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
