//
//  PropertyRepairHeaderView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairHeaderView.h"
#import "EHHorizontalSelectionView.h"

@interface PropertyRepairHeaderView ()<EHHorizontalSelectionViewProtocol>{
    NSArray * _segmentItems;
}

@property (nonatomic ,strong) EHHorizontalSelectionView * segmentView;

@end

@implementation PropertyRepairHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentType = @"01";
        
        _segmentItems = @[@"进行中",@"已完成"];
        
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
        self.segmentView.maxDisplayCount = 2;
        [self addSubview:self.segmentView];
        
        [EHHorizontalLineViewCell updateColorHeight:3.f];
        [EHHorizontalLineViewCell updateCellGap:1];
        [EHHorizontalLineViewCell updateScale:0.5];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
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
    [self sendObject:self.segmentType];
    if (self.bSwitchOptionHandle) {
        self.bSwitchOptionHandle(index);
    }
}

@end
