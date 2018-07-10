//
//  ReservationTextView.h
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationTextView : UIView

@property(nonatomic,strong)UILabel *leftTitle;
@property(nonatomic,strong)UITextField *textField;

@property (nonatomic ,copy) void (^bTextChangeValueHandle)(NSString *content);

@end
