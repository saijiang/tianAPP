//
//  DishesDetailCommentHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DishesDetailCommentHeaderView.h"

@interface DishesDetailCommentHeaderView ()

@property (nonatomic ,strong) UILabel * displayLabel;

@property (nonatomic ,strong) UILabel * commentCountLabel;

@property (nonatomic ,strong) UILabel * commentEvalScoresLabel;


@property (nonatomic ,strong) LocalhostImageView * arrowImageView;

@end
@implementation DishesDetailCommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        _displayLabel = [UnityLHClass masonryLabel:@"用户评论" font:14 color:BM_Color_BlackColor];
        [self addSubview:_displayLabel];
        [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        _commentCountLabel = [UnityLHClass masonryLabel:@"(0)" font:14 color:BM_Color_GrayColor];
        [self addSubview:_commentCountLabel];
        [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_displayLabel.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(_displayLabel.mas_centerY);
        }];
        
        _arrowImageView = [[LocalhostImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.centerY.mas_equalTo(_displayLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(9, 15));
        }];
        
        _commentEvalScoresLabel= [UnityLHClass masonryLabel:@"" font:14 color:BM_Color_GrayColor];
        [self addSubview:_commentEvalScoresLabel];
        [_commentEvalScoresLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.centerY.mas_equalTo(_displayLabel.mas_centerY);
        }];

        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void) configCommentHeaderViewWithData:(id)data{

    NSInteger count = [data[@"total"] integerValue];
    self.commentCountLabel.text = [NSString stringWithFormat:@"(%ld)",(long)count];
    self.userInteractionEnabled = count > 5;
    self.arrowImageView.hidden = count <= 5;
  

}

//京东详情评价区头赋值
- (void) configJDCommentHeaderViewWithData:(id)data{
    
    NSInteger count = [data[@"countData"] integerValue];
    self.commentCountLabel.text = [NSString stringWithFormat:@"(%ld)",(long)count];
    self.userInteractionEnabled = YES;//count > 5;
    self.arrowImageView.hidden = NO;//count <= 5;
    
    
}

-(void)configEvalScoresHeaderViewWithData:(id)data
{
    float evalScores = [data[@"evalScores"] floatValue];
    self.commentEvalScoresLabel.text=[NSString stringWithFormat:@"%.1f分",evalScores];
    self.commentEvalScoresLabel.hidden = evalScores <= 0;
}



#pragma mark -
#pragma mark Action M

- (void) tapHandle:(UITapGestureRecognizer *)tapGesture{
    
    if (self.bCommentHeaderTapHandle) {
    
        self.bCommentHeaderTapHandle();
    }
}
@end
