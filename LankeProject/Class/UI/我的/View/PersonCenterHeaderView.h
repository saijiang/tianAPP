//
//  PersonCenterHeaderView.h
//  LankeProject
//
//  Created by itman on 17/2/22.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterHeaderView : UIView
@property(nonatomic,strong)NSDictionary*dataDic;
-(void)getUserInfo;
-(void)getWalletBalance;
@end
