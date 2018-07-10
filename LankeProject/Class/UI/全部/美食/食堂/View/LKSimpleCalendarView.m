//
//  LKSimpleCalendarView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKSimpleCalendarView.h"

@interface LKSimpleCalendarView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView * calendarCollectionView;

@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic ,strong) NSMutableArray * datas;

@end

@implementation LKSimpleCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        self.datas = [NSMutableArray array];
        
        self.currentIndex = NSNotFound;
        
        [self creatUI];
    }
    return self;
}

- (void) creatUI{
    
    // CollectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.calendarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.calendarCollectionView.backgroundColor = [UIColor clearColor];
    self.calendarCollectionView.alwaysBounceVertical = NO;
    self.calendarCollectionView.scrollEnabled = NO;
    self.calendarCollectionView.showsVerticalScrollIndicator = NO;
    self.calendarCollectionView.dataSource = self;
    self.calendarCollectionView.delegate = self;
    [self.calendarCollectionView registerClass:[LKSimpleCalendarCCell class]
                    forCellWithReuseIdentifier:[LKSimpleCalendarCCell cellIdentifier]];
    [self addSubview:self.calendarCollectionView];
    [self.calendarCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)configCalendarWithData:(id)data{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString * formatterYesterday = [dateFormatter stringFromDate:yesterday];
        
        NSString * week = weeks[index];
        NSDictionary * data = @{@"week":week,
                                @"day":formatterDay,
                                @"formatterDay":formatterYesterday};
        [self.datas addObject:data];
    }
    
    [self performSelector:@selector(defaultSelect:) withObject:@([[NSDate date] getWeekDay]) afterDelay:0.25];
}

- (void) defaultSelect:(NSNumber *)weekDay{

    self.currentIndex = [weekDay integerValue] - 1;
    
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    
    [self.calendarCollectionView selectItemAtIndexPath:selectIndexPath animated:YES scrollPosition:0];
    
    if (self.bSimpleCalendarDidSelected) {
        
        NSDictionary * data = self.datas[self.currentIndex];
        
        self.bSimpleCalendarDidSelected(self.currentIndex,data[@"formatterDay"]);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{

    [super willMoveToSuperview:newSuperview];
    
    [self configCalendarWithData:nil];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)self.calendarCollectionView.collectionViewLayout;
    
    [self configFlowLayout:flowLayout];
    
    [self.calendarCollectionView setCollectionViewLayout:flowLayout animated:YES];
}

- (void) configFlowLayout:(UICollectionViewFlowLayout *)flowLayout{
    
    CGFloat width = (DEF_SCREEN_WIDTH - 0 * 10 - 0 * 5)/7;
    CGFloat height = CGRectGetHeight(self.frame);
    flowLayout.itemSize = CGSizeMake(width, height);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    flowLayout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
}

#pragma mark -
#pragma mark Collection M

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKSimpleCalendarCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LKSimpleCalendarCCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configCellWithData:self.datas[indexPath.item]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex != indexPath.item) {
        
        self.currentIndex = indexPath.item;
        
        NSDictionary * data = self.datas[indexPath.item];
        
        if (self.bSimpleCalendarDidSelected) {
            self.bSimpleCalendarDidSelected(self.currentIndex,data[@"formatterDay"]);
        }
    }
}

@end

@interface LKSimpleCalendarCCell ()

@property (nonatomic ,strong) UILabel * weeklyLabel;

@property (nonatomic ,strong) UIButton * weeklyButton;

@end
@implementation LKSimpleCalendarCCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        if (!_weeklyLabel) {
            _weeklyLabel = [UnityLHClass masonryLabel:@"周一" font:14 color:BM_Color_BlackColor];
            _weeklyLabel.textAlignment = NSTextAlignmentCenter;
            _weeklyLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_weeklyLabel];
            [_weeklyLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
        }
        
        if (!_weeklyButton) {
            _weeklyButton = [UnityLHClass masonryButton:@"15" imageStr:nil font:15 color:BM_Color_Blue];
            _weeklyButton.userInteractionEnabled = NO;
            _weeklyButton.layer.masksToBounds = YES;
            _weeklyButton.layer.cornerRadius = 15;
            [_weeklyButton hll_setBackgroundImageWithHexString:@"ffffff" forState:UIControlStateNormal];
            [_weeklyButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateSelected];
            [_weeklyButton setTitleColor:BM_Color_BlackColor forState:UIControlStateNormal];
            [_weeklyButton setTitleColor:BM_WHITE forState:UIControlStateSelected];
            [self.contentView addSubview:_weeklyButton];
            [_weeklyButton mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(_weeklyLabel.mas_bottom).mas_offset(0);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.centerX.mas_equalTo(_weeklyLabel.mas_centerX);
            }];
        } 
    }
    return self;
}
- (void)setSelected:(BOOL)selected{

    [super setSelected:selected];
    
    self.weeklyButton.selected = selected;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"LKSimpleCalendarCCell";
}

- (void) configCellWithData:(id)data{
 
    //
    NSString * week = data[@"week"];
    self.weeklyLabel.text = [NSString stringWithFormat:@"%@",week];

    [self.weeklyButton setTitle:data[@"day"] forState:UIControlStateNormal];

}
@end
