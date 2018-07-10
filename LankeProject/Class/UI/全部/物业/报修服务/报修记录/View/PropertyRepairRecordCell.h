//
//  PropertyRepairRecordCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCellProtocol.h"
#import "LKCustomViewProtocol.h"
#import "AXRatingView.h"
#import "LKBottomButton.h"

@class PropertyBottomNewView;

@interface PropertyTopView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) LocalhostImageView * iconImageView;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * timeLabel;
@property (nonatomic ,strong) UILabel * statusLabel;
@end

@interface PropertyBottomView : UIView<LKCustomViewProtocol>

@property (nonatomic ,strong) UIView * topLineView;

@property (nonatomic ,strong) LKNetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * phoneLabel;
@property (nonatomic ,strong) AXRatingView * gradeView;
@property (nonatomic ,strong) UILabel * scoreLabel;
@property (nonatomic ,strong) UIButton * gotoCommentButton;

@property (nonatomic ,strong) UIView * bottomLineView;
@property (nonatomic ,strong) LKBottomButton * handleButton;

@end

@interface PropertyRepairRecordCell : UITableViewCell<LKCellProtocol>

@property (nonatomic ,strong) PropertyTopView * topView;
@property (nonatomic ,strong) PropertyBottomNewView * bottomView;

@property (nonatomic ,copy) void (^bCommentHandle)();
@property (nonatomic ,copy) void (^bOtherHandle)();

@end


//2017.07.28
@interface PropertyBottomNewView : UIView<LKCustomViewProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableCtrl;
@property (nonatomic,strong)NSMutableArray *dataSource;//数据源
@property (nonatomic ,strong) NSMutableDictionary * data;//总数据源
@property (nonatomic ,strong) LKBottomButton * handleButton;
//@property (nonatomic ,copy) void (^bCommentHandle)();
//@property (nonatomic ,copy) void (^bOtherHandle)();

-(void)configFooterWithData:(id)data;

@end

@interface PropertyBottomCell : BaseTableViewCell<LKCustomViewProtocol>

@property (nonatomic ,strong) UIView * topLineView;

@property (nonatomic ,strong) LKNetworkImageView * iconImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * phoneLabel;
@property (nonatomic ,strong) AXRatingView * gradeView;
@property (nonatomic ,strong) UILabel * scoreLabel;
@property (nonatomic ,strong) UIButton * gotoCommentButton;

@property (nonatomic ,strong) UIView * bottomLineView;
- (void)loadCellWithDataSource:(id)data type:(id)type;
@end
