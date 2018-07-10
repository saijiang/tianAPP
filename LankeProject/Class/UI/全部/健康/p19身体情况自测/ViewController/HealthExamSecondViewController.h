//
//  HealthExamSecondViewController.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseViewController.h"


@class HealthInfo;
@interface HealthExamSecondViewController : BaseViewController

@property (nonatomic ,strong) HealthInfo * info;
@end

@interface HealthInfo : NSObject

-(BOOL)isChooseDisease;

-(BOOL)isChooseMovement;

-(BOOL)isChooseFrequency;


@property (strong) NSString* male ;
@property (strong) NSString* height ;
@property (strong) NSString *age;
@property (strong) NSString *weight;

@property (strong) NSString *diabetesFlg;
@property (strong) NSString *heartDiseaseFlg;
@property (strong) NSString *hypertensionFlg;
@property (strong) NSString *hypopiesiaFlg;
@property (strong) NSString *glucopeniaFlg;
@property (strong) NSString *noDiseaseFlg;

@property (strong) NSString *walkFlg;
@property (strong) NSString *joggingFlg;
@property (strong) NSString *swimmingFlg;
@property (strong) NSString *trackFlg;
@property (strong) NSString *basketballFlg;
@property (strong) NSString *bicycleFlg;
@property (strong) NSString *ridingHorseFlg;
@property (strong) NSString *badmintonFlg;
@property (strong) NSString *skiFlg;// 滑雪标识 多余
// 羽毛球
@property (strong) NSString *golfFlg;
@property (strong) NSString *footballFlg;
@property (strong) NSString *rollerSkatingFlg;// 滑旱冰标识 多余
// 足球
@property (strong) NSString *jumpFlg;
@property (strong) NSString *squashFlg;
@property (strong) NSString *tennisFlg;
@property (strong) NSString *tableTennisFlg;
@property (strong) NSString *volleyballFlg;

@property (strong) NSString *sportsRate;

@end

/*
 diabetesFlg	是	string	糖尿病标识，0、否，1、是
 heartDiseaseFlg	是	string	心脏病标识，0、否，1、是
 hypertensionFlg	是	string	高血压标识，0、否，1、是
 hypopiesiaFlg	是	string	低血压标识，0、否，1、是
 glucopeniaFlg	是	string	低血糖标识，0、否，1、是
 noDiseaseFlg	是	string	无疾病标识，0、否，1、是
 
 walkFlg	是	string	散步标识，0、否，1、是
 joggingFlg	是	string	慢跑标识，0、否，1、是
 swimmingFlg	是	string	游泳标识，0、否，1、是
 trackFlg	是	string	田径标识，0、否，1、是
 basketballFlg	是	string	篮球标识，0、否，1、是
 bicycleFlg	是	string	自行车标识，0、否，1、是
 ridingHorseFlg	是	string	骑马标识，0、否，1、是
 skiFlg	是	string	滑雪标识，0、否，1、是
 golfFlg	是	string	高尔夫标识，0、否，1、是
 rollerSkatingFlg	是	string	滑旱冰标识，0、否，1、是
 jumpFlg	是	string	跳绳标识，0、否，1、是
 squashFlg	是	string	壁球标识，0、否，1、是
 tennisFlg	是	string	网球标识，0、否，1、是
 tableTennisFlg	是	string	乒乓球标识，0、否，1、是
 volleyballFlg	是	string	排球标识，0、否，1、是
 
 sportsRate	是	string	每周运动频率，01、从不运动，02、一次，03、二至三次，04、三次以上
 */
