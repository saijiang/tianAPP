//
//  DiningDetailViewController.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningDetailViewController.h"
//topCell
#import "DiningDetailCell.h"
//通知cell
#import "DiningNotiCell.h"
//用餐人数cell
#import "DiningCountCell.h"
//底部cell(每周菜单)
#import "DiningBootomCell.h"
//菜谱
#import "WeeklyDishesViewController.h"
//下周想吃
#import "EatNexWeekViewController.h"
//外卖
#import "TakeOutListViewController.h"

static NSString *DiningDetailCellId = @"DiningDetailCell";
static NSString *DiningNotiCellId = @"DiningNotiCell";
static NSString *DiningCountCellId = @"DiningCountCell";
static NSString *DiningBootomCellId = @"DiningBootomCell";

@interface DiningDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *tableDict;
    NSArray *bannerArray;
}

@property(nonatomic,strong)UITableView *tableCtrl;

@end

@implementation DiningDetailViewController

- (void)requestData
{
    [UserServices getRestaurantDetail:self.restaurantData[@"id"]
                               userId:[KeychainManager readUserId]
                      completionBlock:^(int result, id responseObject)
    {
        if ([responseObject[@"status"] integerValue] == 0)
        {
            tableDict = [[NSDictionary alloc] initWithDictionary:responseObject[@"data"]];
            bannerArray = [[NSArray alloc] initWithObjects:tableDict[@"restaurantImageDetail1"],tableDict[@"restaurantImageDetail2"],tableDict[@"restaurantImageDetail3"], nil];
            [self.tableCtrl reloadData];
            
            self.title = [NSString stringWithFormat:@"%@",tableDict[@"restaurantName"]];
            
        }else
        {
        
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"****";
    self.contentView.backgroundColor = BM_Color_LineColor;
    [self createHeaderView];
    
    [self initUI];
    [self requestData];

    
}

#pragma mark ----------------------------------     界面初始化     ----------------------------------------

-(void)createHeaderView
{
    
}


-(void)initUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableCtrl.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.backgroundColor = BM_CLEAR;
    [self.tableCtrl registerClass:[DiningNotiCell class] forCellReuseIdentifier:DiningNotiCellId];
    [self.tableCtrl registerClass:[DiningCountCell class] forCellReuseIdentifier:DiningCountCellId];
    [self.tableCtrl registerClass:[DiningBootomCell class] forCellReuseIdentifier:DiningBootomCellId];
    [self addSubview:self.tableCtrl];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(0);
    }];
    [self.tableCtrl setNeedsDisplay];
}
#pragma mark - UITableViewViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2+[tableDict[@"listArea"] count];
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
        
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        case 3:
        {
            return 30;
        }
            break;
        case 4:
        {
            return (DEF_SCREEN_WIDTH-2)/3.0;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 4:
            return 0.0f;
            break;
            
        default:
            return 10;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return DEF_SCREEN_WIDTH/2+120;
            break;
        case 3:
            return 40;
            break;
        default:
            return 0.1f;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH/2+120)];
            headView.backgroundColor = BM_WHITE;
            
            
            CommonHeaderView *bannerView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/2)];
            [bannerView configureBannerViewWithImageData:bannerArray];
            [headView addSubview:bannerView];
            
            //地址
            DiningDetailCell *oneCellView = [[DiningDetailCell alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(bannerView), DEF_SCREEN_WIDTH, 40)];
            [oneCellView loadViewWithImage:@"locationIcon" title:@"地        址:" content:tableDict[@"restaurantAddress"]];
            [headView addSubview:oneCellView];
            
            //营业时间
            DiningDetailCell *twoCellView = [[DiningDetailCell alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(oneCellView), DEF_SCREEN_WIDTH, 40)];
            NSString *timeStr = [NSString stringWithFormat:@"%@-%@",tableDict[@"openTime"],tableDict[@"endTime"]];
            [twoCellView loadViewWithImage:@"ding_shijian" title:@"营业时间:" content:timeStr];
            [headView addSubview:twoCellView];
            
            //联系电话
            DiningDetailCell *threeCellView = [[DiningDetailCell alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(twoCellView), DEF_SCREEN_WIDTH, 40)];
            [threeCellView loadViewWithImage:@"ding_dianhua" title:@"联系电话:" content:tableDict[@"contactPhone"]];
            [headView addSubview:threeCellView];
            threeCellView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            [threeCellView addGestureRecognizer:tap];
            
            return headView;
            
        }
            break;
        case 3:
        {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
            headView.backgroundColor = BM_WHITE;
            UILabel *lable = [UnityLHClass masonryLabel:@"用餐情况" font:15.0 color:BM_Color_BlackColor];
            [headView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(headView.mas_left).offset(15);
                make.height.mas_equalTo(39);
                make.top.mas_equalTo(headView.mas_top);
            }];
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = BM_Color_LineColor;
            [headView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lable.mas_left);
                make.bottom.mas_equalTo(headView.mas_bottom);
                make.right.mas_equalTo(headView.mas_right);
                make.height.mas_equalTo(1);
            }];
            
            return headView;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {

        case 1:
        {
            //外卖说明
            DiningNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:DiningNotiCellId];
            if (cell == nil)
            {
                cell = [[DiningNotiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiningNotiCellId];
            }
            [cell loadCellWithDataSource:tableDict[@"takeOutInstruction"]];
            cell.news.leftImage.image=[UIImage imageNamed:@"shuoming"];
            return cell;
        }
        case 2:
        {
            //广告
            DiningNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:DiningNotiCellId];
            if (cell == nil)
            {
                cell = [[DiningNotiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiningNotiCellId];
            }
            [cell loadCellWithDataSource:tableDict[@"noticeContent"]];
            cell.news.leftImage.image=[UIImage imageNamed:@"notiIcon"];
            return cell;
        }

            break;
        case 3:
        {
            //用餐情况
            DiningCountCell *cell = [tableView dequeueReusableCellWithIdentifier:DiningCountCellId];
            if (cell == nil)
            {
                cell = [[DiningCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiningCountCellId];
            }
            if (indexPath.row == 0)
            {
                cell.titleLab.text = @"食堂可容纳人数：";
                cell.contentLab.text = [NSString stringWithFormat:@"%@人",tableDict[@"galleryNum"]];
            }else if (indexPath.row == 1)
            {
                cell.titleLab.text = @"当前用餐情况";
                cell.contentLab.text = @"";
            }
            else
            {
                cell.titleLab.text = [NSString stringWithFormat:@"%@:",tableDict[@"listArea"][indexPath.row-2][@"areaName"]];
               // cell.contentLab.text = [NSString stringWithFormat:@"%@人",tableDict[@"listArea"][indexPath.row-2][@"perNum"]];
                 cell.contentLab.text = [NSString stringWithFormat:@"%@人",@"0"];
            }
            
            return cell;
        }
            break;
        case 4:
        {
            DiningBootomCell *cell = [tableView dequeueReusableCellWithIdentifier:DiningBootomCellId];
            if (cell == nil)
            {
                cell = [[DiningBootomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiningBootomCellId];
            }
            
            [cell receiveObject:^(id object) {
                
                NSLog(@"=====%@",object);
                
                switch ([object integerValue])
                {
                    case 0:
                    {
                        //每周菜单
                        WeeklyDishesViewController *week = [[WeeklyDishesViewController alloc]init];
                        week.restaurantData = tableDict;
                        [self.navigationController pushViewController:week animated:YES];
                    }
                        break;
                    case 1:
                    {
                        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                            
                            //下周想吃
                            EatNexWeekViewController *eat = [[EatNexWeekViewController alloc]init];
                            eat.restaurantData = tableDict;
                            [self.navigationController pushViewController:eat animated:YES];
                        }];
                    }
                        break;
                    case 2:
                    {
                        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
                            
                            //点餐
                            TakeOutListViewController *takeOut = [[TakeOutListViewController alloc]init];
                            takeOut.takeOutType = @"02";
                            takeOut.restaurantData = tableDict;
                            [self.navigationController pushViewController:takeOut animated:YES];
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
                
            }];
            
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4)
    {
        
    }
}


- (void)callPhone:(UITapGestureRecognizer *)tapGesture {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tableDict[@"contactPhone"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
