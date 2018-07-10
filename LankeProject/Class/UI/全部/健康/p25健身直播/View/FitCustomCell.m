//
//  FitCustomCell.m
//  LankeProject
//
//  Created by 符丹 on 17/7/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitCustomCell.h"

@implementation FitCustomCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FitCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FitCustomCell"];
    if (!cell)
    {
        cell=[[FitCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FitCustomCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    self.monthLab = [UnityLHClass masonryLabel:@"" font:16.0 color:BM_Color_Blue];
    self.monthLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.monthLab];
    [self.monthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(15);
    }];

    self.dateLab = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
    self.dateLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthLab.mas_bottom).offset(3);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.monthLab.mas_width);
        make.height.mas_equalTo(15);
        
    }];
   
    self.lineView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#CCCCCC"]]];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.monthLab.mas_centerX);
        make.top.mas_equalTo(self.dateLab.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).offset(10);
        make.width.mas_equalTo(1);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = BM_WHITE;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthLab.mas_right);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-36);
    }];
    bgView.layer.cornerRadius=4.0;
    bgView.layer.masksToBounds = YES;
    float height = DEF_SCREEN_WIDTH/2.0;
    self.imgView = [[NetworkImageView alloc]initWithImage:[UIImage imageNamed:@"category_background_food"]];
    self.imgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(height);
    }];
    
    self.stateBtn = [UnityLHClass masonryButton:@"" font:14.0 color:BM_WHITE];
    self.stateBtn.layer.cornerRadius = 3.0;
   
//   self.stateBtn.layer.borderColor = BM_Color_huiColor.CGColor;
//    self.stateBtn.layer.borderWidth = 1.0;
    [self.imgView addSubview:self.stateBtn];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imgView.mas_right).offset(-15);
        make.top.mas_equalTo(self.imgView.mas_top).offset(15);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(50);
    }];
    
    
    self.titleLab = [UnityLHClass masonryLabel:@"" font:16.0 color:BM_BLACK];
    [bgView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(5);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(5);
    }];
    
    self.timeLab = [UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-5);
        make.bottom.mas_equalTo(self.titleLab.mas_bottom);
    }];
    
    self.contentLab = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_GRAY];
    self.contentLab.numberOfLines = 0;
    [bgView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.timeLab.mas_right);
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    //	是否预约（01未预约，02已预约）
    NSString *isAppoint = dataSource[@"isAppoint"];
    //    	01：直播未开始,02：直播中,03：直播结束
    NSString *isStart = dataSource[@"isStart"];

    switch ([isStart integerValue])
    {
        case 1:
        {
            if ([isAppoint integerValue] == 2)
            {
                [self.stateBtn setTitle:@"已预约" forState:UIControlStateNormal];
                self.stateBtn.enabled=NO;
            
            }
            else
            {
                [self.stateBtn setTitle:@"预约" forState:UIControlStateNormal];

                
            }
             self.stateBtn.backgroundColor=[UIColor colorWithCGColor:BM_Color_Blue.CGColor];
             break;
        }
       
        case 2:
        {
            [self.stateBtn setTitle:@"直播中" forState:UIControlStateNormal];
             self.stateBtn.backgroundColor=[UIColor colorWithCGColor:BM_RED.CGColor];
             break;
        }
       
        case 3:
        {
            [self.stateBtn setTitle:@"已结束" forState:UIControlStateNormal];
                self.stateBtn.backgroundColor=[UIColor colorWithHexString:@"#D0D0D0"];
             break;
        }
     
        
        default:
        break;
    }
    self.contentLab.text = dataSource[@"introduction"];
    self.titleLab.text = dataSource[@"title"];
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",dataSource[@"startTime"],dataSource[@"endTime"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:dataSource[@"liveImage"]] placeholderImage:[UIImage imageNamed:@"category_background_food"]];
    NSArray *stringArr = [dataSource[@"liveDate"] componentsSeparatedByString:@"-"];
    NSString *dateString = [NSString stringWithFormat:@"%@.%@",stringArr[0],stringArr[1]];
    self.dateLab.text = dateString;
    self.monthLab.text=stringArr.lastObject;
}

+(CGFloat)getCellHeightWithDataSource:(id)dataSource
{
    float height = [UnityLHClass getHeight:dataSource[@"introduction"] wid:DEF_SCREEN_WIDTH-70-25 font:14.0];
    return DEF_SCREEN_WIDTH/2.0+height+80;
}

@end
