//
//  NearAddressView.h
//  LankeProject
//
//  Created by itman on 16/12/23.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearAddressView : UIView


-(void)loadNearAddressWithDataSource:(NSArray *)dataSource;

@end


@interface NearAddressCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *address;


@end
