//
//  JDFilterView.h
//  LankeProject
//
//  Created by fud on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "GoodSearchItem.h"
#import "JDBrandView.h"
@interface JDFilterView : UIView

@property (nonatomic ,strong) NSArray * priceFilter;

@property (nonatomic ,copy) void (^bCancelHandle)(JDFilterView * filter);
@property (nonatomic ,copy) void (^bConfirmHandle)(JDFilterView * filterView ,id data);
@property(nonatomic,strong)GoodSearchItem* searchItem;
@property(nonatomic,strong)NSString* typeStr;
@property (nonatomic ,strong) NSMutableArray * dataArray;

@property (nonatomic,assign)BOOL isRight;//默认从上方弹出，YES从右侧弹出 (京东模块从右侧弹出)

#pragma mark -
#pragma mark Animaiton

- (void) showWithView:(UIView *)view onViewController:(UIViewController *)vc;
- (void) hide:(BOOL)animated;
//-(void)getBrandList:(NSString*)categoryId;
- (instancetype)initWithFrame:(CGRect)frame withBrandArray:(NSMutableArray*)brandArray;


@end
