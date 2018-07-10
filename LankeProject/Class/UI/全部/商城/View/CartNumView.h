//
//  CartNumView.h
//  LankeProject
//
//  Created by itman on 17/2/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartNumView : UIView

@property(nonatomic,strong)UILabel *num;

+(CartNumView *)CartNumView;

-(void)getGoodsCartNum;


@end
