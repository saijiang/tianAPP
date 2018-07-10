//
//  GridTableViewCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"
#import "GridConfigProtocol.h"

@interface GridTableViewCell : BaseTableViewCell<LKCellProtocol,GridConfigProtocol>

@property (weak, nonatomic) IBOutlet UILabel *grid1Label;
@property (weak, nonatomic) IBOutlet UILabel *grid2Label;
@property (weak, nonatomic) IBOutlet UILabel *grid3Label;
@property (weak, nonatomic) IBOutlet UILabel *grid4Label;
@property (weak, nonatomic) IBOutlet UILabel *grid5Label;

@property (nonatomic ,assign) CGFloat gridNumber;

@end
