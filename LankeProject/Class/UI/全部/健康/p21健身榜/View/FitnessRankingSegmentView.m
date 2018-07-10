//
//  FitnessRankingSegmentView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessRankingSegmentView.h"
#import "EHHorizontalSelectionView.h"

@interface FitnessRankingSegmentView ()<EHHorizontalSelectionViewProtocol>{
    NSArray * _segmentItems;
}

@property (nonatomic ,strong) EHHorizontalSelectionView * segmentView;

@property (nonatomic ,strong) UIView * leftSepView;
@property (nonatomic ,strong) UIView * rightSepView;

@end

@implementation FitnessRankingSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentType = @"01";
        
        _segmentItems = @[@"好友排名",@"单位排名",@"世界排名"];
        
        self.segmentView = [[EHHorizontalSelectionView alloc] initWithFrame:CGRectZero];
        self.segmentView.backgroundColor = [UIColor whiteColor];
        [self.segmentView registerCellWithClass:[EHHorizontalLineViewCell class]];
        self.segmentView.delegate = self;
        self.segmentView.scrollEnabled = NO;
        self.segmentView.tintColor = BM_Color_Blue;
        self.segmentView.normalTextColor = BM_BLACK;
        self.segmentView.selectTextColor = BM_Color_Blue;
        self.segmentView.font = [UIFont systemFontOfSize:16];
        self.segmentView.fontMedium = [UIFont systemFontOfSize:16];
        self.segmentView.maxDisplayCount = 3;
        [self addSubview:self.segmentView];
        
        [EHHorizontalLineViewCell updateColorHeight:3.f];
        [EHHorizontalLineViewCell updateCellGap:1];
        [EHHorizontalLineViewCell updateScale:0.7];
        
        self.leftSepView = [UIView new];
        self.leftSepView.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:self.leftSepView];
        
        self.rightSepView = [UIView new];
        self.rightSepView.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:self.rightSepView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat margin = DEF_SCREEN_WIDTH / 6;
    [self.leftSepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 20));
        make.centerX.mas_equalTo(self.segmentView.centerX).mas_offset(-margin);
        make.centerY.mas_equalTo(self.segmentView.centerY);
    }];
    
    [self.rightSepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 20));
        make.centerX.mas_equalTo(self.segmentView.centerX).mas_offset(margin);
        make.centerY.mas_equalTo(self.segmentView.centerY);
    }];
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype)view{
    
    return [[self alloc] init];
}

#pragma mark -
#pragma mark EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView* _Nonnull)hSelView{

    return _segmentItems.count;
}

- (NSString * _Nullable)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView* _Nonnull)hSelView{
    return _segmentItems[index];
}

- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index{

    self.segmentType = [NSString stringWithFormat:@"0%lu",index + 1];
    
    if (self.bSwitchOptionHandle) {
        self.bSwitchOptionHandle(index);
    }
}
@end
