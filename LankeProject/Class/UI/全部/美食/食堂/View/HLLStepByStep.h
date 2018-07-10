//
//  HLLStepByStep.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StepByStepHandle)(NSInteger currentCount ,BOOL add);

@interface HLLStepByStep : UIView

// 可以为空，默认为0
@property (nonatomic ,assign ,readonly) NSInteger minCount;
// 可以为空，默认为0
@property (nonatomic ,assign ,readonly) NSInteger currentCount;
// 可以为空，默认为NSNotFound
@property (nonatomic ,assign ,readonly) NSInteger maxCount;

@property (nonatomic ,copy) StepByStepHandle handle;

// 有两种用途
// * 1. 用于设置某一个数值的时候，可以不设置最大值，但最好还是设置一个最大值(库存有限),current值从0开始，minButton不能用 --- 值为NO
// * 2. 用于挑选某些商品的时候，商品有一个库存以及购买限制，--- 值为YES
// 默认值 --- YES
@property (nonatomic ,assign ,getter=isLimitStep) BOOL limitStep;

- (void) configureMinCount:(NSInteger)minCount
              currentCount:(NSInteger)currentCount
                  maxCount:(NSInteger)maxCount;
@end
