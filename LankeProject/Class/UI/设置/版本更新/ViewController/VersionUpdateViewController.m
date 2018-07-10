//
//  VersionUpdateViewController.m
//  LankeProject
//
//  Created by itman on 17/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "VersionUpdateViewController.h"

@interface VersionUpdateViewController ()

@property(nonatomic,strong)UILabel *message;
@property(nonatomic,strong)UIImageView *newicon;
@property(nonatomic,strong)UIButton *updateButton;

@end

@implementation VersionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"版本更新"];
    [self upVersion];
}
-(void)createUI
{
    UIImageView *icon=[[UIImageView alloc]init];
    icon.image=[UIImage imageNamed:@"AppIcon"];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(60);
    }];
    
    NSString *vis=[NSString stringWithFormat:@"V%@",DEF_Version];
    UILabel *message=[UnityLHClass masonryLabel:vis font:14.0 color:BM_BLACK];
    [self.view addSubview:message];
    self.message=message;

    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(icon.mas_bottom).offset(40);

    }];
    
    UIImageView *newicon=[[UIImageView alloc]init];
    newicon.hidden=YES;
    newicon.image=[UIImage imageNamed:@"setting_new"];
    [self.view addSubview:newicon];
    self.newicon=newicon;
    [newicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(message.mas_top);
        make.left.mas_equalTo(message.mas_right).mas_equalTo(2);
    }];
    
    UIButton *updateButton=[UnityLHClass masonryButton:@"版本升级" font:16.0 color:BM_WHITE];
    updateButton.hidden=YES;
    updateButton.backgroundColor=BM_Color_Blue;
    updateButton.layer.masksToBounds=YES;
    updateButton.layer.cornerRadius=5;
    [self.view addSubview:updateButton];
    self.updateButton=updateButton;
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(message.mas_bottom).offset(80);
    }];
    [updateButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/mbyp"]];

    }];
    
}

-(void)upVersion
{
    [UserServices
     upVersionWithcompletionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]])
             {
                 return ;
             }
             NSDictionary *dataSource=responseObject[@"data"];
             NSString *version=DEF_Version;
             //NSString *vis=[NSString stringWithFormat:@"V%@",DEF_Version];
             if ([dataSource[@"version"] floatValue] > [version floatValue])
             {
                 self.newicon.hidden=NO;
                 self.updateButton.hidden=NO;
                 self.message.text=@"当前有新版本更新";
             }
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
