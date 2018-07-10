//
//  FitnessLivingViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessLivingViewController.h"
#import "HLLCollectionViewCalendarLayout.h"
#import "HLLEvent.h"

#import "HLLEventCell.h"
#import "HLLDayRowHeader.h"

#import "HLLCurrentDayHeader.h"
#import "HLLGridline.h"
#import "HLLSignHeader.h"

#import "AdvDetailViewController.h"


NSString * const DayRowHeaderReuseIdentifier = @"DayRowHeaderReuseIdentifier";

@interface FitnessLivingViewController ()<UICollectionViewDataSource,HLLCollectionViewDelegateCalendarLayout,UICollectionViewDelegate>

@property (nonatomic ,strong) HLLCollectionViewCalendarLayout * calenderLayout;

@property (strong, nonatomic) IBOutlet UICollectionView *calenderCollectionView;

@property (nonatomic ,strong) NSMutableArray * tempData;

@property (nonatomic ,strong) NSArray * weekDays;
@property (nonatomic ,assign) NSInteger currentIndex;

@end

@implementation FitnessLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tempData = [NSMutableArray array];
    self.weekDays = [HLLWeekDay weekDays];
    self.currentIndex = [HLLWeekDay todayIndex];
    
    self.title = @"健身直播";
    
    [self showRightBarButtonItemHUDByImage:[UIImage imageNamed:@"navigation_bar_call"]];
    
    
    
    self.calenderLayout = [[HLLCollectionViewCalendarLayout alloc] init];
    self.calenderLayout.delegate = self;
    self.calenderLayout.signHeaderHeight = 50;
    self.calenderLayout.dayRowHeaderWidth = 120;
    self.calenderLayout.contentMargin = UIEdgeInsetsZero;
    self.calenderLayout.sectionMargin = UIEdgeInsetsZero;
    
    self.calenderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.calenderLayout];
    self.calenderCollectionView.dataSource = self;
    self.calenderCollectionView.delegate = self;
    [self.calenderCollectionView setCollectionViewLayout:self.calenderLayout animated:YES];
    self.calenderCollectionView.backgroundColor = [UIColor whiteColor];
    self.calenderCollectionView.alwaysBounceVertical = YES;
    self.calenderCollectionView.showsVerticalScrollIndicator = NO;
    self.calenderCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.calenderCollectionView];
    
    // regist
    [self.calenderCollectionView registerClass:[HLLEventCell class] forCellWithReuseIdentifier:[HLLEventCell cellIdentifier]];
    [self.calenderCollectionView registerClass:[HLLDayRowHeader class] forSupplementaryViewOfKind:HLLCollectionElementKindDayRowHeader withReuseIdentifier:DayRowHeaderReuseIdentifier];
    
    [self.calenderLayout registerClass:[HLLGridline_Gray class] forDecorationViewOfKind:HLLCollectionElementKindHorizontalGridline];
    [self.calenderLayout registerClass:[HLLGridline_Gray class] forDecorationViewOfKind:HLLCollectionElementKindVerticalGridline];
    [self.calenderLayout registerClass:[HLLGridline_White class] forDecorationViewOfKind:HLLCollectionElementKindDayRowGridline];
    [self.calenderLayout registerClass:[HLLCurrentDayHeader class] forDecorationViewOfKind:HLLCollectionElementKindCurrentDayHeader];
    [self.calenderLayout registerClass:[HLLSignHeader class] forDecorationViewOfKind:HLLCollectionElementKindSignHeader];
    
    [self.calenderLayout invalidateLayoutCache];
    
//    下拉刷新
    LKWeakSelf
    [self.calenderCollectionView addHeaderWithCallback:^{
        LKStrongSelf
        [_self requestFitnessLiving];
        [_self.calenderCollectionView headerEndRefreshing];
    }];
    
    
    [self requestFitnessLiving];
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
//    [self.calenderCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(10);
//        make.right.mas_equalTo(self.view.right);
//        make.bottom.mas_equalTo(self.view.bottom);
//    }];
}

- (void)baseRightBtnAction:(UIButton *)btn{
    
    // dadianhua
    [UnityLHClass callTel:@"010-68118899"];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.weekDays.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.tempData.count) {
        
        NSArray * datas = self.tempData[section];
        return datas.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLLEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HLLEventCell cellIdentifier] forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (self.tempData.count) {
        
        HLLEvent * event = self.tempData[indexPath.section][indexPath.row];
        [cell configCellWithData:event];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == HLLCollectionElementKindDayRowHeader) {
        HLLDayRowHeader *dayRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DayRowHeaderReuseIdentifier forIndexPath:indexPath];
        
        [dayRowHeader config:self.weekDays[indexPath.section]];
        
        view = dayRowHeader;
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.tempData.count) {
        
        HLLEvent * event = self.tempData[indexPath.section][indexPath.row];
        if (!event.isEmpty)
        {
            if (event.status == HLLEventStatusLiving)
            {
                
                NSLog(@"goto living");
                AdvDetailViewController *adControll=[[AdvDetailViewController alloc]init];
                adControll.advType=3;
                adControll.externalUrl=event.livingURL;
                adControll.title=event.title;
                [self.navigationController pushViewController:adControll animated:YES];
            }
            else
            {
                if (event.status == HLLEventStatusNormal)
                {
                    // 可以预约
                    [self requestAddHealthAppointWithLiveId:event.livingId];
                }
            }
            
        }
    }
}

#pragma mark -
#pragma mark Network M

- (void) requestFitnessLiving{
    
    // 健身直播接口
    [UserServices getHealthFitnessListWithUserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        
        if (result == 0)
        {
            id data = responseObject[@"data"];
            
            dispatch_async(dispatch_queue_create("what the mass!!", DISPATCH_QUEUE_SERIAL), ^{
                [self.tempData removeAllObjects];
                
                for (HLLWeekDay * weekDay in self.weekDays) {
                    
                    NSMutableArray * temp = [NSMutableArray array];
                    BOOL has = NO;
                    NSArray * listHealth;
                    
                    for (NSDictionary * liveData in data) {
                        
                        has = [liveData[@"liveDate"] isEqual: weekDay.fullDate];
                        
                        if (has) {
                            listHealth = liveData[@"listHealth"];
                            break;
                        }
                    }
                    if (!has) {
                        [temp addObject:[HLLEvent emptyEvent]];
                    }else{
                        
                        NSInteger amCount = 0,pmCount = 0;
                        NSMutableArray * amEvents = [NSMutableArray array];
                        NSMutableArray * pmEvents = [NSMutableArray array];
                        
                        for (NSDictionary * oneEvent in listHealth) {
                            
                            HLLEvent * event = [[HLLEvent alloc] init];
                            [event config:oneEvent];
                            
                            if (event.isAM) {
                                amCount ++;
                                [amEvents addObject:event];
                            }else{
                                pmCount ++;
                                [pmEvents addObject:event];
                            }
                        }
                        if (amCount >= pmCount) {
                            NSInteger index = 0;
                            for (HLLEvent * amEvent in amEvents) {
                                
                                [temp addObject:amEvent];
                                if (index >= pmEvents.count) {
                                    [temp addObject:[HLLEvent emptyEvent]];
                                }else{
                                    [temp addObject:pmEvents[index]];
                                }
                                index ++;
                            }
                        }
                        if (amCount < pmCount) {
                            
                            NSInteger index = 0;
                            for (HLLEvent * pmEvent in pmEvents) {
                                if (index >= amEvents.count) {
                                    [temp addObject:[HLLEvent emptyEvent]];
                                }else{
                                    [temp addObject:amEvents[index]];
                                }
                                [temp addObject:pmEvent];
                                index ++;
                            }
                        }
                    }
                    [self.tempData addObject:temp];
                }// end for-in weeks
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.calenderLayout invalidateLayoutCache];
                    [self.calenderCollectionView reloadData];
                });
                
            });
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestAddHealthAppointWithLiveId:(NSString *)liveId{
    
    // 预约接口
    [UserServices addHealthAppointWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] healthLiveId:liveId completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            //id data = responseObject[@"data"];
            
            [self requestFitnessLiving];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
#pragma mark -
#pragma mark HLLCollectionViewDelegateCalendarLayout

- (NSInteger)currentDayIndex{
    
    return self.currentIndex;
}


@end
