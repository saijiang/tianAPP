//
//  JDFilterView.m
//  LankeProject
//
//  Created by fud on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDFilterView.h"
#import "JDFilterCell.h"
#import "JDFilterHeaderView.h"
#import "JDFilterFooterView.h"
#import "SideChooseManager.h"
#import "UIView+MHExtension.h"
#import "JDBrandView.h"

#define TableWidth  DEF_SCREEN_WIDTH*0.85
#define TableLeft  DEF_SCREEN_WIDTH*0.15

@interface JDFilterView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SideChooseManagerDataSource>

@property (nonatomic ,strong) SideChooseManager * manager;
@property (nonatomic ,strong) NSArray * filterDatas;

@property (nonatomic ,strong) UICollectionView * filterCollectionView;

@property (nonatomic ,strong) UIButton * cancelButton;
@property (nonatomic ,strong) UIButton * confirmButton;

@property (nonatomic ,strong) UIView * separateView;
@property (nonatomic ,strong) NSString * nameStr;
@property (nonatomic ,strong) NSIndexPath  * pathNum;


@end

@implementation JDFilterView

//-(void)getBrandList:(NSString*)categoryId
//{
//    [UserServices
//     getJDBrandListWithcategoryId:categoryId
//     completionBlock:^(int result, id responseObject)
//     {
//        
//         if (result==0)
//         {
//             
//             
//             NSMutableArray *tempArray=[[NSMutableArray alloc]init];
//
//                [tempArray addObject:@{@"name":@"全部",
//                                                @"code":@""}];
//             NSArray *dataArr=responseObject[@"data"];
//             self.dataArray=dataArr;
//             NSInteger num;
//             if (dataArr.count>5) {
//                 num=5;
//             }else{
//                 num=dataArr.count;
//             }
//             for (int i=0; i<num; i++) {
//                 NSMutableDictionary *dataSource=[[NSMutableDictionary alloc]init];
//                 [dataSource setValue:dataArr[i] forKey:@"name"];
//                 [dataSource setValue:[NSString stringWithFormat:@"%d",i] forKey:@"code"];
//                 [tempArray addObject:dataSource];
//             }
//           
//             NSDictionary *brandList=@{@"filterSection":@"品牌",
//                                       @"filterItems":tempArray
//                                       };
//             self.filterDatas = @[@{@"filterSection":@"价格",
//                                    @"filterItems":@[@{@"name":@"全部",
//                                                       @"code":@""},
//                                                     @{@"name":@"0-50",
//                                                       @"code":@"0"},
//                                                     @{@"name":@"50-100",
//                                                       @"code":@"1"},
//                                                     @{@"name":@"100-200",
//                                                       @"code":@"2"},
//                                                     @{@"name":@"200-500",
//                                                       @"code":@"3"},
//                                                     @{@"name":@"500以上",
//                                                       @"code":@"4"}]}];
//             
//             self.filterDatas=@[self.filterDatas.firstObject,brandList];
//             [self.manager configChooseManagerForDefaultSelectedItems:self.priceFilter];
//             [self.manager configChooseManager:self.filterDatas];
//             [self.manager foldSection:0];
//
//         }
//         else
//         {
//             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
//         }
//     }];
//}

- (instancetype)initWithFrame:(CGRect)frame withBrandArray:(NSMutableArray*)brandArray
{
    self = [super initWithFrame:frame];
    if (self) {
   
        
        self.manager = [[SideChooseManager alloc] init];
        self.manager.dataSource = self;
        self.manager.allowsFoldSectionView = YES;
        self.manager.allowsMultipleSelection = NO;
        self.manager.allowsFoldSectionRow = 300;
        
        self.hidden=YES;
        self.frame=KAPPDELEGATE.window.bounds;
        [KAPPDELEGATE.window addSubview:self];
        UIView *backView=[[UIView alloc]init];
        backView.frame=self.bounds;
        backView.backgroundColor=BM_BLACK;
        backView.alpha=0.3;
        [self addSubview:backView];
        
    
        UIView *writeView=[[UIView alloc]initWithFrame:CGRectMake(TableLeft,0, TableWidth, DEF_SCREEN_HEIGHT)];
        writeView.userInteractionEnabled=YES;
        writeView.backgroundColor=BM_WHITE;
        [self addSubview:writeView];

        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
        [backView addGestureRecognizer:tap];
        
//        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        self.filterDatas=brandArray;
        [self.manager configChooseManagerForDefaultSelectedItems:self.priceFilter];
        [self.manager configChooseManager:self.filterDatas];
        [self.manager foldSection:0];

        

        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        [self configFlowLayout:layout];
        
        self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TableLeft, 20, TableWidth, DEF_SCREEN_HEIGHT-20) collectionViewLayout:layout];
        self.filterCollectionView.alwaysBounceVertical = YES;
        self.filterCollectionView.dataSource = self;
        self.filterCollectionView.delegate = self;
        self.filterCollectionView.backgroundColor = [UIColor whiteColor];
        [self.filterCollectionView registerClass:[JDFilterHeaderView class]
                      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                             withReuseIdentifier:[JDFilterHeaderView reuseIdentifier]];
        
        [self.filterCollectionView registerClass:[JDFilterFooterView class]
                      forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                             withReuseIdentifier:[JDFilterFooterView reuseIdentifier]];
        
        [self.filterCollectionView registerClass:[JDFilterCell class]
                      forCellWithReuseIdentifier:[JDFilterCell cellIdentifier]];
        
        [self addSubview:self.filterCollectionView];
        self.manager.collectionView = self.filterCollectionView;

        
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
            
            
                if (array.count)
                {
                    NSSet * setOne = array[0];
                    NSSet * setTwo = array[1];
                    
                    if (setOne.count)
                    {
                        NSArray * items = self.filterDatas[0][@"filterItems"];
                        NSInteger index = [[setOne allObjects][0] integerValue];
                        NSString * codeOne = items[index][@"name"];
                        code=codeOne;
                    }
                    if (setTwo.count)
                    {
//                        NSArray * items = self.filterDatas[1][@"filterItems"];
//                        NSInteger index = [[setTwo allObjects][0] integerValue];
//                        self.typeStr = items[index][@"name"];
                      
                    }
                    code =[NSString stringWithFormat:@"%@,%@",code,self.typeStr];
                    if (self.bConfirmHandle)
                    {
                        self.bConfirmHandle(self,code);
                    }
                    
                    
                }
            }];
        [self addSubview:self.confirmButton];
        
        self.separateView = [UIView lineView];
        [self addSubview:self.separateView];
        
//        self.snapshotImageView = [[UIImageView alloc] init];
//        self.snapshotImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.snapshotImageView.userInteractionEnabled = YES;
//        [self addSubview:self.snapshotImageView];
        

    }
    return self;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.filterCollectionView.mas_left);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.mas_bottom);
        
        make.width.mas_equalTo(self.filterCollectionView.mas_width).multipliedBy(0.5);
    }];

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.cancelButton.mas_height);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.cancelButton.mas_width);
        
    }];
    
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.cancelButton.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.cancelButton.mas_bottom).mas_equalTo(-10);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(self.cancelButton.mas_centerY);
        make.left.mas_equalTo(self.cancelButton.mas_right);
    }];
    
    [self.cancelButton addLineUp:YES andDown:NO andColor:BM_Color_SeparatorColor];
    [self.confirmButton addLineUp:YES andDown:NO andColor:BM_Color_SeparatorColor];
}

#pragma mark -
#pragma mark Animaiton

- (void) showWithView:(UIView *)view onViewController:(UIViewController *)vc{
    
    self.hidden=NO;
    
    [self.manager configChooseManagerForDefaultSelectedItems:self.priceFilter];
    
    [self.manager configChooseManager:self.filterDatas];
    
//    [vc.view addSubview:self];
    
    CGRect rect = self.frame;
    
    if (view)
    {
        view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        
    }
    
    self.frame = (CGRect){(rect.origin.x+ rect.size.width),rect.origin.y,rect.size};
    
    
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
        
        

//        CGFloat x = (collectionRect.origin.x + collectionRect.size.width);
//        self.filterCollectionView.frame = (CGRect){{x,collectionRect.origin.y},collectionRect.size};
//
//        self.confirmButton.frame = (CGRect){{x,confirmButtonRect.origin.y},confirmButtonRect.size};
//
//        x = (cancelButtonRect.origin.x + cancelButtonRect.size.width);
//        self.cancelButton.frame = (CGRect){{x,cancelButtonRect.origin.y},cancelButtonRect.size};
//
        
//
//        x = (confirmButtonRect.origin.x + confirmButtonRect.size.width);
        self.frame = CGRectMake(DEF_SCREEN_WIDTH, 0, 0, 0);
        
        
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
   
    JDFilterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[JDFilterCell cellIdentifier] forIndexPath:indexPath];
   
    ChooseItem * item = [self.manager itemObjectAtIndexPath:indexPath];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            if (![self.typeStr isEqualToString:@"全部"]&&self.typeStr.length>0) {
                item.selected=NO;

            }else{
                item.selected=YES;

            }
        }
        if ( self.nameStr.length>0) {
            item.selected=NO;
        }
    }
//    if (indexPath.section==1) {
//        if ( self.nameStr.length>0) {
//            item.selected=NO;
//        }
//    }
   
   
    [cell configCellWithData:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    self.pathNum=indexPath;
    self.nameStr=@"";
    [self.manager selectCellAtIndexPath:indexPath];

  
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout{
    
    CGFloat height = 40.0f;
    
    
    CGFloat width = (TableWidth - 2 * 20 - 2 * 20)/3;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.minimumLineSpacing = 15.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
    layout.headerReferenceSize = CGSizeMake(TableWidth, 50.0f);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
       return CGSizeMake(TableWidth, 50.0f);
    }
    return CGSizeMake(TableWidth, 0.01f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        JDFilterHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[JDFilterHeaderView reuseIdentifier] forIndexPath:indexPath];
        
        ChooseSection * sectionObj = [self.manager sectionObjectAtSection:indexPath.section];
        [headerView configureHeaderViewWithData:sectionObj.section];
        
        if (indexPath.section == 1 && self.right){
            
            
            headerView.filterButton.hidden=NO;
            if (self.nameStr.length>0) {
                
                [headerView.filterButton setTitle:self.nameStr forState:UIControlStateNormal];
            }else{
                
                if (self.pathNum.length!=0) {
                    ChooseItem * item = [self.manager itemObjectAtIndexPath:self.pathNum];
                    [headerView.filterButton setTitle:item.item[@"name"] forState:UIControlStateNormal];
                }else{
                  [headerView.filterButton setTitle:self.typeStr forState:UIControlStateNormal];
                }
              
            }
            
            self.typeStr=headerView.filterButton.currentTitle;

        }else{
            headerView.filterButton.hidden=YES;

        }

        
        [headerView receiveObject:^(id object)
         {
            
             [self.manager foldSection:indexPath.section];
         }];
        return headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
        JDFilterFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[JDFilterFooterView reuseIdentifier] forIndexPath:indexPath];
        if (indexPath.section == 1 && self.right)
        {
            
            
            [footerView configureFooterViewWithData:@"全部品牌"];
            [footerView.allBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                JDBrandView *choose=[[JDBrandView alloc]initWithFrame:CGRectZero DataSource:self.dataArray];
//                                choose.itemArray = self.highLevelCategoryData;
//                                [choose configureDefaultSelectedItems:weakSelf.highLevelDefaultSelectedItems];
//             
                
                
                [choose showViewWithChooseBlock:^(NSArray * result) {
                    
                    
                }];
                
                [choose receiveObject:^(id object) {
                    
                    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"close"])
                    {
                        [self hide:YES];
                        
                    }else{
                        
                        self.nameStr=object;
                         self.pathNum=nil;
                       [self.filterCollectionView reloadData];
                      
                    }
                }];
                
            }];
            
            
        }else{
            [footerView configureFooterViewWithData:@"header"];
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

