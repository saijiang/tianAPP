//
//  AllFunction ViewController.m
//  LankeProject
//
//  Created by itman on 16/10/9.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "AllFunctionViewController.h"
#import "AllFunctionConfig.h"
#import "TCMResultViewController.h"
#import "TCMCheckViewController.h"
@interface AllFunctionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) AllFunctionConfig * manager;
@property (nonatomic ,strong) UICollectionView * allFunctionCollectionView;
@end

@implementation AllFunctionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _manager = [[AllFunctionConfig alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavBarCustomByTitle:@"全部"];
//    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_huifu"]];
    
    [self creatUI];
}

- (void) creatUI{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.allFunctionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.allFunctionCollectionView.alwaysBounceVertical = YES;
    self.allFunctionCollectionView.dataSource = self.manager;
    self.allFunctionCollectionView.delegate = self;
    self.allFunctionCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.allFunctionCollectionView];
    
    [self.allFunctionCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-10);
    }];
    
    self.manager.collectionView = self.allFunctionCollectionView;
    
    DataSource * dataSource = [DataSource dataSourceWithName:@"allFunctionConfig"];
    
    [self.manager configAllFunctionWithDataSource:dataSource];
    
    

}

- (void)baseRightBtnAction:(UIButton *)btn{

//    [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout{
    // - 2 * 10 - 2 * 5
    CGFloat width = (DEF_SCREEN_WIDTH - 2 * 10 - 2 * 5)/4;
    CGFloat height = width + 0;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 40.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    void (^normalHandle)() = ^(){
        
        Item * item = [self.manager itemObjectAtIndexPath:indexPath];
        NSString * viewControllerName = item.item[@"controller"];
        if ([viewControllerName isEqualToString:@"TCMCheckViewController"])
        {
            // 接口
            [UserServices getPhysiquePerResultWithUserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
                
                if (result == 0)
                {
                    id data = responseObject[@"data"];
                    if ([data isKindOfClass:[NSDictionary class]])
                    {
                        TCMResultViewController * result = [[TCMResultViewController alloc] init];
                        result.pageStr=@"allf";
                        [self.navigationController pushViewController:result animated:YES];
                    }
                    else{
                        
                        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                        [actionSheet showInView:self.view  withCompletionHandler:^(NSInteger buttonIndex)
                         {
                             switch (buttonIndex) {
                                 case 0:
                                 {
                                     
                                     TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                     nextTCM.sexStr=@"boy";
                                      nextTCM.stypeStr=@"allf";
                                     [self.navigationController pushViewController:nextTCM animated:YES];
                                    // [self removeSelfFromNavigationStack];
                                     
                                     
                                     
                                 }
                                     break;
                                 case 1:
                                 {
                                     
                                     TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                          nextTCM.sexStr=@"girl";
                                          nextTCM.stypeStr=@"allf";
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
                    
                }else{
                    
                    [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                    
                }
            }];
        }
        else
        {
            
            UIViewController * viewController = [UIViewController controllerWithString:viewControllerName];
            if (viewController && [viewController isKindOfClass:[BaseViewController class]])
            {
                
                viewController.title = item.item[@"title"];
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
        }
    };
    
    

    
    

    if (indexPath.section==1)
   {
        if (!(indexPath.row == 1) )
        {
            if ([KeychainManager islogin])
            {
                    NSString *type=nil;
                    if (indexPath.row==4) {
                        //健身计划
                        type=@"01";
                    }
                    
                    [UserServices
                     getUserAuthorityByUserId:[KeychainManager readUserId]
                     flag:@"01"
                     type:type
                     completionBlock:^(int result, id responseObject)
                     {
                         if (result==0)
                         {
                             normalHandle();
                             
                         }
                         else
                         {
                             [UnityLHClass showAlertView:responseObject[@"msg"]];
                         }
                     }];
            }
            else
            {
                [KeychainManager gotoLogin];
            }
            
        }
        else
        {
            normalHandle();
        }

 }else{
        
       if (indexPath.section == 3 ||indexPath.section == 4)
        {
            [UnityLHClass showHUDWithStringAndTime:@"功能正在开发中，敬请期待"];
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];

       }
        else
        {
            normalHandle();
        }

 };

}

@end

