//
//  LKPickSectionCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKPickSectionCell.h"

@interface LKPickSectionCell ()

@property (nonatomic ,strong) UIView * lineView;

@end

@implementation LKPickSectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        if (!_sectionNameLabel) {
            _sectionNameLabel = [UnityLHClass masonryLabel:@"菜单分类2" font:15 color:BM_Color_BlackColor];
            _sectionNameLabel.textAlignment = NSTextAlignmentCenter;
            _sectionNameLabel.highlightedTextColor = BM_Color_Blue;
            _sectionNameLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [self.contentView addSubview:_sectionNameLabel];
        }
        if (!_lineView) {
            _lineView = [[UIView alloc] init];
            _lineView.backgroundColor = [UIColor whiteColor];;
            [self.contentView addSubview:_lineView];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(2/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
    
    self.sectionNameLabel.highlighted = selected;
    if (selected) {
        self.sectionNameLabel.backgroundColor = [UIColor colorWithHexString:@"#Ffffff"];
    }else{
        self.sectionNameLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"LKPickSectionCell";
}

- (void) config:(id)data{

    self.sectionNameLabel.text = [NSString stringWithFormat:@"%@",data];
}

- (void) configCellWithData:(id)data{
    
    self.sectionNameLabel.text = [NSString stringWithFormat:@"%@",data[@"dishesName"]];
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.sectionNameLabel.text = [NSString stringWithFormat:@"%@",dataSource[@"classNameFirst"]];

}

@end
