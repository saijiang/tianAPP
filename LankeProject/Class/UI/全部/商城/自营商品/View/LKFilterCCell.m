//
//  LKFilterCCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LKFilterCCell.h"
#import "SideChooseManager.h"

@interface LKFilterCCell ()

@property (nonatomic ,strong) UILabel * itemLabel;

@end

@implementation LKFilterCCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#Ffffff"];
        self.contentView.layer.borderColor = BM_Color_SeparatorColor.CGColor;
        self.contentView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.contentView.layer.cornerRadius = 5.0f;
        self.contentView.layer.masksToBounds = YES;
        
        if (!_itemLabel) {
            _itemLabel = [UnityLHClass masonryLabel:@"CCCC" font:14 color:[UIColor colorWithHexString:@"#666666"]];
            _itemLabel.textAlignment = NSTextAlignmentCenter;
            _itemLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_itemLabel];
            [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
    }
    return self;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *) cellIdentifier{

    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ChooseItem *)data{

    self.itemLabel.text = [NSString stringWithFormat:@"%@",data.item[@"name"]];
    if (data.isSelected) {
        self.contentView.layer.borderColor = BM_Color_Blue.CGColor;
        self.itemLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.contentView.backgroundColor = BM_Color_Blue;
    }else{
        self.contentView.layer.borderColor = BM_Color_SeparatorColor.CGColor;
        self.itemLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
}

@end


@interface LKFilterHeaderView ()

@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UIButton * filterButton;

@end
@implementation LKFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.userInteractionEnabled = NO;
        
        UILabel *titleLB = [UnityLHClass masonryLabel:@"****" font:16.0 color:[UIColor colorWithHexString:@"#999999"]];
        titleLB.backgroundColor=BM_CLEAR;
        [self addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 20, 0, 0));
        }];
        
        self.titleLabel = titleLB;
        
        UIButton *filterButton=[UnityLHClass masonryButton:@"" imageStr:@"Mall_xiala-1" font:13.0 color:BM_WHITE];
        [filterButton setImage:[UIImage imageNamed:@"Mall_xiala"] forState:UIControlStateSelected];
        filterButton.hidden=YES;
        [filterButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
        [self addSubview:filterButton];
        self.filterButton=filterButton;
        [filterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [filterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(filterButton.selected)];
        }];
        
        //
    }
    return self;
}

- (void) configureHeaderViewWithData:(id)data{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",data[@"filterSection"]];
}

- (void)hideRightImageView
{
    self.filterButton.hidden=YES;

}
- (void)showRightImageView
{
    self.filterButton.hidden=NO;
}
- (void)setRightImageViweSeleted:(BOOL)seleted
{
    self.filterButton.selected=seleted;
}
+ (NSString *)reuseIdentifier{
    
    return @"LKFilterHeaderView";
}
@end

@interface LKFilterFooterView ()

@property (nonatomic,strong)UILabel *allLab;//全部品牌
@property (nonatomic,strong)LocalhostImageView *arrowImgView;//箭头

@end

@implementation LKFilterFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self  createUI];
        
    }
    return self;
}

-(void)createUI
{
    self.allLab = [UnityLHClass masonryLabel:@"全部品牌" font:15.0 color:[UIColor colorWithHexString:@"#999999"]];
    self.allLab.hidden = YES;
    [self addSubview:self.allLab];
    
    self.arrowImgView = [[LocalhostImageView alloc]initWithImage:[UIImage imageNamed:@"UserCenter-RightArrow"]];
    self.arrowImgView.hidden = YES;
    [self addSubview:self.arrowImgView];
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_allBtn];
}

-(void)layoutSubviews
{
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(7);
        make.height.offset(15);
    }];
    
    [self.allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-10);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

+ (NSString *)reuseIdentifier{
    
    return @"LKFilterFooterView";
}

- (void) configureFooterViewWithData:(id)data
{
    self.allLab.hidden = NO;
    self.arrowImgView.hidden = NO;
    self.allLab.text = data;
}

@end
