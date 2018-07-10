//
//  JDFilterFooterView.h
//  LankeProject
//
//  Created by zhounan on 2017/12/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDFilterFooterView : UICollectionReusableView

@property (nonatomic,strong)UIButton *allBtn;

+ (NSString *) reuseIdentifier;

- (void) configureFooterViewWithData:(id)data;
@end
