//
//  StarView.h
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

typedef void(^starNumber)(int starValue);

#import <UIKit/UIKit.h>
//typedef void (^starValue)(int starValue);


@interface StarView : UIView
@property (nonatomic, copy)starNumber starBlock;


- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star withStarNumber:(int)starNum;

- (void)showStarNumber:(starNumber)starValue;

- (void )buildStarViewWithImageNum:(float)starNum;

@end
