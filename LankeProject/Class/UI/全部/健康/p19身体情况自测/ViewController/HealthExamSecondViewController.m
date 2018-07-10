//
//  HealthExamSecondViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthExamSecondViewController.h"
#import "LKBottomButton.h"
#import "HealthExamSingleSelectCCell.h"
#import "HealthExamSectionHeaderReView.h"
#import "HealthExamManager.h"
#import "HealthSelfResultViewController.h"

@interface HealthExamSecondViewController ()

@property (nonatomic ,strong) HealthExamManager * manager;

@property (nonatomic ,strong) UICollectionView * examCollectionView;

@property (nonatomic ,strong) LKBottomButton * nextStepButton;

@end

@implementation HealthExamSecondViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _info = [[HealthInfo alloc] init];
        _manager = [[HealthExamManager alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身体情况自测";
    
    [self creatUI];
    
    DataSource * dataSource = [DataSource dataSourceWithName:@"healthExam"];
    [self.manager configAllFunctionWithDataSource:dataSource];
}

- (void) creatUI{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [self configFlowLayout:layout];
    
    self.examCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.examCollectionView.alwaysBounceVertical = YES;
    self.examCollectionView.allowsSelection = YES;
    self.examCollectionView.allowsMultipleSelection = YES;
    self.examCollectionView.dataSource = self.manager;
    self.examCollectionView.delegate = self.manager;
    self.examCollectionView.backgroundColor = [UIColor colorWithHexString:@"#FfFfFf"];
    self.manager.info=self.info;
    [self addSubview:self.examCollectionView];
    self.manager.collectionView = self.examCollectionView;
    
    self.nextStepButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [self.nextStepButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.nextStepButton addTarget:self action:@selector(navigationToCommit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextStepButton];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.examCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-80);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = 15.0f;
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-margin);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.examCollectionView.mas_bottom).mas_offset(10);
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout{

    CGFloat width = (DEF_SCREEN_WIDTH - 2 * 10)/3;
    CGFloat height = 30;
    layout.itemSize = CGSizeMake(width, height);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 40.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
}

#pragma mark -
#pragma mark Navigation

- (void) navigationToCommit
{
    if(![self.info isChooseDisease])
    {
        [UnityLHClass showAlertView:@"请选择患有疾病，如无，选择无疾病"];
    }
    else if(![self.info isChooseMovement])
    {
        [UnityLHClass showAlertView:@"请选择喜欢的运动（至少两项）"];
    }
    else if(![self.info isChooseFrequency])
    {
        [UnityLHClass showAlertView:@"请选择每周运动频率"];
    }
    else
    {
        [UserServices
         saveBodySelfCheckWithUserId:[KeychainManager readUserId]
         userName:[KeychainManager readNickName]
         sex:self.info.male
         height:self.info.height
         age:self.info.age
         weight:self.info.weight
         diabetesFlg:self.info.diabetesFlg
         heartDiseaseFlg:self.info.heartDiseaseFlg
         hypertensionFlg:self.info.hypertensionFlg
         hypopiesiaFlg:self.info.hypopiesiaFlg
         glucopeniaFlg:self.info.glucopeniaFlg
         noDiseaseFlg:self.info.noDiseaseFlg
         walkFlg:self.info.walkFlg
         joggingFlg:self.info.joggingFlg
         swimmingFlg:self.info.swimmingFlg
         trackFlg:self.info.trackFlg
         basketballFlg:self.info.basketballFlg
         bicycleFlg:self.info.bicycleFlg
         ridingHorseFlg:self.info.ridingHorseFlg
         badmintonFlg:self.info.badmintonFlg
         golfFlg:self.info.golfFlg
         footballFlg:self.info.footballFlg
         jumpFlg:self.info.jumpFlg
         squashFlg:self.info.squashFlg
         tennisFlg:self.info.tennisFlg
         tableTennisFlg:self.info.tableTennisFlg
         volleyballFlg:self.info.volleyballFlg
         sportsRate:self.info.sportsRate
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 // 跳转至身体自测结果
                 HealthSelfResultViewController * result = [[HealthSelfResultViewController alloc] init];
                 result.data=responseObject[@"data"];
                 [self.navigationController pushViewController:result animated:YES];
                 
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
    
}


#pragma mark -
#pragma mark Network M


@end

@implementation HealthInfo


-(BOOL)isChooseDisease
{
//    diabetesFlg	是	string	糖尿病标识，0、否，1、是
//    heartDiseaseFlg	是	string	心脏病标识，0、否，1、是
//    hypertensionFlg	是	string	高血压标识，0、否，1、是
//    hypopiesiaFlg	是	string	低血压标识，0、否，1、是
//    glucopeniaFlg	是	string	低血糖标识，0、否，1、是
//    noDiseaseFlg	是	string	无疾病标识，0、否，1、是
    if ([self.diabetesFlg integerValue]==1||[self.heartDiseaseFlg integerValue]==1||[self.hypertensionFlg integerValue]==1||[self.hypopiesiaFlg integerValue]==1||[self.glucopeniaFlg integerValue]==1||[self.noDiseaseFlg integerValue]==1)
    {
        return YES;
    }
    return NO;
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
                      self.walkFlg,
                      self.joggingFlg,
                      self.swimmingFlg,
                      self.trackFlg,
                      self.basketballFlg,
                      self.bicycleFlg,
                      self.ridingHorseFlg,
                      self.badmintonFlg,
                      self.golfFlg,
                      self.footballFlg,
                      self.jumpFlg,
                      self.squashFlg,
                      self.tennisFlg,
                      self.tableTennisFlg,
                      self.volleyballFlg,
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


-(BOOL)isChooseFrequency
{
    if ([self.sportsRate integerValue]==0)
    {
        return NO;
    }
    return YES;

}

-(id)init
{
    self=[super init];
    [self setValuesForKeysWithDictionary:[self properties_aps]];
    return self;
}
//获取对象的所有属性
- (NSArray *)getAllProperties

{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
//Model到字典
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props setObject:@"0" forKey:propertyName];
    }
    free(properties);
    return props;
    
}@end
