//
//  MallClassificationSectionView.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallClassificationSectionView : UICollectionReusableView

@property(nonatomic,strong)UILabel *title;

+(NSString*)cellIdentifier;

@end
