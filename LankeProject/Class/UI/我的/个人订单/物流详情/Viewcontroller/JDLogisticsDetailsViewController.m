//
//  JDLogisticsDetailsViewController.m
//  LankeProject
//
//  Created by zhounan on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDLogisticsDetailsViewController.h"
#import "JDShopLogisticsDetailsView.h"
@interface JDLogisticsDetailsViewController ()

@end

@implementation JDLogisticsDetailsViewController

-(void)getJDhopLogisticsInfo
{
    [UserServices getJDOrderTrackWithJdOrderId:self.orderCode
                               completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]])
            {
                NSArray *array = responseObject[@"data"];
                NSArray *temp = [[array reverseObjectEnumerator] allObjects];
                [self createViewWithDataSource:temp];
            }
           
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
    
//    [UserServices
//     getYhdLogisticsInfoWithOrderCode:self.orderCode
//     completionBlock:^(int result, id responseObject)
//     {
//         if (result==0)
//         {
//             [self createViewWithDataSource:responseObject[@"data"]];
//         }
//         else
//         {
//             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//         }
//     }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"物流详情"];
    [self getJDhopLogisticsInfo];
    
}
-(void)createViewWithDataSource:(NSArray *)dataSource
{
    self.contentView.pagingEnabled=YES;
    [self.contentView setContentSize:CGSizeMake(DEF_SCREEN_WIDTH*dataSource.count, 0)];
    
//    for (int i=0; i<dataSource.count; i++)
//    {
        JDShopLogisticsDetailsView *view=[[JDShopLogisticsDetailsView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT)];
        [view loadViewWithDataSource:dataSource];
        [self addSubview:view];
//    }
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

