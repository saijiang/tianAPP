//
//  TCMResultViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "TCMResultViewController.h"
#import "TCMResultItemView.h"
#import "TCMCheckViewController.h"
#import "LKBottomButton.h"
#import "HLLAlert.h"
#import "AllFunctionViewController.h"
#import "HealthHomeViewController.h"

@interface TCMResultViewController ()<DZNEmptyDataSetSource>

@property (nonatomic ,strong) TCMResultItemView * topResultView;
@property (nonatomic ,strong) TCMResultItemView * centerResultView;
@property (nonatomic ,strong) TCMResultItemView * bottomResultView;
@property (nonatomic ,strong) LKBottomButton * testButton;

@end

@implementation TCMResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自测结果";
    self.contentView.emptyDataSetSource=self;
    [self  requestTCMResult];

}

- (void)createView
{

    self.topResultView = [TCMResultItemView view];
    [self addSubview:self.topResultView];
    
    self.centerResultView = [TCMResultItemView view];
    [self addSubview:self.centerResultView];
    
    self.bottomResultView = [TCMResultItemView view];
    [self addSubview:self.bottomResultView];
    
    self.testButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    self.testButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.testButton setTitle:@"重新中医检测" forState:UIControlStateNormal];
    [self.testButton addTarget:self action:@selector(tCMCheckViewController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.testButton];
}
-(void)baseBackBtnAction:(UIButton *)btn
{
    if ([self.pageStr isEqualToString:@"allf"]) {
        for (id controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[AllFunctionViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else if ([self.pageStr isEqualToString:@"health"]) {
        
        for (id controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HealthHomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
      //  [self.navigationController popViewControllerAnimated:YES];
    }
  

}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    [self.topResultView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.centerResultView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.topResultView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.bottomResultView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.centerResultView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.bottomResultView.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-50);
    }];

}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -100);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}

#pragma mark -

-(void)tCMCheckViewController
{
    
    [[[[[[[HLLAlertActionSheet alert]
          title:@"提示"]
         message:@"重新中医检测？"]
        buttons:@[@"取消",@"确定"]]
       style:UIAlertActionStyleDestructive index:1]
      show]
     fetchClick:^(NSInteger index)
     {
         if (index)
         {
             [UserServices
              cleanPhysiquePerPointWithUserId:[KeychainManager readUserId]
              completionBlock:^(int result, id responseObject)
              {
                  
                  if (result == 0)
                  {
                       UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                    
                      [actionSheet showInView:self.view  withCompletionHandler:^(NSInteger buttonIndex){
                                
                                switch (buttonIndex) {
                                    case 0:
                                    {
                                        
                                                TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                                nextTCM.sexStr=@"boy";
                                                [self.navigationController pushViewController:nextTCM animated:YES];
                                               // [self removeSelfFromNavigationStack];
                                                
                                    }
                                        break;
                                    case 1:
                                    {
                                       
                                        TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                        nextTCM.sexStr=@"girl";
                                        [self.navigationController pushViewController:nextTCM animated:YES];
                                               // [self removeSelfFromNavigationStack];
                                        
                                    }
                                        break;
                                    case 2:
                                        
                                        break;
                                        
                                        
                                    default:
                                        break;
                                }
                                
                                
                                
                            }];
                           
                          
                 
                      
                   
                      
                  }
                  else
                  {
                      // error handle here
                      [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                  }
              }];
         }
     }];
 
}


#pragma mark  Network M

- (void) requestTCMResult{
    
    // 接口
    [UserServices getPhysiquePerResultWithUserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                [self createView];
                
                [self.topResultView configForTop:data];
                [self.centerResultView configForCenter:data];
                [self.bottomResultView configForBottom:data];
            }
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
