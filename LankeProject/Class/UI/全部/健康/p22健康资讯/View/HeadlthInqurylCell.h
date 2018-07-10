//
//  HeadlthInqurylCell.h
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"

@interface HeadlthInqurylCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic, strong) UILabel *BigTitle;

@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) UILabel *detailLB;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic,strong) UIImageView *imageIcon;


@end
