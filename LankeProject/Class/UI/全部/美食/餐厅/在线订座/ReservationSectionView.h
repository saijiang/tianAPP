//
//  ReservationSectionView.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationSectionView : UIView

@property(nonatomic,strong)UILabel *leftTitle;
@property(nonatomic,strong)UILabel *rightTitle;

@property (nonatomic ,copy) void (^bTapHandle)();
@end
