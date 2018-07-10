//
//  HealthExamSingleSelectCCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamSingleSelectCCell.h"
#import "HealthExamManager.h"
#import "TCMManager.h"

@interface HealthExamSingleSelectCCell ()

@property (readwrite) UIImageView * selectImageView;

@property (nonatomic ,strong) UILabel * displayLabel;

@end

@implementation HealthExamSingleSelectCCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _selectImageView = [UIImageView new];
        [self.contentView addSubview:_selectImageView];
        
        _displayLabel = [UnityLHClass masonryLabel:@"" font:14 color:BM_Color_BlackColor];
        [self.contentView addSubview:_displayLabel];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.selectImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-0);
        make.centerY.mas_equalTo(self.selectImageView.mas_centerY);
    }];
}
- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.selectImageView.highlighted = selected;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *) cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ExamRowItem *)data{
    
    self.displayLabel.text = [NSString stringWithFormat:@"%@",data.data[@"title"]];
    self.selectImageView.highlighted = data.isSelect;
}

- (void) configForTCM:(TCMRowItem *)data{

    self.selectImageView.image = [UIImage imageNamed:@"circle_choose_off"];
    self.selectImageView.highlightedImage = [UIImage imageNamed:@"circle_choose_on"];
    
    self.displayLabel.text = [NSString stringWithFormat:@"%@",data.display];
    self.selectImageView.highlighted = data.isSelect;
}
@end
