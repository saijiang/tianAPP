//
//  FitnessMessageCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"

@interface FitnessMessageCell : UITableViewCell<LKCellProtocol>

@property (nonatomic ,strong) LKNetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UIImageView * messageContentView;
@property (nonatomic ,strong) UILabel * messageLabel;

@end
