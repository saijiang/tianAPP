//
//  FitnessRankingCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@class FitnessRankingItem;

@interface FitnessRankingCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic ,copy) void (^bZanHandle)(FitnessRankingItem *,BOOL cancelZan);
@property (nonatomic ,copy) void (^bAttendHandle)(FitnessRankingItem *,BOOL cancelAttend);

- (void) configCellWithData:(FitnessRankingItem *)data atIndexPath:(NSIndexPath *)indexPath;

@end

@interface FitnessRankingItem : NSObject

@property (nonatomic ,weak) NSIndexPath * indexPath;

@property (nonatomic ,strong) NSString * userId;

@property (nonatomic ,assign) NSInteger rang;

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * icon;
@property (nonatomic ,strong) NSString * calorie;

@property (nonatomic ,strong) NSString * zanCount;
@property (nonatomic ,assign) BOOL didZan;

@property (nonatomic ,assign) BOOL hasAttention;

- (instancetype) initItemWith:(id)data;

@end
