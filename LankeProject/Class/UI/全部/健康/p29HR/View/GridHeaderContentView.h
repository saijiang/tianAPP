//
//  GridHeaderContentView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCustomViewProtocol.h"
#import "GridConfigProtocol.h"

@interface GridHeaderContentView : UIView<LKCustomViewProtocol,GridConfigProtocol>

@property (weak, nonatomic) IBOutlet UILabel * grid1Label;
@property (weak, nonatomic) IBOutlet UILabel * grid2Label;
@property (nonatomic ,weak) IBOutlet UILabel * grid3Label;
@property (nonatomic ,weak) IBOutlet UILabel * grid4Label;
@property (nonatomic ,weak) IBOutlet UILabel * grid5Label;

@property (nonatomic ,strong) UIView * contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gridLabelWidthConstraint;

@property (nonatomic ,assign) NSInteger gridNumber;

- (void) setupContentView:(UIView *(^)())contentView;

@end
