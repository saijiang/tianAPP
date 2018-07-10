//
//  JDServiceRecordCell.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceRecordCell.h"

@implementation JDServiceRecordCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    JDServiceRecordCell*cell = [tableView dequeueReusableCellWithIdentifier:@"JDServiceRecordCell"];
    if (!cell)
    {
        cell = [[JDServiceRecordCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JDServiceRecordCell"];
    }
    return cell;
}

-(void)createCell
{
    self.backgroundColor = BM_WHITE;
    self.serviceNumberLabel = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.serviceNumberLabel];
    [self.serviceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    self.serviceTypeLabel = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    [self.contentView addSubview:self.serviceTypeLabel];
    [self.serviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.serviceNumberLabel.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(self.serviceNumberLabel.mas_height);
    }];

    
    UIView * bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = BM_Color_LineColor;
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_serviceNumberLabel.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    self.serviceImageView = [[NetworkImageView alloc]initWithImage:[UIImage imageNamed:@"default_dishes"]];
    [self.contentView addSubview:self.serviceImageView];
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLineView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.height.and.width.mas_equalTo(60);
    }];
    
    self.nameLabel = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.serviceImageView.mas_top);
        make.left.mas_equalTo(self.serviceImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
//    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
//    [self.contentView addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(80);
//        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
//        make.top.mas_equalTo(self.serviceImageView.mas_bottom).offset(20);
//    }];
    
//    self.serviceStatusBtn = [[LeftImageBtn alloc]init];
//    [self.serviceStatusBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateNormal];
//    [self.serviceStatusBtn setTitle:@"待您反馈" forState:UIControlStateNormal];
//    [self.serviceStatusBtn setTitleColor:BM_BLACK forState:UIControlStateNormal];
//    self.serviceStatusBtn.titleLabel.font = BM_FONTSIZE14;
//    [bgView addSubview:self.serviceStatusBtn];
//    [self.serviceStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(5);
//        make.centerY.mas_equalTo(bgView.mas_centerY);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(bgView.mas_height);
//    }];
    
//    self.arrowImgView = [[UIImageView alloc]init];
//    _arrowImgView.image = [UIImage imageNamed:@"UserCenter-RightArrow"];
//    [bgView addSubview:self.arrowImgView];
//    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(bgView.mas_right).offset(-15);
//        make.centerY.mas_equalTo(bgView.mas_centerY);
//        make.width.offset(7);
//        make.height.offset(15);
//    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = BM_Color_LineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.serviceImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(bottomLineView.mas_left);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
//    self.serviceProgressLabel = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
//    self.serviceProgressLabel.numberOfLines = 0;
//    [bgView addSubview:self.serviceProgressLabel];
//    [self.serviceProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.left.mas_equalTo(line.mas_right).offset(10);
//        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-5);
//        make.height.mas_equalTo(bgView.mas_height).multipliedBy(0.5).offset(-5);
//    }];
    
//    self.serviceNextLabel = [UnityLHClass masonryLabel:@"下一阶段：" font:14.0 color:BM_GRAY];
//    [bgView addSubview:self.serviceNextLabel];
//    [self.serviceNextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.serviceProgressLabel.mas_bottom);
//        make.height.mas_equalTo(self.serviceProgressLabel.mas_height);
//        make.left.mas_equalTo(self.serviceProgressLabel.mas_left);
//        make.right.mas_equalTo(self.serviceProgressLabel.mas_right);
//    }];
    
    
}

-(void)configCellWithData:(id)dataSource
{
    self.serviceNumberLabel.text = [NSString stringWithFormat:@"服务单号：%@",dataSource[@"afsServiceId"]];
    //    customerExpect:退货(10)、换货(20)、维修(30)
    switch ([dataSource[@"customerExpect"] integerValue])
    {
        case 10:
        {
            self.serviceTypeLabel.text = @"退货";
        }
            break;
        case 20:
        {
            self.serviceTypeLabel.text = @"换货";
        }
            break;
        case 30:
        {
            self.serviceTypeLabel.text = @"维修";
        }
            break;
            
        default:
            break;
    }
    
    [self.serviceImageView sd_setImageWithURL:[NSURL URLWithString:dataSource[@"skuImagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.nameLabel.text = dataSource[@"skuName"];
    


    
   
    
//    self.serviceProgressLabel.text = @"您的服务单已申请成功，待售后审核中";
    //    afsServiceStep: 申请阶段(10),审核不通过(20),客服审核(21),商家审核(22),京东收货(31),商家收货(32), 京东处理(33),商家处理(34), 用户确认(40),完成(50), 取消 (60);
//    switch ([dataSource[@"afsServiceStep"] integerValue])
//    {
//        case 10:
//            {
//                self.serviceNextLabel.text = @"下一阶段：申请阶段";
//            }
//            break;
//        case 20:
//        {
//            self.serviceNextLabel.text = @"下一阶段：审核不通过";
//        }
//            break;
//        case 21:
//        {
//            self.serviceNextLabel.text = @"下一阶段：申请阶段";
//        }
//            break;
//        case 22:
//        {
//            self.serviceNextLabel.text = @"下一阶段：申请阶段";
//        }
//            break;
//        case 31:
//        {
//            self.serviceNextLabel.text = @"下一阶段：申请阶段";
//        }
//            break;
//        case 32:
//        {
//            self.serviceNextLabel.text = @"下一阶段：申请阶段";
//        }
//            break;
//
//        default:
//            break;
//    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation JDServiceRecordFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        self.cancelBtn = [UnityLHClass masonryButton:@"取消申请" font:15.0 color:BM_BLACK];
        self.cancelBtn.layer.cornerRadius = 5.0;
        self.cancelBtn.layer.borderColor = BM_GRAY.CGColor;
        self.cancelBtn.layer.borderWidth = 1.0;
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(80);
            make.right.mas_equalTo(self.mas_right).offset(-15);
        }];
        
        
        self.statusLabel = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        [self addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.cancelBtn.mas_centerY);
            make.right.mas_equalTo(self.cancelBtn.mas_left).offset(-10);
        }];
    }
    return self;
}

-(void)loadViewWithData:(id)dataSource
{
    /*
     approvedResult 直赔积分 (11),直赔余额 (12),直赔优惠卷 (13),直赔京豆 (14),直赔商品 (21),上门换新 (22),自营取件 (31),客户送货(32),客户发货 (33),闪电退款 (34),虚拟退款 (35),大家电检测 (80),大家电安装 (81),大家电移机 (82),大家电维修(83),大家电其它 (84);
     */
    if ([dataSource[@"approvedResult"] integerValue] == 33)
    {
        self.cancelBtn.hidden = NO;
        self.cancelBtn.layer.borderColor = BM_CLEAR.CGColor;
        self.cancelBtn.backgroundColor = BM_Color_Blue;
        [self.cancelBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
        self.cancelBtn.enabled = YES;
        [self.cancelBtn setTitle:@"填写快递" forState:UIControlStateNormal];
    }
    else
    {
        //       canCancel  是否可以取消 0否 1是
        if ([dataSource[@"canCancel"] integerValue] == 0)
        {
            //        self.cancelBtn.layer.borderColor = BM_Color_LineColor.CGColor;
            //        [self.cancelBtn setTitleColor:BM_GRAY forState:UIControlStateNormal];
            //        self.cancelBtn.backgroundColor = BM_CLEAR;
            //        self.cancelBtn.enabled = NO;
            
            self.cancelBtn.hidden = YES;
        }
        else
        {
            self.cancelBtn.hidden = NO;
            self.cancelBtn.layer.borderColor = BM_CLEAR.CGColor;
            self.cancelBtn.backgroundColor = BM_Color_Blue;
            [self.cancelBtn setTitleColor:BM_WHITE forState:UIControlStateNormal];
            self.cancelBtn.enabled = YES;
            //        [self.cancelBtn setTitle:@"填写快递" forState:UIControlStateNormal];
        }
    }
    
    
    
    //   state 状态 01未完成 02已完成 03已取消 04审核不通过
    switch ([dataSource[@"state"] integerValue])
    {
        case 1:
        {
            self.statusLabel.text = @"售后状态：售后中";
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"售后状态：已完成";
        }
            break;
        case 3:
        {
            self.statusLabel.text = @"售后状态：已取消";
        }
            break;
        case 4:
        {
            self.statusLabel.text = @"售后状态：审核不通过";
        }
            break;
            
        default:
            break;
    }
}

@end
