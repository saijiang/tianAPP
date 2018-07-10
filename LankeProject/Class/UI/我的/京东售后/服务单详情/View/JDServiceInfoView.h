//
//  JDServiceInfoView.h
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDServiceInfoView : UIView

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *typeLab;//服务类型
@property (nonatomic,strong)UILabel *contactLab;//联系人
@property (nonatomic,strong)UILabel *phoneNumberLab;//电话
@property (nonatomic,strong)UILabel *addressLab;//地址
@property (nonatomic,strong)UILabel *numberLab;//快递单号

//赋值
-(void)loadViewWithData:(id)dataSource;

@end
