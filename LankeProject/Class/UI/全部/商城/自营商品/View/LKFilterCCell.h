//
//  LKFilterCCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface LKFilterCCell : BaseCollectionCell<LKCellProtocol>

@end

@interface LKFilterHeaderView : UICollectionReusableView

- (void) configureHeaderViewWithData:(id)data;
- (void)hideRightImageView;
- (void)showRightImageView;
- (void)setRightImageViweSeleted:(BOOL)seleted;

+ (NSString *) reuseIdentifier;

@end

@interface LKFilterFooterView : UICollectionReusableView

@property (nonatomic,strong)UIButton *allBtn;

+ (NSString *) reuseIdentifier;

- (void) configureFooterViewWithData:(id)data;

@end
