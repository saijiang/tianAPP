//
//  JDServiceRecordCell.h
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDServiceRecordCell : BaseTableViewCell

@property (nonatomic ,strong) UILabel * serviceNumberLabel;//服务单号
@property (nonatomic ,strong) UILabel * serviceTypeLabel;//售后类型
@property (nonatomic ,strong) NetworkImageView * serviceImageView; //图片
@property (nonatomic ,strong) UILabel * nameLabel;//商品名称
//@property (nonatomic ,strong) LeftImageBtn * serviceStatusBtn;//售后状态
//@property (nonatomic ,strong) UILabel * serviceProgressLabel;//服务进度
//@property (nonatomic ,strong) UILabel * serviceNextLabel;//服务下一步操作
//@property (nonatomic ,strong) UIImageView * arrowImgView; //箭头


-(void)configCellWithData:(id)dataSource;

@end

@interface JDServiceRecordFooterView : UIView

@property (nonatomic ,strong) UIButton *cancelBtn;//取消申请
@property (nonatomic ,strong) UILabel * statusLabel;//审核状态

-(void)loadViewWithData:(id)dataSource;

@end
