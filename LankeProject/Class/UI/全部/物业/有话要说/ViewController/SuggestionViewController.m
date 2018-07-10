//
//  SuggestionViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SuggestionViewController.h"
//文本输入框
#import "JYZTextView.h"
//选择照片
#import "SelectedPhotoView.h"
#import "SuggestionHistoryViewController.h"

@interface SuggestionViewController ()

@property(nonatomic,strong)UILabel *type;//类型
@property(nonatomic,strong)JYZTextView *introduction;//输入框
@property(nonatomic,strong)SelectedPhotoView *photo;//上传照片

@property(nonatomic,strong)NSString *complainType;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavBarCustomByTitle:@"有话要说"];
    [self showRightBarButtonItemHUDByName:@"历史"];
    self.complainType=@"01";
}

- (void)baseRightBtnAction:(UIButton *)btn{

    SuggestionHistoryViewController * vc = [[SuggestionHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createUI
{
    //类型的底部view
    UIView *oneView=[[UIView alloc]init];
    oneView.backgroundColor=BM_WHITE;
    [self addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50);
    }];
    //类型title lable
    UILabel *type=[UnityLHClass masonryLabel:@"类型" font:15.0 color:BM_BLACK];
    [oneView addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(oneView.mas_centerY);
    }];
    
    //箭头
    UIImageView *goimageView=[[UIImageView alloc]init];
    goimageView.image=[UIImage imageNamed:@"right_arrow"];
    goimageView.userInteractionEnabled=YES;
    [oneView addSubview:goimageView];
    [goimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(oneView.mas_centerY);
        make.right.mas_equalTo(-15);
        
    }];
    
    //类型content lable
    self.type=[UnityLHClass masonryLabel:@"选择类型" font:15.0 color:BM_BLACK];
    [oneView addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goimageView.mas_left).offset(-15);
        make.centerY.mas_equalTo(oneView.mas_centerY);
    }];
    
    //线条
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [oneView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(oneView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [oneView addGestureRecognizer:tap];
    
    
    //输入框底部view
    UIView *twoView=[[UIView alloc]init];
    twoView.backgroundColor=BM_WHITE;
    [self addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(150);
    }];
    
    self.introduction=[[JYZTextView alloc]init];
    self.introduction.font=BM_FONTSIZE(15.0);
    self.introduction.placeholder=@"请输入有话要说的内容";
    [twoView addSubview:self.introduction];
    [self.introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(twoView.mas_top).offset(5);
        make.bottom.mas_equalTo(twoView.mas_bottom).offset(-10);
    }];
    
    UILabel *photolable=[UnityLHClass masonryLabel:@"上传照片" font:15.0 color:BM_BLACK];
    [self addSubview:photolable];
    [photolable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(twoView.mas_bottom).offset(20);
    }];
    
    self.photo=[[SelectedPhotoView alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(photolable), DEF_SCREEN_WIDTH-10*2, 100)];
    self.photo.maxColumn=3;
    self.photo.maxImageCount=3;
    [self addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(photolable.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(100);
    }];
    
    UIButton *submitButton=[UnityLHClass masonryButton:@"提交" font:17.0 color:BM_WHITE];
    submitButton.layer.masksToBounds=YES;
    submitButton.layer.cornerRadius=5;
    submitButton.backgroundColor=[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
    submitButton.frame=CGRectMake(15, DEF_BOTTOM(self.photo)+30, DEF_SCREEN_WIDTH-15*2, 40);
    [self addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.photo.mas_bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
    
    [submitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self addTopicComplain];
    }];
    
    
}

-(void)addTopicComplain
{
    if (self.introduction.text.length==0)
    {
        [UnityLHClass showAlertView:self.introduction.placeholder];
    }
    else
    {
        [UserServices
         addTopicComplainWithUserId:[KeychainManager readUserId]
         districtId:[KeychainManager readDistrictId]
         complainType:self.complainType
         complainContent:self.introduction.text
         imagesPath:self.photo.images
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 SuggestionHistoryViewController * vc = [[SuggestionHistoryViewController alloc] init];
                 [self.navigationController pushViewController:vc animated:YES];
                 if (self.navigationController && [self.navigationController.viewControllers count])
                 {
                     NSMutableArray * vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                     [vcs removeObjectAtIndex:vcs.count-2];
                     self.navigationController.viewControllers = vcs;
                 }

                 
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
}


#pragma mark --- 选择类型
-(void)tap
{
    
    NSArray *dropArray=@[@"物业费用",@"物业保修",@"其他"];
    NSArray *complainTypeArray=@[@"01",@"02",@"03"];
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"物业费用",@"物业保修",@"其他", nil];
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex<dropArray.count)
        {
            self.type.text =dropArray[buttonIndex];
            self.complainType=complainTypeArray[buttonIndex];
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
