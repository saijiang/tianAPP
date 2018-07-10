//
//  ReservationGenderView.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationGenderView : UIView

@property(nonatomic,strong)UILabel *leftTitle;

@property (nonatomic ,copy) void (^bChooseGenderHandle)(NSString *gender);

@end
