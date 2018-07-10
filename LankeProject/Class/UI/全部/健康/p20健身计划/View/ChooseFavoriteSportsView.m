//
//  ChooseFavoriteSportsView.m
//  LankeProject
//
//  Created by itman on 17/3/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChooseFavoriteSportsView.h"
#import "ChooseFavoriteSportsManger.h"

@interface ChooseFavoriteSportsView()

@property (nonatomic ,strong) UIView * baseView;
@property (nonatomic ,strong) UICollectionView * examCollectionView;
@property (nonatomic ,strong) ChooseFavoriteSportsManger * manager;

@property (nonatomic ,strong) UIButton *confirm;
@property (nonatomic ,strong) UIButton *cancle;

@end

@implementation ChooseFavoriteSportsView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_CLEAR;
        _manager = [[ChooseFavoriteSportsManger alloc] init];
        [self creatUI];
    }
    return self;
}

- (void) creatUI
{
    UIView *baseView=[[UIView alloc]init];
    baseView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.2];
    [self addSubview:baseView];
    self.baseView=baseView;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.examCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.examCollectionView.alwaysBounceVertical = YES;
    self.examCollectionView.allowsSelection = YES;
    self.examCollectionView.allowsMultipleSelection = YES;
    self.examCollectionView.backgroundColor = BM_WHITE;
    self.examCollectionView.dataSource = self.manager;
    self.examCollectionView.delegate = self.manager;
    [self.baseView addSubview:self.examCollectionView];
    
    self.manager.collectionView = self.examCollectionView;
    HealthInfo *info=[[HealthInfo alloc]init];
    self.manager.info=info;
    DataSource * dataSource = [DataSource dataSourceWithName:@"ChooseFavoriteSports"];
    [self.manager configWithDataSource:dataSource];
   
    
    UIButton *confirm=[UnityLHClass masonryButton:@"确认" font:16.0 color:BM_WHITE];
    confirm.backgroundColor=BM_Color_Blue;

    [self.baseView addSubview:confirm];
    self.confirm=confirm;
    [confirm handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self hiddenView:self];
        [self resetSports];
    }];
    UIButton *cancle=[UnityLHClass masonryButton:@"取消" font:16.0 color:BM_BLACK];
    cancle.backgroundColor=[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];

    [self.baseView addSubview:cancle];
    self.cancle=cancle;
    [cancle handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self hiddenView:self];
    }];

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.examCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.baseView.mas_left);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(self.confirm.mas_top).offset(0);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.baseView.mas_bottom);
    }];
    
    [self.cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.confirm.mas_width);
        make.height.mas_equalTo(self.confirm.mas_height);
        make.left.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.confirm.mas_centerY);
    }];
}

- (void)didMoveToSuperview{

    [super didMoveToSuperview];
}

- (void)setData:(id)data{

    _data = data;
    
    [self requestFavoriteSport];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout
{
    CGFloat width = (DEF_SCREEN_WIDTH - 2 * 10)/3;
    CGFloat height = 30;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 40.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self showView:self];
}

//显示
-(void)showView:(UIView *)view
{
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏
- (void)hiddenView:(UIView *)view
{
    [self hideView];
    
}
-(BOOL)isChooseMovement
{
    //    walkFlg	是	string	散步标识，0、否，1、是
    //    joggingFlg	是	string	慢跑标识，0、否，1、是
    //    swimmingFlg	是	string	游泳标识，0、否，1、是
    //    trackFlg	是	string	田径标识，0、否，1、是
    //    basketballFlg	是	string	篮球标识，0、否，1、是
    //    bicycleFlg	是	string	自行车标识，0、否，1、是
    //    ridingHorseFlg	是	string	骑马标识，0、否，1、是
    //    skiFlg	是	string	滑雪标识，0、否，1、是
    //    golfFlg	是	string	高尔夫标识，0、否，1、是
    //    rollerSkatingFlg	是	string	滑旱冰标识，0、否，1、是
    //    jumpFlg	是	string	跳绳标识，0、否，1、是
    //    squashFlg	是	string	壁球标识，0、否，1、是
    //    tennisFlg	是	string	网球标识，0、否，1、是
    //    tableTennisFlg	是	string	乒乓球标识，0、否，1、是
    //    volleyballFlg	是	string	排球标识，0、否，1、是
    NSArray *flaArr=@[
                      self.manager.info.walkFlg,
                      self.manager.info.joggingFlg,
                      self.manager.info.swimmingFlg,
                      self.manager.info.trackFlg,
                      self.manager.info.basketballFlg,
                      self.manager.info.bicycleFlg,
                      self.manager.info.ridingHorseFlg,
                      self.manager.info.badmintonFlg,
                      self.manager.info.golfFlg,
                      self.manager.info.footballFlg,
                      self.manager.info.jumpFlg,
                      self.manager.info.squashFlg,
                      self.manager.info.tennisFlg,
                      self.manager.info.tableTennisFlg,
                      self.manager.info.volleyballFlg,
                      ];
    int flaTag=0;
    for (NSString *flg in flaArr)
    {
        if ([flg integerValue]==1)
        {
            flaTag++;
        }
    }
    if (flaTag<2)
    {
        return NO;
    }
    return YES;
    
}

-(void)resetSports
{
    if (![self isChooseMovement])
    {
        [UnityLHClass showAlertView:@"请选择喜欢的运动（至少两项）"];
        return;
    }
    [UserServices
     resetSportsWithUserId:[KeychainManager readUserId]
     bodyId:self.data[@"bodyId"]
     userName:[KeychainManager readNickName]
     fitnessPlanId:self.data[@"id"]
     walkFlg:self.manager.info.walkFlg
     joggingFlg:self.manager.info.joggingFlg
     swimmingFlg:self.manager.info.swimmingFlg
     trackFlg:self.manager.info.trackFlg
     basketballFlg:self.manager.info.basketballFlg
     bicycleFlg:self.manager.info.bicycleFlg
     ridingHorseFlg:self.manager.info.ridingHorseFlg
     badmintonFlg:self.manager.info.badmintonFlg
     golfFlg:self.manager.info.golfFlg
     footballFlg:self.manager.info.footballFlg
     jumpFlg:self.manager.info.jumpFlg
     squashFlg:self.manager.info.squashFlg
     tennisFlg:self.manager.info.tennisFlg
     tableTennisFlg:self.manager.info.tableTennisFlg
     volleyballFlg:self.manager.info.volleyballFlg
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             [self sendObject:@"resetSports"];
             [UnityLHClass showHUDWithStringAndTime:@"重置喜爱运动成功"];

         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
    }];
}

- (void) requestFavoriteSport{
    
    // 请求喜欢的运动接口
    [UserServices getFavoriteSportsWithBodyId:self.data[@"bodyId"] completionBlock:^(int result, id responseObject) {
        if (result == 0) {
            id data = responseObject[@"data"];
            [self.manager updateDataSource:data];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
