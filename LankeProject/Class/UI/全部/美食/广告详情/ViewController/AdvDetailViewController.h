//
//  AdvDetailViewController.h
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvDetailViewController : BaseViewController

// 1 : 首页
// 2 : 美食
// 3 : 外部链接
// 4 : 富文本
@property (nonatomic ,assign) NSInteger advType;

@property (nonatomic ,strong) NSString * externalUrl;
@property (nonatomic ,strong) id data;
@end
