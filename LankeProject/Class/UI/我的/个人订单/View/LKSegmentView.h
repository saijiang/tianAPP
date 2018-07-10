//
//  LKSegmentView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSegmentItem : UIButton
@end

@interface LKSegmentView : UIView

@property (nonatomic ,strong) UIImage * normalImage;
@property (nonatomic ,strong) UIImage * selectImage;

@property (nonatomic ,strong) UIColor * selectColor;

@property (nonatomic ,strong ,readonly) NSMutableArray <LKSegmentItem *>* segmentItems;

@property (nonatomic ,copy) void (^bSegmentViewDidSelectedItem)(NSInteger index);

- (void) defaultSelectedFirstItem;
- (void) configSegmentViewWithItems:(NSArray <NSString *>*)items;
- (void) updateSegmentViewWithItems:(NSArray <NSString *>*)items;
@end
