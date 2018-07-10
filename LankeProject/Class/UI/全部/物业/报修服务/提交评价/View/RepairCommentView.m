//
//  RepairCommentView.m
//  LankeProject
//
//  Created by itman on 17/5/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "RepairCommentView.h"

#import "LKBottomButton.h"
@interface RepairCommentView()



@end

@implementation RepairCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.layer.cornerRadius=10;
        self.clipsToBounds=YES;
        
        UILabel *headerTitle=[[UILabel alloc]init];
        headerTitle.textColor=BM_WHITE;
        headerTitle.text=@"提示 ";
        headerTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:headerTitle];
        headerTitle.backgroundColor=BM_Color_Blue;
        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        UILabel *lelfOne=[UnityLHClass masonryLabel:@"评分" font:15.0 color:BM_BLACK];
        [self addSubview:lelfOne];
        [lelfOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(headerTitle.mas_bottom).offset(20);
            
        }];
      
        _commentGradeView = [[AXRatingView alloc] init];
        _commentGradeView.numberOfStar = 5;
        _commentGradeView.value = 5;
        _commentGradeView.markFont = [UIFont systemFontOfSize:16];
        _commentGradeView.baseColor = [UIColor colorWithHexString:@"#CCCCCC"];
        _commentGradeView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
        [_commentGradeView setStepInterval:1.0];
        [self addSubview:_commentGradeView];
        
        [self.commentGradeView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.mas_equalTo(lelfOne.mas_centerY).offset(5);
            make.right.mas_equalTo(self.mas_right).mas_offset(-20);
            make.left.mas_equalTo(lelfOne.mas_right).mas_offset(10);
            make.height.mas_equalTo(30);
        }];
        
        self.contentView = [[JYZTextView alloc] init];
        self.contentView.clipsToBounds=YES;
        self.contentView.layer.cornerRadius=5;
        self.contentView.layer.borderWidth=1;
        self.contentView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
        self.contentView.placeholder = @"请输入评价内容...";
        self.contentView.font = [UIFont systemFontOfSize:13];
        self.contentView.placeholderColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lelfOne.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(self.mas_right).mas_offset(-20);
            make.height.mas_equalTo(100);
        }];
        
        LKBottomButton *handleButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        handleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [handleButton setTitle:@"提交" forState:UIControlStateNormal];
        [self addSubview:handleButton];
        [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_centerX).offset(-10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.3);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        [handleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@"提交"];
            [self hideView];
        }];
        
        LKBottomButton *cancelhandleButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        [cancelhandleButton hll_setBackgroundImageWithColor:BM_GRAY
                                     forState:UIControlStateNormal];
        cancelhandleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelhandleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:cancelhandleButton];
        [cancelhandleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.3);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        [cancelhandleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self hideView];
        }];


    }
    return self;
}


@end
