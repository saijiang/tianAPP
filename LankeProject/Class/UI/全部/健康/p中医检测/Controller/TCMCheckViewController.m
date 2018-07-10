//
//  TCMCheckViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "TCMCheckViewController.h"
#import "LKBottomButton.h"
#import "HealthExamSingleSelectCCell.h"
#import "HealthExamSectionHeaderReView.h"
#import "TCMManager.h"
#import "TCMResultViewController.h"
#import "HLLAlert.h"

#import "AllFunctionViewController.h"
#import "HealthHomeViewController.h"
@interface TCMCheckViewController ()<TCMManagerDelegate>

@property (nonatomic ,strong) NSArray * originalDatas;

@property (nonatomic ,strong) TCMManager * manager;

@property (nonatomic ,strong) UICollectionView * examCollectionView;

@property (nonatomic ,strong) LKBottomButton * nextStepButton;
@property (nonatomic ,strong) NSString * type;
@property (nonatomic ,strong) NSString * sexType;

@property (nonatomic,assign)  BOOL valid;

@end

@implementation TCMCheckViewController

- (instancetype) initWithType:(NSString *)type{

    self = [super init];
    if (self) {
        
        
        _manager = [[TCMManager alloc] initWithType:type];
        _manager.delegate = self;
        
        _type = type;
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tcm" ofType:@"json"]];
        
        NSError * error = nil;
        
        NSArray * datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
        
        
        
        if (error) {
            return self;
        }
        //self.originalDatas = datas;
        
        NSInteger index = [type integerValue] - 1;
        self.originalDatas = datas[index][@"listQuestion"];
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sexType=self.sexStr;
    
    //self.title = [NSString stringWithFormat:@"中医体质检测(%@)",self.type];
    self.title=@"问卷调查";
    [self creatUI];
    [self requestExam:self.type];
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
    
    [self addSubview:self.examCollectionView];
    self.manager.collectionView = self.examCollectionView;
    
    self.nextStepButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    self.nextStepButton.enabled = YES;
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextStepButton.layer.masksToBounds = 0.0f;
    self.nextStepButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextStepButton];
    
    [self showRightBarButtonItemHUDByName:@"重置"];
    self.rightButton.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.examCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-60);
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make){
        CGFloat margin = .0f;
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-margin);
        make.height.mas_equalTo(50);
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
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 30.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 10.0f);
}

#pragma mark -
#pragma mark Action M

- (void) nextStep:(UIButton *)button{
    
    if (!self.valid)
    {
        [UnityLHClass showHUDWithStringAndTime:@"您的题目没有答完"];
        return;
    }
    
    NSString * nextType = [NSString stringWithFormat:@"0%ld",[self.type integerValue] + 1];
    
    NSMutableArray*jsonArray=[self.manager result];
    
    if ([jsonArray[0][@"physicalType"] isEqualToString:@"06"]) {
        if ([self.sexStr isEqualToString:@"boy"]) {
            
            NSDictionary * itemData = @{@"questionNum":@"451",
                                        @"questionContent":@"6.您带下色黄（白带颜色发黄）吗？（限女性回答）",
                                        @"questionScore":@"1"};
            [jsonArray[0][@"listQuestion"] addObject:itemData];
            
         
            
        }else{
            
            NSDictionary * itemData = @{@"questionNum":@"452",
                                        @"questionContent":@"您的阴囊潮湿吗？（限男性回答）",
                                        @"questionScore":@"1"};
            [jsonArray[0][@"listQuestion"] addObject:itemData];
            
        }
        
    }
    
    
    NSString * jsonStr = [jsonArray JSONFragment];
    [UserServices addPhysiquePerPointWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] jsonStr:jsonStr completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
           
            
            if ([nextType integerValue] == 10) {
                
                TCMResultViewController * result = [[TCMResultViewController alloc] init];
                 result.pageStr=@"cheak";
                [self.navigationController pushViewController:result animated:YES];
                
                [self removeSelfFromNavigationStack];

            }else{
                
            
                TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:nextType];
                
                nextTCM.sexStr=self.sexType;
                
                
                [self.navigationController pushViewController:nextTCM animated:YES];
               
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

#pragma mark -
#pragma mark TCMManagerDelegate M

- (void)tcmManager:(TCMManager *)manager forValid:(BOOL)valid
{
    self.valid=valid;
//    self.nextStepButton.enabled = valid;
}

#pragma mark -
#pragma mark Network M

- (void) requestExam:(NSString *)type{
    
 
    
    if ([type isEqualToString:@"06"]) {
        
        if ([self.sexStr isEqualToString:@"boy"]) {
            
            NSArray*arr= [self.originalDatas DQRemoveObjectAtIndex:self.originalDatas.count-2];
            self.originalDatas=arr;
            
        }else{
            
            NSArray*arr= [self.originalDatas DQRemoveObjectAtIndex:self.originalDatas.count-1];
            self.originalDatas=arr;
            
        }
        
    }

    
    // 试卷内容接口
    [UserServices
     physiquePerListWithUserId:[KeychainManager readUserId]
     physicalType:type
     completionBlock:^(int result, id responseObject)
    {
        
        if (result == 0)
        {
            
            id data = responseObject[@"data"];
            
            
            NSArray * listQuestion = data[@"listQuestion"];
            if (listQuestion.count)
            {
                if ([type isEqualToString:@"06"]) {
                    
                    NSMutableArray*listArray=[NSMutableArray array];
                    for (NSDictionary*dic in listQuestion) {
                        if ([dic[@"questionNum"] integerValue]==451||[dic[@"questionNum"] integerValue]==452) {
                            
                            listArray=[NSMutableArray arrayWithArray:[listQuestion DQRemoveObject:dic]];
                        }
                    }
                    
                
                    listQuestion=listArray;
                    
                    [self createNewDate:listQuestion];
                  
                }else{
                    
                  self.originalDatas = listQuestion;
                    
                }
                
              
                
            }
            
            [self.manager config:self.originalDatas];
            
            
            if ([type isEqualToString:@"01"])
            {
                self.rightButton.hidden = ![data[@"testCompleteFlg"] boolValue];
            }
            else
            {
                self.rightButton.hidden = YES;
            }
        }
        else
        {
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
-(void)createNewDate:(NSArray*)listArray
{

    if (listArray.count==0) {
        return;
    }
    NSMutableArray*listarra=[NSMutableArray arrayWithArray:[listArray DQMoveLastObject]];
    if ([self.sexStr isEqualToString:@"boy"]) {
        
        NSDictionary * itemData = @{@"questionNum":listArray[listArray.count-1][@"questionNum"],
                                    @"questionContent":@"7.您的阴囊潮湿吗？（限男性回答)",
                                    @"questionScore":[NSString stringWithFormat:@"%@",listArray[listArray.count-1][@"questionScore"]]};
        [listarra addObject:itemData];
        
    }else{
        NSDictionary * itemData = @{@"questionNum":listArray[listArray.count-1][@"questionNum"],
                                    @"questionContent":@"6.您带下色黄（白带颜色发黄）吗？（限女性回答) " ,
                                    @"questionScore":[NSString stringWithFormat:@"%@",listArray[listArray.count-1][@"questionScore"]]};
        [listarra addObject:itemData];
   
        
    }
  
    self.originalDatas=listarra;
    
    
}
- (void)baseRightBtnAction:(UIButton *)btn{
    if (self.rightButton.hidden) {
        return;
    }

    [[[[[[[HLLAlertActionSheet alert]
          title:@"提示"]
         message:@"确定要重置所有已答的问题？"]
        buttons:@[@"取消",@"确定"]]
       style:UIAlertActionStyleDestructive index:1]
      show]
     fetchClick:^(NSInteger index)
    {
         if (index)
         {
             [UserServices
              cleanPhysiquePerPointWithUserId:[KeychainManager readUserId]
              completionBlock:^(int result, id responseObject)
             {
                 
                 if (result == 0)
                 {
                     
                     TCMCheckViewController * nextTCM = [[TCMCheckViewController alloc] initWithType:self.type];
                     [self.navigationController pushViewController:nextTCM animated:NO];
                     if (self.navigationController && [self.navigationController.viewControllers count])
                     {
                         NSMutableArray * vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                         [vcs removeObjectAtIndex:vcs.count-2];
                         self.navigationController.viewControllers = vcs;
                     }

                 }
                 else
                 {
                     // error handle here
                     [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
                 }
             }];
         }
     }];
    
}

@end
