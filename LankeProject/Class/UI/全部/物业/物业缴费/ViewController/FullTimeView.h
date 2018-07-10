//
//  FullTimeView.h
//  ios2688webshop
//
//  Created by wangchan on 16/2/23.
//  Copyright © 2016年 zhangzl. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FinishPickView <NSObject>
-(void)didFinishPickView:(NSDate*)date;
@end
@interface FullTimeView : UIView
@property(nonatomic,strong)NSDate*curDate;
@property(nonatomic,strong)id<FinishPickView>delegate;
@end
