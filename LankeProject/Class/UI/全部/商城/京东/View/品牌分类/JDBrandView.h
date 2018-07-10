//
//  JDBrandView.h
//  LankeProject
//
//  Created by fud on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SideChooseBlock)(id);

@interface JDBrandView : UIView
@property (nonatomic,strong)NSArray *dataArray;//数据源

-(void)showViewWithChooseBlock:(SideChooseBlock)sideChoose;
- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSArray*)dataSource;

@end
