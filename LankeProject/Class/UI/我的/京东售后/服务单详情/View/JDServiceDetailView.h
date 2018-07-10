//
//  JDServiceDetailView.h
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoView.h"

@interface JDServiceDetailView : UIView

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *rightLab;//右侧的lable
@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)SelectedPhotoView *photoView;
@property (nonatomic,strong)NSArray *imageArray;//问题图片数组

@end
