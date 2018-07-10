//
//  DishesDetailContentCell.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface DishesDetailContent : NSObject

@property (nonatomic ,strong) id data;// 富文本内容
@property (nonatomic ,assign) CGFloat contentHeight;

@end

@interface DishesDetailContentCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) DishesDetailContent * content;
@property (nonatomic ,copy) void (^bCellHeightChangedBlock)();
@property (nonatomic, copy) void (^bLoadRequestBlock)(NSURLRequest *curRequest);

/** 自营商品详情 */
- (void) configCellForGoodsDetail:(id)data;
/** 团购商品详情 */
- (void) configCellForGroupDetail:(id)data;
/** 一号店商品详情 */
- (void) configCellForStoreOneDetail:(id)data;
/** 京东商品详情 */
- (void) configCellForStoreJDDetail:(id)data;
/** 查看报告 */
- (void) configCellForFitnessDetail:(id)data;


@end


