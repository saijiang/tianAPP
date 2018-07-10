//
//  SymptomListViewController.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SymptomListViewController.h"
#import "MallClassificationView.h"
#import "SelfTestCell.h"
#import "SymptomCell.h"

#import "CanResultsViewController.h"

@interface SymptomListViewController ()<MallClassificationViewDelegate,MallClassificationViewDataSource>

@property (nonatomic ,strong) MallClassificationView * classificationView;
@property (nonatomic ,strong) NSArray * firstCategoryList;
@property (nonatomic ,strong) NSMutableArray * secondCategoryList;

@end

@implementation SymptomListViewController

-(void)getSymptomsListWithBodyName:(NSString *)bodyName
{
    if (!_secondCategoryList)
    {
        _secondCategoryList=[[NSMutableArray alloc]init];
    }
    [UserServices
     getSymptomsListWithBodyName:bodyName
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [_secondCategoryList removeAllObjects];
            for (NSDictionary *data in responseObject[@"data"])
            {
                for (NSDictionary *dataDic in data[@"listSymptom"])
                {
                    [self.secondCategoryList addObject:dataDic];
                }
            }
            
            [self.classificationView reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstCategoryList = @[
                            @{@"image":@"zice_nan",
                              @"selectedImage":@"zice_nan1",
                              @"name":@"全身症状",
                              },
                            @{@"image":@"zice_nan",
                              @"selectedImage":@"zice_nan1",
                              @"name":@"皮肤症状",
                              },

                            @{@"image":@"zice_tou",
                              @"selectedImage":@"zice_tou1",
                              @"name":@"头部",
                              },
                            @{@"image":@"zice_yanjing",
                              @"selectedImage":@"zice_yanjing1",
                              @"name":@"咽颈部",
                              },
                            @{@"image":@"zice_xiong",
                              @"selectedImage":@"zice_xiong1",
                              @"name":@"胸部",
                              },
                            @{@"image":@"zice_fubu",
                              @"selectedImage":@"zice_fubu1",
                              @"name":@"腹部",
                              },
                            @{@"image":@"zice_shou",
                              @"selectedImage":@"zice_shou1",
                              @"name":@"四肢",
                              },
                            @{@"image":@"zice_shengzhi",
                              @"selectedImage":@"zice_shengzhi1",
                              @"name":@"生殖部位",
                              },
                            @{@"image":@"zice_gupeng",
                              @"selectedImage":@"zice_gupeng1",
                              @"name":@"骨盆",
                              },
                            @{@"image":@"zice_yaobei",
                              @"selectedImage":@"zice_yaobei1",
                              @"name":@"腰背部",
                              },
                            @{@"image":@"zice_tunbu",
                              @"selectedImage":@"zice_tunbu1",
                              @"name":@"臀部及肛门",
                              },

                          
                           ];
    _secondCategoryList = [NSMutableArray array];
    [self createView];
    [self setSelectSection:@"全身症状"];
}

- (void) createView
{
    self.classificationView = [[MallClassificationView alloc] init];
    self.classificationView.backgroundColor = [UIColor clearColor];
    self.classificationView.dataSource = self;
    self.classificationView.delegate = self;
    [self.classificationView registerClass:[SelfTestCell class]
                 forSectionReuseIdentifier:[SelfTestCell cellIdentifier]];
    [self.classificationView registerClass:[SymptomCell class]
                     forRowReuseIdentifier:[SymptomCell cellIdentifier]];
    [self.view addSubview:self.classificationView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DEF_SCREEN_WIDTH - 100;
    CGFloat height = 45;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    layout.footerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 0.0f);
    [self.classificationView configUICollectionViewFlowLayout:layout];
    
}
-(void)setSelectSection:(NSString*)organ
{
    for (int i=0; i<_firstCategoryList.count; i++)
    {
        NSDictionary *data=_firstCategoryList[i];
        if ([data[@"name"] isEqualToString:organ])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getSymptomsListWithBodyName:organ];
                [self.classificationView setSelectSectionIndex:i];

            });

        }
    }
}
- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    [self.classificationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    
}
#pragma mark -
#pragma mark MallClassificationView M

//右侧分组行数section
-(NSInteger)pickViewNumberOfRowsInSection:(MallClassificationView *)pickView
{
    return 1;
}
//右侧分组行数row
- (NSInteger)pickView:(nonnull MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section
{
    return self.secondCategoryList.count;
}
//左侧分组行数
- (NSInteger)numberOfSectionsInPickView:(nonnull MallClassificationView *)pickView
{
    
    return self.firstCategoryList.count;
}
-(CGFloat)numberOfSectionsInPickViewHight:(MallClassificationView *)pickView numberOfRowsInSection:(NSInteger)section
{
    return 90;
}
- (nonnull __kindof UITableViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForSectionAtSection:(NSInteger)section{
    
    NSDictionary *data=self.firstCategoryList[section];
    SelfTestCell * cell = [pickerView dequeueReusablePickSectionWithIdentifier:[SelfTestCell cellIdentifier] forSection:section];
    [cell configCellWithData:data];;
    return cell;
}

- (nonnull __kindof UICollectionViewCell *) pickView:(nonnull MallClassificationView *)pickerView viewForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    SymptomCell * cell = [pickerView dequeueReusablePickRowWithIdentifier:[SymptomCell cellIdentifier] forIndexPath:indexPath];
    [cell loadCellWithDataSource:self.secondCategoryList[indexPath.row]];;
    return cell;
}


- (void) pickView:(nonnull MallClassificationView *)pickerView didPickSectionAtSection:(NSInteger)section
{
    NSString *organ=self.firstCategoryList[section][@"name"];
    [self getSymptomsListWithBodyName:organ];

}

- (void) pickView:(nonnull MallClassificationView *)pickerView didPickRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CanResultsViewController *canResult=[[CanResultsViewController alloc]init];
    canResult.symptomsId=self.secondCategoryList[indexPath.row][@"symptomsId"];
    canResult.title = self.secondCategoryList[indexPath.row][@"symptomsClassName"];

    [self.navigationController pushViewController:canResult animated:YES];
}

@end
