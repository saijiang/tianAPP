//
//  PopUpSeletedView.h
//  LankeProject
//
//  Created by itman on 17/2/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^endChooseData)(id data,NSInteger row);
typedef void (^endChooseDictData)(NSDictionary *dict);
typedef void (^CancelBlock)();
/**
 *  显示下拉菜单
 */
@interface PopUpSeletedView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,assign) CGFloat rowHeight;
@property (nonatomic ,assign) NSInteger maxExhibitRow;
@property (nonatomic,copy) CancelBlock cBlock;
@property (nonatomic, copy) endChooseData endChooseBlock;
@property (nonatomic, copy) endChooseDictData endChooseDictData;
@property (nonatomic, strong) UITableView *showTabelView;

//初始化下拉菜单的数据
- (void)resetWithSourceArray:(NSArray *)sourceArray;

/**
 * 初始化Dict数据
 */
- (void)resetWithDictSourceArray:(NSArray *)dictSourceArray withTitleKey:(NSString *)titleKey;

//退出下拉菜单
- (void)cancelBlock:(CancelBlock)canBlock;

- (void)cancel;

- (void)showWithRect:(CGRect)rect suitableandExhibit:(BOOL)suitableand andEndChooseBlock:(endChooseData)endChooseBlock;

- (void)showWithRect:(CGRect)rect andEndChooseBlock:(endChooseData)endChooseBlock;

- (void)showWithRect:(CGRect)rect andEndChooseDictBlock:(endChooseDictData)endChooseDictBlock;

- (void) defaultSelectedAtIndex:(NSInteger)index;

- (void) setSelectedAtIndex:(NSInteger)index;


@end

