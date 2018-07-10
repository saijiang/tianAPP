//
//  ConvenirntDetailViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ConvenirntDetailViewController.h"
//headerView
#import "ConverientDetailHeaderView.h"
//cell
#import "ConverientDetailCustomCell.h"

@interface ConvenirntDetailViewController ()
{
    UIButton *callBtn;
    NSMutableArray *testArray;
}

@property (nonatomic,strong)ConverientDetailHeaderView *headerView;
@property (nonatomic,strong)id dataSource;

@end

@implementation ConvenirntDetailViewController


-(void)getDistrictMerchantDetail
{
    [UserServices
     getDistrictMerchantDetailWithMerchantId:self.merchantId
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            self.dataSource=responseObject[@"data"];
            self.title = self.dataSource[@"merchantName"];
            testArray = [[NSMutableArray alloc]init];
            NSArray *arr = @[@{@"image":@"serviceDetail_icon1",@"title":[NSString stringWithFormat:@"地址:  %@",self.dataSource[@"merchantAddress"]]},
                             @{@"image":@"serviceDetail_icon2",@"title":[NSString stringWithFormat:@"时间:  %@-%@",self.dataSource[@"merchantStartTime"],self.dataSource[@"merchantEndTime"]]},
                             @{@"image":@"serviceDetail_icon3",@"title":[NSString stringWithFormat:@"价格:  人均¥%@",self.dataSource[@"averagePrice"]]},
                             @{@"image":@"serviceDetail_icon4",@"title":[NSString stringWithFormat:@"电话:  %@",self.dataSource[@"merchantMobile"]]},
                             @{@"image":@"serviceDetail_icon5",@"title":[NSString stringWithFormat:@"分类:  %@",@"美食"]}];
            [testArray addObjectsFromArray:arr];
            [self initUI];
            //创建悬浮电话按钮
            [self createCallBtn];
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
    [self getDistrictMerchantDetail];
}

#pragma mark ------ 界面初始化
-(void)initUI
{
    NSString *string = self.dataSource[@"merchantDescription"];
    //区头
    _headerView = [[ConverientDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 300)];
    float height = [UnityLHClass getHeight:string wid:DEF_SCREEN_WIDTH-30 font:14.0]+20 +DEF_SCREEN_WIDTH/2.0;
    _headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, height);
    [self addSubview:_headerView];
    [_headerView loadHeaderViewWithDataSource:self.dataSource];
    
    //cell
    for (NSInteger i = 0 ; i < testArray.count; i++)
    {
        ConverientDetailCustomCell *view = [[ConverientDetailCustomCell alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(_headerView)+10+i*50, DEF_SCREEN_WIDTH, 50)];
        view.detailIcon.image = [UIImage imageNamed:testArray[i][@"image"]];
        view.detailLab.text = testArray[i][@"title"];
        [self addSubview:view];

        if (i == testArray.count - 1)
        {
            self.contentView.contentSize = CGSizeMake(0, DEF_BOTTOM(view)+10);
        }
        
    }
    
}

#pragma makr ---- 悬浮电话按钮
-(void)createCallBtn
{
    //电话
    callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"serviceDetailCallIcon"] forState:UIControlStateNormal];
    [self addSubview:callBtn];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).offset(-50);
        make.width.and.height.mas_equalTo(70);
    }];
    
    [callBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UnityLHClass callTel:self.dataSource[@"merchantMobile"]];
    }];
    
//    //添加长按手势
//    UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveBtn:)];
//    [callBtn addGestureRecognizer:longPress];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
