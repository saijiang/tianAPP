//
//  MallcommentCell.m
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallcommentCell.h"

@implementation MallcommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MallcommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MallcommentCell"];
    if (!cell)
    {
        cell=[[MallcommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MallcommentCell"];
    }
    return cell;
    
}
-(void)createCell
{
    self.contentView.toplineWithColor=[UIColor groupTableViewBackgroundColor];
    self.icon=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(15);
        make.width.and.height.mas_equalTo(70);
    }];
    
    self.note=[[JYZTextView alloc]init];
    self.note.delegate=self;
    self.note.font=BM_FONTSIZE(15.0);
    self.note.placeholder=@"请输入评价内容";
    [self.contentView addSubview:self.note];
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40);
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.note.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *leftlable=[UnityLHClass masonryLabel:@"评星" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:leftlable];
    [leftlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(self.icon.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    _commentGradeView = [[AXRatingView alloc] init];
    _commentGradeView.markFont = [UIFont systemFontOfSize:16];
    _commentGradeView.baseColor = [UIColor colorWithHexString:@"#CCCCCC"];
    _commentGradeView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
    [_commentGradeView setStepInterval:1];
    [self.contentView addSubview:_commentGradeView];
    
    [self.commentGradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(leftlable.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [self.commentGradeView aXRatingViewHandle:^(AXRatingView *ratingView) {
        
        self.model.evalScores = [NSString stringWithFormat:@"%d",(int)ratingView.value];
    }];
}
-(void)loadCellWithDataSource:(MallcommentModel*)dataSource
{
    self.model=dataSource;
    [_commentGradeView setValue:[self.model.evalScores integerValue]];
    self.note.text=self.model.evalContent;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.model.goodImage] placeholderImage:[UIImage imageNamed:@"default_dishes"]];


}
-(void)textViewDidChange:(UITextView *)textView
{
    self.model.evalContent=self.note.text;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.model.evalContent=self.note.text;

}
@end
