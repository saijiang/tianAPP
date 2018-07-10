//
//  GridConfigProtocol.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GridConfigProtocol <NSObject>

// 按照依左边的使用来显示右边多余的label
- (void) setupSpecialForTwoGrid;
- (void) setupSpecialForThreeGrid;

/** 
 * 历史健身数据 
 */
- (void) configFitnessHistory:(id)data;
/** 
 单位人员患病情况 
 */
- (void) configEmployeeIllInfo:(id)data;
/** 查看当前健身计划明细 */
- (void) configFitnessPlanDetail:(id)data;
// 查看手动添加健身数据
- (void) configAddSportFitnessPlanDetail:(id)data;
/** 每日健身情况 */
- (void) configDailyFitness:(id)data;
/** 患病明细 */
- (void) configIllDetail:(id)data;
/** 中医体质检测 */
- (void) configTCM:(id)data;

@end
