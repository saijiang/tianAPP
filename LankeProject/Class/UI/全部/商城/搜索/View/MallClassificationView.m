//
//  MallClassificationView.m
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallClassificationView.h"
#define kSectionViewWidth  100

@interface MallClassificationView ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UITableView * sectionTableView;

@property (nonatomic ,strong) UICollectionView * rowsCollectionView;

@property (nonatomic ,assign) NSInteger selectedSectionIndex;

@end

@implementation MallClassificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.defaultSelectFirstSection = YES;
        self.selectedSectionIndex = 0;
        
        //
        _sectionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _sectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sectionTableView.dataSource = self;
        _sectionTableView.delegate = self;
        _sectionTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _sectionTableView.tableFooterView = [UIView new];
        [self addSubview:_sectionTableView];
        UIView * headerView = [UIView new];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.frame = CGRectMake(0, 0, kSectionViewWidth, 0.1);
        _sectionTableView.tableHeaderView = headerView;
        
        //
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        [self configFlowLayout:layout];
        
        self.rowsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.rowsCollectionView.alwaysBounceVertical = YES;
        self.rowsCollectionView.dataSource = self;
        self.rowsCollectionView.delegate = self;
        self.rowsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.rowsCollectionView];
        
    }
    return self;
}

- (void)dealloc{
    
    _sectionTableView.delegate = nil;
    _sectionTableView.dataSource = nil;
    
    _rowsCollectionView.dataSource = nil;
    _rowsCollectionView.delegate = nil;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.defaultSelectFirstSection) {
        
        NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.selectedSectionIndex = 0;
        [self.sectionTableView selectRowAtIndexPath:selectIndexPath animated:YES scrollPosition:0];
    }
    
    [self.sectionTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.mas_top).mas_offset(1);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        make.width.mas_equalTo(kSectionViewWidth);
    }];
    
    [self.rowsCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.sectionTableView.top).mas_offset(1);
        make.left.mas_equalTo(self.sectionTableView.mas_right);
        make.bottom.mas_equalTo(self.sectionTableView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint_h = CGPointMake(0,0);
    CGPoint stopPoint_h = CGPointMake(CGRectGetWidth(rect),0);
    
    CGPoint lines[] = {
        startPoint_h,
        stopPoint_h
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    
    CGContextStrokePath(context);
}


#pragma mark -
#pragma mark API
- (void) configUICollectionViewFlowLayout:(UICollectionViewFlowLayout *)layout
{
    self.rowsCollectionView.collectionViewLayout=layout;
    [self.rowsCollectionView reloadData];
    
}
- (void) setSelectSectionIndex:(NSInteger)index
{
    self.selectedSectionIndex=index;
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.selectedSectionIndex];
    [self.sectionTableView selectRowAtIndexPath:selectIndexPath animated:YES scrollPosition:0];
    [self.sectionTableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

- (void)reloadData{
    
    [self.sectionTableView reloadData];
    
    [self.rowsCollectionView reloadData];
    
    if (self.defaultSelectFirstSection) {
        
        NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.selectedSectionIndex];
        //self.selectedSectionIndex = 0;
        [self.sectionTableView selectRowAtIndexPath:selectIndexPath animated:YES scrollPosition:0];
    }
}

- (nullable UIView *) sectionViewForSection:(NSInteger)section{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    UITableViewCell * sectionCell = [self.sectionTableView cellForRowAtIndexPath:indexPath];
    
    return sectionCell;
}
- (NSInteger) currentSelectSectionIndex{
    
    return self.selectedSectionIndex;
}

- (void)registerClass:(nullable Class)cellClass forSectionReuseIdentifier:(NSString *)identifier{
    
    [self.sectionTableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)registerClass:(nullable Class)cellClass forRowReuseIdentifier:(NSString *)identifier{
    
    [self.rowsCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(nullable Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier{
    
    [self.rowsCollectionView registerClass:cellClass forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (__kindof UITableViewCell *) dequeueReusablePickSectionWithIdentifier:(NSString *)identifier forSection:(NSInteger)section{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    return [self.sectionTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *) dequeueReusablePickRowWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath * currentIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
    return [self.rowsCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:currentIndexPath];
}
- (__kindof UICollectionReusableView *) dequeueReusableSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    
    return [self.rowsCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
}
#pragma mark -
#pragma mark Private M

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout{
    
    CGFloat width = (DEF_SCREEN_WIDTH - kSectionViewWidth-4*10)/3.0;
    CGFloat height = 120;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 40.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger numberOfSections = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInPickView:)]) {
        
        numberOfSections = [self.dataSource numberOfSectionsInPickView:self];
    }
    return numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickView:viewForSectionAtSection:)]) {
        
        UITableViewCell * cell = [self.dataSource pickView:self viewForSectionAtSection:indexPath.section];
        if (self.selectedSectionIndex == indexPath.section) {
            [cell setSelected:YES animated:NO];
        }
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(numberOfSectionsInPickViewHight:numberOfRowsInSection:)])
    {
        return [self.dataSource numberOfSectionsInPickViewHight:self numberOfRowsInSection:indexPath.section];
    }
    return 60.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedSectionIndex == indexPath.section) {
        return ;
    }
    self.selectedSectionIndex = indexPath.section;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickView:didPickSectionAtSection:)]) {
        
        [self.delegate pickView:self didPickSectionAtSection:self.selectedSectionIndex];
    }
    
    [self.rowsCollectionView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickView:didDepickSectionAtSection:)]) {
        
        [self.delegate pickView:self didDepickSectionAtSection:indexPath.section];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfItemsInSection = 1;
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(pickViewNumberOfRowsInSection:)])
    {
        numberOfItemsInSection = [self.dataSource pickViewNumberOfRowsInSection:self];

    }
    return numberOfItemsInSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger numberOfItemsInSection = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickView:numberOfRowsInSection:)]) {
        
        numberOfItemsInSection = [self.dataSource pickView:self numberOfRowsInSection:section];
    }
    return numberOfItemsInSection;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickView:viewForRowAtIndexPath:)]) {
        
        UICollectionViewCell * cell = [self.dataSource pickView:self viewForRowAtIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(pickView:viewForSupplementaryElementOfKind:atIndexPath:)])
    {
        UICollectionReusableView * reusableView = [self.dataSource pickView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickView:didPickRowAtIndexPath:)]) {
        
        [self.delegate pickView:self didPickRowAtIndexPath:indexPath];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
