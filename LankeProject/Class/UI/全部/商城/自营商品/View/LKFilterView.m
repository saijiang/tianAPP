//
//  LKFilterView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/19.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LKFilterView.h"
#import "LKFilterCCell.h"
#import "SideChooseManager.h"
#import "UIView+MHExtension.h"
#import "JDBrandView.h"


@interface LKFilterView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SideChooseManagerDataSource>

@property (nonatomic ,strong) SideChooseManager * manager;
@property (nonatomic ,strong) NSArray * filterDatas;

@property (nonatomic ,strong) UIImageView * snapshotImageView;

@property (nonatomic ,strong) UICollectionView * filterCollectionView;

@property (nonatomic ,strong) UIButton * cancelButton;
@property (nonatomic ,strong) UIButton * confirmButton;

@property (nonatomic ,strong) UIView * separateView;

@end

@implementation LKFilterView

-(void)getBrandList
{
    [UserServices
     getBrandListWithFlag:nil
     classOneId:self.searchItem.classOneId
     classTwoId:self.searchItem.classTwoId
     classThridId:self.searchItem.classThridId
     goodsName:self.searchItem.goodsName
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            NSMutableArray *tempArray=[[NSMutableArray alloc]init];
            [tempArray addObject:@{
                                   @"name":@"全部",
                                   @"code":@""}];
            
            NSArray *dataArr=responseObject[@"data"];
            for (NSDictionary *dic in dataArr)
            {
                NSMutableDictionary *dataSource=[[NSMutableDictionary alloc]init];
                [dataSource setValue:dic[@"brandName"] forKey:@"name"];
                [dataSource setValue:dic[@"id"] forKey:@"code"];
                [tempArray addObject:dataSource];
            }
            NSDictionary *brandList=@{@"filterSection":@"品牌",
                                      @"filterItems":tempArray
                                      };
            
            self.filterDatas=@[self.filterDatas.firstObject,brandList];
            
            [self.manager configChooseManagerForDefaultSelectedItems:self.priceFilter];
            [self.manager configChooseManager:self.filterDatas];
            [self.manager foldSection:1];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.manager = [[SideChooseManager alloc] init];
        self.manager.dataSource = self;
        self.manager.allowsFoldSectionView = YES;
        self.manager.allowsMultipleSelection = NO;
        self.manager.allowsFoldSectionRow = 3;

        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        self.filterDatas = @[@{@"filterSection":@"价格",
                               @"filterItems":@[@{@"name":@"全部",
                                                  @"code":@""},
                                                @{@"name":@"0-50",
                                                  @"code":@"0"},
                                                @{@"name":@"50-100",
                                                  @"code":@"1"},
                                                @{@"name":@"100-200",
                                                  @"code":@"2"},
                                                @{@"name":@"200-500",
                                                  @"code":@"3"},
                                                @{@"name":@"500以上",
                                                  @"code":@"4"}]},@{@"filterSection":@"品牌",
                                                                    @"filterItems":@[@{@"name":@"全部",
                                                                                       @"code":@""},
                                                                                     @{@"name":@"APPLE",
                                                                                       @"code":@"0"},
                                                                                     @{@"name":@"华为",
                                                                                       @"code":@"1"},
                                                                                     @{@"name":@"三星",
                                                                                       @"code":@"2"},
                                                                                     @{@"name":@"乐视",
                                                                                       @"code":@"3"},
                                                                                     @{@"name":@"vivo",
                                                                                       @"code":@"4"}]}];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        [self configFlowLayout:layout];
        
        self.filterCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.filterCollectionView.alwaysBounceVertical = YES;
        self.filterCollectionView.dataSource = self;
        self.filterCollectionView.delegate = self;
        self.filterCollectionView.backgroundColor = [UIColor whiteColor];
        [self.filterCollectionView registerClass:[LKFilterHeaderView class]
                      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                             withReuseIdentifier:[LKFilterHeaderView reuseIdentifier]];
        
        [self.filterCollectionView registerClass:[LKFilterFooterView class]
                      forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                             withReuseIdentifier:[LKFilterFooterView reuseIdentifier]];
        
        [self.filterCollectionView registerClass:[LKFilterCCell class]
                      forCellWithReuseIdentifier:[LKFilterCCell cellIdentifier]];
        
        [self addSubview:self.filterCollectionView];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton hll_setBackgroundImageWithHexString:@"ffffff" forState:UIControlStateNormal];
        self.cancelButton.adjustsImageWhenHighlighted = NO;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            self.priceFilter = @[[NSMutableSet setWithObjects:@(0), nil]];
            
            [self hide:YES];
            
            if (self.bCancelHandle) {
                self.bCancelHandle(self);
            }
        }];
        [self addSubview:self.cancelButton];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton hll_setBackgroundImageWithHexString:@"ffffff" forState:UIControlStateNormal];
        self.confirmButton.adjustsImageWhenHighlighted = NO;
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.confirmButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
        [self.confirmButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
            [self hide:YES];
            NSString * code = @"";
            
            NSArray * array = [self.manager commit];
            self.priceFilter = array;
            
            
            if (_isProShop)
            {
                if (array.count)
                {
                    NSSet * setOne = array[0];
                    NSSet * setTwo = array[1];

                    if (setOne.count)
                    {
                        NSArray * items = self.filterDatas[0][@"filterItems"];
                        NSInteger index = [[setOne allObjects][0] integerValue];
                        NSString * codeOne = items[index][@"code"];
                        code=codeOne;
                    }
                    if (setTwo.count)
                    {
                        NSArray * items = self.filterDatas[1][@"filterItems"];
                        NSInteger index = [[setTwo allObjects][0] integerValue];
                        NSString * codeTwo = items[index][@"code"];
                        code =[NSString stringWithFormat:@"%@,%@",code,codeTwo];
                    }
                    if (self.bConfirmHandle)
                    {
                        self.bConfirmHandle(self,code);
                    }

                    
                }
            }
            else
            {
                if (array.count)
                {
                    NSSet * set = array[0];
                    if (set.count)
                    {
                        NSArray * items = self.filterDatas[0][@"filterItems"];
                        NSInteger index = [[set allObjects][0] integerValue];
                        code = items[index][@"code"];
                    }
                }
                if (self.bConfirmHandle) {
                    self.bConfirmHandle(self,code);
                }

            }
        }];
        [self addSubview:self.confirmButton];
        
        self.separateView = [UIView lineView];
        [self addSubview:self.separateView];
        
        self.snapshotImageView = [[UIImageView alloc] init];
        self.snapshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.snapshotImageView.userInteractionEnabled = YES;
        [self addSubview:self.snapshotImageView];
     
        self.manager.collectionView = self.filterCollectionView;
        
    }
    return self;
}

-(void)setIsProShop:(BOOL)isProShop
{
    _isProShop=isProShop;
    if (_isProShop) {
        [self getBrandList];
    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.snapshotImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
    }];
    [self.filterCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        if (self.isProShop)
        {
            make.height.mas_equalTo(300.0f);
        }
        else if (self.isRight)
        {
            make.height.mas_equalTo(self.mas_height);
        }
        else
        {
            make.height.mas_equalTo(220.0f);

        }
        
        
        
        make.top.mas_equalTo(self.snapshotImageView.mas_bottom).mas_offset(-10);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        if (self.isRight)
        {
            make.bottom.mas_equalTo(self.mas_bottom);
        }
        else
        {
            make.top.mas_equalTo(self.filterCollectionView.mas_bottom);
        }
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.cancelButton.mas_height);
        if (self.isRight)
        {
            make.bottom.mas_equalTo(self.mas_bottom);
        }
        else
        {
            make.top.mas_equalTo(self.filterCollectionView.mas_bottom);
        }
        make.width.mas_equalTo(self.cancelButton.mas_width);
    }];
    
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.cancelButton.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.cancelButton.mas_bottom).mas_equalTo(-10);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(self.cancelButton.mas_centerY);
        make.left.mas_equalTo(self.cancelButton.mas_right);
    }];
    if (!self.isRight)
    {
        [self.snapshotImageView addLineUp:NO andDown:YES andColor:BM_Color_SeparatorColor];
    }
    else
    {
        [self.snapshotImageView addLineUp:NO andDown:NO andColor:BM_CLEAR];
    }
    
    [self.cancelButton addLineUp:YES andDown:NO andColor:BM_Color_SeparatorColor];
    [self.confirmButton addLineUp:YES andDown:NO andColor:BM_Color_SeparatorColor];
}

#pragma mark -
#pragma mark Animaiton

- (void) showWithView:(UIView *)view onViewController:(UIViewController *)vc{
    
    [self.manager configChooseManagerForDefaultSelectedItems:self.priceFilter];
    
    [self.manager configChooseManager:self.filterDatas];

    [vc.view addSubview:self];
    
    CGRect rect = self.frame;
    
    if (view)
    {
        view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        if (self.isRight)
        {
            self.snapshotImageView.image = [view captureImageAtRect:CGRectMake(0, 0, CGRectGetWidth(view.bounds),  0.01)];
        }
        else
        {
            self.snapshotImageView.image = [view captureImageAtRect:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - 10)];
        }

    }
    
    if (self.isRight)
    {
        self.frame = (CGRect){(rect.origin.x+ rect.size.width),rect.origin.y,rect.size};
    }
    else
    {
        self.frame = (CGRect){rect.origin.x,-(rect.origin.y + rect.size.height),rect.size};
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
}

- (void) hide:(BOOL)animated{
    
    CGRect collectionRect = self.filterCollectionView.frame;
    CGRect cancelButtonRect = self.cancelButton.frame;
    CGRect confirmButtonRect = self.confirmButton.frame;
    self.separateView.hidden = YES;
    
    [UIView animateWithDuration:animated ? 0.25: 0 animations:^{
        
        
        if (self.isRight)
        {
            CGFloat x = (collectionRect.origin.x + collectionRect.size.width);
            self.filterCollectionView.frame = (CGRect){{x,collectionRect.origin.y},collectionRect.size};
            
            x = (cancelButtonRect.origin.x + cancelButtonRect.size.width);
            self.cancelButton.frame = (CGRect){{x,cancelButtonRect.origin.y},cancelButtonRect.size};
            
            self.confirmButton.frame = (CGRect){{x,confirmButtonRect.origin.y},confirmButtonRect.size};
        }
        else
        {
            CGFloat y = -(collectionRect.origin.y + collectionRect.size.height);
            self.filterCollectionView.frame = (CGRect){{collectionRect.origin.x,y},collectionRect.size};
            
            y = -(cancelButtonRect.origin.y + cancelButtonRect.size.height);
            self.cancelButton.frame = (CGRect){{cancelButtonRect.origin.x,y},cancelButtonRect.size};
            
            self.confirmButton.frame = (CGRect){{confirmButtonRect.origin.x,y},confirmButtonRect.size};
        }
        
        
        
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.manager numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.manager numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LKFilterCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LKFilterCCell cellIdentifier] forIndexPath:indexPath];
    ChooseItem * item = [self.manager itemObjectAtIndexPath:indexPath];
    [cell configCellWithData:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.manager selectCellAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout{
    
    CGFloat height = 40.0f;
    
    
    CGFloat width = (DEF_SCREEN_WIDTH - 2 * 20 - 2 * 20)/3;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.minimumLineSpacing = 15.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 50.0f);
    if (self.isRight)
    {
        layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 50.0f);
    }
    else
    {
        layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        LKFilterHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[LKFilterHeaderView reuseIdentifier] forIndexPath:indexPath];
        
        ChooseSection * sectionObj = [self.manager sectionObjectAtSection:indexPath.section];
        [headerView configureHeaderViewWithData:sectionObj.section];
//        if (indexPath.section==0)
//        {
            [headerView hideRightImageView];
//        }
//        else
//        {
//            [headerView showRightImageView];
//            [headerView setRightImageViweSeleted:sectionObj.isFold];
//        }
        [headerView receiveObject:^(id object)
         {
            [self.manager foldSection:indexPath.section];
        }];
        return headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
        LKFilterFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[LKFilterFooterView reuseIdentifier] forIndexPath:indexPath];
        if (indexPath.section == 1 && self.right)
        {
            [footerView configureFooterViewWithData:@"全部品牌"];
            [footerView.allBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                JDBrandView *choose=[[JDBrandView alloc]initWithFrame:CGRectZero];
//                choose.itemArray = self.highLevelCategoryData;
//                [choose configureDefaultSelectedItems:weakSelf.highLevelDefaultSelectedItems];
                [choose showViewWithChooseBlock:^(NSArray * result) {
                    
                    
                }];
                
            }];
        }
        return footerView;
    }
    return nil;
}

#pragma mark -
#pragma mark SideChooseManagerDataSource

- (NSString *) chooseManagerItemsListKey:(SideChooseManager *)manager{
    
    return @"filterItems";
}

#pragma mark -
#pragma mark LKCustomViewProtocol

+ (instancetype) view{

    return [[self alloc] init];
}

@end
