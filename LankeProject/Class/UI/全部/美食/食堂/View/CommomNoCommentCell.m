//
//  CommomNoCommentCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "CommomNoCommentCell.h"

@interface CommomNoCommentCell ()

@property (nonatomic ,strong) UILabel * noCommentDisplayLabel;

@end

@implementation CommomNoCommentCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CommomNoCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommomNoCommentCell"];
    if (!cell)
    {
        cell=[[CommomNoCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommomNoCommentCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_noCommentDisplayLabel) {
            _noCommentDisplayLabel = [UnityLHClass masonryLabel:@"暂时没有用户评论" font:15 color:[UIColor colorWithHexString:@"999999"]];
            _noCommentDisplayLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_noCommentDisplayLabel];
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.noCommentDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"CommomNoCommentCell";
}

+ (CGFloat) cellHeight{
    
    return 50;
}

@end
