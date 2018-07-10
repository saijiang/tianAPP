//
//  HealthExamSingleSelectCCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface HealthExamSingleSelectCCell : BaseCollectionCell<LKCellProtocol>

@property (nonatomic ,strong, readonly) UIImageView * selectImageView;

- (void) configForTCM:(id)data;
@end
