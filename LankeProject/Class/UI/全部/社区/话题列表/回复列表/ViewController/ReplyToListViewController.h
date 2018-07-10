//
//  ReplyToListViewController.h
//  LankeProject
//
//  Created by itman on 17/3/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"

@interface ReplyToListViewController : BaseViewController

@property(nonatomic,copy)NSString *topicId;//话题ID
@property(nonatomic,assign)BOOL isGroup;//是否为群主身份

@end
