//
//  HealthHomeViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthHomeViewController.h"
#import "HealthInquiryViewController.h"
#import "AllFunctionConfig.h"
#import "LKBannerView.h"
#import "HealthDetailViewController.h"
#import "HRDivisionViewController.h"
#import "FitnessConsultViewController.h"
#import "AdvDetailViewController.h"
#import "TCMCheckViewController.h"
#import "TCMResultViewController.h"
@interface HealthHomeViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSArray * bannerData;

@property (nonatomic ,strong) AllFunctionConfig * manager;
@property (nonatomic ,strong) UICollectionView * allFunctionCollectionView;
@property (nonatomic ,strong) LKBannerView * bannerView;
@end

@implementation HealthHomeViewController

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
    
    self.title = @"健身运动";
    if ([KeychainManager isHR])
    {
        [self showRightBarButtonItemHUDByName:@"HR专区"];

    }
    [self creatUI];
    [self requestBannerInfo];
    
}

- (void) creatUI{
    
    LKWeakSelf
    self.bannerView = [[LKBannerView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/2.0)];
    self.bannerView.myPageView.duration = 3.0f;
    self.bannerView.myPageView.didSelectPageViewAtIndex = ^(NSInteger index){
       // source 	string 	01：外部URL， 02：富文本
        LKStrongSelf
        NSDictionary *data=_self.bannerData[index];
        AdvDetailViewController *adv=[[AdvDetailViewController alloc]init];
        adv.title=data[@"advertName"];
        if ([data[@"source"] intValue]==1)
        {
            adv.externalUrl=data[@"externalUrl"];
            adv.advType=3;
        }
        else if ([data[@"source"] intValue]==2)
        {
            adv.data=data[@"advertContent"];
            adv.advType=4;
        }
        [_self.navigationController pushViewController:adv animated:YES];
    };

    [self addSubview:self.bannerView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.allFunctionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.allFunctionCollectionView.alwaysBounceVertical = YES;
    self.allFunctionCollectionView.dataSource = self.manager;
    self.allFunctionCollectionView.delegate = self;
    self.allFunctionCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.allFunctionCollectionView];
    
    self.manager.collectionView = self.allFunctionCollectionView;

    DataSource * dataSource = [DataSource dataSourceWithName:@"healthHome"];
    [self.manager configAllFunctionWithDataSource:dataSource];

}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(DEF_SCREEN_WIDTH/2.0);
    }];
    
    [self.allFunctionCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.mas_equalTo(self.bannerView.mas_left);
        make.right.mas_equalTo(self.bannerView.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
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
                         result.pageStr=@"health";
                        [self.navigationController pushViewController:result animated:YES];
                    }
                    else{
                        
                          UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"检测前请先选择性别" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                        [actionSheet showInView:self.view  withCompletionHandler:^(NSInteger buttonIndex)
                         {
                             switch (buttonIndex) {
                                 case 0:
                                 {
                                    
                                  TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                   nextTCM.sexStr=@"boy";
                                     nextTCM.stypeStr=@"health";
                                  [self.navigationController pushViewController:nextTCM animated:YES];
                                  //[self removeSelfFromNavigationStack];
                                     
                                     
                                     
                                 }
                                     break;
                                 case 1:
                                 {
                                    
                                    TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:@"01"];
                                     nextTCM.sexStr=@"girl";
                                     nextTCM.stypeStr=@"health";
                                    [self.navigationController pushViewController:nextTCM animated:YES];
                                    //[self removeSelfFromNavigationStack];
                                     
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
    

    
    if (!(indexPath.section == 0&&
        indexPath.row == 0) )
    {
        if ([KeychainManager islogin])
        {
          
                NSString *type=nil;
                if (indexPath.row==1&&indexPath.section==1) {
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
}


#pragma mark -
#pragma mark Navigation M

- (void) baseRightBtnAction:(UIButton *)btn{
    
    // 跳转至HR专区
    HRDivisionViewController * hr = [[HRDivisionViewController alloc] init];
    [self.navigationController pushViewController:hr animated:YES];
}

- (void) navigationToDetailWithId:(NSString *)adviceId{
    
    // 跳转至资讯详情
    HealthDetailViewController * detail = [[HealthDetailViewController alloc] init];
    detail.adviceId = adviceId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark Network M

- (void) requestBannerInfo{
    
    [UserServices getHealthNoticeListCompletionBlock:^(int result, id responseObject) {
       
        if (result == 0) {

            self.bannerData = responseObject[@"data"];
            
            if (self.bannerData.count) {
                
                NSMutableArray * imageArray = [NSMutableArray array];
                for (id data in self.bannerData)
                {
                    [imageArray addObject:data[@"advertImage"]];
                    
                    
                }
                [self.bannerView configureBannerViewWithBannerList:imageArray];
            }

        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
