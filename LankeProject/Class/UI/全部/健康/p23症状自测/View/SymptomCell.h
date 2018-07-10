//
//  SymptomCell.h
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface SymptomCell : BaseCollectionCell

@property(nonatomic,strong)UILabel *name;

+(NSString*)cellIdentifier;
@end
