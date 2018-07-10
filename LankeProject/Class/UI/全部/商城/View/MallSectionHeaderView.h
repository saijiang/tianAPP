//
//  MallSectionHeaderView.h
//  LankeProject
//
//  Created by itman on 17/2/10.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallSectionHeaderView : UICollectionReusableView

@property(nonatomic,strong)UIButton *scanAll;

-(void)loadMallforIndexPath:(NSIndexPath *)indexPath;

-(void)loadSectionWithTitle:(NSString *)title;

@end
