//
//  AddressCell.h
//  LankeProject
//
//  Created by Justin on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LKCellProtocol.h"
@interface AddressCell : BaseTableViewCell<LKCellProtocol>

@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UILabel *phoneLB;

@property (nonatomic, strong) UILabel *addressLB;

@property (nonatomic, strong) UIImageView *lineImage;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) UIButton *modBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) BOOL type;

@end
