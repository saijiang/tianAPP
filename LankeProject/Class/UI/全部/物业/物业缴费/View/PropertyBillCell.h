//
//  PropertyBillCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"

@interface PropertyBillCell : UITableViewCell<LKCellProtocol>

-(void)loadCellWithDataSource:(id)dataSource;

@end

@interface PropertyBillSingelCell : UITableViewCell<LKCellProtocol>
@property (nonatomic ,strong) UILabel * billTitleLabel;
@property (nonatomic ,strong) UILabel * billDetailLabel;

@end
