//
//  CommunityTermsViewController.h
//  LankeProject
//
//  Created by itman on 17/4/24.
//  Copyright © 2017年 张涛. All rights reserved.
//

typedef NS_ENUM(NSInteger, TermsStyle)
{
    TermsStyleAdd       = 0,//添加
    TermsStyleEditor    = 1,//编辑
    TermsStyleReading   = 2,//阅读
};

#import "BaseViewController.h"


@interface CommunityTermsViewController : BaseViewController

@property(nonatomic,assign)TermsStyle style;
@property(nonatomic,strong)id data;

@end
