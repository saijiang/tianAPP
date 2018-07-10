//
//  OneShopLogisticsDetailsViewController.m
//  LankeProject
//
//  Created by itman on 17/2/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "OneShopLogisticsDetailsViewController.h"
#import "OneShopLogisticsDetailsView.h"

@interface OneShopLogisticsDetailsViewController ()

@end

@implementation OneShopLogisticsDetailsViewController

-(void)getOneshopLogisticsInfo
{
    [UserServices
     getYhdLogisticsInfoWithOrderCode:self.orderCode
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self createViewWithDataSource:responseObject[@"data"]];
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"物流详情"];
    [self getOneshopLogisticsInfo];
    
}
-(void)createViewWithDataSource:(NSArray *)dataSource
{
    self.contentView.pagingEnabled=YES;
    [self.contentView setContentSize:CGSizeMake(DEF_SCREEN_WIDTH*dataSource.count, 0)];

    for (int i=0; i<dataSource.count; i++)
    {
        OneShopLogisticsDetailsView *view=[[OneShopLogisticsDetailsView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH*i, 0, DEF_SCREEN_WIDTH, DEF_CONTENT)];
        [view loadViewWithDataSource:dataSource[i]];
        [self addSubview:view];
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
