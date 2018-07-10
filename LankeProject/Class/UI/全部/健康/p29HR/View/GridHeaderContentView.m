//
//  GridHeaderContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GridHeaderContentView.h"
#import "UIView+AutoLayoutSupport.h"

@interface GridHeaderContentView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroungImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *displayContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightConstraint;

@end

@implementation GridHeaderContentView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.gridNumber = 5;
    }
    return self;
}
- (void)awakeFromNib{

    [super awakeFromNib];
    self.lineViewHeightConstraint.constant = 1/[UIScreen mainScreen].scale;
    self.backgroungImageView.image = [UIImage imageWithColorHexString:@"#67B0D9"];
}

- (void) setupContentView:(UIView *(^)())contentView{
    
    if (contentView) {
        self.contentView = contentView();
    }
    [self.displayContentView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
//    [self setNeedsDisplay];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // bug here :不知道什么原因，会多出来在nib中设置的视图宽度。。。wtf
    // 7p手机显示两个：width=207，nib中是83，但是展示到屏幕上就是290
    // 暂时使用硬编码减去多余的吧
    CGFloat width = self.bounds.size.width/self.gridNumber;
    self.gridLabelWidthConstraint.constant = width - DEF_SCREEN_WIDTH/5;
    
}
#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype) view{

    return [[[NSBundle mainBundle] loadNibNamed:@"GridHeaderContentView" owner:nil options:nil] firstObject];
}

#pragma mark -
#pragma mark GridConfigProtocol

// 按照依左边的使用来显示右边多余的label
- (void) setupSpecialForTwoGrid{
    
    self.gridNumber = 2;
    [self.grid3Label ADKHideViewWidth];
    [self.grid4Label ADKHideViewWidth];
    [self.grid5Label ADKHideViewWidth];
}

- (void) setupSpecialForThreeGrid{
    
    self.gridNumber = 3;
    [self.grid4Label ADKHideViewWidth];
    [self.grid5Label ADKHideViewWidth];
}

// 历史健身数据
- (void) configFitnessHistory:(id)data{
    
    [self setupSpecialForTwoGrid];
    
    self.grid1Label.text = @"时间";
    self.grid2Label.text = @"消耗量";
}

// 单位人员患病情况
- (void) configEmployeeIllInfo:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = @"疾病";
    self.grid2Label.text = @"患病人数";
    self.grid3Label.text = @"患病比例";
}

// 查看当前健身计划明细
- (void) configFitnessPlanDetail:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = @"时间";
    self.grid2Label.text = @"消耗量";
    self.grid3Label.text = @"完成情况";
}
// 查看手动添加健身数据
- (void) configAddSportFitnessPlanDetail:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = @"运动";
    self.grid2Label.text = @"时长";
    self.grid3Label.text = @"已消耗卡路里";
}

// 每日健身情况
- (void) configDailyFitness:(id)data{
    
    self.gridNumber = 5;
    
    self.grid1Label.text = @"姓名";
    self.grid2Label.text = @"工号";
    self.grid3Label.text = @"实际\n消耗量";
    self.grid4Label.text = @"目标\n消耗量";
    self.grid5Label.text = @"完成情况";
}

// 患病明细
- (void) configIllDetail:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = @"姓名";
    self.grid2Label.text = @"工号";
    self.grid3Label.text = @"电话";
}

- (void)configTCM:(id)data{
    
    [self setupSpecialForThreeGrid];
    
    self.grid1Label.text = @"体质类型";
    self.grid2Label.text = @"人数";
    self.grid3Label.text = @"占参与人数比例";
}
@end
