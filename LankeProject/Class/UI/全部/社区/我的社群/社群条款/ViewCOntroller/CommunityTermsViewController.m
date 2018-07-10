//
//  CommunityTermsViewController.m
//  LankeProject
//
//  Created by itman on 17/4/24.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CommunityTermsViewController.h"
#import "JYZTextView.h"
#import "MoreCommunityViewController.h"

@interface CommunityTermsViewController ()

@property(nonatomic,strong)JYZTextView *terms;
@property(nonatomic,strong)UIButton *termsButton;

@end

@implementation CommunityTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT-45)];
    [self addSubview:headerView];
    
    self.terms=[[JYZTextView alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH-30, 300)];
    [headerView addSubview:self.terms];
    self.terms.backgroundColor=self.contentView.backgroundColor;
    self.terms.font=BM_FONTSIZE(15.0);
    self.terms.textColor=BM_BLACK;
    self.terms.placeholder=@"请添加社群加入条款";
    if (self.style==TermsStyleReading) {
        self.terms.height=headerView.height;
    }
    
    self.termsButton=[UnityLHClass masonryButton:@"" font:15.0 color:BM_WHITE];
    self.termsButton.backgroundColor=BM_Color_Blue;
    [self.view addSubview:self.termsButton];
    self.termsButton.frame=CGRectMake(0, DEF_BOTTOM(headerView), DEF_SCREEN_WIDTH, 45);
    
    [self.termsButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self communityTerms];
    }];
    
    [self loadViewWithStyle];
}

-(void)communityTerms
{
    switch (self.style)
    {
        case TermsStyleAdd:
        {
            [self editAssociation];
 
        }
            break;
        case TermsStyleEditor:
        {
            [self editAssociation];
        }
            break;
            
        case TermsStyleReading:
        {
            [self addAssociation];
            
        }
            break;
            
            
        default:
            break;
    }


}
-(void)addAssociation
{
    [UserServices
     addAssociationWithuserId:[KeychainManager readUserId]
     userName:[KeychainManager readNickName]
     associationId:self.data[@"associationId"]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self sendObject:@"addAssociation"];
             [UnityLHClass showHUDWithStringAndTime:@"提交成功请等待群主审核"];
             
             MoreCommunityViewController *  moreCommunityVC = nil;
             
             for (UIViewController * VC in self.navigationController.viewControllers) {
                 
                 if ([VC isKindOfClass:[MoreCommunityViewController class]]) {
                     
                     moreCommunityVC = (MoreCommunityViewController *)VC;
                     
                 }
                 
             }
             
             [self.navigationController popToViewController:moreCommunityVC animated:YES];

//             [self.navigationController popViewControllerAnimated:YES];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

-(void)editAssociation
{
    if (self.terms.text.length==0) {
        [UnityLHClass showAlertView:self.terms.placeholder];return;
    }
    [UserServices
     editAssociationWithassociationId:self.data[@"associationId"]
     associationProvision:self.terms.text
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self sendObject:@"editAssociation"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];

         }
    }];
}

-(void)loadViewWithStyle
{
    switch (self.style)
    {
        case TermsStyleAdd:
        {
            self.title=@"添加社群条款";
            [self.termsButton setTitle:@"保存" forState:UIControlStateNormal];

        }
            break;
        case TermsStyleEditor:
        {
            self.title=@"社群条款维护";
            [self.termsButton setTitle:@"保存" forState:UIControlStateNormal];
            self.terms.text=self.data[@"associationProvision"];

        }
            break;

        case TermsStyleReading:
        {
            self.title=@"社群加入条款";
            self.terms.editable=NO;
            [self.termsButton setTitle:@"同意并申请加入" forState:UIControlStateNormal];
             self.terms.text=self.data[@"associationProvision"];
            if (self.terms.text.length==0) {
                self.terms.text=@"社群内严禁谈论涉及政治、宗教、黄赌毒、传播不实谣言等";

            }

        }
            break;

            
        default:
            break;
    }
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
